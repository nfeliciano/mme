//
//  BooksViewController.swift
//  Museum Ideas
//
//  Created by Noel Feliciano on 2016-01-05.
//  Copyright © 2016 mme. All rights reserved.
//

import UIKit

class BooksViewController: UIViewController, UIPageViewControllerDataSource, UIDocumentInteractionControllerDelegate {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var publishButton: UIButton!
    
    var pageViewController: UIPageViewController!
    var pageTitles: NSMutableArray!
    var pageImages: NSArray!
    
    var station: Int! = -1
    
    /*pages:
    1 - Intro with stage photo
    2 - Sample photo 1
    3 - Sample photo 2
    4 - Photo 1
    5 - Photo 2
    6 - Photo 3
    7 - Video
    8 - End with self photo
    */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pageTitles = NSMutableArray()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func backButton(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func stationPressed(sender: UIButton) {
        if (sender.tag == 1) {
            station = 1;
        } else if (sender.tag == 2) {
            station = 2;
        } else if (sender.tag == 3) {
            station = 3;
        }
        let defaults = NSUserDefaults.standardUserDefaults()
        //17
        for (var i:Int = 11; i <= 17; i++) {
            if let str = defaults.stringForKey("station\(station)-activityText\(i)") {
                self.pageTitles.addObject(str)
            } else {
                self.pageTitles.addObject("Untitled Page")
            }
        }
        self.pageTitles.addObject("Thanks for reading my book!")
        self.pageImages = NSArray(objects: "activityStage.png", "station\(station)-samplePhoto1.png", "station\(station)-samplePhoto2.png", "station\(station)-image1.png", "station\(station)-image2.png", "station\(station)-image3.png", "videoPlayButton.png", "station0-image1.png")
        self.pageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("BookViewController") as! UIPageViewController
        self.pageViewController.dataSource = self
        let startVC = self.viewControllerAtIndex(0) as PageViewController
        let viewControllers = NSArray(object: startVC)
        
        self.pageViewController.setViewControllers(viewControllers as! [PageViewController], direction: .Forward, animated: true, completion: nil)
        self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)

        self.view.addSubview(self.pageViewController.view)
        self.pageViewController.didMoveToParentViewController(self)
        self.backButton.titleLabel?.textColor = UIColor.blackColor()
        self.view.bringSubviewToFront(backButton)
        
//        self.publishButton.hidden = false
        self.view.bringSubviewToFront(self.publishButton)
    }
    
    func viewControllerAtIndex(index: Int) -> PageViewController {
        if ((self.pageTitles.count == 0) || index >= self.pageTitles.count) {
            return PageViewController()
        }
        
        var vc: PageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PageViewController") as! PageViewController
        vc.station = station
        vc.pageLabelText = self.pageTitles[index] as! String
        vc.pageIndex = index
        vc.imageFile = self.pageImages[index] as! String
        
        return vc
    }
    
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        var vc = viewController as! PageViewController
        var index = vc.pageIndex as Int
        
        if (index == 0 || index == NSNotFound) { return nil }
        index--
        return self.viewControllerAtIndex(index)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        var vc = viewController as! PageViewController
        var index = vc.pageIndex as Int
        if (index == NSNotFound) { return nil }
        index++
        if (index == self.pageTitles.count) {
            return nil
        }
        return self.viewControllerAtIndex(index)
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return self.pageTitles.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    @IBAction func generatePDFButtonPressed(sender:UIButton) {
        if (station == -1) { return }
        self.pageViewController.removeFromParentViewController()
        self.pageViewController.view.removeFromSuperview()
        let fileName:String = "Book_Station_\(station)"
        let documentsDirectory:NSString = CommonMethods().getDocumentsDirectory()
        let pdf = documentsDirectory.stringByAppendingString(fileName)
        
//        self.performSelectorOnMainThread(Selector(generatePDFWithFilePath(pdf)), withObject: nil, waitUntilDone: true)
        self.generatePDFWithFilePath(pdf)
    }
    
    func generatePDFWithFilePath(file:String) {
        let pageSize = CGSize(width: 768, height: 1024)
        UIGraphicsBeginPDFContextToFile(file, CGRectZero, nil);
        var currentPage:Int = 0
        repeat {
            UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, pageSize.width, pageSize.height), nil)
            self.drawPageNumber(currentPage)
            self.drawBorder()
//            self.drawTextForPage(currentPage)
//            self.drawImageForPage(currentPage)
            currentPage += 1
        } while (currentPage != 8)
        UIGraphicsEndPDFContext()
        
        self.uploadToIBooks(file)
    }
    
    func drawBorder() {
        let pageSize = CGSize(width: 768, height: 1024)
        let currentContext = UIGraphicsGetCurrentContext()
        let borderColor = UIColor.blackColor()
        let rectFrame = CGRectMake(10, 10, pageSize.width-20, pageSize.height-20)
        CGContextSetStrokeColorWithColor(currentContext, borderColor.CGColor)
        CGContextSetLineWidth(currentContext, 2.0)
        CGContextStrokeRect(currentContext, rectFrame)
    }
    
    func drawPageNumber(pageNumber:Int) {
        let pageNumberString:String = "Page \(pageNumber)"
        let pageSize = CGSize(width: 768, height: 1024)
        
        let stringRenderingRect = CGRectMake(10, pageSize.height-40.0, pageSize.width-20.0, 16.0)
        pageNumberString.drawInRect(stringRenderingRect, withAttributes: nil)
    }
    
    func drawTextForPage(pageNumber:Int) {
        let pageSize = CGSize(width: 768, height: 1024)
        if let textToDraw:String = self.pageTitles.objectAtIndex(pageNumber) as! String {
            let stringRenderingRect = CGRectMake(10, pageSize.height-40.0, pageSize.width-20.0, 16.0)
            textToDraw.drawInRect(stringRenderingRect, withAttributes: nil)
        }
    }
    
    func drawImageForPage(pageNumber:Int) {
//        let pageSize = CGSize(width: 768, height: 1024)
//        if (pageNumber == 0) {
//            print("argh")
//            let image = UIImage(named:"activityStage.png")
//            image!.drawInRect(CGRectMake((pageSize.width - 300)/2, 300, 300,400))
//        } else {
//            let image: UIImage = UIImage(contentsOfFile: self.pageImages.objectAtIndex(pageNumber) as! String)!
//            image.drawInRect(CGRectMake((pageSize.width - 300)/2, 300, 300,400))
//        }
    }
    
    func uploadToIBooks(pdfFile:String) {
        let pdfData = NSURL.fileURLWithPath(pdfFile)
        let didShow: Bool
        let documentInteractionController = UIDocumentInteractionController(URL: pdfData)
        documentInteractionController.delegate = self
        documentInteractionController.UTI = "com.adobe.pdf"
        documentInteractionController.presentOpenInMenuFromRect(self.publishButton.frame, inView: self.view, animated: true)
        
        
//        let activityViewController = UIActivityViewController(activityItems: [pdfData], applicationActivities: nil)
//        activityViewController.popoverPresentationController?.sourceView = self.view
//        presentViewController(activityViewController, animated: true, completion: nil)
    }
}