//
//  DocumentScannerView.swift
//  BookVault
//
//  Created by Jan-Nikolas Othersen on 16.07.24.
//  Auf Basis von: https://medium.com/@ramesh_aran86/how-to-use-visionkit-in-swiftui-for-text-and-barcode-scanning-on-ios-e3f66c9006f2
//  Mit ChatGPT in Repository MVVM umgebaut
//

import SwiftUI
import VisionKit

struct DocumentScannerView: UIViewControllerRepresentable {
    @ObservedObject var viewModel: ScannerViewModel
    @Binding var searchString: String
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> DataScannerViewController {
        let scannerViewController = viewModel.repository.configureScanner(delegate: context.coordinator, scanMode: viewModel.scanMode)
        viewModel.scannerViewController = scannerViewController
        return scannerViewController
    }
    
    func updateUIViewController(_ uiViewController: DataScannerViewController, context: Context) {
        // Update the view controller if needed
    }
    
    class Coordinator: NSObject, DataScannerViewControllerDelegate {
        var parent: DocumentScannerView
        
        init(parent: DocumentScannerView) {
            self.parent = parent
        }
        
        func dataScanner(_ dataScanner: DataScannerViewController, didAdd addedItems: [RecognizedItem], allItems: [RecognizedItem]) {
            parent.viewModel.processAddedItems(items: addedItems)
        }
        
        func dataScanner(_ dataScanner: DataScannerViewController, didRemove removedItems: [RecognizedItem], allItems: [RecognizedItem]) {
            parent.viewModel.processRemovedItems(items: removedItems)
        }
        
        func dataScanner(_ dataScanner: DataScannerViewController, didUpdate updatedItems: [RecognizedItem], allItems: [RecognizedItem]) {
            parent.viewModel.processUpdatedItems(items: updatedItems)
        }
        
        func dataScanner(_ dataScanner: DataScannerViewController, didTapOn item: RecognizedItem) {
            parent.viewModel.processItem(item: item)
            parent.searchString = parent.viewModel.scannedText
            parent.viewModel.stopScanning()
        }
    }
}


#Preview {
    @State var searchString: String = ""
    
    return DocumentScannerView(viewModel: ScannerViewModel(), searchString: $searchString)
}
