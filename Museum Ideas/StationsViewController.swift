//
//  StationsViewController.swift
//  Museum Ideas
//
//  Created by Noel Feliciano on 2015-11-17.
//  Copyright © 2015 mme. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import MobileCoreServices
import Darwin

class StationsViewController: UIViewController {
    
    @IBOutlet weak var titleLabel : UILabel!
    @IBOutlet weak var backgroundImage : UIImageView!
    
    override func viewDidLoad() {
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
        
        for (var i = 1; i <= 4; i += 1) {
            let button : UIButton = self.view.viewWithTag(i) as! UIButton
            var tag: Int = i
            if (i == 4) { tag = 0 }
//            defaults .setObject(textField.text, forKey: "station\(tag)-name")
            if let stationName = defaults.stringForKey("station\(tag)-name") {
                button.setTitle(stationName, forState: .Normal)
            }
        }
        
        self.playVideo()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "toBooks") {
            return;
        }
        let station:StationViewController = segue.destinationViewController as! StationViewController
        if (segue.identifier == "stationOne") {
            station.station = 1;
        } else if (segue.identifier == "stationTwo") {
            station.station = 2;
        } else if (segue.identifier == "stationThree") {
            station.station = 3;
        } else if (segue.identifier == "stationIntro") {
            station.station = 0;
        }
    }
    
    func playVideo() {
        let fileManager = NSFileManager.defaultManager()
        
        let vidPath = CommonMethods().getDocumentsDirectory().stringByAppendingPathComponent("mainVideoGuide.mp4")
        if (fileManager.fileExistsAtPath(vidPath)) {
            let player = AVPlayer(URL: NSURL(fileURLWithPath: vidPath))
            let playerCtrl = AVPlayerViewController()
            playerCtrl.player = player
            self.presentViewController(playerCtrl, animated: true) {
                playerCtrl.player?.play()
            }
        } else {
            //TODO
        }
    }
    
    @IBAction func backButton(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func infoPressed(sender:UIButton) {
        self.playVideo()
    }
}