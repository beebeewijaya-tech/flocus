//
//  ExcludeApp.swift
//  flocus
//
//  Created by Bee Wijaya on 08/04/26.
//

import SwiftUI
import FamilyControls


struct ExcludeApp: View {
    // MARK: - Binding
    @Binding var isPresented: Bool
    
    // MARK: - State
    @State private var isEnabled: Bool = false
    @State var showModalExclude: Bool = false
    
    // MARK: - ViewModel
    @EnvironmentObject var familyControlViewModel: FamilyControlViewModel


    var body: some View {
        Modal(content: {
            VStack{
                VStack(spacing: 4) {
                    Text("Exclude App")
                        .font(.title)
                        .foregroundColor(Color("Primary"))
                        .fontWeight(.bold)
                }
        

                Image("Mascot")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                
                Text("\(familyControlViewModel.selection.applications.count) app(s) allowed")
                    .font(.system(size: 20))
                    .foregroundStyle(Color("Primary").opacity(0.6))
                    .padding(.top, 10)
                    .padding(.bottom,30)
                
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
    ExcludeApp(isPresented: .constant(true))
        .environmentObject(FamilyControlViewModel())
}
