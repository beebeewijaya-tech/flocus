//
//  TimerDisplay.swift
//  flocus
//
//  Created by Bee Wijaya on 09/04/26.
//

import SwiftUI

struct TimerDisplay: View {
    let time: String

    var body: some View {
        Text(time)
            .font(.system(size: 80))
            .foregroundColor(.black)
            .bold()
    }
}

#Preview {
    TimerDisplay(time: "05:00")
}
