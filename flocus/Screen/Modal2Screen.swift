//
//  Modal2Screen.swift
//  flocus
//
//  Created by Bee Wijaya on 07/04/26.
//

import SwiftUI


struct Modal2Screen: View {
    @Binding var showed: Bool

    var body: some View {
        FullModal(content: {
            VStack {
                Text("Modal 2")
                    .font(.largeTitle)
                    .bold()
                    .padding()
            }
        }, showed: $showed, showCloseBtn: false)
    }
}


#Preview {
    Modal2Screen(showed: .constant(true))
}
