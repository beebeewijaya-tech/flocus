//
//  FocusScreen.swift
//  flocus
//
//  Created by Bee Wijaya on 07/04/26.
//

import SwiftUI
import SwiftData
import AVFoundation

struct FocusScreen: View {
    // MARK: - Model
    @Environment(\.modelContext) private var context
    @Query(sort: \TaskModel.createdAt) var tasks: [TaskModel]
    
    // MARK: - Bindings
    
    @Binding var isPresented: Bool
    @Binding var pageState: PageState
    
    // MARK: - State
    
    @State var showTaskFinished: Bool = false
    @State var abortText = ""
    @State var abortStyle: ButtonStyleVariant
    @State var longPressTask: Task<Void, Never>? = nil
    @State var showTimerEnded: Bool = false
    @State var currentTask: String = ""
    @State private var audioPlayer: AVAudioPlayer?
    @State private var existingTask: TaskModel? // this is for "Continue after break" purpose
    @State private var isSoundOn = true

    // MARK: - Storage
    @AppStorage("selected_music_file") var selectedMusic: String = "BirdSound"
    
    // MARK: - ViewModels
    
    @EnvironmentObject var avatarViewModel: AvatarViewModel
    @EnvironmentObject var timerViewModel: TimerViewModel
    @EnvironmentObject var taskViewModel: TaskViewModel
    
    
    // MARK: - Constants
    
    private let nanoseconds = 1_000_000_000
    private let timerAbort = 3
    private var initialAbortStyle: ButtonStyleVariant
    private var initialAbortTitle: String
    
    // MARK: - Init
    
    init(
        isPresented: Binding<Bool>,
        abortText: String = "Abort",
        abortStyle: ButtonStyleVariant = .secondary,
        pageState: Binding<PageState>
    ) {
        self._isPresented = isPresented
        self._abortText = State(initialValue: abortText)
        self._abortStyle = State(initialValue: abortStyle)
        self.initialAbortTitle = abortText
        self.initialAbortStyle = abortStyle
        self._pageState = pageState
    }
    
    // MARK: - Actions
    
    func runTimer() {
        timerViewModel.startTimer()
    }
    
    func stopTimer() {
        timerViewModel.stopTimer()
    }
        
    func abort() {
        abortText = "Hold to abort"
        self.stopTimer()
        isPresented = false
    }
    
    private func resetAbort() {
        longPressTask?.cancel()
        longPressTask = nil
        abortStyle = initialAbortStyle
        abortText = initialAbortTitle
    }
        
    private var holdToAbortGesture: some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { _ in
                guard longPressTask == nil else { return }
                abortStyle = .danger
                abortText = "Hold to abort"
                longPressTask = Task { @MainActor in
                    for count in stride(from: timerAbort, through: 1, by: -1) {
                        abortText = "Abort in (\(count))s"
                        try? await Task.sleep(nanoseconds: UInt64(nanoseconds))
                        guard !Task.isCancelled else { return }
                    }
                    abort()
                    abortStyle = initialAbortStyle
                    abortText = initialAbortTitle
                    longPressTask = nil
                }
            }
            .onEnded { _ in
                resetAbort()
            }
    }
        
    private func finishTask() {
        if let curTask = taskViewModel.getCurrentTask(tasks: tasks) {
            taskViewModel.markDoneToggleTask(curTask)
        }
    }
    
    
    private func finishAllTasks() -> Bool {
        // if tasks finished go to success
        if taskViewModel.isEmpty(tasks: tasks) {
            clearState()
            pageState = .success
            return true
        }
        
        return false
    }
    
    
    func clearState() {
        timerViewModel.stopTimer()
        taskViewModel.clear(tasks: tasks)
    }
    
    func playBackgroundMusic() {
        if let path = Bundle.main.path(forResource: selectedMusic, ofType: "mp3") {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
                audioPlayer?.numberOfLoops = -1
                audioPlayer?.play()
            } catch {
                print("Playback error")
            }
        }
    }
    
    private func getSoundIcon() -> String {
        if isSoundOn {
            return "speaker.wave.1.fill"
        } else {
            return "speaker.slash.fill"
        }
    }
    
    private func toggleSound() {
        if isSoundOn {
            audioPlayer?.stop()
        } else {
            playBackgroundMusic()
        }
        isSoundOn.toggle()
    }
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Image(systemName: getSoundIcon())
                    .padding()
                    .glassEffect()
                    .foregroundColor(.black)
                    .onTapGesture { toggleSound() }
            }
            .padding()
            CurrentTaskHeader(taskName: currentTask)
                .padding(.top, 20)
            TimerDisplay(time: timerViewModel.renderTimer())
            FocusAvatar(avatarName: avatarViewModel.getAvatar())
            
            VStack {
                PrimaryButton(title: "Finish") {
                    // if finishAllTasks is "true" then just return
                    self.finishTask()
                    if finishAllTasks() { return }
                    
                    showTaskFinished = true
                    self.stopTimer()
                }
                
                if longPressTask != nil {
                    Text(abortText)
                        .font(.caption)
                        .foregroundColor(.red)
                        .bold()
                }
                PrimaryButton(title: abortText, style: abortStyle) {}
                    .simultaneousGesture(holdToAbortGesture)
            }
            .padding(.top, 50)
        }
        .taskFinishedAlert(parentAlert: $isPresented, pageState: $pageState, showTaskFinished: $showTaskFinished)
        .timesUpAlert(parentAlert: $isPresented, pageState: $pageState, showTimerEnded: $showTimerEnded, continueAfterBreakAction: {
            taskViewModel.markDoneToggleTask(existingTask!) 
        })
        // MARK: - Event Lifecycle
        .onAppear {
            currentTask = taskViewModel.getCurrentTask(tasks: tasks)?.name ?? ""
            existingTask = taskViewModel.getCurrentTask(tasks: tasks) ?? nil
            runTimer()
            playBackgroundMusic()
        }
        .onDisappear {
            audioPlayer?.stop()
        }
        .onChange(of: timerViewModel.seconds) { _, newValue in
            // if finishAllTasks is "true" then just return
            if finishAllTasks() { return }
            
            if newValue == 0 {
                
                // if finishAllTasks is "true" then just return
                self.finishTask()
                if finishAllTasks() { return }
                
                self.stopTimer()
                showTimerEnded = true
            }
        }
    }
}

// MARK: - Preview

#Preview {
    let container = try! ModelContainer(for: TaskModel.self)
    let familyControlViewModel = FamilyControlViewModel()

    FocusScreen(
        isPresented: .constant(true),
        pageState: .constant(.focused),
    )
    .environmentObject(familyControlViewModel)
    .environmentObject(TimerViewModel(seconds: 25 * 60, familyControlViewModel: familyControlViewModel))
    .environmentObject(TaskViewModel(context: container.mainContext))
    .environmentObject(AvatarViewModel())
}
