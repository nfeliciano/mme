//
//  BooksViewController.swift
//  Museum Ideas
//
//  Created by Noel Feliciano on 2016-01-05.
//  Copyright © 2016 mme. All rights reserved.
//

import UIKit

class BooksViewController: UIViewController, UIPageViewControllerDataSource {
    
    @IBOutlet weak var backButton: UIButton!
    
    var pageViewController: UIPageViewController!
    var pageTitles: NSMutableArray!
    var pageImages: NSArray!
    
    var station: Int!
    
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
        var startVC = self.viewControllerAtIndex(0) as PageViewController
        var viewControllers = NSArray(object: startVC)
        
        self.pageViewController.setViewControllers(viewControllers as! [PageViewController], direction: .Forward, animated: true, completion: nil)
        self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)

        self.view.addSubview(self.pageViewController.view)
        self.pageViewController.didMoveToParentViewController(self)
        self.backButton.titleLabel?.textColor = UIColor.blackColor()
        self.view.bringSubviewToFront(backButton)
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
}