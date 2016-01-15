//
//  DesignViewController.swift
//  Museum Ideas
//
//  Created by Noel Feliciano on 2016-01-15.
//  Copyright © 2016 mme. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import MobileCoreServices

class DesignViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stageButton: UIButton!
    @IBOutlet weak var photosButton: UIButton!
    @IBOutlet weak var textButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        let defaults = NSUserDefaults.standardUserDefaults()
        if let title = defaults.objectForKey("activityName") {
            self.titleField.text = title as! String
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func recordButtonPressed(sender : UIButton) {
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
    
    @IBAction func stagePressed(sender : UIButton) {
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
    
    @IBAction func backButtonPressed(sender : UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
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
                            let filename = getDocumentsDirectory().stringByAppendingPathComponent("activityGuide.mp4")
                            videoData!.writeToFile(filename, atomically: true)
                            
                            
                        }
                    }
                    else
                    {
                        let temp : UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
                        
                        if let data = UIImagePNGRepresentation(temp) {
                            let filename = getDocumentsDirectory().stringByAppendingPathComponent("activityStage.png")
                            data.writeToFile(filename, atomically: true)
                            
                        }
                    }
                }
            }
            
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func getDocumentsDirectory() -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.selectedTextRange = textField.textRangeFromPosition(textField.beginningOfDocument, toPosition: textField.endOfDocument)
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textField.text?.characters.count > 0 {
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults .setObject(textField.text, forKey: "activityName")
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
