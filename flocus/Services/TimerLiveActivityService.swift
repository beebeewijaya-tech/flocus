//
//  TimerLiveActivityService.swift
//  flocus
//
//  Created by Bee Wijaya on 07/04/26.
//

import SwiftUI
import ActivityKit


/// TimerLiveActivityService responsible for running LiveActivity widget when it's getting triggered by the system
class TimerLiveActivityService {
    var activity: Activity<TimerWidgetAttributes>?
    
    func observeLiveActivity() {
        /**
         observing which live activity has become stale to be killed
         */
        Task {
            guard let activity = self.activity else { return }
            for await state in activity.activityStateUpdates {
                if state == .stale || state == .ended {
                    await self.stopLiveActivity()
                }
            }
        }
    }
    
    func startTimerLiveActivity(until: Date, taskName: String) {
        /**
         start live activity to show the timer on the island and also on the lockscreen
         */
        let attribute = TimerWidgetAttributes()
        let state = TimerWidgetAttributes.ContentState(
            taskName: taskName,
            quotes: "Stop Looking at screen!",
            endDate: until
        )
        
        let content = ActivityContent(state: state, staleDate: until)
        do {
            self.activity = try Activity<TimerWidgetAttributes>.request(attributes: attribute, content: content)
            
            Task {
                let duration = until.timeIntervalSinceNow
                if duration > 0 {
                    try? await Task.sleep(for: .seconds(duration), clock: .continuous)
                }
                await self.stopLiveActivity()
            }
        } catch {
            print("Error \(error)")
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
