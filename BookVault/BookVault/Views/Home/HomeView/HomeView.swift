//
//  HomeView.swift
//  ReadersVault
//
//  Created by Jan-Nikolas Othersen on 01.07.24.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel = HomeViewModel()

    @State private var selection: WidgetElement.ElementType = .standard
    var body: some View {
        NavigationStack {
            ScrollView {
                if viewModel.widgets.isEmpty {
                    Spacer()
                    HStack {
                        Spacer()
                        Label("", systemImage: "arrow.up")
                            .padding(.horizontal)
                    }
                    Text("Füge neue Widgets Deiner Startseite über das Zahnrad hinzu!")
                }
                ForEach(viewModel.widgets) { widget in
                    if viewModel.areWidgetsDragable {
                        HomeWidgetView(widget: widget)
                            .environmentObject(viewModel)
                            .draggable(widget) {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(.ultraThinMaterial)
                                    .frame(width: 1, height: 1)
                                    .onAppear {
                                        viewModel.draggingWidget = widget
                                    }
                            }
                            .dropDestination(for: Widget.self) { _, _ in
                                viewModel.draggingWidget = nil
                                return false
                            } isTargeted: { status in
                                if let draggingWidget = viewModel.draggingWidget, status, draggingWidget != widget {
                                    if let sourceIndex = viewModel.widgets.firstIndex(of: draggingWidget),
                                       let destinationIndex = viewModel.widgets.firstIndex(of: widget) {
                                        withAnimation(.bouncy) {
                                            let sourceWidget = viewModel.widgets.remove(at: sourceIndex)
                                            viewModel.widgets.insert(sourceWidget, at: destinationIndex)
                                        }
                                    }
                                }
                            }
                    } else {
                        if !widget.elements.isEmpty {
                            HomeWidgetView(widget: widget)
                                .environmentObject(viewModel)
                        } else {
                            HStack {
                                Text("Füge Deinem Widget(s) Elemente hinzu!")
                                Spacer()
                                Image(systemName: "arrow.up")
                            }
                            .padding(.horizontal)
                            Text("Klicke auf das entsprechende Widget und füge Elemente hinzu!")
                        }
                    }
                }
            }
            .toolbar {
                if !viewModel.widgets.isEmpty {
                    Button("", systemImage: viewModel.areWidgetsDragable ? "lock.open" : "lock", action: {
                        viewModel.areWidgetsDragable.toggle()
                    })
                }
                Button("", systemImage: "gear", action: {
                    viewModel.isSheetPresented.toggle()
                })
            }
            .sheet(isPresented: $viewModel.isSheetPresented, onDismiss: {
                viewModel.clearSelectedWidgets()
            }) {
                HomeSettingsSheetView()
                    .environmentObject(viewModel)
            }
        }
    }
}

#Preview {
    HomeView()
}
