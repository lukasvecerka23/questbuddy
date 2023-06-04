//
//  RankingView.swift
//  IZAProject
//
//  Created by Lukáš Večerka on 27.05.2023.
//

import SwiftUI

struct RankingView: View {
    @Binding var showMenu: Bool
    @ObservedObject var rankingModel: RankingModel = RankingModel.shared
    @ObservedObject var userModel: UserModel = UserModel.shared
    var body: some View {
        ZStack{
            Image("Background")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
            VStack{
                Spacer().frame(height: 70)
                // List of users
                ScrollView{
                    ForEach(Array(rankingModel.users.enumerated()), id: \.1.id) { index, user in
                        HStack {
                            if index == 0 {
                                        Image("gold-small")  // Image for 1st place
                                    } else if index == 1 {
                                        Image("silver-small")  // Image for 2nd place
                                    } else if index == 2 {
                                        Image("copper-small")  // Image for 3rd place
                                    }
                            Text(user.username)
                                .font(Font.custom("Poppins-Bold", size: 25))
                            Spacer()
                            HStack {
                                Text(user.points.pointsFormat)
                                    .font(Font.custom("Poppins-Bold", size: 18))
                                Image(systemName: "diamond.fill")
                                    .foregroundColor(Color("Aqua"))
                                    .imageScale(.small)
                            }
                            .padding()
                            .frame(height: 30)
                            .background(Color("GrayMid"))
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color("GrayLight"))
                        .cornerRadius(15)
                        
                    }
                    .foregroundColor(.white)
                }
                .clipped()
            }
            .padding()
            .toolbar {
                // Points
                ToolbarItem(placement: .navigationBarLeading){
                    HStack {
                        Text(userModel.user?.points.pointsFormat ?? "0")
                            .font(Font.custom("Poppins-Bold", size: 18))
                            .foregroundColor(.white)
                        Image(systemName: "diamond.fill")
                            .foregroundColor(Color("Aqua"))
                            .imageScale(.small)
                    }
                    .padding()
                    .frame(height: 30)
                    .background(Color("GrayLight"))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                }
                ToolbarItem(placement: .principal){
                    Text("Ranking")
                        .foregroundColor(.white)
                        .font(Font.custom("Poppins-Bold", size: 30))
                }
                
                // Menu icon
                ToolbarItem(placement: .navigationBarTrailing){
                    Button(action: {
                        withAnimation{
                            showMenu.toggle()
                        }
                    }) {
                        Image(systemName: "person.fill")
                            .foregroundColor(.white)
                    }
                }
            }
        }
    }
}
