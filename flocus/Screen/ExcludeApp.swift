//
//  ExcludeApp.swift
//  flocus
//
//  Created by Bee Wijaya on 08/04/26.
//

import SwiftUI
import FamilyControls


struct ExcludeApp: View {
    @Binding var isPresented: Bool
    @State private var isEnabled: Bool = false
    @ObservedObject var familyControlViewModel: FamilyControlViewModel
    @State var showModalExclude: Bool = false

    var body: some View {
        Modal(content: {
            VStack{
                VStack(spacing: 4) {
                    Text("Exclude App")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                }
                .padding(.top,20)

                Image("Mascot")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                
                Text("\(familyControlViewModel.selection.applications.count) app(s) allowed")
                    .font(.title)
                    .foregroundStyle(Color("Primary"))
                    .bold()
                    .padding(.vertical, 20)
                
                PrimaryButton(title: "Allow app(s)") {
                    showModalExclude = true
                }
                .familyActivityPicker(
                    isPresented: $showModalExclude,
                    selection: $familyControlViewModel.selection
                )
            }
        },
          isPresented: $isPresented,
        )
       
    }
}

#Preview {
    ExcludeApp(
        isPresented: .constant(true),
        familyControlViewModel: FamilyControlViewModel()
    )
}
