//
//  CurrentTaskHeader.swift
//  flocus
//
//  Created by Bee Wijaya on 09/04/26.
//

import SwiftUI

struct CurrentTaskHeader: View {
    let taskName: String

    var body: some View {
        VStack(spacing: 4) {
            Text("Current Task:")
                .font(.headline)
                .foregroundColor(Color("Primary"))
            Text(taskName)
                .font(.largeTitle)
                .padding(10)
                .bold()
                .foregroundColor(Color("Primary"))
        }
    }
}

#Preview {
    CurrentTaskHeader(taskName: "PR Sekolah")
}
