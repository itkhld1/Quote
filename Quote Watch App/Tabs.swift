//
//  Tabs.swift
//  Quotes Watch App
//
//  Created by itkhld on 11.01.2025.
//

import SwiftUI

struct Tabs: View {
    
    @State private var favQuotes: [String] = []
    
    var body: some View {
        TabView {
            ContentView()
            Favoriests()
        }
        .tabViewStyle(CarouselTabViewStyle())
    }
}

#Preview {
    Tabs()
}
 
