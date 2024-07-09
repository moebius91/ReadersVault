//
//  AuthorsResultView.swift
//  BookVault
//
//  Created by Jan-Nikolas Othersen on 09.07.24.
//

import SwiftUI

struct AuthorsResultView: View {
    @EnvironmentObject private var viewModel: SearchViewModel
    
    var body: some View {
        List(viewModel.authors, id: \.self) { author in
            Text(author)
        }
        .listStyle(.plain)
    }
}

#Preview {
    var viewModel = SearchViewModel()
    viewModel.getAuthors("Tim Burton")
    
    return AuthorsResultView()
        .environmentObject(viewModel)
}
