//
//  RegisterView.swift
//  IZAProject
//
//  Created by Lukáš Večerka on 22.05.2023.
//

import SwiftUI
import FirebaseAuth

struct RegisterView: View {
    @Binding var showingLogin: Bool
    
    // Registration form properties
    @State var username: String = ""
    @State var email: String = ""
    @State var password: String = ""
    
    @EnvironmentObject var loginService: LoginService
    
    // Properties for information sheet
    @State var showSheet = false
    @State var sheetText = ""
    
    var body: some View {
        ZStack{
            Image("Background")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
            VStack{
                Text("Create account")
                    .multilineTextAlignment(.center)
                    .font(Font.custom("Poppins-ExtraBold", size: 55))
                    .foregroundColor(Color("Aqua"))
                    .bold()
                
                // Username form
                HStack{
                    TextField("", text: $username, prompt: Text("Username").foregroundColor(.white))
                        .foregroundColor(Color.white)
                        .font(Font.custom("Poppins-Light", size: 16))
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled(true)
                    Spacer()
                    Image(systemName: !username.isEmpty ? "checkmark" : "xmark")
                                        .foregroundColor(!username.isEmpty ? .green : .red)
                }.padding()
                .background(Color("GrayLight"))
                .cornerRadius(20)
                
                // Email form
                HStack{
                    TextField("", text: $email, prompt: Text("Email").foregroundColor(.white))
                        .foregroundColor(Color.white)
                        .font(Font.custom("Poppins-Light", size: 16))
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled(true)
                    Spacer()
                    Image(systemName: email.isEmailValid ? "checkmark" : "xmark")
                                        .foregroundColor(email.isEmailValid ? .green : .red)
                }.padding()
                .background(Color("GrayLight"))
                .cornerRadius(20)
                
                
                // Password form
                HStack{
                    SecureField("", text: $password, prompt: Text("Password").foregroundColor(.white))
                        .foregroundColor(Color.white)
                        .font(Font.custom("Poppins-Light", size: 16))
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled(true)
                    Spacer()
                    Image(systemName: password.isPasswordValid ? "checkmark" : "xmark")
                                        .foregroundColor(password.isPasswordValid ? .green : .red)
                }.padding()
                .background(Color("GrayLight"))
                .cornerRadius(20)
                
                
                Button(action: {
                    if username.isEmpty {
                        sheetText = "Username can't be empty!"
                        showSheet.toggle()
                    }else {
                        loginService.Register(email: email, password: password, username: username){ succ, err in
                            if succ{
                                showingLogin = true
                            } else if let err = err {
                                sheetText = err.localizedDescription
                                showSheet.toggle()
                            }
                        }
                    }
                }){
                    Text("Register")
                        .font(Font.custom("Poppins-Bold", size: 20))
                        .foregroundColor(.black)
                    
                        .frame(maxWidth: .infinity)
                        .padding()
                    
                        .background(RoundedRectangle(cornerRadius: 20).fill(Color("Aqua")))
                }
                .padding(.vertical)
                
                
                HStack{
                    Text("Already have account?")
                        .foregroundColor(.white)
                    Button(action: {showingLogin = true}){
                        Text("Sign in")
                            .foregroundColor(Color("Aqua"))
                    }
                }.font(Font.custom("Poppins-Light", size: 16))
            }
            .sheet(isPresented: $showSheet){
                NavigationView{
                    ErrorSheet(errText: $sheetText)
                }.presentationDetents([.fraction(0.3)])
            }
            .padding()
        }
    }
}
