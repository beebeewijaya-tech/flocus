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
        var imageTree: String
        var timer: Int
        var quotes: String
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

                        Image("Cactus")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 60, height: 60)
                            .clipShape(Circle())
                    }
                        
                    
                    VStack(alignment: .leading) {
                        Text(renderTimer(seconds: context.state.timer))
                            .font(.title2)
                            .foregroundStyle(.white)
                            .bold()
                        Text("Study")
                            .font(.caption)
                            .foregroundStyle(.white)
                        Text("Task: Tugas 1")
                            .font(.caption)
                            .foregroundStyle(.white)
                    }
                    .padding(.top, 12)
                    .frame(maxWidth: .infinity, alignment: .leading)
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
        } dynamicIsland: { context in
            DynamicIsland {
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

                                Image("Cactus")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 60, height: 60)
                                    .clipShape(Circle())
                            }
                                
                            
                            VStack(alignment: .leading) {
                                Text(renderTimer(seconds: context.state.timer))
                                    .font(.title2)
                                    .foregroundStyle(.white)
                                    .bold()
                                Text("Study")
                                    .font(.caption)
                                    .foregroundStyle(.white)
                                Text("Task: Tugas 1")
                                    .font(.caption)
                                    .foregroundStyle(.white)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                }
            } compactLeading: {
                Image(systemName: "clock")
                    .foregroundStyle(.green)
                    .bold()
            } compactTrailing: {
                Text(renderTimer(seconds: context.state.timer))
                    .font(.title2)
                    .foregroundStyle(.green)
                    .bold()
            } minimal: {
                Image(systemName: "clock")
                    .foregroundStyle(.green)
                    .bold()
            }
        }
    }
}



#Preview("Timer Lock Screen", as: .content, using: TimerWidgetAttributes()) {
    TimerWidgetLiveActivity()
} contentStates: {
    TimerWidgetAttributes.ContentState(imageTree: "🌳", timer: 300, quotes: "Stop Looking at screen!")
}


#Preview("Timer Island", as: .dynamicIsland(.compact), using: TimerWidgetAttributes()) {
    TimerWidgetLiveActivity()
} contentStates: {
    TimerWidgetAttributes.ContentState(imageTree: "🌳", timer: 100, quotes: "Stop Looking at screen!")
}
