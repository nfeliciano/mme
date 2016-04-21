//
//  DesignerViewController.swift
//  Museum Ideas
//
//  Created by Noel Feliciano on 2016-03-08.
//  Copyright © 2016 mme. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import MobileCoreServices

class DesignerViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    var station: Int!
    @IBOutlet weak var titleField: UITextField!
    
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
    
    @IBAction func backButtonPressed(sender : UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
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
    
    @IBAction func recordVideo(sender:UIButton) {
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
        print("didfinish")
        if (picker.sourceType == UIImagePickerControllerSourceType.Camera || picker.sourceType == UIImagePickerControllerSourceType.PhotoLibrary) {
            print("yes")
            let mediaType:AnyObject? = info[UIImagePickerControllerMediaType]
            if let type:AnyObject = mediaType {
                if type is String {
                    print("isVideo")
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
                            let filename = CommonMethods().getDocumentsDirectory().stringByAppendingPathComponent("mainVideoGuide.mp4")
                            videoData!.writeToFile(filename, atomically: true)
                            UISaveVideoAtPathToSavedPhotosAlbum(url.path!, nil, nil, nil);
                        }
                    }
                    else
                    {
                        let temp : UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
                        let image : UIImage = CommonMethods().rotateCameraImageToProperOrientation(temp, maxResolution: 1024)
                        if let data = UIImagePNGRepresentation(image) {
                            let filename = CommonMethods().getDocumentsDirectory().stringByAppendingPathComponent("activityStage.png")
                            data.writeToFile(filename, atomically: true)
                        }
                        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                        
                    }
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            }
        }
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.selectedTextRange = textField.textRangeFromPosition(textField.beginningOfDocument, toPosition: textField.endOfDocument)
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textField.text?.characters.count > 0 {
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults .setObject(textField.text, forKey: "station\(station)-name")
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        let currentCharacterCount = textField.text?.characters.count ?? 0
        if (range.length + range.location > currentCharacterCount){
            return false
        }
        let newLength = currentCharacterCount + string.characters.count - range.length
        return newLength <= 30
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "toBooks") {
            return;
        }
        let station:DesignViewController = segue.destinationViewController as! DesignViewController
        if (segue.identifier == "stationIntro") {
            station.station = 0;
        } else if (segue.identifier == "stationOne") {
            station.station = 1;
        } else if (segue.identifier == "stationTwo") {
            station.station = 2;
        } else {
            station.station = 3;
        }
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
