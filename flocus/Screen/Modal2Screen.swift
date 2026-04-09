//
//  Modal2Screen.swift
//  flocus
//
//  Created by Bee Wijaya on 07/04/26.
//

import SwiftUI


struct Modal2Screen: View {
    @Binding var isPresented: Bool

    var body: some View {
        FullModal(content: {
            VStack {
                Text("Modal 2")
                    .font(.largeTitle)
                    .bold()
                    .padding()
            }
        }, isPresented: $isPresented, showCloseBtn: false)
    }
}


#Preview {
    Modal2Screen(isPresented: .constant(true))
}
