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
        self.scrollView.contentSize = CGSize(width: self.scrollView.frame.size.width*2, height: self.scrollView.frame.size.height);
        self.scrollView.delegate = self
        
        let menuRightGesture : UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.menuSwipe(_:)))
        menuRightGesture.direction = .right
        self.menuView.addGestureRecognizer(menuRightGesture)
        
        let menuLeftGesture : UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.menuSwipe(_:)))
        menuLeftGesture.direction = .left
        self.menuView.addGestureRecognizer(menuLeftGesture)
        
//        self.playIntroVideo()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let fileManager = FileManager.default
        let path = getDocumentsDirectory().appendingPathComponent("myImage.png")
        let image: UIImage
        if (fileManager.fileExists(atPath: path)) {
            let initialImage : UIImage = UIImage(contentsOfFile: path)!
            image = UIImage(cgImage: initialImage.cgImage!, scale: 1, orientation: .right)
        } else {
            image = UIImage(named: "emptyImage.png")!
        }
        self.addImagetoScrollViewAtPage(image, page: 0)
        
        let vidPath = getDocumentsDirectory().appendingPathComponent("myVideo.mp4")
        let vidImage: UIImage
        if (fileManager.fileExists(atPath: vidPath)) {
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
    
    func addImagetoScrollViewAtPage(_ imageToAdd: UIImage, page: Int) {
        for imageView in self.scrollView.subviews {
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
        
        if (page == 1) {
            let tapGesture : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.playMyVideo(_:)))
            tapGesture.numberOfTapsRequired = 1
            image.addGestureRecognizer(tapGesture)
            image.isUserInteractionEnabled = true
        }
    }
    
    func playMyVideo(_ sender: UITapGestureRecognizer) {
        let fileManager = FileManager.default

        let vidPath = getDocumentsDirectory().appendingPathComponent("myVideo.mp4")
        if (fileManager.fileExists(atPath: vidPath)) {
            let player = AVPlayer(url: URL(fileURLWithPath: vidPath))
            let playerCtrl = AVPlayerViewController()
            playerCtrl.player = player
            self.present(playerCtrl, animated: true) {
                playerCtrl.player?.play()
            }
        }
    }
    
    func playIntroVideo() {
        let path = Bundle.main.path(forResource: "intro_start", ofType: "MOV")
        let url = URL(fileURLWithPath: path!)
        let player = AVPlayer(url: url)
        let playerCtrl = AVPlayerViewController()
        playerCtrl.player = player
        self.present(playerCtrl, animated: true) {
            playerCtrl.player?.play()
        }

    }
    
    @IBAction func playVideo(_ sender: UIButton) {
//        self.playIntroVideo()
        let fileManager = FileManager.default
        
        let vidPath = getDocumentsDirectory().appendingPathComponent("activityGuide.mp4")
        if (fileManager.fileExists(atPath: vidPath)) {
            let player = AVPlayer(url: URL(fileURLWithPath: vidPath))
            let playerCtrl = AVPlayerViewController()
            playerCtrl.player = player
            self.present(playerCtrl, animated: true) {
                playerCtrl.player?.play()
            }
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
                            let filename = getDocumentsDirectory().appendingPathComponent("myVideo.mp4")
                            try? videoData!.write(to: URL(fileURLWithPath: filename), options: [.atomic])
                            
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
                            let filename = getDocumentsDirectory().appendingPathComponent("myImage.png")
                            try? data.write(to: URL(fileURLWithPath: filename), options: [.atomic])
                            
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
            
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func controlButtonPressed(_ sender: UIButton) {
        let toPage : Int = sender.tag-101
        self.scrollView .setContentOffset(CGPoint(x: self.scrollView.frame.size.width * CGFloat(toPage), y: 0), animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToGuide" {
            
        } else if segue.identifier == "segueToBooks" {
            print("prep")
        }
    }
    
    override func performSegue(withIdentifier identifier: String, sender: Any?) {
        if identifier == "segueToGuide" {
            
        } else if identifier == "segueToBooks" {
            print("go")
        }
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
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
        self.changeInputIcon()
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        self.changeInputIcon()
    }
    
    func changeInputIcon() {
        if scrollView.contentOffset.x == 0 {
            self.cameraButton!.isHidden = false;
            self.recordButton!.isHidden = true;
        } else {
            self.cameraButton!.isHidden = true;
            self.recordButton!.isHidden = false;
        }
    }
    
    func getDocumentsDirectory() -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory as NSString
    }
    
    
}

