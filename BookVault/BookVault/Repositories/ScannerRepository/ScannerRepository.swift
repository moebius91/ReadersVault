//
//  ScannerRepository.swift
//  BookVault
//
//  Created by Jan-Nikolas Othersen on 16.07.24.
//  Auf Basis von: https://medium.com/@ramesh_aran86/how-to-use-visionkit-in-swiftui-for-text-and-barcode-scanning-on-ios-e3f66c9006f2
//  Mit ChatGPT in Repository MVVM umgebaut
//

import VisionKit

@MainActor
class ScannerRepository {
    func configureScanner(delegate: DataScannerViewControllerDelegate, scanMode: ScannerViewModel.ScanMode) -> DataScannerViewController {
        var recognizedDataTypes: Set<DataScannerViewController.RecognizedDataType> = []
        
        switch scanMode {
        case .text:
            let textDataType: DataScannerViewController.RecognizedDataType = .text(
                languages: [
                    "de-DE",
                    "en-US"
                ]
            )
            recognizedDataTypes.insert(textDataType)
        case .barcode:
            let barcodeDataType: DataScannerViewController.RecognizedDataType = .barcode(symbologies: [.ean13])
            recognizedDataTypes.insert(barcodeDataType)
        }
        
        let scannerViewController = DataScannerViewController(
            recognizedDataTypes: recognizedDataTypes,
            qualityLevel: .accurate,
            recognizesMultipleItems: false,
            isHighFrameRateTrackingEnabled: false,
            isHighlightingEnabled: false
        )
        
        scannerViewController.delegate = delegate
        return scannerViewController
    }
}
