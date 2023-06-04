//
//  MenuBarView.swift
//  IZAProject
//
//  Created by Lukáš Večerka on 27.05.2023.
//

import SwiftUI

enum Tab: String, CaseIterable {
    case habits
    case ranking
}

struct MenuBarView: View {
    @Binding var selectedTab: Tab
    
    var body: some View {
            HStack{
                Spacer()
                
                // Habits
                Button(action: {selectedTab = .habits}){
                    VStack{
                        Image(systemName: "list.bullet")
                        Text("Habits")
                            .font(Font.custom("Poppins-Light", size: 16))
                    }
                    .padding()
                    .foregroundColor(selectedTab == .habits ? Color("Aqua") : .white)
                }
                Spacer()
                
                // Ranking
                Button(action: {selectedTab = .ranking}){
                    VStack{
                        Image(systemName: "chart.bar.fill")
                        Text("Ranking")
                            .font(Font.custom("Poppins-Light", size: 16))
                    }
                    .padding()
                    .foregroundColor(selectedTab == .ranking ? Color("Aqua") : .white)
                }
                Spacer()
        
            }
            .frame(width: nil, height: 100)
            .background(Color("GrayDark"), in: RoundedRectangle(cornerRadius: 30))
            .background(content: {Color("GrayDark").padding(.top, 20)})
    }
}
