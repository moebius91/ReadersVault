//
//  SingleBookResultView.swift
//  BookVault
//
//  Created by Jan-Nikolas Othersen on 09.07.24.
//

import SwiftUI

struct SingleBookResultView: View {
    @EnvironmentObject private var viewModel: SearchViewModel
    
    var body: some View {
        Text(viewModel.book?.title ?? "no title")
    }
}

#Preview {
    SingleBookResultView()
        .environmentObject(SearchViewModel())
}
