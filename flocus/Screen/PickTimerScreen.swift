//
//  PickTimer.swift
//  flocus
//
//  Created by Richie Daryl Kwenandar on 06/04/26.
//

import SwiftUI


struct PickTimerScreen: View {
    @Binding var isPresented: Bool
    @State private var selected = 15
    @StateObject var timerViewModel: TimerViewModel
    @State private var showFocusPage: Bool = false
    @ObservedObject var familyControlViewModel: FamilyControlViewModel
    
    init(isPresented: Binding<Bool>, familyControlViewModel: FamilyControlViewModel) {
        self._isPresented = isPresented
        self._familyControlViewModel = ObservedObject(initialValue: familyControlViewModel)
        self._timerViewModel = StateObject(wrappedValue: TimerViewModel(seconds: 0, familyControlViewModel: familyControlViewModel))
    }
    
    
    func setTimer() {
        let seconds = selected * 60
        self.timerViewModel.updateSeconds(seconds: seconds)
    }
        
    var body: some View {
        FullModal(content: {
            VStack(spacing: 4) {
                Text("Current Task:")
                    .foregroundColor(Color("Primary"))
                Text("PR Sekolah")
                    .font(.title.bold())
                    .padding(10)
                    .foregroundColor(Color("Primary"))
            }
            .padding(.top,40)
            
            
            Text("Set your duration")
                .padding(.top,50)
                .foregroundColor(Color("Primary"))
            
            HStack {
                Picker("Min", selection: $selected) {
                    ForEach(15...45, id: \.self) { minute in
                        Text("\(minute)").tag(minute)
                            .foregroundStyle(Color("Primary"))
                    }
                }
                .pickerStyle(.wheel)
                .frame(width:120)
                
                Text("Min")
                    .font(.headline)
                    .foregroundColor(Color("Primary"))
                
            }
            Spacer()
            
            PrimaryButton(title: "Start") {
                showFocusPage = true
                setTimer()
            }
            .fullScreenCover(isPresented: $showFocusPage, content: {
                FocusNavigationScreen(isPresented: $showFocusPage, timerViewModel: timerViewModel)
            })
            .padding(.bottom,120)
            
        }, isPresented: $isPresented)
    }
}

#Preview {
    PickTimerScreen(isPresented: .constant(true), familyControlViewModel: FamilyControlViewModel())
}
