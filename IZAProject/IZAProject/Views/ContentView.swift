//
//  ContentView.swift
//  IZAProject
//
//  Created by Lukáš Večerka on 26.05.2023.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @State var selectedTab: Tab = .habits
    @State var showMenu = false
    
    var body: some View {
        ZStack{
            NavigationView{
                VStack{
                    if selectedTab == .habits {
                        HabitsView(showMenu: $showMenu)
                            .transition(.slide)
                    } else if selectedTab == .ranking {
                        RankingView(showMenu: $showMenu)
                            .transition(.slide)
                    } else {
                        Text("Error")
                    }
                }
                .animation(.default, value: selectedTab)
            }
            VStack{
                Spacer()
                MenuBarView(selectedTab: $selectedTab)
            }
        }
        .edgesIgnoringSafeArea(.all)
        .sheet(isPresented: $showMenu){
                MenuView()
        }
    }
}
