//
//  FocusAvatar.swift
//  flocus
//
//  Created by Bee Wijaya on 10/04/26.
//

import SwiftUI
import Lottie

struct FocusAvatar: View {
    @State private var playBackMode: LottiePlaybackMode = .paused(at: .frame(0))
    @State private var currentStage: Int = 0
    @State private var isAnimating: Bool = false

    @EnvironmentObject var timerViewModel: TimerViewModel

    var avatarName: String
    let stageFrames: [AnimationFrameTime] = [0, 1, 2, 3, 4, 5, 6, 7] // our image file only 8 frame

    var body: some View {
        Avatar(
            playBackMode: $playBackMode,
            avatarName: avatarName,
            onFinish: { _ in
                isAnimating = false
                playBackMode = .paused(at: .frame(stageFrames[currentStage]))
            }
        )
        .onChange(of: timerViewModel.seconds) { _, newValue in
            // get initial seconds ( from picker timer )
            let totalTime = Double(timerViewModel.initialSeconds)
            
            // check total time is greater than 0
            // also check if its animating ( not finish )
            guard totalTime > 0, !isAnimating else { return }

            // count elapsed time ( total secs - timer run )
            let elapsed = totalTime - Double(newValue)
            let progress = elapsed / totalTime
            
            // get expected stage from progress
            // if progress 0.5, 0.5 * 8 ( 4 )
            // 4 - 1 = 3, get idx 3 as stage
            let expectedStage = min(
                Int(progress * Double(stageFrames.count - 1)),
                stageFrames.count - 1
            )

            // if stage same, just return
            guard expectedStage > currentStage else { return }

            // run the animation
            let fromFrame = stageFrames[currentStage]
            let toFrame = stageFrames[expectedStage]
            currentStage = expectedStage
            isAnimating = true
            playBackMode = .playing(.fromFrame(fromFrame, toFrame: toFrame, loopMode: .playOnce))
        }
    }
}
