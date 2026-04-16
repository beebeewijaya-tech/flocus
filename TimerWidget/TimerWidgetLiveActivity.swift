//
//  TimerWidgetLiveActivity.swift
//  TimerWidget
//
//  Created by Bee Wijaya on 06/04/26.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct TimerWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var taskName: String
        var quotes: String
        var endDate: Date
    }
}

struct LockScreenView: View {
    var context: ActivityViewContext<TimerWidgetAttributes>
    
    var body: some View {
        let isExpired = context.state.endDate < Date()
        
        VStack {
            HStack(alignment: .top, spacing: 20) {
                ZStack {
                    Color.white
                        .frame(width: 80, height: 80)
                        .clipShape(Circle())
                        .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 2)
                    Color("Secondary")
                        .frame(width: 70, height: 70)
                        .clipShape(Circle())
                    
                    Image("Mascot")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60, height: 60)
                        .clipShape(Circle())
                }
                
                if isExpired {
                    VStack(alignment: .leading) {
                        Text("Time's up")
                            .font(.caption)
                            .foregroundStyle(.white)
                        Text("Open your app to continue!")
                            .font(.caption)
                            .foregroundStyle(.white)
                    }
                    .padding(.top, 12)
                    .frame(maxWidth: .infinity, alignment: .leading)
                } else {
                    VStack(alignment: .leading) {
                        Text(timerInterval: Date.now...context.state.endDate, countsDown: true)
                            .font(.title2)
                            .foregroundStyle(.white)
                            .bold()
                        Text("Study")
                            .font(.caption)
                            .foregroundStyle(.white)
                        Text("Task: \(context.state.taskName)")
                            .font(.caption)
                            .foregroundStyle(.white)
                    }
                    .padding(.top, 12)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding()
            .padding(.top)
            
            Text(context.state.quotes)
                .padding()
                .padding(.bottom)
                .font(.caption)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .background(Color.black.opacity(0.3))
        }
    }
}

struct TimerWidgetLiveActivity: Widget {
    func renderTimer(seconds: Int) -> String {
        let sec = seconds % 60
        let min = seconds / 60
        let formattedTime = String(format: "%02d:%02d", min, sec)
        return formattedTime
    }
    
    
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: TimerWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            LockScreenView(context: context)
        } dynamicIsland: { context in
            let isExpired = context.state.endDate < Date()
            return DynamicIsland {
                DynamicIslandExpandedRegion(.bottom) {
                    VStack {
                        HStack(alignment: .top, spacing: 20) {
                            ZStack {
                                Color.white
                                    .frame(width: 80, height: 80)
                                    .clipShape(Circle())
                                    .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 2)
                                Color("Secondary")
                                    .frame(width: 70, height: 70)
                                    .clipShape(Circle())
                                
                                Image("Mascot")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 60, height: 60)
                                    .clipShape(Circle())
                            }
                            
                            
                            VStack(alignment: .leading) {
                                if isExpired {
                                    Text("Time's up")
                                        .font(.caption)
                                        .foregroundStyle(.white)
                                    Text("Open your app to continue!")
                                        .font(.caption)
                                        .foregroundStyle(.white)
                                } else {
                                    Text(timerInterval: Date.now...max(Date.now, context.state.endDate), countsDown: true)
                                        .font(.title2)
                                        .foregroundStyle(.white)
                                        .bold()
                                    Text("Study")
                                        .font(.caption)
                                        .foregroundStyle(.white)
                                    Text("Task: \(context.state.taskName)")
                                        .font(.caption)
                                        .foregroundStyle(.white)
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                }
            } compactLeading: {
                if !isExpired {
                    Image(systemName: "clock")
                        .foregroundStyle(.green)
                        .bold()
                }
            } compactTrailing: {
                if !isExpired {
                    // only show if not expired
                    Text(timerInterval: Date.now...context.state.endDate, countsDown: true)
                        .font(.caption)
                        .foregroundStyle(.green)
                        .frame(width: 40)
                        .monospacedDigit()
                        .bold()
                }
            } minimal: {
                if !isExpired {
                    // only show if not expired
                    Image(systemName: "clock")
                        .foregroundStyle(.green)
                        .bold()
                }
            }
        }
    }
}



#Preview("Timer Lock Screen", as: .content, using: TimerWidgetAttributes()) {
    TimerWidgetLiveActivity()
} contentStates: {
    TimerWidgetAttributes.ContentState(taskName: "Tugas 1", quotes: "Stop Looking at screen!", endDate: Date().addingTimeInterval(TimeInterval(300)))
}


#Preview("Timer Island", as: .dynamicIsland(.compact), using: TimerWidgetAttributes()) {
    TimerWidgetLiveActivity()
} contentStates: {
    TimerWidgetAttributes.ContentState(taskName: "Tugas 1", quotes: "Stop Looking at screen!", endDate: Date().addingTimeInterval(TimeInterval(300)))
}
