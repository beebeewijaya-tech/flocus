//
//  CongratsScreen.swift
//  flocus
//
//  Created by Muhammad Dzakki Abdullah on 07/04/26.
//

import SwiftUI
import Lottie

struct CongratsScreen: View {
    // MARK: - Binding
    @Binding var isPresented: Bool
    @Binding var isPickTimerPresented: Bool
    @State private var playBackMode: LottiePlaybackMode = .playing(.fromFrame(0, toFrame: 100, loopMode: .loop))
    
    // MARK: - ViewModel
    @EnvironmentObject var avatarViewModel: AvatarViewModel
    
    
    // MARK: - Init
    init(isPresented: Binding<Bool>, isPickTimerPresented: Binding<Bool>) {
        self._isPresented = isPresented
        self._isPickTimerPresented = isPickTimerPresented
    }
    
    // MARK: - View
    var body: some View {
        ZStack(alignment: .top) {
            Color("Secondary")
                .ignoresSafeArea(edges: .all)
            VStack {
                Image("Banner")
                    .frame(maxWidth: .infinity, maxHeight: 300)
                Text("CONGRATULATIONS")
                    .padding(.top, 20)
                    .padding(.bottom, 35)
                    .font(.system(size: 30, weight: .black))
                    .foregroundStyle(Color("Primary"))
                
                ZStack {
                    Avatar(
                        playBackMode: $playBackMode,
                        avatarName: "\(avatarViewModel.getAvatar())Shake",
                    )
                   }
                    .frame(width: 144, height: 157)
                Text("All tasks have been")
                    .padding(.top, 35)
                    .font(.system(size: 24))
                    .foregroundStyle(Color("Primary"))
                Text("COMPLETED")
                    .font(.system(size: 34, weight: .black))
                    .foregroundStyle(Color("Primary"))
                    .padding(.bottom, 29)
                
                PrimaryButton(title: "Back Home") {
                    isPickTimerPresented = false
                    isPresented = false
                }
                .frame(width: 100, height: 40)
                .padding()
                .background(Color("Primary"))
                .foregroundStyle(Color("Secondary"))
                .clipShape(Capsule())
            }
        }
    }
}
#Preview {
    CongratsScreen(isPresented: .constant(true), isPickTimerPresented: .constant(true))
        .environmentObject(AvatarViewModel())
}
