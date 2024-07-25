//
//  HomeView.swift
//  BookVault
//
//  Created by Jan-Nikolas Othersen on 01.07.24.
//

import SwiftUI

let bookList: [String] = ["Buch 1", "Buch 2", "Buch 3", "Buch 4", "Buch 5"]

struct HomeView: View {

    @State private var settingsPresented = false
    @State private var searchString = ""

    var body: some View {
        NavigationStack {
            // Liste Empfehlungen
            // Hinzuzufügen
            ScrollView {
                VStack(alignment: .leading) {
                    Text("Empfehlungen")
                        .font(.title2)
                        .bold()
                        .padding(.leading)
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(bookList, id: \.self) { book in
                                Text(book)
                            }
                            .frame(width: 96, height: 128)
                            .background(.gray)
                        }
                        .padding(.horizontal)
                    }
                    // Eigene Bücherlisten
                    Text("Deine Listen")
                        .font(.title2)
                        .bold()
                        .padding(.leading)
                    ForEach(bookList, id: \.self) { book in
                        VStack(alignment: .leading) {
                            Text(book)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 32)
//                                .background(.green)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal)
                        }
                    }
                    .background(.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .padding(.horizontal)
                }
            }
            .navigationTitle("Home")
            .searchable(text: $searchString)
            .onChange(of: searchString) {
                // ViewModel Suchfunktion

            }
            .toolbar {
                Button("Einstellungen", systemImage: "gear") {
                    settingsPresented.toggle()
                }
            }
            .sheet(isPresented: $settingsPresented) {
                // Einstellungen für die Startseite
                Text("Einstellungen")
                Button("Einstellungen schließen") {
                    settingsPresented.toggle()
                }
                Spacer()
            }
        }
    }
}

#Preview {
    HomeView()
}
