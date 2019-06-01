//
//  PDFAnnotationView.swift
//  PDFGenerator
//
//  Created by Manish Bhande on 30/05/2019.
//  Copyright © 2019 Manish. All rights reserved.
//

import UIKit
import PDFKit

/// Create UIView annotation to add to PDF
@available(iOS 11.0, *)
open class MBPDFAnnotationView: PDFAnnotation {

    /// Image to add on PDF
    private let view: UIView

    public init(view: UIView, bounds: CGRect, withProperties properties: [AnyHashable: Any]?) {
        self.view = view
        super.init(bounds: bounds, forType: PDFAnnotationSubtype.stamp, withProperties: properties)

    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Add UIView in PDF here
    override open func draw(with box: PDFDisplayBox, in context: CGContext) {
        view.layer.render(in: context)
    }
}
