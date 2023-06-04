//
//  DurationPickerView.swift
//  IZAProject
//
//  Created by Lukáš Večerka on 30.05.2023.
//

import SwiftUI

struct DurationPickerView: View {
    @Environment(\.dismiss) var dismiss
    
    // Set hours and minutes to zero
    @State private var selectedTime: Date = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date()) ?? Date()
    
    // Time in new habit form
    @Binding var calculatedTime: Int

    var body: some View {
        VStack {
            // Date picker
            DatePicker("", selection: $selectedTime, displayedComponents: .hourAndMinute)
                            .labelsHidden()
                            .datePickerStyle(WheelDatePickerStyle())
                            .accentColor(Color("Aqua"))
                            .colorScheme(.dark)
                            .environment(\.locale, Locale.init(identifier: "en_GB"))
            
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
                Text("Select time")
                    .foregroundColor(.white)
                    .font(Font.custom("Poppins-Bold", size: 30))
            }
            
            // Save duration
            ToolbarItem(placement: .navigationBarTrailing){
                Button(action: {
                   let calendar = Calendar.current
                    let dateComponents = calendar.dateComponents([.hour, .minute], from: selectedTime)
                    calculatedTime = dateComponents.hour! * 60 + dateComponents.minute!
                    dismiss()
                }) {
                    Text("Save")
                        .foregroundColor(.white)
                        .font(Font.custom("Poppins-Regular", size: 16))
                }
            }
        }
    }
}
