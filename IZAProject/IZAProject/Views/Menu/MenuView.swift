//
//  MenuView.swift
//  IZAProject
//
//  Created by Lukáš Večerka on 29.05.2023.
//

import SwiftUI

struct MenuView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var loginService : LoginService
    @ObservedObject var userModel: UserModel = UserModel.shared
    
    // Properties for information sheets
    @State var showSheet = false
    @State var sheetText = ""
    
    var body: some View {
        NavigationView{
            VStack{
                // First box
                VStack(spacing: 0) {
                    // User settings
                    NavigationLink(destination: UserSettingsView()){
                            HStack{
                                Image(systemName: "gearshape")
                                    .foregroundColor(.blue)
                                Text("User Settings")
                                    .font(Font.custom("Poppins-Regular", size: 16))
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(Color("Aqua"))
                            }
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color("GrayLight"))
                
                    
                    Divider()
                        .background(Color("GrayLightest"))
                    
                    // Stats
                    NavigationLink(destination: StatsView()){
                        HStack{
                            Image(systemName: "chart.bar.xaxis")
                                .foregroundColor(.green)
                            Text("Stats")
                                .font(Font.custom("Poppins-Regular", size: 16))
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(Color("Aqua"))
                        }
                    }
                    .padding()
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .background(Color("GrayLight"))
                }
                .cornerRadius(15)
                .padding(.vertical)
                
                // Second box
                VStack(spacing: 0) {
                    
                    // Help
                    NavigationLink(destination: HelpView()){
                        HStack{
                            Image(systemName: "questionmark.circle")
                                .foregroundColor(.orange)
                            Text("Help")
                                .font(Font.custom("Poppins-Regular", size: 16))
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(Color("Aqua"))
                        }
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color("GrayLight"))
                    
                    Divider()
                        .background(Color("GrayLightest"))
                    
                    // Log out
                    Button(action: {
                        loginService.LogOut(){ succ in
                            if succ{
                                loginService.isLoggedIn = false
                            }else{
                                sheetText = "Something wrong happened! Unable to log out!"
                                showSheet = true;
                            }
                        }
                    }){
                        HStack{
                            Image(systemName: "person.badge.minus")
                                .foregroundColor(.red)
                            Text("Log out")
                                .font(Font.custom("Poppins-Regular", size: 16))
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(Color("Aqua"))
                        }
                    }
                    .padding()
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .background(Color("GrayLight"))
                    
                }
                .cornerRadius(15)
                Spacer()
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color("GrayDark"))
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading){
                    Button(action: {
                            dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.white)
                    }
                }
                ToolbarItem(placement: .principal){
                    Text("Menu")
                        .foregroundColor(.white)
                        .font(Font.custom("Poppins-Bold", size: 30))
                }


            }
            .navigationBarTitleDisplayMode(.inline)
        }
        .sheet(isPresented: $showSheet){
            NavigationView{
                ErrorSheet(errText: $sheetText)
            }.presentationDetents([.fraction(0.3)])
        }
        
    }
}
