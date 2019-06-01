//
//  SinglePagePDFGenerator.swift
//  PDFGenerator
//
//  Created by Manish Bhande on 30/05/2019.
//  Copyright © 2019 Manish. All rights reserved.
//

import Foundation
import UIKit

/// Generate Single page PDF from UIViewController
public final class MBSinglePagePDFGenerator {

    /// Standard PDF page size
    public class var PDFPageSize: CGSize {
        return CGSize(width: 595, height: 842)
    }

    /// Don't create object of this class
    private init() { }

    /// Call this method on class to export PDF
    ///
    /// - Parameters:
    ///   - page: UIViewController to add on PDF
    ///   - keepPDFPageSize: Use Standard PDFpage size or controller page size
    /// - Returns: URL of a newpDF
    public class func exportPDF(controller: UIViewController, keepPDFPageSize: Bool = true) throws -> URL {
        // PDF should be generated on main thread only
        if !Thread.isMainThread {
            throw MBPDFError.notMainThread.error
        }
        // PDF data must be generated
        guard let data = pageData(page: controller, keepPDFPageSize: keepPDFPageSize) else {
            throw MBPDFError.pdfData(-1).error
        }
        do { return try savePDF(data: data) }
    }
}

// MARK: - Generating PDF Code
private extension MBSinglePagePDFGenerator {
    /// Get PDF data for given ViewController
    ///
    /// - Parameter page: UIViewController as PDF Page
    /// - Returns: Data of PDF
    class func pageData(page: UIViewController, keepPDFPageSize: Bool) -> Data? {
        let pageFrame = CGRect(origin: .zero, size: PDFPageSize)
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

    /// Save data file storage
    ///
    /// - Parameter data: PDF Data
    /// - Returns: saved URL
    class func savePDF(data: Data) throws -> URL {
        let path = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first
        guard let pdfPath = path?.appendingPathComponent("SiglePageNewPDF.pdf") else {
            throw MBPDFError.fileNotFound.error
        }
        do {
            try data.write(to: pdfPath)
            return pdfPath
        }
    }
}
