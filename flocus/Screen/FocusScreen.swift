//
//  FocusScreen.swift
//  flocus
//
//  Created by Bee Wijaya on 07/04/26.
//

import SwiftUI


struct FocusScreen: View {
    @Binding var isPresented: Bool
    @StateObject var timerViewModel: TimerViewModel
    @StateObject var avatarViewModel: AvatarViewModel
    
    init(isPresented: Binding<Bool>, seconds: Int) {
        self._isPresented = isPresented
        self._timerViewModel = StateObject(wrappedValue: TimerViewModel(seconds: seconds))
        self._avatarViewModel = StateObject(wrappedValue: AvatarViewModel())
    }

    var body: some View {
        FullModal(content: {
            VStack {
                VStack(spacing: 4) {
                    Text("Current Task:")
                        .font(.headline)
                        .foregroundColor(Color("Primary"))

                    Text("PR Sekolah")
                        .font(.largeTitle)
                        .padding(10)
                        .bold()
                        .foregroundColor(Color("Primary"))
                }
                .padding(.top, 70)
                
                
                Text(timerViewModel.renderTimer())
                    .font(.system(size: 80))
                    .bold()
                
                Image(avatarViewModel.getAvatar())
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 200)
                
                VStack {
                    PrimaryButton(title: "Finish") {
                        
                    }
                    
                    PrimaryButton(title: "Abort", style: .secondary) {
                        
                    }
                }
                .padding(.top, 50)
            }
        }, isPresented: $isPresented, showCloseBtn: false)
    }
}


#Preview {
    Modal2Screen(isPresented: .constant(true), seconds: 300)
}
