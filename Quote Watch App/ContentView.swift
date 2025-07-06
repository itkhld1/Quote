//
//  ContentView.swift
//  Quote Watch App
//
//  Created by itkhld on 4.07.2025.
//

import SwiftUI
import UserNotifications

struct ContentView: View {
    
    @State private var dailyQuote: String = ""
    @State private var background: String = ""
    @State private var favQuotes: [String] = []
    @State private var favButtonTapped = false
    @State private var isTextVisible = false
    @State private var ShwoSubmitSheet = false
    
    let backgrounds = ["2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23"]
    
    var body: some View {
         
        ZStack {
            ZStack {
                Image(background)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 400, height: 220)
                    .edgesIgnoringSafeArea(.all)
                    .opacity(0.5)
                
                VStack {
                    if isTextVisible {
                        Text(dailyQuote)
                            .font(.custom("Migae-SemiBold", size: 15))
                            .frame(width: 170, height: 90)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.leading)
                            .padding()
                    }
                }
                .padding(.bottom, 60)
            }
            .onAppear {
                loadFavorites()
                let newQuote = getDailyQuote()
                if dailyQuote != newQuote {
                    dailyQuote = newQuote
                    favButtonTapped = favQuotes.contains(dailyQuote)
                }
                background = getRandomBackgroundImage()
                isTextVisible = true
                requestNotificationPremission()
                scheduleDailyNotification()
            }
            
            VStack {
                Spacer()
                
                HStack {
                    Button(action: {
                        ShwoSubmitSheet.toggle()
                    }, label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title3)
                            .foregroundColor(.white)
                    })
                    .buttonStyle(PlainButtonStyle())
                    .padding()
                    .sheet(isPresented: $ShwoSubmitSheet, content: {
                        SubmitQuoteView(favQuotes: $favQuotes)
                            .presentationDragIndicator(.visible)
                    })
                    
                    ShareLink(item: dailyQuote, preview: SharePreview("Today's Quote")) {
                        Image(systemName: "paperplane.circle.fill")
                            .font(.title3)
                            .foregroundColor(.white)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding()
                    
                    Button(action: {
                        if favButtonTapped {
                            removeFromFavorites(dailyQuote)
                        } else {
                            addToFavorites(dailyQuote)
                        }
                        favButtonTapped.toggle()
                        
                    }, label: {
                        Image(systemName: favButtonTapped ? "star.fill" : "star")
                            .font(.title3)
                            .foregroundColor(favButtonTapped ? .yellow : .white)
                    })
                    .buttonStyle(PlainButtonStyle())
                    .padding()
                }

            }
            .padding()
        }
    }
    
    func getDailyQuote() -> String {
        let dayOfYear = Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 1
        return quotes[dayOfYear % quotes.count]
    }
    
    func getRandomBackgroundImage() -> String {
        return backgrounds.randomElement() ?? "1"
    }
    
    func requestNotificationPremission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { success, error in
            if success {
                print("Notification permission granted.")
            } else {
                print("Notification permission denied: \(String(describing: error))")
            }
        }
    }
    
    func scheduleDailyNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Daily Quote"
        content.body = "Tap to see today's inspirational quote!"
        content.sound = .default

        // Trigger notification at 8 AM every day
        var dateComponents = DateComponents()
        dateComponents.hour = 8  // Set time to 8 AM
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(identifier: "dailyQuoteNotification", content: content, trigger: trigger)
        
        // Add notification request
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            } else {
                print("Daily notification scheduled successfully!")
            }
        }
    }
    
    func loadFavorites() {
        if let savedQuotes = UserDefaults.standard.array(forKey: "favQuotes") as? [String]{
            favQuotes = savedQuotes
        }
    }
    
    func saveFavorites() {
        UserDefaults.standard.set(favQuotes, forKey: "favQuotes")
    }
    
    func addToFavorites(_ quote: String) {
        if !favQuotes.contains(quote) {
            favQuotes.append(quote)
            saveFavorites()
        }
    }
    
    func removeFromFavorites(_ quote: String) {
        favQuotes.removeAll {$0 == quote}
        saveFavorites()
    }
}

#Preview {
    ContentView()
}

