//
//  PrimaryButton.swift
//  flocus
//
//  Created by Richie Daryl Kwenandar on 08/04/26.
//

import SwiftUI

enum ButtonStyleVariant {
    case primary
    case secondary
    case danger

    var backgroundColor: Color {
        switch self {
        case .primary:
            return Color("Primary")
        case .secondary:
            return Color.white
        case .danger:
            return .red
        }
    }
    
    var foregroundColor: Color {
        switch self {
        case .primary:
            return .white
        case .secondary:
            return Color("Primary")
        case .danger:
            return .white
        }
    }
    
    var borderColor: Color {
        switch self {
        case .primary, .danger:
            return .clear
        case .secondary:
            return Color("Primary")
        }
    }
    
    var borderWidth: CGFloat {
        switch self {
        case .primary, .danger:
            return 0
        case .secondary:
            return 2
        }
    }
    
}

struct PrimaryButton: View {
    var title: String
    var style: ButtonStyleVariant = .primary
    var action: () -> Void
    
  
    var body: some View {
        Button(action: action) {
            Text(title)
                .frame(width: 120, height: 35)
                .padding()
                .background(style.backgroundColor)
                .foregroundColor(style.foregroundColor)
                .overlay(
                    Capsule()
                        .stroke(style.borderColor, lineWidth: style.borderWidth)
                )
                .clipShape(Capsule())
        }
    }
}


#Preview {
    PrimaryButton(title: "Click Me", style: .danger) {}
}
