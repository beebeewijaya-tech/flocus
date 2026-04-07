//
//  CongratsScreen.swift
//  flocus
//
//  Created by Muhammad Dzakki Abdullah on 07/04/26.
//

import SwiftUI

struct CongratsScreen: View {
    var body: some View {
        ZStack(alignment: .top) {
            Color("Secondary")
                .ignoresSafeArea(edges: .all)
            VStack {
                Image("Banner")
                    .frame(maxWidth: .infinity, maxHeight: 300)
                Text("CONGRATULATIONS")
                    .padding(.top, 20)
                    .padding(.bottom, 35)
                    .font(.system(size: 30, weight: .black))
                    .foregroundStyle(Color("Primary"))
                
                Image("Cactus")
                    .resizable()
                    .frame(width: 144, height: 157)
                Text("All Tasks have been")
                    .padding(.top, 35)
                    .font(.system(size: 24))
                    .foregroundStyle(Color("Primary"))
                Text("COMPLETED")
                    .font(.system(size: 34, weight: .black))
                    .foregroundStyle(Color("Primary"))
                    .padding(.bottom, 29)
                
                Button("Back Home") {
                }
                .frame(width: 100, height: 40)
                .padding()
                .background(Color("Primary"))
                .foregroundStyle(Color("Secondary"))
                .clipShape(Capsule())
            }
        }
    }
}
#Preview {
    CongratsScreen()
}
