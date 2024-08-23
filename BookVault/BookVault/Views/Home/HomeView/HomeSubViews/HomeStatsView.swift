//
//  HomeStatsView.swift
//  ReadersVault
//
//  Created by Jan-Nikolas Othersen on 16.08.24.
//

import SwiftUI

struct HomeStatsView: View {
    let stats: [String: String]

    var body: some View {
        Text("stats")
            .padding()
    }
}

#Preview {
    HomeStatsView(stats: ["": ""])
}
