//
//  VaultDetailHorizontalView.swift
//  ReadersVault
//
//  Created by Jan-Nikolas Othersen on 19.08.24.
//

import SwiftUI

struct VaultDetailHorizontalView: View {
    @EnvironmentObject var viewModel: VaultDetailViewModel

    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(Array(viewModel.books), id: \.self) { book in
                    NavigationLink(value: NavigationValue.bookDetailView) {
                        VaultDetailBookItemView(book: book)
                    }
                }
                .padding(4)
            }
            .padding(0)
        }
        .padding(.top, 16)
    }
}

#Preview {
    let viewModel = VaultListViewModel()
    viewModel.getCDVaults()

    if let vault = viewModel.vaults.last {
        return VaultDetailHorizontalView()
            .environmentObject(VaultDetailViewModel(vault: vault))
    }

    return EmptyView()
}
