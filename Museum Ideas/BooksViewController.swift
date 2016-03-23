//
//  BooksViewController.swift
//  Museum Ideas
//
//  Created by Noel Feliciano on 2016-01-05.
//  Copyright © 2016 mme. All rights reserved.
//

import UIKit

class BooksViewController: UIViewController, UIPageViewControllerDataSource {
    
    var pageViewController: UIPageViewController!
    var pageTitles: NSMutableArray!
    var pageImages: NSArray!
    
    var station: Int!
    
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
        for (var i:Int = 11; i <= 13; i++) {
            if let str = defaults.stringForKey("station\(station)-activityText\(i)") {
                self.pageTitles.addObject(str)
            } else {
                self.pageTitles.addObject("Untitled Page")
            }
        }
        self.pageImages = NSArray(objects: "station1-image1.png", "station1-image2.png", "station1-image3.png")
        self.pageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("BookViewController") as! UIPageViewController
        self.pageViewController.dataSource = self
        var startVC = self.viewControllerAtIndex(0) as PageViewController
        var viewControllers = NSArray(object: startVC)
        
        self.pageViewController.setViewControllers(viewControllers as! [PageViewController], direction: .Forward, animated: true, completion: nil)
        self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
        
//        self.pageImages = NSArray(objects: "station\(sender.tag)-image1.png", "station\(sender.tag)-image2.png", "station\(sender.tag)-image3.png")
        self.view.addSubview(self.pageViewController.view)
        self.pageViewController.didMoveToParentViewController(self)
    }
    
    func viewControllerAtIndex(index: Int) -> PageViewController {
        if ((self.pageTitles.count == 0) || index >= self.pageTitles.count) {
            return PageViewController()
        }
        
        var vc: PageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PageViewController") as! PageViewController
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