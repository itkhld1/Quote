//
//  SubmitQuoteView.swift
//  Quotes Watch App
//
//  Created by itkhld on 12.01.2025.
//

import SwiftUI

struct SubmitQuoteView: View {
    
    @Environment(\.dismiss) var dismiss 
    @State private var newQuote: String = ""
    
    @Binding var favQuotes: [String]

    var body: some View {
        ZStack {
            LinearGradient(colors: [Color("DarkBrown"), Color("LightBrown")], startPoint: .bottomLeading, endPoint: .topLeading)
                .edgesIgnoringSafeArea(.all)
                .opacity(0.4)
            VStack {
                Text("Write Your Own Quote\"")
                    .font(.custom("Migae-SemiBold", size: 12))
                    .padding()
                    .bold()
                
                TextField("Enter your quote here.", text: $newQuote)
                    .padding()
                    .textFieldStyle(PlainTextFieldStyle())
                    .font(.caption2)
                    .frame(maxWidth: .infinity)
                
                
                Button(action: {
                    if !newQuote.isEmpty {
                        favQuotes.append(newQuote)
                        saveFavorites()
                        dismiss()
                    }
                }, label: {
                    Text("Submit")
                        .font(.caption2)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(25)
                })
                .buttonStyle(PlainButtonStyle())
                .padding()
                
                Spacer()
            }
        }
    }
    
    func saveFavorites() {
        UserDefaults.standard.set(favQuotes, forKey: "favQuotes")
    }
}

#Preview {
    SubmitQuoteView(favQuotes: .constant([]))
}
