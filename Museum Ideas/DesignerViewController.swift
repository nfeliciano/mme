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
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class DesignerViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    var station: Int!
    @IBOutlet weak var titleField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        if let title = defaults.object(forKey: "activityName") {
            self.titleField.text = title as! String
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButtonPressed(_ sender : UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func stagePressed(_ sender : UIButton) {
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
    
    @IBAction func recordVideo(_ sender:UIButton) {
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
        print("didfinish")
        if (picker.sourceType == UIImagePickerControllerSourceType.camera || picker.sourceType == UIImagePickerControllerSourceType.photoLibrary) {
            print("yes")
            let mediaType:AnyObject? = info[UIImagePickerControllerMediaType] as AnyObject?
            if let type:AnyObject = mediaType {
                if type is String {
                    print("isVideo")
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
                            let filename = CommonMethods().getDocumentsDirectory().appendingPathComponent("mainVideoGuide.mp4")
                            try? videoData!.write(to: URL(fileURLWithPath: filename), options: [.atomic])
                            UISaveVideoAtPathToSavedPhotosAlbum(url.path, nil, nil, nil);
                        }
                    }
                    else
                    {
                        let temp : UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
                        let image : UIImage = CommonMethods().rotateCameraImageToProperOrientation(temp, maxResolution: 1024)
                        if let data = UIImagePNGRepresentation(image) {
                            let filename = CommonMethods().getDocumentsDirectory().appendingPathComponent("activityStage.png")
                            try? data.write(to: URL(fileURLWithPath: filename), options: [.atomic])
                        }
                        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                        
                    }
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.selectedTextRange = textField.textRange(from: textField.beginningOfDocument, to: textField.endOfDocument)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text?.characters.count > 0 {
            let defaults = UserDefaults.standard
            defaults .set(textField.text, forKey: "station\(station)-name")
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let currentCharacterCount = textField.text?.characters.count ?? 0
        if (range.length + range.location > currentCharacterCount){
            return false
        }
        let newLength = currentCharacterCount + string.characters.count - range.length
        return newLength <= 30
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toBooks") {
            return;
        }
        let station:DesignViewController = segue.destination as! DesignViewController
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
