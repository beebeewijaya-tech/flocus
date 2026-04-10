//
//  CongratsScreen.swift
//  flocus
//
//  Created by Muhammad Dzakki Abdullah on 07/04/26.
//

import SwiftUI
import SwiftData

struct BreakScreen: View {
    // MARK: - Model
    @Environment(\.modelContext) private var context
    @Query(sort: \TaskModel.createdAt) var tasks: [TaskModel]
    
    // MARK: - State
    @Binding var isPresented: Bool
    
    // MARK: - ViewModels
    @EnvironmentObject var avatarViewModel: AvatarViewModel
    @EnvironmentObject var timerViewModel: TimerViewModel
    @EnvironmentObject var taskViewModel: TaskViewModel
    
    init(isPresented: Binding<Bool>) {
        self._isPresented = isPresented
    }
    
    // MARK: - Actions
    func endBreak() {
        timerViewModel.stopTimer()
        isPresented = false
    }
    
    func getCurrentTask() -> String {
        return taskViewModel.getCurrentTask(tasks: tasks)?.name ?? ""
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            Color("Secondary")
                .ignoresSafeArea(edges: .all)
            VStack {
                Image("Banner")
                    .frame(maxWidth: .infinity, maxHeight: 300)
                Text("Break Time !")
                    .padding(.top, 20)
                    .padding(.bottom, 30)
                    .font(.system(size: 30, weight: .black))
                    .foregroundStyle(Color("Primary"))
                ZStack {
                    GifReaderService(gifName: "\(avatarViewModel.avatarChoose)Gif")
                           .frame(width: 300, height: 300)
                           .clipped()
                   }
                   .frame(width: 144, height: 157)
                Text("Starting \"\(getCurrentTask())\" at...")
                    .padding(.top, 35)
                    .font(.system(size: 24))
                    .foregroundStyle(Color("Primary"))
                
                TimerDisplay(
                    time: timerViewModel.renderTimer(),
                    fontSize: 34,
                    color: Color("Primary")
                )
                
                Button("Start Early") {
                    endBreak()
                }
                .frame(width: 100, height: 40)
                .padding()
                .background(Color("Primary"))
                .foregroundStyle(Color("Secondary"))
                .clipShape(Capsule())
            }
        }
        .onAppear {
            timerViewModel.updateSeconds(seconds: 10 * 60)
            timerViewModel.startTimer()
        }
        .onChange(of: timerViewModel.seconds) { _, newValue in
            if newValue == 0 {
                endBreak()
            }
        }
    }
}


#Preview {
    let container = try! ModelContainer(for: TaskModel.self)
    let familyControlViewModel = FamilyControlViewModel()

    BreakScreen(isPresented: .constant(true))
        .environmentObject(TaskViewModel(context: container.mainContext))
        .environmentObject(familyControlViewModel)
        .environmentObject(TimerViewModel(seconds: 300, familyControlViewModel: familyControlViewModel))
        .environmentObject(AvatarViewModel())
}

