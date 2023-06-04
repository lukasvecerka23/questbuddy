//
//  LoadingView.swift
//  IZAProject
//
//  Created by Lukáš Večerka on 26.05.2023.
//

import SwiftUI

struct LoadingView: View {
    @State private var isSpinning = false

    var body: some View {
        ZStack{
            Image("Background")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
            VStack{
                Text("QuestBuddy")
                    .font(Font.custom("Poppins-ExtraBold", size: 55))
                    .foregroundColor(Color("Aqua"))
                Circle()
                    .trim(from: 0.0, to: 0.75)
                    .stroke(Color("Aqua"), lineWidth: 8)
                    .frame(width: 50, height: 50)
                    .rotationEffect(Angle(degrees: isSpinning ? 360 : 0))
                    .animation(.linear(duration: 1).repeatForever(autoreverses: false), value: self.isSpinning)
                    .onAppear() {
                        self.isSpinning = true
                    }
            }.padding()
        }
        
    }
}
