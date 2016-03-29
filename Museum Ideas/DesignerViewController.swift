//
//  DesignerViewController.swift
//  Museum Ideas
//
//  Created by Noel Feliciano on 2016-03-08.
//  Copyright © 2016 mme. All rights reserved.
//

import UIKit

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
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if (picker.sourceType == UIImagePickerControllerSourceType.Camera || picker.sourceType == UIImagePickerControllerSourceType.PhotoLibrary) {
            
            let temp : UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
            let image : UIImage = CommonMethods().rotateCameraImageToProperOrientation(temp, maxResolution: 1024)
            if let data = UIImagePNGRepresentation(image) {
                let filename = CommonMethods().getDocumentsDirectory().stringByAppendingPathComponent("activityStage.png")
                data.writeToFile(filename, atomically: true)
                
            }
            
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
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
