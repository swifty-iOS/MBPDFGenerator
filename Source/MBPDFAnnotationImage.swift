//
//  ImagePDFAnnotation.swift
//  PDFGenerator
//
//  Created by Manish Bhande on 29/05/2019.
//  Copyright © 2019 Manish. All rights reserved.
//

import Foundation
import PDFKit

/// Create Image annotation to add to PDF
@available(iOS 11.0, *)
open class MBPDFAnnotationImage: PDFAnnotation {

    /// Image to add on PDF
    private let image: UIImage

    public init(image: UIImage, bounds: CGRect, withProperties properties: [AnyHashable: Any]?) {
        self.image = image
        super.init(bounds: bounds, forType: PDFAnnotationSubtype.stamp, withProperties: properties)

    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Set image here
    override open func draw(with box: PDFDisplayBox, in context: CGContext) {
        // Get the CGImage of our image
        guard let cgImage = self.image.cgImage else { return }
        // Draw our CGImage in the context of our PDFAnnotation bounds
        context.draw(cgImage, in: self.bounds)
    }
}
