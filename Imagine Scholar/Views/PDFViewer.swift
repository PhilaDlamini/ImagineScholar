//
//  PDFViewer.swift
//  Imagine Scholar
//
//  Created by Phila Dlamini on 7/23/23.
//

import SwiftUI
import PDFKit

struct PDFViewer: View {
    let url: URL
    let title: String
    
    var body: some View {
        PDFKitView(url: url)
            .navigationBarTitle(Text(title), displayMode: .inline)
    }
}

struct PDFKitView: UIViewRepresentable {
    let url: URL
    
    func makeUIView(context: Context) -> some UIView {
        let pdfView = PDFView()
        pdfView.autoScales = true
        
        if let document = PDFDocument(url: url) {
            pdfView.document = document
        }
        
        return pdfView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        //nothing to do here
    }
}

