//
//  CustomSearchBar.swift
//  BookVault
//
//  Created by Jan-Nikolas Othersen on 23.07.24.
//

import SwiftUI

struct CustomSearchBar: View {
    @Binding var text: String

    var body: some View {
        HStack {
            TextField("Suche", text: $text)
                .padding(7)
                .padding(.horizontal, 25)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .overlay {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundStyle(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)

                        if !text.isEmpty {
                            Button(action: {
                                self.text = ""
                            }) {
                                Image(systemName: "multiply.cicle.fill")
                                    .foregroundStyle(.gray)
                                    .padding(.trailing, 8)
                            }
                        }
                    }
                }
        }
    }
}

#Preview {
    @State var text: String = ""

    return CustomSearchBar(text: $text)
}
