//
//  StationViewController.swift
//  Museum Ideas
//
//  Created by Noel Feliciano on 2015-11-17.
//  Copyright © 2015 mme. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import MobileCoreServices

class StationViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIScrollViewDelegate {
    
    @IBOutlet weak var cameraButton : UIButton!
    @IBOutlet weak var recordButton : UIButton!
    @IBOutlet weak var scrollView : UIScrollView!
    @IBOutlet weak var menuView : UIView!
    
    var station: Int! = -1
    var numPages: Int! = 4
    var currentPic: Int! = 1
    @IBOutlet weak var titleField: UILabel!
    @IBOutlet weak var instructionsText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleField.text = "Station \(station)"
        if (station == 0) {
            titleField.text = "Introduction"
        }
        let defaults = NSUserDefaults.standardUserDefaults()
        instructionsText.text = defaults.stringForKey("station\(station)-activityText1")
        
        if (station == 0) {
            numPages = 2
            self.changeMenuViewToTwo()
        }
        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * CGFloat(numPages), self.scrollView.frame.size.height);
        self.scrollView.delegate = self
        
        let menuRightGesture : UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: Selector("menuSwipe:"))
        menuRightGesture.direction = .Right
        self.menuView.addGestureRecognizer(menuRightGesture)
        
        let menuLeftGesture : UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: Selector("menuSwipe:"))
        menuLeftGesture.direction = .Left
        self.menuView.addGestureRecognizer(menuLeftGesture)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.loadImages()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let page: Int = Int(scrollView.contentOffset.x / self.view.frame.size.width)
        let defaults = NSUserDefaults.standardUserDefaults()
        self.instructionsText.text = defaults.stringForKey("station\(station)-activityText\(page+1)")
    }
    
    @IBAction func backButton(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func buttonPressed(sender: UIButton) {
        let tag :Int!
        if (sender.tag == 101) {
            tag = 1
        } else if (sender.tag == 102) {
            tag = 2
        } else if (sender.tag == 103) {
            tag = 3
        } else if (sender.tag == 104) {
            if (station == 0) { tag = 2 }
            else { tag = 4 }
        } else {
            return
        }
        currentPic = tag
        self.scrollView.setContentOffset(CGPointMake(CGFloat(tag-1)*self.scrollView.frame.size.width, 0), animated: true)
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
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        currentPic = Int((self.scrollView.contentOffset.x / self.scrollView.frame.size.width) + 1)
        self.changeInputIcon()
    }
    
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        currentPic = Int((self.scrollView.contentOffset.x / self.scrollView.frame.size.width) + 1)
        self.changeInputIcon()
    }
    
    func changeInputIcon() {
        if scrollView.contentOffset.x < self.scrollView.contentSize.width-self.scrollView.frame.size.width {
            self.cameraButton!.hidden = false;
            self.recordButton!.hidden = true;
        } else {
            self.cameraButton!.hidden = true;
            self.recordButton!.hidden = false;
        }
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
    
    @IBAction func videoPressed(sender: UIButton) {
        let videoFromSource = UIImagePickerController()
        videoFromSource.delegate = self
        videoFromSource.allowsEditing = true;
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            videoFromSource.sourceType = .Camera
            videoFromSource.mediaTypes = [kUTTypeMovie as String]
            videoFromSource.videoQuality = .TypeMedium
            videoFromSource.videoMaximumDuration = 30.0
            self.presentViewController(videoFromSource, animated: true, completion: nil)
        }
    }
    
    func loadImages() {
        for var i = 1; i < numPages; i++ {
            let fileManager = NSFileManager.defaultManager()
            let path = CommonMethods().getDocumentsDirectory().stringByAppendingPathComponent("station\(station)-image\(i).png")
            if (fileManager.fileExistsAtPath(path)) {
                let image: UIImage = UIImage(contentsOfFile: path)!
                let rotated: UIImage = UIImage(CGImage: image.CGImage!, scale: 1, orientation: .Right)
                self.addImagetoScrollViewAtPage(rotated, page: i-1)
                //add to image here
            } else {
                //add empty image here
                self.addImagetoScrollViewAtPage(UIImage(named: "emptyImage.png")!, page: i-1)
            }
        }
        let fileManager = NSFileManager.defaultManager()
        let path = CommonMethods().getDocumentsDirectory().stringByAppendingPathComponent("station\(station)-video.mp4")
        var image : UIImage
        if (fileManager.fileExistsAtPath(path)) {
            image = UIImage(named: "videoPlayButton.png")!
            let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("playThisVideo:"))
            tap.numberOfTapsRequired = 1
            tap.numberOfTouchesRequired = 1
            self.scrollView.addGestureRecognizer(tap)
        } else {
            image = UIImage(named: "emptyVideo.png")!
            
        }
        self.addImagetoScrollViewAtPage(image, page: numPages-1)
    }
    
    func playThisVideo(sender : UITapGestureRecognizer) {
        if (self.scrollView.contentOffset.x >= self.scrollView.frame.size.width*3) {
            let fileManager = NSFileManager.defaultManager()
            
            let vidPath = CommonMethods().getDocumentsDirectory().stringByAppendingPathComponent("station\(station)-video.mp4")
            if (fileManager.fileExistsAtPath(vidPath)) {
                let player = AVPlayer(URL: NSURL(fileURLWithPath: vidPath))
                let playerCtrl = AVPlayerViewController()
                playerCtrl.player = player
                self.presentViewController(playerCtrl, animated: true) {
                    playerCtrl.player?.play()
                }
            }
        }
    }
    
    func changeMenuViewToTwo() {
        let photoButton:UIButton = self.menuView.viewWithTag(101) as! UIButton
        let videoButton:UIButton = self.menuView.viewWithTag(104) as! UIButton
        
        let photoTwo:UIButton = self.menuView.viewWithTag(102) as! UIButton
        let photoThree:UIButton = self.menuView.viewWithTag(103) as! UIButton
        photoTwo.removeFromSuperview()
        photoThree.removeFromSuperview()
        
        //TODO: still a problem
//        self.menuView.frame = CGRectMake(self.menuView.frame.origin.x, self.menuView.frame.origin.y, self.menuView.frame.size.width-200, self.menuView.frame.size.height)
//        photoButton.titleLabel?.text = "Photo"
//        videoButton.titleLabel?.text = "Video"
//        photoButton.center = CGPointMake(self.menuView.frame.size.width / 3, photoButton.center.y)
//        videoButton.center = CGPointMake(self.menuView.frame.size.width*2 / 3, photoButton.center.y)
    }
    
    func addImagetoScrollViewAtPage(imageToAdd: UIImage, page: Int) {
        for imageView in self.scrollView.subviews {
            //bad code..
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
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if (picker.sourceType == UIImagePickerControllerSourceType.Camera || picker.sourceType == UIImagePickerControllerSourceType.PhotoLibrary) {
            
            let mediaType:AnyObject? = info[UIImagePickerControllerMediaType]
            if let type:AnyObject = mediaType {
                if type is String {
                    let stringType = type as! String
                    
                    if stringType == kUTTypeMovie as String {
                        print("is a movie")
                        let urlOfVideo = info[UIImagePickerControllerMediaURL] as? NSURL
                        if let url = urlOfVideo {
                            print("url of video")
                            var dataReadingError: NSError?
                            let videoData: NSData?
                            do {
                                videoData = try NSData(contentsOfURL: url, options: .MappedRead)
                            } catch let error as NSError {
                                print("videoData error")
                                dataReadingError = error
                                videoData = nil
                            }
                            let filename = CommonMethods().getDocumentsDirectory().stringByAppendingPathComponent("station\(station)-video.mp4")
                            videoData!.writeToFile(filename, atomically: true)
                            
                            //add image to scrollview here
                            for imageView in self.scrollView.subviews {
                                if (imageView.tag == 13) {
                                    let replaceView : UIImageView = imageView as! UIImageView
                                    replaceView.image = UIImage(named: "videoPlayButton.png")!
                                }
                            }
                        }
                    }
                    else
                    {
                        let temp : UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
                        
                        if let data = UIImagePNGRepresentation(temp) {
                            let filename = CommonMethods().getDocumentsDirectory().stringByAppendingPathComponent("station\(station)-image\(currentPic).png")
                            data.writeToFile(filename, atomically: true)
                            
                            //add image to scrollview here
                            for imageView in self.scrollView.subviews {
                                if (imageView.tag >= 10 && imageView.tag < 13) {
                                    let replaceView : UIImageView = imageView as! UIImageView
                                    replaceView.image = temp
                                }
                            }
                        }
                    }
                }
            }
            
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
}