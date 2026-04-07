//
//  FullModal.swift
//  flocus
//
//  Created by Bee Wijaya on 07/04/26.
//

import SwiftUI


struct FullModal<Content: View>: View {
    @ViewBuilder var content: Content
    @Binding var showed: Bool // show modal or not
    var showCloseBtn: Bool = true // showing "X" btn
    
    var body: some View {
        ZStack(alignment: .top) {
            Color("Secondary")
                .ignoresSafeArea()
            
            VStack (spacing: 16){
                if showCloseBtn {
                    HStack {
                        Button{
                            showed = false
                        } label: {
                            Image(systemName: "xmark")
                                .padding()
                                .glassEffect()
                                .foregroundColor(Color("Primary"))
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
    }, showed: .constant(true), showCloseBtn: true)
}
