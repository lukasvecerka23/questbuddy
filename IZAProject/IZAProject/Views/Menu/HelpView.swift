//
//  HelpView.swift
//  IZAProject
//
//  Created by Lukáš Večerka on 31.05.2023.
//

import SwiftUI

struct HelpView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var body: some View {
        ScrollView{
            VStack(spacing: 20){
                
                Group{
                    HStack{
                        Image(systemName: "list.bullet")
                            .foregroundColor(Color("Aqua"))
                        Text("List of habits for specific day, where you can check your habits, filter your habits and edit your habits.")
                            .foregroundColor(.white)
                            .font(Font.custom("Poppins-Light", size: 12))
                        Spacer()
                    }
                    
                    HStack{
                        Image(systemName: "chart.bar.fill")
                            .foregroundColor(Color("Aqua"))
                        Text("Ranking of all users which is order by points collected from habit completions.")
                            .foregroundColor(.white)
                            .font(Font.custom("Poppins-Light", size: 12))
                        Spacer()
                    }
                    
                    HStack{
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(Color("Aqua"))
                        Text("Creation of new habit. Enter the name of habit and choose the frequency of habit (Daily, Weekly or Monthly), time of day (All day, Morning, Afternoon or Evening) and finally set the duration of the habit (e.g. 30m).")
                            .foregroundColor(.white)
                            .font(Font.custom("Poppins-Light", size: 12))
                        Spacer()
                    }
                    
                    HStack{
                        Image(systemName: "pencil")
                            .foregroundColor(Color("Aqua"))
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                        Text("By tapping on specific habit you'll get to habit detail where you can edit or remove the habit.")
                            .foregroundColor(.white)
                            .font(Font.custom("Poppins-Light", size: 12))
                        Spacer()
                    }
                    
                    HStack{
                        Image(systemName: "calendar")
                            .foregroundColor(Color("Aqua"))
                        Text("By tapping on this calendar you can choose different day to filter your habits. You can also switch between different time of the day.")
                            .foregroundColor(.white)
                            .font(Font.custom("Poppins-Light", size: 12))
                        Spacer()
                    }
                }
                
                Group{
                    HStack{
                        Image(systemName: "person.fill")
                            .foregroundColor(.white)
                        Text("You can access menu by tap on this icon. You can find user settings, statistics, help there. There is also a button to log out.")
                            .foregroundColor(.white)
                            .font(Font.custom("Poppins-Light", size: 12))
                        Spacer()
                    }
                    
                    HStack{
                        Image(systemName: "diamond.fill")
                            .foregroundColor(Color("Aqua"))
                        Text("Points are earned by completion of habits. They are used in user ranking to compare with other users.")
                            .foregroundColor(.white)
                            .font(Font.custom("Poppins-Light", size: 12))
                        Spacer()
                    }
                    
                    HStack{
                        Image(systemName: "circle")
                            .foregroundColor(Color("GrayLight"))
                        Text("When you tap on this circle you can complete habit you want.")
                            .foregroundColor(.white)
                            .font(Font.custom("Poppins-Light", size: 12))
                        Spacer()
                    }
                    
                    HStack{
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(Color("Aqua"))
                        Text("Already finished habits")
                            .foregroundColor(.white)
                            .font(Font.custom("Poppins-Light", size: 12))
                        Spacer()
                    }
                    
                    HStack{
                        Image(systemName: "gearshape")
                            .foregroundColor(.blue)
                        Text("Here you can change your username, email or password and also delete your account.")
                            .foregroundColor(.white)
                            .font(Font.custom("Poppins-Light", size: 12))
                        Spacer()
                    }
                    HStack{
                        Image(systemName: "chart.bar.xaxis")
                            .foregroundColor(.green)
                        Text("You can watch your statistics there - all completed habits etc.")
                            .foregroundColor(.white)
                            .font(Font.custom("Poppins-Light", size: 12))
                        Spacer()
                    }
                }
                
            }
            
        }.padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color("GrayDark"))
            .navigationBarBackButtonHidden(true)
            .toolbar{
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
                ToolbarItem(placement: .principal){
                    Text("Help")
                        .foregroundColor(.white)
                        .font(Font.custom("Poppins-Bold", size: 30))
                }
                
                
            }
            .navigationBarTitleDisplayMode(.inline)
    }
}
