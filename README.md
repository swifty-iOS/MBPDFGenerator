# MBPDFGenerator
This generates PDF (iOS 10 and above) from UIViewController using native code. This can also helps to edit PDF (iOS 11 and above) using UIView and Images. It can generate Single Page and Multipage PDF (iOS 11 and above).

## Installation

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

To integrate ***MBPDFGenerator*** into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
target '<Your Target Name>' do
    pod 'MBPDFGenerator'
end
```

## How to Use

```swift
// Generate single page PDF
let url = try? MBSinglePagePDFGenerator.exportPDF(controller: self)

// you can use keepPDFPageSize as fasle to use actual UIViewController layout
let url = try? MBSinglePagePDFGenerator.exportPDF(controller: self, keepPDFPageSize: false)
```

```swift
// Generate mutli page PDF, it uses datasouece to generate PDF

   let pdf = MBPDFGenerator(dataSource: self)
   
   // set if you can actual UIViewController layout vs actula PDF page sie
   pdf.keepPDFPageSize = false
   
   // Generate PDF
   let url = try? pdf.exportPDF()

// Data source for PDFGenerator
 MBPDFGeneratorDataSource {
    
    func numberOfPages() -> Int {
        return //number of pages for PDF
    }
    
    func page(at index: Int) -> UIViewController {
        return //UIViewConoller for give page index
    }
```

### Edit PDF
```swift
// You can edit any existing PDF
    let anyView = UIView()
    
    // Create location to add on PDF
    let viewBounds = CGRect(x: 10, y: 20, width: anyView.bounds.width, height: anyView.bounds.height)
    
    // Create view annomation from view that need to add
    let viewAnnotation = MBPDFAnnotationView(view: anyView, bounds: viewBounds, withProperties: nil)
    
    // Create PDF object from existing PDF url
    let pdf = MBPDFGenerator(url: <Existing PDF URL>)
    
    // Somply add annonation at specified page index
    if pdf?.addAnnotation(viewAnnotation, atPage: 0) {
        // Generate New edited PDF
        controller.url = try? pdf?.exportPDF()
    }   
```


## Licence

**[MIT](LICENSE)**