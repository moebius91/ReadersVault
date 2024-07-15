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
        VStack {
            VStack {
                AsyncImage(
                    url: viewModel.book?.image,
                    content: { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .clipShape(RoundedRectangle(cornerRadius: 15.0))
                    },
                    placeholder: {
                        Image("photo.artframe")
                    }
                )
                .frame(width: 150)
                Text(viewModel.book?.title ?? "no title")
                    .font(.title2)
                    .bold()
                if viewModel.book?.authors != nil {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Autoren:")
                                .bold()
                            ForEach((viewModel.book?.authors)!, id: \.self) { name in
                                Text(name)
                            }
                        }
                        Spacer()
                    }
                    .padding()
                }
            }
            .padding()
            HStack {
                Button("Zur Bibliothek hinzufügen") {
                    viewModel.saveBookInCoreData() 
                }
                .buttonStyle(BorderedProminentButtonStyle())
                Button("Kaufen") {
                    // Verlinkung zu Amazon
                }
                .buttonStyle(BorderedButtonStyle())
            }
            Spacer()
        }
    }
}

#Preview {
    var viewModel = SearchViewModel()
    viewModel.getBookByIsbn("9783424200447")
    
    return SingleBookResultView()
        .environmentObject(viewModel)
}
