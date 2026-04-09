//
//  FullModal.swift
//  flocus
//
//  Created by Bee Wijaya on 07/04/26.
//

import SwiftUI


struct FullModal<Content: View>: View {
    @Environment(\.colorScheme) var colorScheme
    @ViewBuilder var content: Content
    @Binding var isPresented: Bool // show modal or not
    var showCloseBtn: Bool = true // showing "X" btn
    
    var body: some View {
        ZStack(alignment: .top) {
            Color("Secondary")
                .ignoresSafeArea()
            
            VStack (spacing: 16){
                if showCloseBtn {
                    HStack {
                        Button{
                            isPresented = false
                        } label: {
                            Image(systemName: "xmark")
                                .padding()
                                .glassEffect()
                                .foregroundColor(.black)
                        }
                        Spacer()
                    }
                    .padding(.horizontal)
                }
                
                
                content
            }
        }
        
    }
}


#Preview {
    FullModal(content: {
        VStack{}
    }, isPresented: .constant(true), showCloseBtn: true)
}
