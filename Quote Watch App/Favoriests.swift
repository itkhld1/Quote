//
//  Favoriests.swift
//  Quotes Watch App
//
//  Created by itkhld on 11.01.2025.
//

import SwiftUI

struct Favoriests: View {
    @State private var favQuotes: [String] = [] 

    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    LinearGradient(colors: [Color("Color"), Color("Color 2"), Color("Color 1")], startPoint: .topLeading, endPoint: .bottomTrailing)
                        .edgesIgnoringSafeArea(.all)
                        .opacity(0.6)
                    
                    List {
                        ForEach(favQuotes, id: \.self) { fav in
                            VStack{
                                Text(fav)
                                    .font(.custom("Migae-SemiBold", size: 12))
                                    .foregroundColor(.white)
                            }
                            .padding()
                        }
                        .onDelete(perform: deleteFavs)
                    }
                    .listStyle(CarouselListStyle())
                    .padding(.horizontal, 6)
                }
            }
            .navigationTitle("Favs✨")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear{
            loadFavorites()
        }
    }
    
    public func deleteFavs(at offset: IndexSet) {
        favQuotes.remove(atOffsets: offset)
        saveFavorites()
    }

    private func loadFavorites() {
        if let savedQuotes = UserDefaults.standard.array(forKey: "favQuotes") as? [String] {
            favQuotes = savedQuotes
        }
    }
    
    func saveFavorites() {
        UserDefaults.standard.set(favQuotes, forKey: "favQuotes")
    }
}

#Preview {
    Favoriests()
}
