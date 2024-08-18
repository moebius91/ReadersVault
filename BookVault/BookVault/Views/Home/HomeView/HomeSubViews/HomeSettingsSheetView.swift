//
//  HomeSettingsSheetView.swift
//  ReadersVault
//
//  Created by Jan-Nikolas Othersen on 17.08.24.
//

import SwiftUI

struct HomeSettingsSheetView: View {
    @EnvironmentObject private var viewModel: HomeViewModel
    @State private var title = ""

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                ZStack {
                    Rectangle()
                        .fill(Color(UIColor.systemGray6))
                    VStack {
                        HStack {
                            Spacer()
                            Button(action: {
                                viewModel.isSheetPresented.toggle()
                            }, label: {
                                Label("", systemImage: "xmark")
                            })
                            .padding()
                        }
                        Spacer()
                    }
                    .padding(.top)
                }
                .frame(height: 25)
                List {
                    Section("Widget hinzufügen") {
                        TextField("Widget Titel", text: $title)
                        Button("Widget hinzufügen") {
                            let newWidget = viewModel.createWidget(title: title, elements: [])
                            if !title.isEmpty {
                                viewModel.selectedWidgets.append(newWidget)
                                viewModel.widgets.append(newWidget)
                            }
                        }
                    }
                    if !viewModel.selectedWidgets.isEmpty {
                        Section("Widgets") {
                            ForEach(viewModel.selectedWidgets) { widget in
                                VStack {
                                    NavigationLink(destination: {
                                        HomeWidgetElementSelectionView()
                                            .onAppear {
                                                viewModel.widget = widget
                                                viewModel.addAllElementsFromWidgetToSelected(widget)
                                                viewModel.cdBooksToWidgetBooks()
                                            }
                                            .onDisappear {
                                                viewModel.selectedWidgetElements.removeAll()
                                            }
                                    }) {
                                        Text(widget.title)
                                    }
                                }
                                .swipeActions {
                                    Button(role: .destructive, action: {
                                        viewModel.removeWidgetFromSelectedById(widget.id)
                                        viewModel.removeWidgetFromById(widget.id)
                                    }, label: {
                                        Label("", systemImage: "trash")
                                    })
                                }
                            }
                        }
                    }
                    Section {
                        Button(action: {
                            viewModel.clearSelectedWidgets()
                            viewModel.isSheetPresented.toggle()
                        }, label: {
                            Text("Schließen")
                        })
                    }
                }
            }
            .onAppear {
                viewModel.addAllWidgetsToSelected()
                viewModel.widget = nil
            }
        }
    }
}

#Preview {
    HomeSettingsSheetView()
        .environmentObject(HomeViewModel())
}

#Preview("HomeView") {
    HomeView()
}
