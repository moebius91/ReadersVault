//
//  HomeListsView.swift
//  ReadersVault
//
//  Created by Jan-Nikolas Othersen on 16.08.24.
//

import SwiftUI

struct HomeListsView: View {
    let lists: [WidgetList]

    var body: some View {
        Text("lists")
            .padding()
    }
}

#Preview {
    HomeListsView(lists: [])
}
