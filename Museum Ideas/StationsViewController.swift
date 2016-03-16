//
//  StationsViewController.swift
//  Museum Ideas
//
//  Created by Noel Feliciano on 2015-11-17.
//  Copyright © 2015 mme. All rights reserved.
//

import UIKit
import Darwin

class StationsViewController: UIViewController {
    
    @IBOutlet weak var titleLabel : UILabel!
    @IBOutlet weak var backgroundImage : UIImageView!
    
    override func viewDidLoad() {1
        super.viewDidLoad()
        let defaults = NSUserDefaults.standardUserDefaults()
        if let title = defaults.objectForKey("activityName") {
            self.titleLabel.text = title as! String
        }
        let fileManager = NSFileManager.defaultManager()
        let path = CommonMethods().getDocumentsDirectory().stringByAppendingPathComponent("activityStage.png")
        if (fileManager.fileExistsAtPath(path)) {
            let image: UIImage = UIImage(contentsOfFile: path)!
            self.backgroundImage.image = image
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let station:StationViewController = segue.destinationViewController as! StationViewController
        if (segue.identifier == "stationOne") {
            station.station = 1;
        } else if (segue.identifier == "stationTwo") {
            station.station = 2;
        } else {
            station.station = 3;
        }
    }
    
    @IBAction func backButton(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }
}