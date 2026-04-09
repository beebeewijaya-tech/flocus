//
//  PickTimer.swift
//  flocus
//
//  Created by Richie Daryl Kwenandar on 06/04/26.
//

import SwiftUI
import SwiftData

struct PickTimerScreen: View {
    // MARK: - Model
    @Environment(\.modelContext) private var context
    @Query(sort: \TaskModel.createdAt) var tasks: [TaskModel]
    
    // MARK: - Binding
    @Binding var isPresented: Bool
    
    // MARK: - State
    @State private var selected = 15
    @State private var showFocusPage: Bool = false

    // MARK: - ViewModel
    @EnvironmentObject var timerViewModel: TimerViewModel
    @EnvironmentObject var familyControlViewModel: FamilyControlViewModel
    @EnvironmentObject var taskViewModel: TaskViewModel
    @EnvironmentObject var avatarViewModel: AvatarViewModel

    
    // MARK: - Init
    init(isPresented: Binding<Bool>) {
        self._isPresented = isPresented
    }
    
    // MARK: - Actions
    func setTimer() {
        let seconds = selected * 60
        self.timerViewModel.updateSeconds(seconds: seconds)
    }
        
    // MARK: - View
    var body: some View {
        FullModal(content: {
            CurrentTaskHeader(taskName: taskViewModel.getCurrentTask(tasks: tasks)?.name ?? "")
                .padding(.top, 40)
            
            
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
            .fullScreenCover(isPresented: $showFocusPage) {
                FocusNavigationScreen(isPresented: $showFocusPage, isPickTimerPresented: $isPresented)
                    .environmentObject(timerViewModel)
                    .environmentObject(taskViewModel)
                    .environmentObject(familyControlViewModel)
                    .environmentObject(avatarViewModel)
            }
            .padding(.bottom,120)
            
        }, isPresented: $isPresented)
    }
}

#Preview {
    let container = try! ModelContainer(for: TaskModel.self)
    let familyControlViewModel = FamilyControlViewModel()

    PickTimerScreen(isPresented: .constant(true))
        .environmentObject(TaskViewModel(context: container.mainContext))
        .environmentObject(familyControlViewModel)
        .environmentObject(TimerViewModel(seconds: 0, familyControlViewModel: familyControlViewModel))
        .modelContainer(container)
}
