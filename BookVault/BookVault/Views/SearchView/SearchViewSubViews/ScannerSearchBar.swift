//
//  ScannerSearchBar.swift
//  ReadersVault
//
//  Created by Jan-Nikolas Othersen on 25.07.24.
//

import SwiftUI

struct ScannerSearchBar: View {
    @Binding var text: String
    @Binding var isEditing: Bool
    var onScanButtonTapped: () -> Void

    var body: some View {
        HStack {
            TextField("Suche", text: $text, onEditingChanged: { editing in
                withAnimation {
                    isEditing = editing
                }
            })
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
                            Image(systemName: "multiply.circle.fill")
                                .foregroundStyle(.gray)
                                .padding(.trailing, 8)
                        }
                    }

                    Button(action: {
                        withAnimation {
                            onScanButtonTapped()
                        }
                    }) {
                        Image(systemName: "barcode.viewfinder")
                            .foregroundStyle(.blue)
                            .padding(.trailing, 8)
                    }
                }
            }
        }
    }
}

#Preview {
    @State var text: String = ""
    @State var isEditing: Bool = false

    return ScannerSearchBar(text: $text, isEditing: $isEditing) {
        print("Scan button tapped")
    }
}
