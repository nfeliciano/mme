//
//  StationViewController.swift
//  Museum Ideas
//
//  Created by Noel Feliciano on 2015-11-17.
//  Copyright © 2015 mme. All rights reserved.
//

import UIKit

class StationViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var imageOneButton : UIButton!
    @IBOutlet weak var imageTwoButton : UIButton!
    @IBOutlet weak var imageThreeButton : UIButton!
    @IBOutlet weak var videoButton : UIButton!
    @IBOutlet weak var cameraButton : UIButton!
    @IBOutlet weak var recordButton : UIButton!
    @IBOutlet weak var imagePreview : UIImageView!
    
    var station: Int!
    var currentPic: Int! = 1
    @IBOutlet weak var titleField: UILabel!
    
    override func viewDidLoad() {
        titleField.text = "Station \(station)"
        self.loadImage()
        super.viewDidLoad()
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
    
    @IBAction func buttonPressed(sender: UIButton) {
        if (sender.tag == 1) {
            currentPic = 1
        } else if (sender.tag == 2) {
            currentPic = 2
        } else if (sender.tag == 3) {
            currentPic = 3
        } else if (sender.tag == 4) {
            currentPic = 4
        }
        self.loadImage()
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
    
    func loadImage() {
        let fileManager = NSFileManager.defaultManager()
        let path = getDocumentsDirectory().stringByAppendingPathComponent("station\(station)-image\(currentPic).png")
        if (fileManager.fileExistsAtPath(path)) {
            let image: UIImage = UIImage(contentsOfFile: path)!
            self.imagePreview.image = image
        } else {
            self.imagePreview.image = nil
            print("nope")
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if (picker.sourceType == UIImagePickerControllerSourceType.Camera || picker.sourceType == UIImagePickerControllerSourceType.PhotoLibrary) {
            let temp : UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
            
            if let data = UIImagePNGRepresentation(temp) {
                let filename = getDocumentsDirectory().stringByAppendingPathComponent("station\(station)-image\(currentPic).png")
                data.writeToFile(filename, atomically: true)
            }
            
            imagePreview.image = temp
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func getDocumentsDirectory() -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
}