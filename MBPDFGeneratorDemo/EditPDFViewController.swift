//
//  EditPDFViewController.swift
//  MBPDFGeneratorDemo
//
//  Created by Manish Bhande on 01/06/19.
//  Copyright © 2019 Manish. All rights reserved.
//

import UIKit

@available (iOS 11.0, *)
class EditPDFViewController: UIViewController {
    
    @IBOutlet weak var signature: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let controller = segue.destination as? WebViewController {
            if sender is UIBarButtonItem {
                
                let viewBounds = CGRect(x: 10, y: 20, width: signature.bounds.width, height: signature.bounds.height)
                    let sign = MBPDFAnnotationView(view: signature, bounds: viewBounds, withProperties: nil)
                    let pdf = MBPDFGenerator(url: Bundle.main.url(forResource: "sample", withExtension: "pdf")!)
                    _ = pdf?.addAnnotation(sign, atPage: 0)
                    controller.url = try? pdf?.exportPDF()
                    
                } else {
                    controller.url = Bundle.main.url(forResource: "sample", withExtension: "pdf")
                }
            }
        }
            
}
