//
//  LandingPage.swift
//  IZAProject
//
//  Created by Lukáš Večerka on 22.05.2023.
//

import SwiftUI
import FirebaseAuth

struct LandingPage: View {
    @State private var showingLogin = true
    @EnvironmentObject var loginService: LoginService

     var body: some View {
         VStack{
             if loginService.isLogging{
                 LoadingView()
             }
            else if loginService.isLoggedIn {
                    ContentView()
                 }
             else {
                 VStack {
                     if showingLogin {
                         LoginView(showingLogin: $showingLogin)
                             .transition(.move(edge: .top))
                     } else {
                         RegisterView(showingLogin: $showingLogin)
                             .transition(.move(edge: .bottom))
                     }
                 }.animation(.default, value: showingLogin)
             }
         }
         
     }
}
