//
//  MBPDFError.swift
//  MBPDFGeneratorDemo
//
//  Created by Manish Bhande on 01/06/19.
//  Copyright © 2019 Manish. All rights reserved.
//

import Foundation

internal enum MBPDFError {

    case notMainThread
    case pdfData(Int)
    case fileNotFound
    case fileNotSaved

    var error: NSError {
        switch self {
        case .fileNotFound:
            return NSError(domain: "Not able find caches directory.", code: -1112, userInfo: nil)
        case .fileNotSaved:
            return NSError(domain: "Not able save PDF.", code: -1113, userInfo: nil)
        case .notMainThread:
            return NSError(domain: "Not a main thread, generated PDF on main therad.", code: -1111, userInfo: nil)
        case .pdfData(let index):
            let msg = "Not generate PDF data\(index != -1 ? " for page \(index)." : ".")"
            return NSError(domain: msg, code: -1114, userInfo: nil)
        }
    }
}
