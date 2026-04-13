//
//  CustomAvatarScreen.swift
//  flocus
//
//  Created by Steffany Florence on 07/04/26.
//

import SwiftUI
import SwiftData

struct CustomAvatarScreen: View {
    // MARK: - Binding
    @Binding var isPresented: Bool
    
    // MARK: - State
    @State private var selectedTab = 0
    @State private var selectedAvatar: String = "Cactus"
    
    // MARK: - Properties
    var imageList: Array = ["Cactus", "Lavender", "PalmTree", "SnakePlant"]
    
    // MARK: - ViewModel
    @EnvironmentObject private var avatarViewModel: AvatarViewModel
    
    
    // MARK: - Actions
    func saveAvatar(_ name: String) {
        selectedAvatar = name
        avatarViewModel.avatarChoose = name
        avatarViewModel.saveAvatar(avatar: name)
    }
    
    func getAvatar() {
        selectedAvatar = avatarViewModel.avatarChoose
        selectedTab = imageList.firstIndex(of: selectedAvatar) ?? 0
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
    
    @ViewBuilder
    func avatarDisplay(icon:String, isSelected: Bool) -> some View {
            if isSelected {
            GifReaderService(gifName: "\(icon)Gif")
                    .frame( width: 200)
            } else {
                Image(icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200)
            }
    }
    
    // MARK: - View
    
    var body: some View {
        Modal(content: {
            VStack(spacing: 0) {
                Text("Choose your Avatar!")
                    .font(.title)
                    .foregroundColor(Color("Primary"))
                    .fontWeight(.bold)
                
                TabView(selection: $selectedTab) {
                    ForEach(0..<4) { i in
                        avatarDisplay(
                            icon: imageList [i],
                            isSelected: selectedAvatar == imageList[i]
                        ) .tag(i)
//                        Image(imageList[i])
//                            .resizable()
//                            .scaledToFit()
//                            .frame(height: 200)
//                            .tag(i)
                    }
                }
                .onChange(of: selectedTab) { _, newValue in
                    saveAvatar(imageList[newValue])
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
        .onAppear {
            getAvatar()
        }
    }
}

#Preview {
    CustomAvatarScreen(isPresented: .constant(true))
        .environmentObject(AvatarViewModel())
}
