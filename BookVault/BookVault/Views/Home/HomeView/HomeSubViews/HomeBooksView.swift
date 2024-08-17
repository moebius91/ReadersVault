//
//  HomeBooksView.swift
//  ReadersVault
//
//  Created by Jan-Nikolas Othersen on 16.08.24.
//

import SwiftUI

struct HomeBooksView: View {
    let books: [WidgetBook]

    var body: some View {
        Text("books")
            .padding()
    }
}

#Preview {
    HomeBooksView(books: [])
}
