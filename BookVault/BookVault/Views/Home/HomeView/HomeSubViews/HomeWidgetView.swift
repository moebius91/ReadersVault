//
//  HomeWidgetView.swift
//  ReadersVault
//
//  Created by Jan-Nikolas Othersen on 16.08.24.
//

import SwiftUI

struct HomeWidgetView: View {
    @EnvironmentObject var viewModel: HomeViewModel
    let widget: Widget

    var body: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(UIColor.systemGray6))
                .padding()
            VStack(alignment: .leading) {
                HStack {
                    Text(widget.title)
                        .font(.title2)
                        .bold()
                    Spacer()
                    VStack {
                        Button("", systemImage: widget.itemsMovable ? "lock.open" : "lock") {
                            viewModel.toggleWidgetItemsMovable(for: widget.id)
                        }
                    }
                }
                .padding(.top)
                .padding(.horizontal)
                ForEach(widget.elements) { element in
                    if widget.itemsMovable {
                        HomeElementView(element: element)
                            .draggable(element) {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(.ultraThinMaterial)
                                    .frame(width: 1, height: 1)
                                    .onAppear {
                                        viewModel.draggingWidgetElement = element
                                    }
                            }
                            .dropDestination(for: WidgetElement.self) { _, _ in
                                viewModel.draggingWidgetElement = nil
                                return false
                            } isTargeted: { status in
                                if let draggingWidgetElement = viewModel.draggingWidgetElement, status, draggingWidgetElement != element {
                                    if let sourceWidgetIndex = viewModel.widgets.firstIndex(where: { $0.elements.contains(draggingWidgetElement) }),
                                       let sourceIndex = viewModel.widgets[sourceWidgetIndex].elements.firstIndex(of: draggingWidgetElement),
                                       let destinationWidgetIndex = viewModel.widgets.firstIndex(where: { $0.id == widget.id }) {
                                        let destinationIndex = viewModel.widgets[destinationWidgetIndex].elements.firstIndex(where: { $0.id == element.id }) ?? viewModel.widgets[destinationWidgetIndex].elements.count
                                        withAnimation(.bouncy) {
                                            let elementCountBeforeRemoval = viewModel.widgets[sourceWidgetIndex].elements.count
                                            if elementCountBeforeRemoval > 1 {
                                                let sourceElement = viewModel.widgets[sourceWidgetIndex].elements.remove(at: sourceIndex)
                                                viewModel.widgets[destinationWidgetIndex].elements.insert(sourceElement, at: destinationIndex)
                                            }
                                        }
                                    }
                                }
                            }
                    } else {
                        HomeElementView(element: element)
                    }
                }
            }
            .padding(.bottom)
            .padding()
        }
    }
}

#Preview {
    HomeWidgetView(widget: Widget(title: "Test", elements: []))
        .environmentObject(HomeViewModel())
}

#Preview("HomeView") {
    HomeView()
}
