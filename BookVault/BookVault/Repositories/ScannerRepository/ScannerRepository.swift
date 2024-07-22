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
        
        // Set um dem DataScannerViewController mitzuteilen, ob wir Barcodes oder Texte scannen wollen, noch leer
        var recognizedDataTypes: Set<DataScannerViewController.RecognizedDataType> = []
        
        // Abhängig vom übergebenen ScanMode case wird zwischen Text- und Barcodeerkennung gewechselt, und der RecognizedDataType im Set gespeichert.
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
        
        // Hier wird der DataScannerViewController erstellt und konfiguriert.
        // Der ViewController verwaltet die Views und reagiert auf Benutzerinteraktionen.
        let scannerViewController = DataScannerViewController(
            // Übergabe, ob nach Barcode, Text oder beidem gesucht werden soll.
            recognizedDataTypes: recognizedDataTypes,
            // Qualität des Scanns
            qualityLevel: .accurate,
            // Sollen mehrere Items erkannt werden?
            recognizesMultipleItems: false,
            // Soll bei hoher Bildwiederholungsrate gescannt werden?
            isHighFrameRateTrackingEnabled: false,
            // Sollen gefundene Elemente hervorgehoben werden?
            isHighlightingEnabled: false
        )
        
        // Das Delegate wird gesetzt, um die Ergebnisse des Scannvorgangs weiterzuleiten.
        // Der DataScannerViewController verwendet das Delegate, um den Status und die
        // Ergebnisse des Scannens an die Klasse zu melden, die dieses Protokoll implementiert.
        scannerViewController.delegate = delegate
        return scannerViewController
    }
}
