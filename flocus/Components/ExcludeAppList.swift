//
//  ExcludeAppList.swift
//  flocus
//
//  Created by Bee Wijaya on 08/04/26.
//

import SwiftUI

struct ExcludeAppItem: View {
    @Binding var appItem: AppItem
    
    var body: some View {
        HStack {
            HStack(spacing: 12) {
                Image(systemName: appItem.image)
                    .font(.system(size: 56))
                Text(appItem.name)
                    .font(.title3)
                    .fontWeight(.medium)
            }

            Toggle("", isOn: $appItem.isEnabled)
                .padding()
        }
        .listRowBackground(Color("Secondary"))
    }
}
