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
                Color.black.opacity(0.1)
                    .ignoresSafeArea(edges: .all)
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Image(systemName: "gear")

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
