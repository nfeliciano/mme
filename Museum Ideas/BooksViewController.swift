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
    
    var activity : UIActivityIndicatorView!
    
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
        
        self.publishButton.hidden = false
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
    
    func startActivity(completion:() -> ()) {
        let bg = UIImageView(frame: self.view.frame)
        bg.backgroundColor = UIColor.grayColor()
        bg.alpha = 0.8
        bg.tag = 1
        self.view.addSubview(bg)
        
        activity = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
        activity.center = self.view.center
        activity.hidesWhenStopped = true
        activity.activityIndicatorViewStyle = .WhiteLarge
        bg.addSubview(activity)
        activity.startAnimating()
    }
    
    @IBAction func generatePDFButtonPressed(sender:UIButton) {
        if (station == -1) { return }
//        self.pageViewController.removeFromParentViewController()
//        self.pageViewController.view.removeFromSuperview()
        
        let fileName:String = "Book_Station_\(station).pdf"
        let documentsDirectory:NSString = CommonMethods().getDocumentsDirectory()
        let pdf = documentsDirectory.stringByAppendingPathComponent(fileName)
//        self.startActivity { () -> () in
            self.generatePDFWithFilePath(pdf)
//        }
    }
    
    func generatePDFWithFilePath(file:String) {
        
        let pageSize = CGSize(width: 768, height: 1024)
        
        UIGraphicsBeginPDFContextToFile(file, CGRectZero, [:]);
        var currentPage:Int = 0
        repeat {
            if (currentPage == 6) {
                currentPage += 1
                continue
            }
            UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, pageSize.width, pageSize.height), nil)
            self.drawPageNumber(currentPage)
            self.drawBorder()
            self.drawTextForPage(currentPage)
            self.drawImageForPage(currentPage)
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
        var pageNumberString:String = "Page \(pageNumber+1)"
        if (pageNumber == 7) {
            pageNumberString = "Page \(pageNumber)"
        }
        let pageSize = CGSize(width: 768, height: 1024)
        
        let stringRenderingRect = CGRectMake(30, pageSize.height-40.0, pageSize.width-20.0, 16.0)
        pageNumberString.drawInRect(stringRenderingRect, withAttributes: nil)
    }
    
    func drawTextForPage(pageNumber:Int) {
        let pageSize = CGSize(width: 768, height: 1024)
        if let textToDraw:String = self.pageTitles.objectAtIndex(pageNumber) as! String {
            let stringRenderingRect = CGRectMake(124, 113, 500, 30.0)
            let font = UIFont.init(name: "Optima-Bold", size: 24.0)
            let attr = [NSFontAttributeName:font!] as [String : AnyObject]
            textToDraw.drawInRect(stringRenderingRect, withAttributes: attr)
        }
    }
    
    func drawImageForPage(pageNumber:Int) {
        let pageSize = CGSize(width: 768, height: 1024)
        let path = CommonMethods().getDocumentsDirectory().stringByAppendingPathComponent(self.pageImages.objectAtIndex(pageNumber) as! String)
        let fileManager = NSFileManager.defaultManager()
        if (fileManager.fileExistsAtPath(path)) {
            let image: UIImage = UIImage(contentsOfFile: path)!
            image.drawInRect(CGRectMake((pageSize.width - 400)/2, 250, 450,600))
        }
    }
    
    func uploadToIBooks(pdfFile:String) {
        let pdfData = NSURL.fileURLWithPath(pdfFile)
        
//        let bg = self.view.viewWithTag(1)
//        bg?.removeFromSuperview()
//        activity.stopAnimating()
//        activity.removeFromSuperview()
        let activityViewController = UIActivityViewController(activityItems: [pdfData], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.publishButton
        presentViewController(activityViewController, animated: true, completion: nil)
    }
}