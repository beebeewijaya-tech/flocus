//
//  ExcludeAppList.swift
//  flocus
//
//  Created by Bee Wijaya on 08/04/26.
//

import SwiftUI

struct ExcludeAppItem: View {
    @Binding var exclude: Exclude
    
    var body: some View {
        HStack {
            HStack(spacing: 12) {
                Image(systemName: exclude.image)
                    .font(.system(size: 56))
                Text(exclude.name)
                    .font(.title3)
                    .fontWeight(.medium)
            }

            Toggle("", isOn: $exclude.isEnabled)
                .padding()
        }
        .listRowBackground(Color("Secondary"))
    }
}
