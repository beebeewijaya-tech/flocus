//
//  Avatar.swift
//  flocus
//
//  Created by Bee Wijaya on 10/04/26.
//

import SwiftUI
import Lottie


struct Avatar: View {
    @Binding var playBackMode: LottiePlaybackMode
    var avatarName: String
    var onFinish: ((Bool) -> Void)? = nil

    var body: some View {
        VStack {
            LottieView(animation: .named(avatarName))
                .playbackMode(playBackMode)
                .animationDidFinish { completed in
                    onFinish?(completed)
                }
        }
        .frame(height: 200)
    }
}


#Preview {
    Avatar(playBackMode: .constant(.playing(.fromFrame(0, toFrame: 4, loopMode: .playOnce))), avatarName: "Cactus")
}
