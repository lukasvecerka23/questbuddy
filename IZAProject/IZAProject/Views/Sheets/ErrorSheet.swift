//
//  ErrorSheet.swift
//  IZAProject
//
//  Created by Lukáš Večerka on 31.05.2023.
//

import SwiftUI

struct ErrorSheet: View {
    @Environment(\.dismiss) var dismiss
    @Binding var errText: String
    
    var body: some View {
        
        VStack {
            Text(errText)
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
                    Image(systemName: "exclamationmark.triangle")
                        .foregroundColor(.red)
                    Text("Error!")
                        .foregroundColor(.red)
                        .font(Font.custom("Poppins-Bold", size: 30))
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}
