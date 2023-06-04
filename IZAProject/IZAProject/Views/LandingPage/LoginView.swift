//
//  LoginView.swift
//  IZAProject
//
//  Created by Lukáš Večerka on 22.05.2023.
//

import SwiftUI

struct LoginView: View {
    @Binding var showingLogin: Bool
    
    // Login form properties
    @State var email: String = ""
    @State var password: String = ""
    
    @EnvironmentObject var loginService: LoginService
    
    // Properties for information sheets
    @State var showSheet = false
    @State var sheetText = ""
    
    var body: some View {
        ZStack{
            Image("Background")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
            VStack{
                Text("Welcome in")
                    .font(Font.custom("Poppins-ExtraBold", size: 50))
                    .foregroundColor(.white)
                    .bold()
                Text("QuestBuddy")
                    .font(Font.custom("Poppins-ExtraBold", size: 55))
                    .foregroundColor(Color("Aqua"))
                    .bold()
                
                Text("Let's start your productive journey!")
                    .font(Font.custom("Poppins-Light", size: 18))
                    .padding()
                    .foregroundColor(.white.opacity(0.7))
                
                // Email login
                TextField("", text: $email, prompt: Text("Email").foregroundColor(.white))
                    .padding()
                    .background(Color("GrayLight"))
                    .foregroundColor(Color.white)
                    .cornerRadius(20)
                    .font(Font.custom("Poppins-Light", size: 16))
                    .textInputAutocapitalization(.never)
                
                // Password login
                SecureField("", text: $password, prompt: Text("Password").foregroundColor(.white))
                    .padding()
                    .background(Color("GrayLight"))
                    .foregroundColor(Color.white)
                    .cornerRadius(20)
                    .font(Font.custom("Poppins-Light", size: 16))
                    .textInputAutocapitalization(.never)
                
                Button(action:{
                    // Try to log in, if error occure pop up sheet
                    loginService.LogIn(email: email, password: password){succ, err in
                        if succ{
                            
                        }else if let err = err {
                            sheetText = err.localizedDescription
                            showSheet.toggle()
                        }
                    }
                }){
                    Text("Sign In")
                        .font(Font.custom("Poppins-Bold", size: 20))
                        .foregroundColor(.black)
                    
                        .frame(maxWidth: .infinity)
                        .padding()
                    
                        .background(RoundedRectangle(cornerRadius: 20).fill(Color("Aqua")))
                }
                .padding(.vertical)
                
                HStack{
                    Text("New to QuestBuddy?")
                        .foregroundColor(.white)
                    Button(action: {showingLogin = false}){
                        Text("Register")
                            .foregroundColor(Color("Aqua"))
                    }
                }.font(Font.custom("Poppins-Light", size: 16))
                
            }.padding()
            .sheet(isPresented: $showSheet){
                NavigationView{
                    ErrorSheet(errText: $sheetText)
                }.presentationDetents([.fraction(0.3)])
            }
        }
    }
}
