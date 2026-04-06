//
//  ContentView.swift
//  flocus
//
//  Created by Bee Wijaya on 06/04/26.
//

import SwiftUI

struct ContentView: View {
    @State private var showModal1 = false

    var body: some View {
        Button("Modal 1") {
            showModal1 = true
        }
        .fullScreenCover(isPresented: $showModal1) {
            Modal1Screen(showed: $showModal1)
        }
    }
}

#Preview {
    ContentView()
}
