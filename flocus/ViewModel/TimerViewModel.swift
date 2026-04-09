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
/// TimerViewModel will be responsible on doing the timer functionality
class TimerViewModel: ObservableObject {
    @Published var seconds: Int // duration
    var initialSeconds: Int
    var timer: AnyCancellable?
    var activity: Activity<TimerWidgetAttributes>?
    var timerLiveActivity: TimerLiveActivityService
    var familyControlViewModel: FamilyControlViewModel
    
    // persistence variable
    @AppStorage("timerEndDate") var timerEndDate: Double = 0
    
    
    init(seconds: Int, familyControlViewModel: FamilyControlViewModel) {
        self.initialSeconds = seconds
        self.seconds = seconds
        self.timerLiveActivity = TimerLiveActivityService()
        self.familyControlViewModel = familyControlViewModel

        self.checkAndResumeTimer()
    }
    
    func updateSeconds(seconds: Int) {
        self.seconds = seconds
    }
    
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
        timer?.cancel()
        timer = nil
        
        Task {
            await self.timerLiveActivity.stopLiveActivity()
            let until = Date().addingTimeInterval(TimeInterval(self.seconds))
            self.timerLiveActivity.startTimerLiveActivity(until: until)
            self.timerLiveActivity.observeLiveActivity()
            timerEndDate = until.timeIntervalSince1970
            self.familyControlViewModel.lockApps()
            
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
                        print("TIMER: \(t)")
                    }
            }
        }
    }
    
    func checkAndResumeTimer() {
        let targetDate = Date(timeIntervalSince1970: timerEndDate)
        let remaining = Int(targetDate.timeIntervalSinceNow)
        
        if remaining > 0 {
            self.seconds = remaining
            self.stopTimer()
            self.startTimer()
        } else {
            self.stopTimer()
            self.timerEndDate = 0
        }
    }
    
    func stopTimer() {
        /**
         canceling timer and stopping liveactivity
         */
        timer?.cancel()
        timer = nil
        
        if self.seconds == 0 {
            self.seconds = self.initialSeconds
        }
        
        self.familyControlViewModel.unlockApps()
        
        Task {
            await self.timerLiveActivity.stopLiveActivity()
        }
    }
}
