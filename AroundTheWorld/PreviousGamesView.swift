//
//  ContentView.swift
//  AroundTheWorld
//
//  Created by Trey Gaines on 1/16/24.
//

import SwiftUI
import SwiftData

struct PreviousGamesView: View {
    @Environment(\.modelContext) private var modelContext
    @AppStorage("isDarkMode") var isDarkMode: Bool = true
    @Query private var games: [Game]

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 0) {
                    //ForEach but sorted by timestamp to ensure most recent game comes first
                    ForEach(games.sorted(by: { $0.timestamp > $1.timestamp })) { game in
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Score: \(game.score)")
                                    .font(.headline)
                                    .foregroundColor(isDarkMode ? .white : .black)

                                VStack(alignment: .trailing) {
                                    Text(game.timestamp, format: Date.FormatStyle(date: .numeric))
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                .frame(maxWidth: .infinity, alignment: .trailing)

                                Text("Time Taken: \(game.timeTaken)")
                                    .font(.subheadline)
                                    .foregroundColor(isDarkMode ? .white : .black)
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .background(RoundedRectangle(cornerRadius: 10)
                            //.fill(Color.gray.opacity(0.5)) Wanted to try out a Materila
                            .fill(Material.ultraThinMaterial))
                        .padding(.horizontal)
                        .padding(.vertical, 4)
                    }
                }
            }
            .padding(.top, 0)
            .navigationTitle("Previous Games")
        }
    }
}
