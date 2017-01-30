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
        let defaults = UserDefaults.standard
        instructionsText.text = defaults.string(forKey: "station\(station)-activityText1")
        
        if (station == 0) {
            numPages = 2
        }
        self.scrollView.contentSize = CGSize(width: self.scrollView.frame.size.width * CGFloat(numPages), height: self.scrollView.frame.size.height);
        self.scrollView.delegate = self
        
        let menuRightGesture : UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(StationViewController.menuSwipe(_:)))
        menuRightGesture.direction = .right
        self.menuView.addGestureRecognizer(menuRightGesture)
        
        let menuLeftGesture : UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(StationViewController.menuSwipe(_:)))
        menuLeftGesture.direction = .left
        self.menuView.addGestureRecognizer(menuLeftGesture)
        
        if (numPages == 2) {
            self.changeMenuViewToTwo()
        }
        
        self.playVideo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loadImages()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page: Int = Int(scrollView.contentOffset.x / self.view.frame.size.width)
        let defaults = UserDefaults.standard
        if let instructions = defaults.string(forKey: "station\(station)-activityText\(page+1)") {
            self.instructionsText.text = instructions
        } else {
            self.instructionsText.text = "No Instructions Yet"
        }
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func infoButtonPressed(_ sender : UIButton) {
        self.playVideo()
    }
    
    func playVideo() {
        let fileManager = FileManager.default
        
        let vidPath = CommonMethods().getDocumentsDirectory().appendingPathComponent("station\(station)-guide.mp4")
        if (fileManager.fileExists(atPath: vidPath)) {
            let player = AVPlayer(url: URL(fileURLWithPath: vidPath))
            let playerCtrl = AVPlayerViewController()
            playerCtrl.player = player
            self.present(playerCtrl, animated: true) {
                playerCtrl.player?.play()
            }
        } else {
            //TODO
        }
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
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
        self.scrollView.setContentOffset(CGPoint(x: CGFloat(tag-1)*self.scrollView.frame.size.width, y: 0), animated: true)
    }
    
    func menuSwipe(_ sender: UISwipeGestureRecognizer) {
        if (sender.direction == .left) {
            if (self.scrollView.contentOffset.x < self.scrollView.contentSize.width - self.scrollView.frame.size.width) {
                self.scrollView.setContentOffset(CGPoint(x: self.scrollView.contentOffset.x+self.scrollView.frame.size.width, y: 0), animated: true)
            }
        } else {
            if (self.scrollView.contentOffset.x != 0) {
                self.scrollView.setContentOffset(CGPoint(x: self.scrollView.contentOffset.x-self.scrollView.frame.size.width, y: 0), animated: true)
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        currentPic = Int((self.scrollView.contentOffset.x / self.scrollView.frame.size.width) + 1)
        self.changeInputIcon()
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        currentPic = Int((self.scrollView.contentOffset.x / self.scrollView.frame.size.width) + 1)
        self.changeInputIcon()
    }
    
    func changeInputIcon() {
        if scrollView.contentOffset.x < self.scrollView.contentSize.width-self.scrollView.frame.size.width {
            self.cameraButton!.isHidden = false;
            self.recordButton!.isHidden = true;
        } else {
            self.cameraButton!.isHidden = true;
            self.recordButton!.isHidden = false;
        }
    }
    
    @IBAction func cameraPressed(_ sender: UIButton) {
        let imageFromSource = UIImagePickerController()
        imageFromSource.delegate = self
        imageFromSource.allowsEditing = false;
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            imageFromSource.sourceType = UIImagePickerControllerSourceType.camera
            
        } else {
            imageFromSource.sourceType = UIImagePickerControllerSourceType.photoLibrary
        }
        
        self.present(imageFromSource, animated: true, completion: nil)
    }
    
    @IBAction func videoPressed(_ sender: UIButton) {
        let videoFromSource = UIImagePickerController()
        videoFromSource.delegate = self
        videoFromSource.allowsEditing = true;
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            videoFromSource.sourceType = .camera
            videoFromSource.mediaTypes = [kUTTypeMovie as String]
            videoFromSource.videoQuality = .typeMedium
            videoFromSource.videoMaximumDuration = 30.0
            self.present(videoFromSource, animated: true, completion: nil)
        }
    }
    
    func loadImages() {
        for i in 1 ..< numPages {
            let fileManager = FileManager.default
            let path = CommonMethods().getDocumentsDirectory().appendingPathComponent("station\(station)-image\(i).png")
            if (fileManager.fileExists(atPath: path)) {
                let image: UIImage = UIImage(contentsOfFile: path)!
//                let rotated: UIImage = UIImage(CGImage: image.CGImage!, scale: 1, orientation: .Right)
                self.addImagetoScrollViewAtPage(image, page: i-1)
                //add to image here
            } else {
                //add empty image here
                self.addImagetoScrollViewAtPage(UIImage(named: "emptyImage.png")!, page: i-1)
            }
        }
        let fileManager = FileManager.default
        let path = CommonMethods().getDocumentsDirectory().appendingPathComponent("station\(station)-video.mp4")
        var image : UIImage
        if (fileManager.fileExists(atPath: path)) {
            image = UIImage(named: "videoPlayButton.png")!
            let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(StationViewController.playThisVideo(_:)))
            tap.numberOfTapsRequired = 1
            tap.numberOfTouchesRequired = 1
            self.scrollView.addGestureRecognizer(tap)
        } else {
            image = UIImage(named: "emptyVideo.png")!
            
        }
        self.addImagetoScrollViewAtPage(image, page: numPages-1)
    }
    
    func playThisVideo(_ sender : UITapGestureRecognizer) {
        if (self.scrollView.contentOffset.x >= self.scrollView.frame.size.width*3) {
            let fileManager = FileManager.default
            
            let vidPath = CommonMethods().getDocumentsDirectory().appendingPathComponent("station\(station)-video.mp4")
            if (fileManager.fileExists(atPath: vidPath)) {
                let player = AVPlayer(url: URL(fileURLWithPath: vidPath))
                let playerCtrl = AVPlayerViewController()
                playerCtrl.player = player
                self.present(playerCtrl, animated: true) {
                    playerCtrl.player?.play()
                }
            }
        }
    }
    
    func changeMenuViewToTwo() {
        let newPhotoButton:UIButton = self.menuView.viewWithTag(102) as! UIButton
        let newVideoButton:UIButton = self.menuView.viewWithTag(103) as! UIButton
        
        let photoOne:UIButton = self.menuView.viewWithTag(101) as! UIButton
        let photoTwo:UIButton = self.menuView.viewWithTag(104) as! UIButton
        photoOne.removeFromSuperview()
        photoTwo.removeFromSuperview()
        newPhotoButton.tag = 101
        newVideoButton.tag = 104
        
        //TODO: still a problem
        self.menuView.frame = CGRect(x: self.menuView.frame.origin.x, y: self.menuView.frame.origin.y, width: self.menuView.frame.size.width-200, height: self.menuView.frame.size.height)
        newPhotoButton.setTitle("Photo", for: UIControlState())
        newVideoButton.setTitle("Video", for: UIControlState())
    }
    
    func addImagetoScrollViewAtPage(_ imageToAdd: UIImage, page: Int) {
        for imageView in self.scrollView.subviews {
            //bad code..
            if (imageView.tag == page+10) {
                let replaceView : UIImageView = imageView as! UIImageView
                replaceView.image = imageToAdd
                return
            }
        }
        let image : UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 450, height: 600))
        let frame : CGRect = self.scrollView.frame
        image.center = CGPoint(x: frame.size.width/2 + (CGFloat(page) * frame.size.width), y: frame.size.height/2)
        image.image = imageToAdd
        image.tag = page+10;
        self.scrollView .addSubview(image)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if (picker.sourceType == UIImagePickerControllerSourceType.camera || picker.sourceType == UIImagePickerControllerSourceType.photoLibrary) {
            
            let mediaType:AnyObject? = info[UIImagePickerControllerMediaType] as AnyObject?
            if let type:AnyObject = mediaType {
                if type is String {
                    let stringType = type as! String
                    
                    if stringType == kUTTypeMovie as String {
                        print("is a movie")
                        let urlOfVideo = info[UIImagePickerControllerMediaURL] as? URL
                        if let url = urlOfVideo {
                            print("url of video")
                            var dataReadingError: NSError?
                            let videoData: Data?
                            do {
                                videoData = try Data(contentsOf: url, options: .mappedRead)
                            } catch let error as NSError {
                                print("videoData error")
                                dataReadingError = error
                                videoData = nil
                            }
                            let filename = CommonMethods().getDocumentsDirectory().appendingPathComponent("station\(station)-video.mp4")
                            try? videoData!.write(to: URL(fileURLWithPath: filename), options: [.atomic])
                            
                            //add image to scrollview here
                            for imageView in self.scrollView.subviews {
                                if (imageView.tag == 13) {
                                    let replaceView : UIImageView = imageView as! UIImageView
                                    replaceView.image = UIImage(named: "videoPlayButton.png")!
                                }
                            }
                            
                            UISaveVideoAtPathToSavedPhotosAlbum(url.path, nil, nil, nil);
                        }
                    }
                    else
                    {
                        let temp : UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
                        let image : UIImage = CommonMethods().rotateCameraImageToProperOrientation(temp, maxResolution: 1024)
                        
                        if let data = UIImagePNGRepresentation(image) {
                            let filename = CommonMethods().getDocumentsDirectory().appendingPathComponent("station\(station)-image\(currentPic).png")
                            try? data.write(to: URL(fileURLWithPath: filename), options: [.atomic])
                            
                            //add image to scrollview here
                            for imageView in self.scrollView.subviews {
                                if (imageView.tag >= 10 && imageView.tag < 13) {
                                    let replaceView : UIImageView = imageView as! UIImageView
                                    replaceView.image = image
                                }
                            }
                            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                        }
                    }
                }
            }
            
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}
