//
//  TextViewController.swift
//  Museum Ideas
//
//  Created by Noel Feliciano on 2016-03-01.
//  Copyright © 2016 mme. All rights reserved.
//

import UIKit

class TextViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var bookTitle: UILabel!
    
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
        
        if let title = defaults.objectForKey("station\(station)-name") {
            self.bookTitle.text = "Book for \(title as! String)"
        }
        
        if (station == 0) {
            for view in self.view.subviews as [UIView] {
                if let label = view as? UILabel {
                    if (label.text == "Photo 1 Instruction") { continue }
                    else if (label.text == "Photo 2 Instruction") { label.text = "Video Instruction" }
                    else { label.removeFromSuperview() }
                }
                else if let textField = view as? UITextField {
                    if (textField.tag == 1 || textField.tag == 2) { continue }
                    else { textField.removeFromSuperview() }
                }
            }
            self.bookTitle.removeFromSuperview()
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
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        let currentCharacterCount = textField.text?.characters.count ?? 0
        if (range.length + range.location > currentCharacterCount){
            return false
        }
        let newLength = currentCharacterCount + string.characters.count - range.length
        if (textField.tag < 10) {
            return newLength <= 30
        } else {
            return newLength <= 80
        }
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
