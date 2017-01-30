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
        let fileManager = FileManager.default
        let path = CommonMethods().getDocumentsDirectory().appendingPathComponent(imageFile)
        self.imageView.contentMode = .scaleAspectFill
        if (fileManager.fileExists(atPath: path)) {
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
            self.imageView.isUserInteractionEnabled = true
            self.imageView.addGestureRecognizer(tap)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func playMovie(_ sender:UIGestureRecognizer) {
        print("playmovie")
        let fileManager = FileManager.default
        
        let vidPath = CommonMethods().getDocumentsDirectory().appendingPathComponent("station\(station)-video.mp4")
        if (fileManager.fileExists(atPath: vidPath)) {
            let player = AVPlayer(url: URL(fileURLWithPath: vidPath))
            let playerCtrl = AVPlayerViewController()
            playerCtrl.player = player
            self.present(playerCtrl, animated: true) {
                playerCtrl.player?.play()
            }
        }
    }
}
