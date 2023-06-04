//
//  AddNewHabitView.swift
//  IZAProject
//
//  Created by Lukáš Večerka on 30.05.2023.
//

import SwiftUI

struct AddNewHabitView: View {
    @Environment(\.dismiss) var dismiss
    
    // New habit properties
    @State var title = ""
    @State var selectedTimeOfDay: TimeOfDay = .allday
    @State var selectedFrequency: Frequency = .daily
    @State var selectedDuration:Int = 0
    
    @State var showDurationPicker: Bool = false
    
    var body: some View {
        VStack(spacing: 30){
            
            // Name
            TextField("", text: $title, prompt: Text("Name").foregroundColor(.white))
                .padding()
                .background(Color("GrayLight"))
                .foregroundColor(Color.white)
                .cornerRadius(20)
                .font(Font.custom("Poppins-Light", size: 16))
                .textInputAutocapitalization(.never)
            
            // Frequency
            HStack{
                ForEach(Frequency.allCases, id: \.self) { frequency in
                    Button(action: {
                        withAnimation {
                            selectedFrequency = frequency
                        }
                    }) {
                        Text(frequency.stringValue)
                            .padding(.horizontal)
                            .frame(width:115, height: 40)
                            .background(selectedFrequency == frequency ? Color("Aqua") : Color.clear)
                            .foregroundColor(selectedFrequency == frequency ? .black : Color.white.opacity(0.8))
                            .cornerRadius(20)
                            .font(Font.custom("Poppins-Regular", size: 16))
                            
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .background(Color("GrayLight"))
            .cornerRadius(20)
            
            // Time of day
            HStack{
                ForEach(TimeOfDay.allCases, id: \.self) { time in
                    Button(action: {
                        withAnimation {
                            selectedTimeOfDay = time
                        }
                    }) {
                        Text(time.stringValue)
                            .frame(width: 85, height: 40)
                            .background(selectedTimeOfDay == time ? Color("Aqua") : Color.clear)
                            .foregroundColor(selectedTimeOfDay == time ? .black : Color.white.opacity(0.8))
                            .cornerRadius(20)
                            .font(Font.custom("Poppins-Regular", size: 16))
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .background(Color("GrayLight"))
            .cornerRadius(20)
            
            // Duration
            HStack{
                Text("Duration")
                    .foregroundColor(.white)
                    .font(Font.custom("Poppins-Regular", size: 20))
                Spacer()
                Button(action:{showDurationPicker.toggle()}){
                    Text(selectedDuration.durationFormatNormal)
                        .padding(.horizontal)
                }.sheet(isPresented: $showDurationPicker){
                    NavigationView(){
                        DurationPickerView(calculatedTime: $selectedDuration)
                    }.presentationDetents([.fraction(0.4)])
                }
                .foregroundColor(.white)
                .background(Color("GrayMid"))
                .cornerRadius(20)
                
                
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color("GrayLight"))
            .cornerRadius(20)
            
            Spacer()
            
            // Create habit button
            Button(action:{
                HabitsModel.shared.createNewHabit(title: title, frequency: selectedFrequency.rawValue, timeOfDay: selectedTimeOfDay.rawValue, duration: selectedDuration)
                dismiss()
            }){
                Text("Create habit")
                    .font(Font.custom("Poppins-Bold", size: 20))
                    .foregroundColor(.black)
                
                    .frame(maxWidth: .infinity)
                    .padding()
                
                    .background(RoundedRectangle(cornerRadius: 20).fill(Color("Aqua")))
            }
            .padding(.vertical)
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
                Text("New habit")
                    .foregroundColor(.white)
                    .font(Font.custom("Poppins-Bold", size: 30))
            }
        }
    }
}
