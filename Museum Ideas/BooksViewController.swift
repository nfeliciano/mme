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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func stationPressed(_ sender: UIButton) {
        if (sender.tag == 1) {
            station = 1;
        } else if (sender.tag == 2) {
            station = 2;
        } else if (sender.tag == 3) {
            station = 3;
        }
        let defaults = UserDefaults.standard
        //17
        for i in 11...17 {
            if let str = defaults.string(forKey: "station\(station)-activityText\(i)") {
                self.pageTitles.add(str)
            } else {
                self.pageTitles.add("Untitled Page")
            }
        }
        self.pageTitles.add("Thanks for reading my book!")
        self.pageImages = NSArray(objects: "activityStage.png", "station\(station)-samplePhoto1.png", "station\(station)-samplePhoto2.png", "station\(station)-image1.png", "station\(station)-image2.png", "station\(station)-image3.png", "videoPlayButton.png", "station0-image1.png")
        self.pageViewController = self.storyboard?.instantiateViewController(withIdentifier: "BookViewController") as! UIPageViewController
        self.pageViewController.dataSource = self
        let startVC = self.viewControllerAtIndex(0) as PageViewController
        let viewControllers = NSArray(object: startVC)
        
        self.pageViewController.setViewControllers(viewControllers as! [PageViewController], direction: .forward, animated: true, completion: nil)
        self.pageViewController.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)

        self.view.addSubview(self.pageViewController.view)
        self.pageViewController.didMove(toParentViewController: self)
        self.backButton.titleLabel?.textColor = UIColor.black
        self.view.bringSubview(toFront: backButton)
        
        self.publishButton.isHidden = false
        self.view.bringSubview(toFront: self.publishButton)
    }
    
    func viewControllerAtIndex(_ index: Int) -> PageViewController {
        if ((self.pageTitles.count == 0) || index >= self.pageTitles.count) {
            return PageViewController()
        }
        
        let vc: PageViewController = self.storyboard?.instantiateViewController(withIdentifier: "PageViewController") as! PageViewController
        vc.station = station
        vc.pageLabelText = self.pageTitles[index] as! String
        vc.pageIndex = index
        vc.imageFile = self.pageImages[index] as! String
        
        return vc
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let vc = viewController as! PageViewController
        var index = vc.pageIndex as Int
        
        if (index == 0 || index == NSNotFound) { return nil }
        index -= 1
        return self.viewControllerAtIndex(index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let vc = viewController as! PageViewController
        var index = vc.pageIndex as Int
        if (index == NSNotFound) { return nil }
        index += 1
        if (index == self.pageTitles.count) {
            return nil
        }
        return self.viewControllerAtIndex(index)
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return self.pageTitles.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    func startActivity(_ completion:() -> ()) {
        let bg = UIImageView(frame: self.view.frame)
        bg.backgroundColor = UIColor.gray
        bg.alpha = 0.8
        bg.tag = 1
        self.view.addSubview(bg)
        
        activity = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        activity.center = self.view.center
        activity.hidesWhenStopped = true
        activity.activityIndicatorViewStyle = .whiteLarge
        bg.addSubview(activity)
        activity.startAnimating()
    }
    
    @IBAction func generatePDFButtonPressed(_ sender:UIButton) {
        if (station == -1) { return }
//        self.pageViewController.removeFromParentViewController()
//        self.pageViewController.view.removeFromSuperview()
        
        let fileName:String = "Book_Station_\(station).pdf"
        let documentsDirectory:NSString = CommonMethods().getDocumentsDirectory()
        let pdf = documentsDirectory.appendingPathComponent(fileName)
//        self.startActivity { () -> () in
            self.generatePDFWithFilePath(pdf)
//        }
    }
    
    func generatePDFWithFilePath(_ file:String) {
        
        let pageSize = CGSize(width: 768, height: 1024)
        
        UIGraphicsBeginPDFContextToFile(file, CGRect.zero, [:]);
        var currentPage:Int = 0
        repeat {
            if (currentPage == 6) {
                currentPage += 1
                continue
            }
            UIGraphicsBeginPDFPageWithInfo(CGRect(x: 0, y: 0, width: pageSize.width, height: pageSize.height), nil)
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
        let borderColor = UIColor.black
        let rectFrame = CGRect(x: 10, y: 10, width: pageSize.width-20, height: pageSize.height-20)
        currentContext?.setStrokeColor(borderColor.cgColor)
        currentContext?.setLineWidth(2.0)
        currentContext?.stroke(rectFrame)
    }
    
    func drawPageNumber(_ pageNumber:Int) {
        var pageNumberString:String = "Page \(pageNumber+1)"
        if (pageNumber == 7) {
            pageNumberString = "Page \(pageNumber)"
        }
        let pageSize = CGSize(width: 768, height: 1024)
        
        let stringRenderingRect = CGRect(x: 30, y: pageSize.height-40.0, width: pageSize.width-20.0, height: 16.0)
        pageNumberString.draw(in: stringRenderingRect, withAttributes: nil)
    }
    
    func drawTextForPage(_ pageNumber:Int) {
        let pageSize = CGSize(width: 768, height: 1024)
        if let textToDraw:String = self.pageTitles.object(at: pageNumber) as! String {
            let stringRenderingRect = CGRect(x: 124, y: 113, width: 500, height: 30.0)
            let font = UIFont.init(name: "Optima-Bold", size: 24.0)
            let attr = [NSFontAttributeName:font!] as [String : AnyObject]
            textToDraw.draw(in: stringRenderingRect, withAttributes: attr)
        }
    }
    
    func drawImageForPage(_ pageNumber:Int) {
        let pageSize = CGSize(width: 768, height: 1024)
        let path = CommonMethods().getDocumentsDirectory().appendingPathComponent(self.pageImages.object(at: pageNumber) as! String)
        let fileManager = FileManager.default
        if (fileManager.fileExists(atPath: path)) {
            let image: UIImage = UIImage(contentsOfFile: path)!
            image.draw(in: CGRect(x: (pageSize.width - 400)/2, y: 250, width: 450,height: 600))
        }
    }
    
    func uploadToIBooks(_ pdfFile:String) {
        let pdfData = URL(fileURLWithPath: pdfFile)
        
//        let bg = self.view.viewWithTag(1)
//        bg?.removeFromSuperview()
//        activity.stopAnimating()
//        activity.removeFromSuperview()
        let activityViewController = UIActivityViewController(activityItems: [pdfData], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.publishButton
        present(activityViewController, animated: true, completion: nil)
    }
}
