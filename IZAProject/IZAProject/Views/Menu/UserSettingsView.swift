//
//  UserSettingsView.swift
//  IZAProject
//
//  Created by Lukáš Večerka on 30.05.2023.
//

import SwiftUI
import FirebaseAuth

struct UserSettingsView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var userModel: UserModel = UserModel.shared
    @EnvironmentObject var loginService: LoginService
    
    // For showing forms
    @State private var showUsernameForm = false
    @State private var showEmailForm = false
    @State private var showPasswordForm = false
    @State private var showDeleteForm = false
    
    // New values
    @State private var newUsername = ""
    @State private var newEmail = ""
    @State private var newPassword = ""
    
    // Properties for password
    @State private var passwordForm = ""
    @State private var emailForm = ""
    @State private var deleteForm = ""
    
    // Properties for information sheet
    @State private var showSheet = false
    @State private var errorMess = ""
    @State private var errSheet = false
    @State private var infoText = ""
    @State private var userDeletion = false
    
    @State private var userEmail = Auth.auth().currentUser?.email ?? ""
    
    var body: some View {
        VStack{
            // Username and email
            HStack{
                Text("Username")
                    .foregroundColor(.white)
                    .font(Font.custom("Poppins-Regular", size: 20))
                Spacer()
                Text(userModel.user?.username ?? "")
                    .foregroundColor(Color("Aqua"))
                    .font(Font.custom("Poppins-Regular", size: 20))
                    .opacity(0.8)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color("GrayLight"))
            .cornerRadius(20)
            HStack{
                Text("Email")
                    .foregroundColor(.white)
                    .font(Font.custom("Poppins-Regular", size: 20))
                Spacer()
                Text(userEmail)
                    .foregroundColor(Color("Aqua"))
                    .font(Font.custom("Poppins-Regular", size: 20))
                    .opacity(0.8)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color("GrayLight"))
            .cornerRadius(20)
            
            Spacer().frame(height: 50)
            
            // Change buttons
            ScrollView{
                
                // Change username
                VStack(spacing:0){
                    Button(action:{
                        newUsername = ""
                        withAnimation{
                            showUsernameForm.toggle()
                        }
                    }){
                        HStack{
                            Image(systemName: "person.fill")
                                .foregroundColor(.mint)
                                .imageScale(.large)
                            Text("Change username")
                                .font(Font.custom("Poppins-Regular", size: 16))
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(Color("Aqua"))
                                .rotationEffect(.degrees(showUsernameForm ? 90 : 0))
                                    .animation(.easeInOut(duration: 0.2), value: showUsernameForm)
                        }.foregroundColor(showUsernameForm ? Color("Aqua"): .white)
                        
                            .frame(maxWidth: .infinity)
                            .padding()
                        
                            .background(Color("GrayLight"))
                            .cornerRadius(showUsernameForm ? 0 : 20)
                    }
                    // show username form
                    if showUsernameForm{
                        Divider()
                            .background(Color("GrayLightest"))
                
                        HStack{
                            HStack{
                                TextField("", text: $newUsername, prompt: Text("New username").foregroundColor(.white))
                                    
                                    .foregroundColor(Color.white)
                                    .font(Font.custom("Poppins-Light", size: 16))
                                    .textInputAutocapitalization(.never)
                                    
                                Spacer()
                                Image(systemName: !newUsername.isEmpty ? "checkmark" : "xmark")
                                                    .foregroundColor(!newUsername.isEmpty ? .green : .red)
                            }
                            .padding()
                            .background(Color("GrayLight"))
                            
                            
                            Button(action:{
                                if newUsername.isEmpty{
                                    errorMess = "Username can't be empty."
                                    errSheet = true
                                    showSheet.toggle()
                                }else {
                                    userModel.updateUsername(to: newUsername){succ, err in
                                        if succ{
                                            infoText = "Username was sucessfuly changed!"
                                            errSheet = false
                                            showSheet.toggle()
                                        }else if let err = err{
                                            errorMess = err.localizedDescription
                                            errSheet = true
                                            showSheet.toggle()
                                        }
                                    }
                                }
                                
                                withAnimation{
                                    showUsernameForm.toggle()
                                }
                            }){
                                Image(systemName: "checkmark")
                                    .imageScale(.large)
                                    .padding()
                                    .foregroundColor(.white)
                                    
                            }
                            .background(.green)
                        }
                        
                        
                    }
                }.cornerRadius(showUsernameForm ? 20 : 0)
                
                // Change email
                VStack(spacing:0){
                    Button(action:{
                        emailForm = ""
                        newEmail = ""
                        withAnimation{
                            showEmailForm.toggle()
                        }
                    }){
                        HStack{
                            Image(systemName: "envelope.fill")
                                .foregroundColor(.cyan)
                            Text("Change email")
                                .font(Font.custom("Poppins-Regular", size: 16))
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(Color("Aqua"))
                                .rotationEffect(.degrees(showEmailForm ? 90 : 0))
                                    .animation(.easeInOut(duration: 0.2), value: showEmailForm)
                        }.foregroundColor(showEmailForm ? Color("Aqua"): .white)
                        
                            .frame(maxWidth: .infinity)
                            .padding()
                        
                            .background(Color("GrayLight"))
                            .cornerRadius(showEmailForm ? 0 : 20)
                    }
                    // show email form
                    if showEmailForm{
                        Divider()
                            .background(Color("GrayLightest"))
                        SecureField("", text: $emailForm, prompt: Text("Password").foregroundColor(.white))
                            .padding()
                            .foregroundColor(Color.white)
                            .font(Font.custom("Poppins-Light", size: 16))
                            .textInputAutocapitalization(.never)
                            .background(Color("GrayLight"))
                        Divider()
                            .background(Color("GrayLightest"))
                        HStack{
                            HStack{
                                TextField("", text: $newEmail, prompt: Text("New email").foregroundColor(.white))
                                    .foregroundColor(Color.white)
                                    .font(Font.custom("Poppins-Light", size: 16))
                                    .textInputAutocapitalization(.never)
                                    
                                Spacer()
                                Image(systemName: newEmail.isEmailValid ? "checkmark" : "xmark")
                                                    .foregroundColor(newEmail.isEmailValid ? .green : .red)
                            }
                            .padding()
                            .background(Color("GrayLight"))
                            
                            Button(action:{
                                userModel.updateEmail(to: newEmail, password: emailForm){succ, err in
                                    if succ{
                                        infoText = "Email was sucessfuly changed!"
                                        userEmail = Auth.auth().currentUser?.email ?? ""
                                        errSheet = false
                                        showSheet.toggle()
                                    }else if let err = err{
                                        errorMess = err.localizedDescription
                                        errSheet = true
                                        showSheet.toggle()
                                    }
                                }
                                withAnimation{
                                    showEmailForm.toggle()
                                }
                            }){
                                Image(systemName: "checkmark")
                                    .padding()
                                    .imageScale(.large)
                                    
                                    .foregroundColor(.white)
                                    
                            }
                            .background(.green)
                        }
                        
                        
                    }
                }.cornerRadius(showEmailForm ? 20 : 0)
                
                // Change password
                VStack(spacing:0){
                    Button(action:{
                        passwordForm = ""
                        newPassword = ""
                        withAnimation{
                            showPasswordForm.toggle()
                        }
                    }){
                        HStack{
                            Image(systemName: "lock.shield")
                                .foregroundColor(.purple)
                            Text("Change password")
                                .font(Font.custom("Poppins-Regular", size: 16))
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(Color("Aqua"))
                                .rotationEffect(.degrees(showPasswordForm ? 90 : 0))
                                    .animation(.easeInOut(duration: 0.2), value: showPasswordForm)
                        }.foregroundColor(showPasswordForm ? Color("Aqua"): .white)
                        
                            .frame(maxWidth: .infinity)
                            .padding()
                        
                            .background(Color("GrayLight"))
                            .cornerRadius(showPasswordForm ? 0 : 20)
                    }
                    // show password form
                    if showPasswordForm{
                        Divider()
                            .background(Color("GrayLightest"))
                        SecureField("", text: $passwordForm, prompt: Text("Old password").foregroundColor(.white))
                            .padding()
                            .foregroundColor(Color.white)
                            .font(Font.custom("Poppins-Light", size: 16))
                            .textInputAutocapitalization(.never)
                            .background(Color("GrayLight"))
                        Divider()
                            .background(Color("GrayLightest"))
                        HStack{
                            HStack{
                                SecureField("", text: $newPassword, prompt: Text("New password").foregroundColor(.white))
                                    .foregroundColor(Color.white)
                                    .font(Font.custom("Poppins-Light", size: 16))
                                    .textInputAutocapitalization(.never)
                                Spacer()
                                Image(systemName: newPassword.isPasswordValid ? "checkmark" : "xmark")
                                                    .foregroundColor(newPassword.isPasswordValid ? .green : .red)
                                    
                            }.padding()
                            .background(Color("GrayLight"))
                            
                            
                            Button(action:{
                                userModel.updatePassword(to: newPassword, password: passwordForm){succ, err in
                                    if succ{
                                        infoText = "Password was sucessfuly changed!"
                                        errSheet = false
                                        showSheet.toggle()
                                    }else if let err = err{
                                        errorMess = err.localizedDescription
                                        errSheet = true
                                        showSheet.toggle()
                                    }
                                }
                                withAnimation{
                                    showPasswordForm.toggle()
                                }
                            }){
                                Image(systemName: "checkmark")
                                    .padding()
                                    .imageScale(.large)
                                    
                                    .foregroundColor(.white)
                                    
                            }
                            .background(.green)
                        }
                        
                        
                    }
                }.cornerRadius(showPasswordForm ? 20 : 0)
                
                // Delete user
                VStack(spacing:0){
                    Button(action:{
                        withAnimation{
                            showDeleteForm.toggle()
                            deleteForm = ""
                        }
                    }){
                        HStack{
                            Image(systemName: "person.badge.minus")
                                .foregroundColor(.red)
                                .imageScale(.medium)
                            Text("Delete user")
                                .font(Font.custom("Poppins-Regular", size: 16))
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(Color("Aqua"))
                                .rotationEffect(.degrees(showDeleteForm ? 90 : 0))
                                    .animation(.easeInOut(duration: 0.2), value: showDeleteForm)
                        }.foregroundColor(showDeleteForm ? Color("Aqua"): .white)
                        
                            .frame(maxWidth: .infinity)
                            .padding()
                        
                            .background(Color("GrayLight"))
                            .cornerRadius(showDeleteForm ? 0 : 20)
                    }
                    // show delete form
                    if showDeleteForm{
                        Divider()
                            .background(Color("GrayLightest"))
                
                        HStack{
                            SecureField("", text: $deleteForm, prompt: Text("Password").foregroundColor(.white))
                                .padding()
                                .foregroundColor(Color.white)
                                .font(Font.custom("Poppins-Light", size: 16))
                                .textInputAutocapitalization(.never)
                                .background(Color("GrayLight"))
                            
                            Button(action:{
                                userModel.deleteUser(password: deleteForm){ result, error in
                                    if result{
                                        infoText = "User was succesfully deleted!"
                                        userDeletion.toggle()
                                    }
                                    if let error = error {
                                        errorMess = error.localizedDescription
                                        errSheet = true
                                        showSheet.toggle()
                                    }
                                }
                                withAnimation{
                                    showDeleteForm.toggle()
                                }
                            }){
                                Image(systemName: "xmark")
                                    .imageScale(.large)
                                    .padding()
                                    .foregroundColor(.white)
                                    
                            }
                            .background(.red)
                        }
                        
                        
                        
                    }
                }.sheet(isPresented: $userDeletion, onDismiss: {
                    withAnimation{
                        loginService.LogOut(){ succ in
                            if succ{
                                loginService.isLoggedIn = false
                            }else{
                                errorMess = "Something wrong happened! Unable to log out!"
                                errSheet = true;
                                showSheet.toggle()
                            }
                        }
                    }
                }){
                    NavigationView{
                        InformationSheet(text: $infoText)
                    }.presentationDetents([.fraction(0.3)])
                }
                .cornerRadius(showDeleteForm ? 20 : 0)
            }
        }.sheet(isPresented: $showSheet){
            NavigationView{
                if errSheet {
                    ErrorSheet(errText: $errorMess)
                } else {
                    InformationSheet(text: $infoText)
                }
            }.presentationDetents([.fraction(0.3)])
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("GrayDark"))
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    HStack {
                        Image(systemName: "chevron.backward")
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(.white)
                    }
                }
            }
            
            ToolbarItem(placement: .principal) {
                Text("User Settings")
                    .foregroundColor(.white)
                    .font(Font.custom("Poppins-Bold", size: 30))
            }
        }
    }
}
