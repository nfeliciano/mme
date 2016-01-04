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
    @IBOutlet weak var imageViewTemp : UIImageView!
    @IBOutlet weak var segmentedControl : UISegmentedControl!
    @IBOutlet weak var scrollView : UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width*2, self.scrollView.frame.size.height);
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
//        self.playVideo()
        let fileManager = NSFileManager.defaultManager()
        let path = getDocumentsDirectory().stringByAppendingPathComponent("myImage.png")
        if (fileManager.fileExistsAtPath(path)) {
            let image: UIImage = UIImage(contentsOfFile: path)!
            self.addImagetoScrollViewAtPage(image, page: 0)
        } else {
            print("nope")
        }
        
        let vidPath = getDocumentsDirectory().stringByAppendingPathComponent("myVideo.mp4")
        if (fileManager.fileExistsAtPath(vidPath)) {
//            let player = AVPlayer(URL: NSURL(fileURLWithPath: path))
//            let playerCtrl = AVPlayerViewController()
//            playerCtrl.player = player
//            self.presentViewController(playerCtrl, animated: true) {
//                playerCtrl.player?.play()
//            }
        } else {
            print("nothing here")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addImagetoScrollViewAtPage(imageToAdd: UIImage, page: Int) {
        let image : UIImageView = UIImageView(frame: CGRectMake(0, 0, 450, 600))
        let frame : CGRect = self.scrollView.frame
        image.center = CGPointMake(frame.size.width/2 + (CGFloat(page) * frame.size.width), frame.size.height/2)
        image.image = imageToAdd
        self.scrollView .addSubview(image)
    }
    
    @IBAction func playVideo(sender: UIButton) {
//        let path = NSBundle.mainBundle().pathForResource("intro_start", ofType: "MOV")
//        let url = NSURL.fileURLWithPath(path!)
//        let player = AVPlayer(URL: url)
//        let playerCtrl = AVPlayerViewController()
//        playerCtrl.player = player
//        self.presentViewController(playerCtrl, animated: true) {
//            playerCtrl.player?.play()
//        }
//        
//        //change this to when the video stops playing
        self.cameraButton?.hidden = false
        self.recordButton?.hidden = false
        self.imageViewTemp?.hidden = false
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
                        }
                    }
                    else
                    {
                        let temp : UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
                        
                        if let data = UIImagePNGRepresentation(temp) {
                            let filename = getDocumentsDirectory().stringByAppendingPathComponent("myImage.png")
                            data.writeToFile(filename, atomically: true)
                        }
                        
                        imageViewTemp.image = temp

                    }
                }
            }
            
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "segueToGuide" {
            
        }
    }
    
    override func performSegueWithIdentifier(identifier: String, sender: AnyObject?) {
        if identifier == "segueToGuide" {
            
        }
    }
    
    func getDocumentsDirectory() -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    
}

