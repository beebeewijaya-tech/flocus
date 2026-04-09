//
//  TimerDisplay.swift
//  flocus
//
//  Created by Bee Wijaya on 09/04/26.
//

import SwiftUI

struct TimerDisplay: View {
    let time: String
    var fontSize: CGFloat = 80
    var color: Color = .black

    var body: some View {
        Text(time)
            .font(.system(size: fontSize))
            .foregroundColor(color)
            .bold()
    }
}

#Preview {
    TimerDisplay(time: "05:00")
}
