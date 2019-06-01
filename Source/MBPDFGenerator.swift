//
//  PDFGenerator.swift
//  PDFGenerator
//
//  Created by Manish Bhande on 28/05/2019.
//  Copyright © 2019 Manish. All rights reserved.
//

import Foundation
import PDFKit

// MARK: - PDFGeneratorDataSource
/// PDFGenerator data source to get PDF pages
public protocol MBPDFGeneratorDataSource: class {

    /// Get number of pages in a PDF
    ///
    /// - Returns: Int
    func numberOfPages() -> Int

    /// Get page for specified page index
    ///
    /// - Parameter index: Page index
    /// - Returns: PDF Page
    func page(at index: Int) -> UIViewController
}

// MARK: - PDFGenerator
/// This class helps you generate PDF from given UIViewController as PDF pages
@available(iOS 11.0, *)
public final class MBPDFGenerator {

    /// Use Orinal UIViewController size or Keep PDF standard size
    public var keepPDFPageSize = true

    /// Document object to control PDF
    public let pdfDocument: PDFDocument

    /// Standard PDF page size
    public class var PDFPageSize: CGSize {
        return CGSize(width: 595, height: 842)
    }

    /// Initializer to generate new PDF
    public init(dataSource: MBPDFGeneratorDataSource) {
        pdfDocument = PDFDocument()
        self.dataSource = dataSource
        isNewPDF = true
    }

    /// Initialize with PDF given data, if data is correct then object will be created
    ///
    /// - Parameter data: PDF Data
    public init?(data: Data) {
        guard let temp = PDFDocument(data: data) else { return nil }
        pdfDocument = temp
        isNewPDF = false
    }

    /// Initialize with PDF with given URL, if URL is correct then object will be created
    ///
    /// - Parameter url: PDF URL
    public init?(url: URL) {
        guard let temp = PDFDocument(url: url) else { return nil }
        pdfDocument = temp
        isNewPDF = false
    }

    /// Export PDF to cache directory and return URL.
    /// Use this function to Generate New PDF only. It uses data source to create PDF pages
    /// Please delete the files one your work is done.
    ///
    /// - Returns: URL
    public func exportPDF() throws -> URL {
        // PDF must be generated in main thread
        if !Thread.isMainThread {
            throw MBPDFError.notMainThread.error
        }
        // Use data source only for New PDF
        if isNewPDF {
            // get all pages here
            let totalPages = dataSource?.numberOfPages() ?? 0
            for pageIndex in 0..<totalPages {
                // get a page here
                guard let page = dataSource?.page(at: pageIndex),
                    let data = pageData(page: page)
                    else { throw MBPDFError.pdfData(pageIndex).error }
                // All each page to PDF
                guard let newPage = PDFDocument(data: data)?.page(at: 0) else { continue }
                pdfDocument.insert(newPage, at: pageIndex)
            }
        }
        do {
            return try savePDF()
        }
    }

    /// Add any annotation to PDF page at gievn index.
    /// If page is available and annotation is added TRUE will be return.
    ///
    /// - Parameters:
    ///   - note: PDFAnnotation
    ///   - index: PDF page index
    /// - Returns: True if successfully added
    public func addAnnotation(_ note: PDFAnnotation, atPage index: Int) -> Bool {
        guard let page = pdfDocument.page(at: index) else { return false }
        page.addAnnotation(note)
        return true
    }

    /// Check this is new PDF or Edit PDF
    private let isNewPDF: Bool

    /// Set data source delegate
    private weak var dataSource: MBPDFGeneratorDataSource?

}

// MARK: - User methods
@available(iOS 11.0, *)
private extension MBPDFGenerator {
    /// Save data to cashe file
    ///
    /// - Parameter data: PDF Data
    /// - Returns: URL
    func savePDF() throws -> URL {
        let path = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first
        guard let pdfPath = path?.appendingPathComponent("NewPDF.pdf") else {
            throw MBPDFError.fileNotFound.error
        }
        if !pdfDocument.write(to: pdfPath) {
            throw MBPDFError.fileNotSaved.error
        }
        return pdfPath
    }

    /// Get PDF data for given ViewController
    ///
    /// - Parameter page: UIViewController as PDF Page
    /// - Returns: Data of PDF
    func pageData(page: UIViewController) -> Data? {
        let pageFrame = CGRect(origin: .zero, size: MBPDFGenerator.PDFPageSize)
        let data = NSMutableData()
        UIGraphicsBeginPDFContextToData(data, pageFrame, nil)
        UIGraphicsBeginPDFPageWithInfo(pageFrame, nil)
        guard let pdfContext = UIGraphicsGetCurrentContext() else { return nil }
        // get old frame of View
        let viewFrame = page.view.frame
        // Set new page frame
        if keepPDFPageSize {
            page.view.bounds = pageFrame
        }
        // Render page
        page.view.layer.render(in: pdfContext)
        // Apply old frame to View
        page.view.frame = viewFrame
        UIGraphicsEndPDFContext()
        return data as Data
    }
}
