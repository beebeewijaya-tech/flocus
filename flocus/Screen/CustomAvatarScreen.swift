//
//  CustomAvatarScreen.swift
//  flocus
//
//  Created by Steffany Florence on 07/04/26.
//

import SwiftUI

struct CustomAvatarScreen: View {
    @Binding var isPresented: Bool
    @State var selectedTab = 0
    @State var selectedAvatar: String = "Cactus"
    var imageList: Array = ["Cactus", "Lavender", "PalmTree", "SnakePlant"]
    
    var body: some View {
        Modal(content: {
            VStack(spacing: 0) {
                Text("Choose your Avatar!")
                    .font(.title)
                    .foregroundColor(Color("Primary"))
                
                TabView(selection: $selectedTab) {
                    ForEach(0..<4) { i in
                        Image(imageList[i])
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                            .tag(i)
                    }
                }
                .onChange(of: selectedTab) { newValue in
                    selectedAvatar = imageList[newValue]
                }
                .frame(height: 280)
                .padding(.bottom, 50)
                .tabViewStyle(.page)
                .indexViewStyle(.page(backgroundDisplayMode: .always))
                
                VStack(spacing: 40) {
                    HStack(spacing: 40) {
                        avatarButton(icon: "Cactus", idx: 0)
                        avatarButton(icon: "Lavender", idx: 1)
                    }
                    
                    HStack(spacing: 40) {
                        avatarButton(icon: "PalmTree", idx: 2)
                        avatarButton(icon: "SnakePlant", idx: 3)
                    }
                }
            }
        }, isPresented: $isPresented)
    }
    
    func avatarButton(icon: String, idx: Int) -> some View {
        Button(action: {
            saveAvatar(icon)
            selectedTab = idx
        }) {
            Image(icon)
                .resizable()
                .scaledToFit()
                .frame(width: 110, height: 100)
                .padding(10)
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(selectedAvatar == icon ? Color("Primary") : Color.clear, lineWidth: 2)
                )
        }
        .buttonStyle(.plain)
    }
    
    func saveAvatar(_ name: String) {
        selectedAvatar = name
    }
}

#Preview {
    CustomAvatarScreen(isPresented: .constant(true))
}
