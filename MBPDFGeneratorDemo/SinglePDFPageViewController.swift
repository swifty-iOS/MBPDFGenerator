//
//  SinglePDFPageViewController.swift
//  MBPDFGeneratorDemo
//
//  Created by Manish Bhande on 01/06/19.
//  Copyright © 2019 Manish. All rights reserved.
//

import UIKit

class SinglePDFPageViewController: UIViewController {
    
    @IBOutlet weak var labelPageIndex: UILabel!
    var pageIndex: Int = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        labelPageIndex.text = "Page \(pageIndex)"
        // Do any additional setup after loading the view.
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? WebViewController {
            let url = try? MBSinglePagePDFGenerator.exportPDF(controller: self)
            controller.url = url
        }
    }
    
}
