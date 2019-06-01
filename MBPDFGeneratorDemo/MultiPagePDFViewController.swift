//
//  ViewController.swift
//  PDFGenerator
//
//  Created by Manish Bhande on 28/05/2019.
//  Copyright © 2019 Manish. All rights reserved.
//

import UIKit

@available(iOS 11.0, *)
class MultiPagePDFViewController: UIViewController {
    
    @IBOutlet weak var pageControl: UIPageControl!
    weak var pageVC: UIPageViewController?
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.destination {
        case let controller as UIPageViewController:
            controller.dataSource = self
            controller.delegate = self
            controller.setViewControllers([page()!], direction: .forward, animated: false, completion: nil)
            
        case let controller as WebViewController:
            let pdf = MBPDFGenerator(dataSource: self)
            let url = try? pdf.exportPDF()
            controller.url = url
        default: super.prepare(for: segue, sender: sender)
        }
    }
    
}

@available(iOS 11.0, *)
extension MultiPagePDFViewController: MBPDFGeneratorDataSource {
    
    func numberOfPages() -> Int {
        return pageControl.numberOfPages
    }
    
    func page(at index: Int) -> UIViewController {
        let nextPage = page()
        nextPage?.pageIndex = index+1
        return nextPage ?? self
    }
    
}

@available(iOS 11.0, *)
extension MultiPagePDFViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func page() -> SinglePDFPageViewController? {
        return storyboard?.instantiateViewController(withIdentifier: "SinglePDFPageViewController") as? SinglePDFPageViewController
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard var index = (viewController as? SinglePDFPageViewController)?.pageIndex, index > 1 else { return nil }
        index -= 1
        let newPage = page()
        newPage?.pageIndex = index
        return newPage
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard var index = (viewController as? SinglePDFPageViewController)?.pageIndex, index < pageControl.numberOfPages else { return nil }
        index += 1
        let newPage = page()
        newPage?.pageIndex = index
        return newPage
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed, let index = (pageViewController.viewControllers?.first as? SinglePDFPageViewController)?.pageIndex {
            pageControl.currentPage = index-1
        }
    }
    
}
