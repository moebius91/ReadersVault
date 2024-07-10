//
//  NavigatorView.swift
//  BookVault
//
//  Created by Jan-Nikolas Othersen on 01.07.24.
//

import SwiftUI

struct NavigatorView: View {
    var body: some View {
        TabView {
            ForEach(Tab.allCases) { tab in
                tab.view
                    .tabItem {
                        Label(tab.title, systemImage: tab.icon)
                    }
                    .tag(tab)
            }
        }
    }
}

#Preview {
    NavigatorView()
}
