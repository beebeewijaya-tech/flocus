//
//  Modal1Screen.swift
//  flocus
//
//  Created by Richie Daryl Kwenandar on 06/04/26.
//

import SwiftUI


struct Modal1Screen: View {
    @Binding var isPresented: Bool
    @State private var selected = 15
    
    var body: some View {
        FullModal(content: {
            VStack(spacing: 4) {
                Text("Current Task:")
                    .foregroundColor(Color("Primary"))
                Text("PR Sekolah")
                    .font(.title.bold())
                    .padding(10)
                    .foregroundColor(Color("Primary"))
            }
            .padding(.top,40)
            
            
            Text("Set your duration")
                .padding(.top,50)
                .foregroundColor(Color("Primary"))
            
            HStack {
                Picker("Min", selection: $selected) {
                    ForEach(15...45, id: \.self) { minute in
                        Text("\(minute)").tag(minute)
                            .foregroundStyle(Color("Primary"))
                    }
                }
                .pickerStyle(.wheel)
                .frame(width:120)
                
                Text("Min")
                    .font(.headline)
                    .foregroundColor(Color("Primary"))
                
            }
            Spacer()
            
            PrimaryButton(title: "Start") {
                isPresented = false
            }
            .padding(.bottom,120)
        }, isPresented: $isPresented)
    }
}

#Preview {
    Modal1Screen(isPresented: .constant(true))
}
