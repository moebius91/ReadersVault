//
//  BulletinBoardView.swift
//  ReadersVault
//
//  Created by Jan-Nikolas Othersen on 08.08.24.
//

import SwiftUI

struct BulletinBoardView: View {
    @EnvironmentObject var loginViewModel: LoginViewModel

    @StateObject private var viewModel = BulletinBoardViewModel()

    var body: some View {
        VStack {
            if viewModel.posts.isEmpty {
                Spacer()
                Text("Keine Einträge auf dem Schwarzenbrett vorhanden.")
                    .padding()
            }
            List(viewModel.posts) { post in
                Text(post.title)
                    .swipeActions {
                        Button(role: .destructive, action: {
                             viewModel.deletePost(withId: post.id)
                        }, label: {
                            Label("", systemImage: "trash")
                        })
                    }
            }
        }
        .onAppear {
            viewModel.fetchPosts()
        }
        .toolbar {
            Button("", systemImage: "plus") {
                viewModel.isPresented = true
            }
        }
        .sheet(isPresented: $viewModel.isPresented) {
            NavigationStack {
                VStack {
                    TextField("Anzeigenname", text: $viewModel.postTitle)
                        .textFieldStyle(.roundedBorder)
                    TextField("Anzeigeninhalt", text: $viewModel.postContent)
                        .textFieldStyle(.roundedBorder)
                    Button("Anzeige schalten") {
                        viewModel.createPost()
                        viewModel.isPresented = false
                    }
                    .buttonStyle(BorderedButtonStyle())
                    .background(.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .foregroundStyle(.white)
                    .padding()
                }
                .navigationTitle("Neue Anzeige schalten")
                .padding(.horizontal)
                Spacer()
            }
        }
    }
}

#Preview {
    NavigationStack {
        BulletinBoardView()
            .environmentObject(LoginViewModel.shared)
    }
}
