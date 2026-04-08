//
//  ExcludeApp.swift
//  flocus
//
//  Created by Bee Wijaya on 08/04/26.
//

import SwiftUI

struct Exclude: Identifiable {
    var id: UUID = UUID()
    var name: String
    var isEnabled: Bool
    var image: String
}


struct ExcludeApp: View {
    @Binding var isPresented: Bool
    @State private var isEnabled: Bool = false
    @State private var App = [
        Exclude(name: "Safari", isEnabled: false, image: "square.and.arrow.up.circle"),
        Exclude(name: "Safari", isEnabled: false, image: "square.and.arrow.up.circle"),
        Exclude(name: "Safari", isEnabled: false, image: "square.and.arrow.up.circle"),
    ]

    var body: some View {
        Modal(content: {
            VStack{
                VStack(spacing: 4) {
                    Text("Exclude App")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                }
                .padding(.top,20)

                List {
                    ForEach(App.indices, id: \.self) { index in
                        ExcludeAppItem(exclude: $App[index])
                    }
                }
                .listStyle(.plain)
                .padding()
            }
        },
          isPresented: $isPresented,
        )
    }
}

#Preview {
    ExcludeApp(isPresented: .constant(true))
}
