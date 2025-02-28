//
//  ContentView.swift
//  BasketballGames
//
//  Created by Samuel Shi on 2/27/25.
//

import SwiftUI

struct Response: Codable {
    var results: [Game]
}

struct Game: Codable {
    var id: Int
    var team: String
    var opponent: String
    var date: String
    var score: [String: Int]
    var isHomeGame: Bool
}

struct ContentView: View {
    @State private var games: [Game] = []
    
    var body: some View {
        NavigationView {
            List(games, id: \.id) { game in
                VStack(alignment: .leading) {
                    HStack {
                        Text("\(game.team) vs. \(game.opponent)")
                        
                        Spacer()
                        
                        Text("\(game.score["unc"] ?? 0) - \(game.score["opponent"] ?? 0)")
                    }
                    HStack {
                        Text(game.date)
                        
                        Spacer()
                        
                        Text(game.isHomeGame ? "Home" : "Away")
                    }
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                }
            }
            .task {
                await loadData()
            }
            .navigationTitle("UNC Basketball")
        }
    }
    
    func loadData() async {
        guard let url = URL(string: "https://api.samuelshi.com/uncbasketball") else {
            print("Invalid URL.")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            if let decodedResponse = try? JSONDecoder().decode([Game].self, from: data) {
                games = decodedResponse
            }
        } catch {
            print("Invalid data.")
        }
    }
}

#Preview {
    ContentView()
}
