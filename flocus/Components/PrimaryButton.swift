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
    
    var backgroundColor: Color {
        switch self {
        case .primary:
            return Color("Primary")
        case .secondary:
            return Color.white
        }
    }
    
    var foregroundColor: Color {
        switch self {
        case .primary:
            return .white
        case .secondary:
            return Color("Primary")
        }
    }
    
    var borderColor: Color {
        switch self {
        case .primary:
            return .clear
        case .secondary:
            return Color("Primary")
        }
    }
    
    var borderWidth: CGFloat {
        switch self {
        case .primary:
            return 0
        case .secondary:
            return 2
        }
    }
    
}

struct PrimaryButton: View {
    let title: String
    var style: ButtonStyleVariant = .primary
    let action: () -> Void

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
    PrimaryButton(title: "Click Me", style: .secondary) {}
}
