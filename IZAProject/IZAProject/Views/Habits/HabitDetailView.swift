//
//  HabitDetailView.swift
//  IZAProject
//
//  Created by Lukáš Večerka on 30.05.2023.
//

import SwiftUI

struct HabitDetailView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var habit: Habit?
    @State var showEditSheet = false
    
    var body: some View {
        VStack{
            if let habit = habit{
                // title
                Text(habit.title)
                    .foregroundColor(.white)
                    .font(Font.custom("Poppins-Bold", size: 30))
                
                // frequency
                HStack{
                    Text("Frequency")
                        .foregroundColor(.white)
                        .font(Font.custom("Poppins-Regular", size: 20))
                    Spacer()
                    Text(Frequency(rawValue: habit.frequency)?.stringValue ?? "")
                        .foregroundColor(Color("Aqua"))
                        .font(Font.custom("Poppins-Regular", size: 20))
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color("GrayLight"))
                .cornerRadius(20)
                
                // time of day
                HStack{
                    Text("Time of day")
                        .foregroundColor(.white)
                        .font(Font.custom("Poppins-Regular", size: 20))
                    Spacer()
                    Text(TimeOfDay(rawValue: habit.timeOfDay)?.stringValue ?? "")
                        .foregroundColor(Color("Aqua"))
                        .font(Font.custom("Poppins-Regular", size: 20))
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color("GrayLight"))
                .cornerRadius(20)
                
                // duration
                HStack{
                    Text("Duration")
                        .foregroundColor(.white)
                        .font(Font.custom("Poppins-Regular", size: 20))
                        .multilineTextAlignment(.center)
                    Spacer()
                    Text(habit.duration.durationFormatNormal)
                        .foregroundColor(Color("Aqua"))
                        .font(Font.custom("Poppins-Regular", size: 20))
                        .multilineTextAlignment(.center)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color("GrayLight"))
                .cornerRadius(20)
                
                Spacer()
            }
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
            
            ToolbarItem(placement: .navigationBarTrailing){
                HStack{
                    // Edit
                    Button(action: {
                        showEditSheet.toggle()
                    }){
                        Image(systemName: "pencil")
                            .foregroundColor(Color("Aqua"))
                    }.sheet(isPresented: $showEditSheet){
                        NavigationView{
                            HabitEditView(habit: $habit)
                        }
                    }
                    // Remove
                    Button(action: {
                        if let habitId = habit?.id{
                            HabitsModel.shared.deleteHabitAndLogs(habitId: habitId)
                            dismiss()
                        }
                    }){
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                    }
                }
                .foregroundColor(.white)
            }
        }
    }
}
