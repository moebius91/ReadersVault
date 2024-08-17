//
//  HomeSingleListView.swift
//  ReadersVault
//
//  Created by Jan-Nikolas Othersen on 16.08.24.
//

import SwiftUI

struct HomeSingleListView: View {
    let list: WidgetList

    var body: some View {
        Text("list")
            .padding()
    }
}

#Preview {
    HomeSingleListView(list: WidgetList(cdListId: UUID(), title: "", books: []))
}
