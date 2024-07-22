//
//  ScannerViewModel.swift
//  BookVault
//
//  Created by Jan-Nikolas Othersen on 16.07.24.
//  Auf Basis von: https://medium.com/@ramesh_aran86/how-to-use-visionkit-in-swiftui-for-text-and-barcode-scanning-on-ios-e3f66c9006f2
//  Mit ChatGPT in Repository MVVM umgebaut
//

import Foundation
import SwiftUI
import VisionKit

@MainActor
class ScannerViewModel: NSObject, ObservableObject, DataScannerViewControllerDelegate {
    enum ScanMode {
            case barcode, text
    }
    
    @Published var scannedText: String = ""
    @Published var isScanning: Bool = false
    @Published var scanMode: ScanMode = .barcode
    
    let repository = ScannerRepository()
    var scannerViewController: DataScannerViewController?
    private var roundBoxMappings: [UUID: UIView] = [:]
    
    override init() {
        super.init()
        configureScanner()
    }
    
    private func configureScanner() {
        scannerViewController = repository.configureScanner(delegate: self, scanMode: scanMode)
    }
    
    private func startScanning() {
        guard let scannerViewController = scannerViewController else { return }
        try? scannerViewController.startScanning()
        isScanning = true
    }
    
    func startBarcodeScanner() {
        scanMode = .barcode
        startScanning()
    }
    
    func startTextScanner() {
        scanMode = .text
        startScanning()
    }
    
    func stopScanning() {
        scannerViewController?.stopScanning()
        isScanning = false
    }
    
    func processAddedItems(items: [RecognizedItem]) {
        for item in items {
            processItem(item: item)
        }
    }
    
    func processRemovedItems(items: [RecognizedItem]) {
        for item in items {
            removeRoundBoxFromItem(item: item)
        }
    }
    
    func processUpdatedItems(items: [RecognizedItem]) {
        for item in items {
            updateRoundBoxToItem(item: item)
        }
    }

    func processItem(item: RecognizedItem) {
        switch item {
        case .text(let text):
            scannedText = text.transcript
            break
        case .barcode(let barcode):
            // mit Hilfe von ChatGPT erstellt
            // Ich wusste nicht, wie ich die ISBN aus dem vom Scanner gelieferte Ergebnis extrahiere.
            if barcode.observation.symbology == .ean13 {
                let payload: String = barcode.observation.payloadStringValue ?? ""
                scannedText = payload
            }
        @unknown default:
            print("Should not happen")
        }
        let frame = getRoundBoxFrame(item: item)
        addRoundBoxToItem(frame: frame, text: scannedText, item: item)
    }
    
    func addRoundBoxToItem(frame: CGRect, text: String, item: RecognizedItem) {
        let roundedRectView = RoundedRectLabel(frame: frame)
        roundedRectView.setText(text: text)
        scannerViewController?.overlayContainerView.addSubview(roundedRectView)
        roundBoxMappings[item.id] = roundedRectView
    }
    
    func removeRoundBoxFromItem(item: RecognizedItem) {
        if let roundBoxView = roundBoxMappings[item.id] {
            if roundBoxView.superview != nil {
                roundBoxView.removeFromSuperview()
                roundBoxMappings.removeValue(forKey: item.id)
            }
        }
    }
    
    func updateRoundBoxToItem(item: RecognizedItem) {
        if let roundBoxView = roundBoxMappings[item.id] {
            if roundBoxView.superview != nil {
                let frame = getRoundBoxFrame(item: item)
                roundBoxView.frame = frame
            }
        }
    }
    
    func getRoundBoxFrame(item: RecognizedItem) -> CGRect {
        let frame = CGRect(
            x: item.bounds.topLeft.x,
            y: item.bounds.topLeft.y,
            width: abs(item.bounds.topRight.x - item.bounds.topLeft.x) + 15,
            height: abs(item.bounds.topLeft.y - item.bounds.bottomLeft.y) + 15
        )
        return frame
    }
}
