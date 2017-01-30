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
        let defaults = UserDefaults.standard
        if let title = defaults.object(forKey: "activityName") {
            self.titleLabel.text = title as! String
        }
        let fileManager = FileManager.default
        let path = CommonMethods().getDocumentsDirectory().appendingPathComponent("activityStage.png")
        if (fileManager.fileExists(atPath: path)) {
            let image: UIImage = UIImage(contentsOfFile: path)!
            self.backgroundImage.image = image
        }
        
        for i in 1...5 {
            let button : UIButton = self.view.viewWithTag(i) as! UIButton
            var tag: Int = i
            if (i == 4) { tag = 0 }
//            defaults .setObject(textField.text, forKey: "station\(tag)-name")
            if let stationName = defaults.string(forKey: "station\(tag)-name") {
                button.setTitle(stationName, for: UIControlState())
            }
        }
        
        self.playVideo()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toBooks") {
            return;
        }
        let station:StationViewController = segue.destination as! StationViewController
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
        let fileManager = FileManager.default
        
        let vidPath = CommonMethods().getDocumentsDirectory().appendingPathComponent("mainVideoGuide.mp4")
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
    
    @IBAction func backButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func infoPressed(_ sender:UIButton) {
        self.playVideo()
    }
}
