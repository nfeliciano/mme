//
//  PageViewController.swift
//  Museum Ideas
//
//  Created by Noel Feliciano on 2016-01-05.
//  Copyright © 2016 mme. All rights reserved.
//

import UIKit

class PageViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var pageIndex: Int!
    var titleText: String!
    var imageFile: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let fileManager = NSFileManager.defaultManager()
        let path = getDocumentsDirectory().stringByAppendingPathComponent(imageFile)
        if (fileManager.fileExistsAtPath(path)) {
            let image: UIImage = UIImage(contentsOfFile: path)!
            let rotated: UIImage = UIImage(CGImage: image.CGImage!, scale: 1, orientation: .Right)
            self.imageView.image = rotated
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getDocumentsDirectory() -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
}