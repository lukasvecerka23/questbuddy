//
//  StatsView.swift
//  IZAProject
//
//  Created by Lukáš Večerka on 31.05.2023.
//

import SwiftUI

struct StatsView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var userModel: UserModel = UserModel.shared
    
    var body: some View {
        VStack(spacing: 20){
            HStack{
                Text("Completed Habits")
                    .foregroundColor(.white)
                    .font(Font.custom("Poppins-Regular", size: 20))
                Spacer()
                Text(userModel.userStats.completedHabits.pointsFormat)
                    .foregroundColor(Color("Aqua"))
                    .font(Font.custom("Poppins-Regular", size: 20))
                    .opacity(0.8)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color("GrayLight"))
            .cornerRadius(20)
            
            HStack{
                Text("Created Habits")
                    .foregroundColor(.white)
                    .font(Font.custom("Poppins-Regular", size: 20))
                Spacer()
                Text(userModel.userStats.createdHabits.pointsFormat)
                    .foregroundColor(Color("Aqua"))
                    .font(Font.custom("Poppins-Regular", size: 20))
                    .opacity(0.8)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color("GrayLight"))
            .cornerRadius(20)
            
            
            HStack{
                Text("Completed duration")
                    .foregroundColor(.white)
                    .font(Font.custom("Poppins-Regular", size: 20))
                Spacer()
                Text(userModel.userStats.completedDuration.durationFormatNormal)
                    .foregroundColor(Color("Aqua"))
                    .font(Font.custom("Poppins-Regular", size: 20))
                    .opacity(0.8)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color("GrayLight"))
            .cornerRadius(20)
            Spacer()
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
                    Text("Stats")
                        .foregroundColor(.white)
                        .font(Font.custom("Poppins-Bold", size: 30))
                }
                
                
            }
            .navigationBarTitleDisplayMode(.inline)
    }
}

struct StatsView_Previews: PreviewProvider {
    static var previews: some View {
        StatsView()
    }
}
