//
//  CustomAvatarScreen.swift
//  flocus
//
//  Created by Steffany Florence on 07/04/26.
//

import SwiftUI

struct CustomAvatarScreen: View {
    
    @State var selectedTab = 0
    @State var selectedAvatar: String = "star.fill"
    var imageList: Array = ["star.fill", "moon.fill", "circle.fill", "cloud.fill"]
    
    var body: some View {
        VStack(spacing: 0) {
            Text("Choose your Avatar!")
                .font(.title)
            
            TabView(selection: $selectedTab) {
                ForEach(0..<4) { i in
                    Image(systemName: imageList[i])
                        .font(.system(size: 100))
                        .tag(i)
                }
            }
            .onChange(of: selectedTab) { newValue in
                selectedAvatar = imageList[newValue]
            }
            .frame(height: 300)
            .padding(.bottom, 50)
            .tabViewStyle(.page)
            .indexViewStyle(.page(backgroundDisplayMode: .always))
            
            VStack(spacing: 40) {
                HStack(spacing: 40) {
                    avatarButton(icon: "star.fill", idx: 0)
                    avatarButton(icon: "moon.fill", idx: 1)
                }
                
                HStack(spacing: 40) {
                    avatarButton(icon: "circle.fill", idx: 2)
                    avatarButton(icon: "cloud.fill", idx: 3)
                }
            }
        }
    }
    
    func avatarButton(icon: String, idx: Int) -> some View {
        Button(action: {
            saveAvatar(icon)
            selectedTab = idx
        }) {
            Image(systemName: icon)
                .font(.system(size: 80))
                .foregroundStyle(selectedAvatar == icon ? Color("Primary") : .gray)
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
    CustomAvatarScreen()
}
