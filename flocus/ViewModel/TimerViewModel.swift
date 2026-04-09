//
//  Timer.swift
//  flocus
//
//  Created by Bee Wijaya on 06/04/26.
//

import SwiftUI
import Combine
import ActivityKit

// MARK: - TimerViewModel

@MainActor
class TimerViewModel: ObservableObject {

    // MARK: - Published

    @Published var seconds: Int

    // MARK: - Properties

    var initialSeconds: Int
    var timer: AnyCancellable?
    var activity: Activity<TimerWidgetAttributes>?
    var timerLiveActivity: TimerLiveActivityService
    var familyControlViewModel: FamilyControlViewModel

    // MARK: - Persistence

    @AppStorage("timerEndDate") var timerEndDate: Double = 0

    // MARK: - Init

    init(seconds: Int, familyControlViewModel: FamilyControlViewModel) {
        self.initialSeconds = seconds
        self.seconds = seconds
        self.timerLiveActivity = TimerLiveActivityService()
        self.familyControlViewModel = familyControlViewModel

        self.checkAndResumeTimer()
    }

    // MARK: - Formatting

    func updateSeconds(seconds: Int) {
        self.seconds = seconds
    }

    func renderTimer() -> String {
        let sec = seconds % 60
        let min = seconds / 60
        return String(format: "%02d:%02d", min, sec)
    }

    // MARK: - Timer Control

    func startTimer() {
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

    func stopTimer() {
        timer?.cancel()
        timer = nil
        timerEndDate = 0

        if self.seconds == 0 {
            self.seconds = self.initialSeconds
        }

        self.familyControlViewModel.unlockApps()

        Task {
            await self.timerLiveActivity.stopLiveActivity()
        }
    }

    // MARK: - Resume

    func checkAndResumeTimer() {
        let targetDate = Date(timeIntervalSince1970: timerEndDate)
        let remaining = Int(targetDate.timeIntervalSinceNow)

        guard remaining > 0 else {
            timerEndDate = 0
            return
        }

        self.seconds = remaining
        self.startTimer()
    }
}
