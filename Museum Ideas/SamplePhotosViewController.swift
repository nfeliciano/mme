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
        self.scrollView.contentSize = CGSize(width: self.scrollView.frame.size.width*2, height: self.scrollView.frame.size.height);
        self.scrollView.delegate = self
        
        let menuRightGesture : UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(SamplePhotosViewController.menuSwipe(_:)))
        menuRightGesture.direction = .right
        self.menuView.addGestureRecognizer(menuRightGesture)
        
        let menuLeftGesture : UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(SamplePhotosViewController.menuSwipe(_:)))
        menuLeftGesture.direction = .left
        self.menuView.addGestureRecognizer(menuLeftGesture)
        
        //        self.playIntroVideo()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        for i in 0 ..< 2 {
            let fileManager = FileManager.default
            let path = CommonMethods().getDocumentsDirectory().appendingPathComponent("station\(station)-samplePhoto\(i+1).png")
            let image: UIImage
            if (fileManager.fileExists(atPath: path)) {
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if (picker.sourceType == UIImagePickerControllerSourceType.camera || picker.sourceType == UIImagePickerControllerSourceType.photoLibrary) {
            
            let temp : UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
            let image : UIImage = CommonMethods().rotateCameraImageToProperOrientation(temp, maxResolution: 1024)
            
            if let data = UIImagePNGRepresentation(image) {
                var filename = ""
                if (scrollView.contentOffset.x == 0) {
                    filename = CommonMethods().getDocumentsDirectory().appendingPathComponent("station\(station)-samplePhoto1.png")
                } else {
                    filename = CommonMethods().getDocumentsDirectory().appendingPathComponent("station\(station)-samplePhoto2.png")
                }
                try? data.write(to: URL(fileURLWithPath: filename), options: [.atomic])
                
                //add image to scrollview here
                for imageView in self.scrollView.subviews {
                    if (imageView.tag == 10) {
                        let replaceView : UIImageView = imageView as! UIImageView
                        replaceView.image = temp
                    }
                }
            }
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            
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
    
    
}

