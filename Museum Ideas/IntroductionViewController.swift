//
//  ViewController.swift
//  Museum Ideas
//
//  Created by Noel Feliciano on 2015-10-13.
//  Copyright © 2015 mme. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import MobileCoreServices

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIScrollViewDelegate {
    @IBOutlet weak var introButton : UIButton!
    @IBOutlet weak var cameraButton : UIButton!
    @IBOutlet weak var recordButton : UIButton!
    @IBOutlet weak var continueButton : UIButton!
    @IBOutlet weak var scrollView : UIScrollView!
    @IBOutlet weak var menuView : UIView!
    
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
        
        let fileManager = NSFileManager.defaultManager()
        let path = getDocumentsDirectory().stringByAppendingPathComponent("myImage.png")
        let image: UIImage
        if (fileManager.fileExistsAtPath(path)) {
            let initialImage : UIImage = UIImage(contentsOfFile: path)!
            image = UIImage(CGImage: initialImage.CGImage!, scale: 1, orientation: .Right)
        } else {
            image = UIImage(named: "emptyImage.png")!
        }
        self.addImagetoScrollViewAtPage(image, page: 0)
        
        let vidPath = getDocumentsDirectory().stringByAppendingPathComponent("myVideo.mp4")
        let vidImage: UIImage
        if (fileManager.fileExistsAtPath(vidPath)) {
//            let player = AVPlayer(URL: NSURL(fileURLWithPath: path))
//            let playerCtrl = AVPlayerViewController()
//            playerCtrl.player = player
//            self.presentViewController(playerCtrl, animated: true) {
//                playerCtrl.player?.play()
//            }
            vidImage = UIImage(named: "videoPlayButton.png")!
        } else {
            vidImage = UIImage(named: "emptyVideo.png")!
        }
        self.addImagetoScrollViewAtPage(vidImage, page: 1)
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
        
        if (page == 1) {
            let tapGesture : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("playMyVideo:"))
            tapGesture.numberOfTapsRequired = 1
            image.addGestureRecognizer(tapGesture)
            image.userInteractionEnabled = true
        }
    }
    
    func playMyVideo(sender: UITapGestureRecognizer) {
        let fileManager = NSFileManager.defaultManager()

        let vidPath = getDocumentsDirectory().stringByAppendingPathComponent("myVideo.mp4")
        if (fileManager.fileExistsAtPath(vidPath)) {
            let player = AVPlayer(URL: NSURL(fileURLWithPath: vidPath))
            let playerCtrl = AVPlayerViewController()
            playerCtrl.player = player
            self.presentViewController(playerCtrl, animated: true) {
                playerCtrl.player?.play()
            }
        }
    }
    
    func playIntroVideo() {
        let path = NSBundle.mainBundle().pathForResource("intro_start", ofType: "MOV")
        let url = NSURL.fileURLWithPath(path!)
        let player = AVPlayer(URL: url)
        let playerCtrl = AVPlayerViewController()
        playerCtrl.player = player
        self.presentViewController(playerCtrl, animated: true) {
            playerCtrl.player?.play()
        }

    }
    
    @IBAction func playVideo(sender: UIButton) {
//        self.playIntroVideo()
        let fileManager = NSFileManager.defaultManager()
        
        let vidPath = getDocumentsDirectory().stringByAppendingPathComponent("activityGuide.mp4")
        if (fileManager.fileExistsAtPath(vidPath)) {
            let player = AVPlayer(URL: NSURL(fileURLWithPath: vidPath))
            let playerCtrl = AVPlayerViewController()
            playerCtrl.player = player
            self.presentViewController(playerCtrl, animated: true) {
                playerCtrl.player?.play()
            }
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
                            let filename = getDocumentsDirectory().stringByAppendingPathComponent("myVideo.mp4")
                            videoData!.writeToFile(filename, atomically: true)
                            
                            //add image to scrollview here
                            for imageView in self.scrollView.subviews {
                                if (imageView.tag == 11) {
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
                            let filename = getDocumentsDirectory().stringByAppendingPathComponent("myImage.png")
                            data.writeToFile(filename, atomically: true)
                            
                            //add image to scrollview here
                            for imageView in self.scrollView.subviews {
                                if (imageView.tag == 10) {
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
    
    override func performSegueWithIdentifier(identifier: String, sender: AnyObject?) {
        if identifier == "segueToGuide" {
            
        } else if identifier == "segueToBooks" {
            print("go")
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
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        self.changeInputIcon()
    }
    
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        self.changeInputIcon()
    }
    
    func changeInputIcon() {
        if scrollView.contentOffset.x == 0 {
            self.cameraButton!.hidden = false;
            self.recordButton!.hidden = true;
        } else {
            self.cameraButton!.hidden = true;
            self.recordButton!.hidden = false;
        }
    }
    
    func getDocumentsDirectory() -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    
}

