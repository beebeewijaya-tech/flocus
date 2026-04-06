//
//  Modal1Screen.swift
//  flocus
//
//  Created by Richie Daryl Kwenandar on 06/04/26.
//

import SwiftUI


struct Modal1Screen: View {
    @Binding var showed: Bool
    @State private var selected = 15
    
    var body: some View {
        ZStack {
            Color("Secondary")
                .ignoresSafeArea()
            
            VStack (spacing: 16){
                
                HStack {
                    
                    Button(action: {showed = false}) {
                        Image(systemName: "xmark")
                            .padding()
                            .glassEffect()
                            .foregroundColor(Color("Primary"))
                    }
                    Spacer()
                }
                .padding(.horizontal)
                
                
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
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(width:120)
                    
                    Text("Min")
                        .font(.headline)
                        .foregroundColor(Color("Primary"))
                    
                    
                }
                Spacer()
                
                Button(action: {
                    print("Durasi dipilih: \(selected) menit")
                    showed = false}) {
                        Text("Start")
                            .frame(width: 120,height: 35)
                            .padding()
                            .background(Color("Primary"))
                            .foregroundColor(.white)
                            .clipShape(Capsule())
                    }
                    .padding(.bottom,120)
            }
        }
    }
}
