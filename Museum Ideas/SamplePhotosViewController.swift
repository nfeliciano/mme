//
//  SamplePhotosViewController.swift
//  Museum Ideas
//
//  Created by Noel Feliciano on 2016-03-22.
//  Copyright © 2016 mme. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import MobileCoreServices

class SamplePhotosViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIScrollViewDelegate {
    @IBOutlet weak var cameraButton : UIButton!
    @IBOutlet weak var scrollView : UIScrollView!
    @IBOutlet weak var menuView : UIView!
    var station: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width*2, self.scrollView.frame.size.height);
        self.scrollView.delegate = self
        
        let menuRightGesture : UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: Selector("menuSwipe:"))
        menuRightGesture.direction = .Right
        self.menuView.addGestureRecognizer(menuRightGesture)
        
        let menuLeftGesture : UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: Selector("menuSwipe:"))
        menuLeftGesture.direction = .Left
        self.menuView.addGestureRecognizer(menuLeftGesture)
        
        //        self.playIntroVideo()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        for (var i = 0; i < 2; i++) {
            let fileManager = NSFileManager.defaultManager()
            let path = CommonMethods().getDocumentsDirectory().stringByAppendingPathComponent("station\(station)-samplePhoto\(i+1).png")
            let image: UIImage
            if (fileManager.fileExistsAtPath(path)) {
                let initialImage : UIImage = UIImage(contentsOfFile: path)!
//                image = UIImage(CGImage: initialImage.CGImage!, scale: 1, orientation: .Right)
                image = initialImage
            } else {
                image = UIImage(named: "emptyImage.png")!
            }
            self.addImagetoScrollViewAtPage(image, page: i)
        }

        }
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addImagetoScrollViewAtPage(imageToAdd: UIImage, page: Int) {
        for imageView in self.scrollView.subviews {
            if (imageView.tag == page+10) {
                let replaceView : UIImageView = imageView as! UIImageView
                replaceView.image = imageToAdd
                return
            }
        }
        let image : UIImageView = UIImageView(frame: CGRectMake(0, 0, 450, 600))
        let frame : CGRect = self.scrollView.frame
        image.center = CGPointMake(frame.size.width/2 + (CGFloat(page) * frame.size.width), frame.size.height/2)
        image.image = imageToAdd
        image.tag = page+10;
        self.scrollView .addSubview(image)
    }
    
    @IBAction func cameraPressed(sender: UIButton) {
        
        let imageFromSource = UIImagePickerController()
        imageFromSource.delegate = self
        imageFromSource.allowsEditing = false;
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            imageFromSource.sourceType = UIImagePickerControllerSourceType.Camera
            
        } else {
            imageFromSource.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        }
        
        self.presentViewController(imageFromSource, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if (picker.sourceType == UIImagePickerControllerSourceType.Camera || picker.sourceType == UIImagePickerControllerSourceType.PhotoLibrary) {
            
            let temp : UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
            let image : UIImage = CommonMethods().rotateCameraImageToProperOrientation(temp, maxResolution: 1024)
            
            if let data = UIImagePNGRepresentation(image) {
                var filename = ""
                if (scrollView.contentOffset.x == 0) {
                    filename = CommonMethods().getDocumentsDirectory().stringByAppendingPathComponent("station\(station)-samplePhoto1.png")
                } else {
                    filename = CommonMethods().getDocumentsDirectory().stringByAppendingPathComponent("station\(station)-samplePhoto2.png")
                }
                data.writeToFile(filename, atomically: true)
                
                //add image to scrollview here
                for imageView in self.scrollView.subviews {
                    if (imageView.tag == 10) {
                        let replaceView : UIImageView = imageView as! UIImageView
                        replaceView.image = temp
                    }
                }
            }
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    @IBAction func controlButtonPressed(sender: UIButton) {
        let toPage : Int = sender.tag-101
        self.scrollView .setContentOffset(CGPointMake(self.scrollView.frame.size.width * CGFloat(toPage), 0), animated: true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "segueToGuide" {
            
        } else if segue.identifier == "segueToBooks" {
            print("prep")
        }
    }
    
    @IBAction func backButton(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func menuSwipe(sender: UISwipeGestureRecognizer) {
        if (sender.direction == .Left) {
            if (self.scrollView.contentOffset.x < self.scrollView.contentSize.width - self.scrollView.frame.size.width) {
                self.scrollView.setContentOffset(CGPointMake(self.scrollView.contentOffset.x+self.scrollView.frame.size.width, 0), animated: true)
            }
        } else {
            if (self.scrollView.contentOffset.x != 0) {
                self.scrollView.setContentOffset(CGPointMake(self.scrollView.contentOffset.x-self.scrollView.frame.size.width, 0), animated: true)
            }
        }
    }
    
    
}

