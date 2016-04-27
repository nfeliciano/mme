//
//  PageViewController.swift
//  Museum Ideas
//
//  Created by Noel Feliciano on 2016-01-05.
//  Copyright © 2016 mme. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class PageViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var pageText: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var pageIndex: Int!
    var titleText: String!
    var pageLabelText: String!
    var imageFile: String!
    var station: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let fileManager = NSFileManager.defaultManager()
        let path = CommonMethods().getDocumentsDirectory().stringByAppendingPathComponent(imageFile)
        self.imageView.contentMode = .ScaleAspectFill
        if (fileManager.fileExistsAtPath(path)) {
            let image: UIImage = UIImage(contentsOfFile: path)!
            self.imageView.image = image
        } else {
            if (imageFile == "videoPlayButton.png") {
                let image = UIImage(named: imageFile)
                self.imageView.image = image
            }
        }
        self.pageText.text = self.pageLabelText;
        
        if (pageIndex == 6) {
            let tap : UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(PageViewController.playMovie(_:)))
            tap.delegate = self
            tap.numberOfTapsRequired = 1
            self.imageView.userInteractionEnabled = true
            self.imageView.addGestureRecognizer(tap)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func playMovie(sender:UIGestureRecognizer) {
        print("playmovie")
        let fileManager = NSFileManager.defaultManager()
        
        let vidPath = CommonMethods().getDocumentsDirectory().stringByAppendingPathComponent("station\(station)-video.mp4")
        if (fileManager.fileExistsAtPath(vidPath)) {
            let player = AVPlayer(URL: NSURL(fileURLWithPath: vidPath))
            let playerCtrl = AVPlayerViewController()
            playerCtrl.player = player
            self.presentViewController(playerCtrl, animated: true) {
                playerCtrl.player?.play()
            }
        }
    }
}
