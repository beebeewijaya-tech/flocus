//
//  Modal.swift
//  flocus
//
//  Created by Bee Wijaya on 07/04/26.
//

import SwiftUI



struct Modal<Content: View>: View {
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
                            Image(systemName: "chevron.left")
                                .padding()
                                .foregroundColor(Color("Primary"))
                        }
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.top, 40)
                }
                
                
                content
            }
        }
        
    }
}


#Preview {
    Modal(content: {
        VStack{}
    }, isPresented: .constant(true), showCloseBtn: true)
}
