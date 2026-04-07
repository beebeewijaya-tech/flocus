//
//  Timer.swift
//  flocus
//
//  Created by Bee Wijaya on 06/04/26.
//


import SwiftUI
import Combine
import ActivityKit

@MainActor
class TimerViewModel: ObservableObject {
    @Published var seconds: Int = 300 // duration
    var timer: AnyCancellable?
    var activity: Activity<TimerWidgetAttributes>?
    
    func renderTimer() -> String {
        /*
         renderTimer: the goal is to get the formatted timer from "seconds"
         using seconds as countdown would be straightforward
         %02d:%02d will brings 300 into "05:00"
         */
        
        let sec = seconds % 60
        let min = seconds / 60
        let formattedTime = String(format: "%02d:%02d", min, sec) // for 03:20 FORMATTED from mins and sec
        return formattedTime
    }
    
    func startTimer() {
        /*
         startTimer: the goal is to do 2 things
         - starting timer and doing countdown
         - run the live activities and update it
         
         will check the timerInstance first, if its nil then we start the timer
         preventing double call
         */
        self.startTimerLiveActivity()

        if timer == nil {
            timer = Timer.publish(every: 1, on: .main, in: .common)
                .autoconnect()
                .sink { _ in
                    self.seconds = self.seconds - 1
                    if self.seconds < 1 {
                        self.stopTimer()
                        return
                    }
                    let t = self.renderTimer()
                    self.updateLiveActivity()
                    print("TIMER: \(t)")
                }
        } else {
            // if there's timer, reset
            // adding 100ms delay for proper cleanup
            Task {
                self.stopTimer()
                try! await Task.sleep(nanoseconds: 2_000_000 * 100) // 100ms
                self.startTimer()
            }
            
        }
    }
    
    func stopTimer() {
        /**
         canceling timer and stopping liveactivity
         */
        timer?.cancel()
        timer = nil
        seconds = 300
        
        Task {
            await self.stopLiveActivity()
        }
    }
    
    
    func startTimerLiveActivity() {
        /**
        start live activity to show the timer on the island and also on the lockscreen
         */
        let attribute = TimerWidgetAttributes()
        let state = TimerWidgetAttributes.ContentState(
            imageTree: "",
            timer: self.seconds,
            quotes: "Stop Looking at screen!"
        )
        
        let content = ActivityContent(state: state, staleDate: Date().addingTimeInterval(Double(self.seconds)))
        do {
            self.activity = try Activity<TimerWidgetAttributes>.request(attributes: attribute, content: content)
        } catch {
            print("Error \(error)")
        }
    }
    
    
    func updateLiveActivity() {
        /**
        updating the live activity to be able to re-render the timer
         */
        Task {
            let state = TimerWidgetAttributes.ContentState(
                imageTree: "",
                timer: self.seconds,
                quotes: "Stop Looking at screen!"
            )
            let content = ActivityContent(state: state, staleDate: nil)
            await self.activity?.update(content)
        }
    }
    
    
    func stopLiveActivity() async {
        /**
         stop live activity to clear the memory and also the state data
         */
        for activity in Activity<TimerWidgetAttributes>.activities {
            await activity.end(ActivityContent(state: activity.content.state, staleDate: nil), dismissalPolicy: .immediate)
        }
    }
    
}
