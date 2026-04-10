//
//  AvatarViewModel.swift
//  flocus
//
//  Created by Bee Wijaya on 09/04/26.
//

import SwiftUI
import Combine

class AvatarViewModel: ObservableObject {
    @AppStorage("avatarChoose") var avatarChoose: String = "Cactus"

    
    func getAvatar() -> String {
        return avatarChoose
    }
    
    func chooseAvatar(avatar: String) {
        avatarChoose = avatar
    }
}
