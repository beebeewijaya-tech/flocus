//
//  HomeScreen.swift
//  flocus
//
//  Created by Bee Wijaya on 06/04/26.
//

import SwiftUI


struct HomeScreen: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Color("Secondary")
                    .ignoresSafeArea(edges: .all)
                Image("cactus")
                    .resizable()
                    .frame(width: 300, height: 300)
                    .aspectRatio(contentMode: .fit)
                    .padding(.bottom,220)
                Image("bubblechat")
                    .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 300, height: 100)
                        .padding(.bottom,550
                        )
                Text("Add a task to get started")
                    .padding(.bottom, 560)
                    .foregroundColor(.black)
                Text("Let's finish your tasks one at a time!")
                    .font(.system(size: 18))
                    .fontWeight(.bold)
                    .padding(.top, 90)
                    
            }
            .toolbar {
                
                
                ToolbarItem(placement: .topBarLeading) {
                    Menu("", systemImage: "gear") {
                        Button("Custom Avatar") {
                        }
                        Button("Custom Music") {
                        }
                        Button("Exclude Apps") {
                        }
                    }
                }
                
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Image(systemName: "pencil")
                    Image(systemName: "plus")
                }
            }
        }
    }
}


#Preview {
    HomeScreen()
}
