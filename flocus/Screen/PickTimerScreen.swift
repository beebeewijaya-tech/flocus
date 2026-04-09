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
    @Query(sort: \TaskModel.order) var tasks: [TaskModel]
    
    // MARK: - Binding
    @Binding var isPresented: Bool
    
    // MARK: - State
    @State private var selected = 15
    @State private var showFocusPage: Bool = false

    // MARK: - ViewModel
    @StateObject var timerViewModel: TimerViewModel
    @ObservedObject var familyControlViewModel: FamilyControlViewModel
    @EnvironmentObject var taskViewModel: TaskViewModel

    
    // MARK: - Init
    init(isPresented: Binding<Bool>, familyControlViewModel: FamilyControlViewModel) {
        self._isPresented = isPresented
        self._familyControlViewModel = ObservedObject(initialValue: familyControlViewModel)
        self._timerViewModel = StateObject(wrappedValue: TimerViewModel(seconds: 0, familyControlViewModel: familyControlViewModel))
    }
    
    // MARK: - Function
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
            .fullScreenCover(isPresented: $showFocusPage, content: {
                FocusNavigationScreen(
                    isPresented: $showFocusPage,
                    timerViewModel: timerViewModel,
                    taskViewModel: taskViewModel
                )
            })
            .padding(.bottom,120)
            
        }, isPresented: $isPresented)
    }
}

#Preview {
    let container = try! ModelContainer(for: TaskModel.self)

    PickTimerScreen(
        isPresented: .constant(true),
        familyControlViewModel: FamilyControlViewModel()
    )
    .environmentObject(TaskViewModel(context: container.mainContext))
    .modelContainer(container)
}
