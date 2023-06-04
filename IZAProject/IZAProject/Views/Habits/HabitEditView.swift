//
//  HabitEditView.swift
//  IZAProject
//
//  Created by Lukáš Večerka on 30.05.2023.
//

import SwiftUI

struct HabitEditView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var habit: Habit?
    @State var title = ""
    @State var selectedTimeOfDay: TimeOfDay = .allday
    @State var selectedFrequency: Frequency = .daily
    @State var selectedDuration:Int = 0
    @State var showDurationPicker: Bool = false
    
    var body: some View {
        VStack(spacing: 30){
            // Title
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
            
            // Save
            Button(action:{
                habit?.title = title
                habit?.frequency = selectedFrequency.rawValue
                habit?.timeOfDay = selectedTimeOfDay.rawValue
                habit?.duration = selectedDuration
                if let _habit = habit{
                    HabitsModel.shared.editHabit(habit: _habit)
                    dismiss()
                }
            }){
                Text("Save")
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
                Text("Habit")
                    .foregroundColor(.white)
                    .font(Font.custom("Poppins-Bold", size: 30))
            }
        }.onAppear{
            // Set values to picked habit
            if let habit = habit{
                title = habit.title
                selectedFrequency = Frequency(rawValue: habit.frequency) ?? .daily
                selectedTimeOfDay = TimeOfDay(rawValue: habit.timeOfDay) ?? .allday
                selectedDuration = habit.duration
            }
            
        }
    }
}
