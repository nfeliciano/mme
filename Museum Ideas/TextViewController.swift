//
//  TextViewController.swift
//  Museum Ideas
//
//  Created by Noel Feliciano on 2016-03-01.
//  Copyright © 2016 mme. All rights reserved.
//

import UIKit

class TextViewController: UIViewController, UITextFieldDelegate {
    
    var station: Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = NSUserDefaults.standardUserDefaults()
        for view in self.view.subviews {
            if let textField = view as? UITextField {
                if let text = defaults.stringForKey("station\(station)-activityText\(textField.tag)") {
                    textField.text = text
                }
            }
        }
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.selectedTextRange = textField.textRangeFromPosition(textField.beginningOfDocument, toPosition: textField.endOfDocument)
        if (textField.center.y > self.view.center.y) {
            animateViewMoving(true, moveValue: 200)
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textField.text?.characters.count > 0 {
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults .setObject(textField.text, forKey: "station\(station)-activityText\(textField.tag)")
        }
        if (textField.center.y > self.view.center.y) {
            animateViewMoving(false, moveValue: 200)
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func backButtonPressed(sender : UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func animateViewMoving (up:Bool, moveValue :CGFloat){
        var movementDuration:NSTimeInterval = 0.3
        var movement:CGFloat = ( up ? -moveValue : moveValue)
        UIView.beginAnimations( "animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration )
        self.view.frame = CGRectOffset(self.view.frame, 0,  movement)
        UIView.commitAnimations()
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
