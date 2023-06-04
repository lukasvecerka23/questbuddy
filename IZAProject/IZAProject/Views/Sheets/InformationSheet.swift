//
//  InformationSheet.swift
//  IZAProject
//
//  Created by Lukáš Večerka on 31.05.2023.
//

import SwiftUI

struct InformationSheet: View {
    @Environment(\.dismiss) var dismiss
    @Binding var text: String
    
    var body: some View {
        VStack {
            Text(text)
                .foregroundColor(.white)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("GrayMid"))
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
                HStack{
                    Image(systemName: "checkmark")
                        .foregroundColor(.green)
                    Text("Success!")
                        .foregroundColor(.green)
                        .font(Font.custom("Poppins-Bold", size: 30))
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}
