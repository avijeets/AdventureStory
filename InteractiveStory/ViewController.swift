//
//  ViewController.swift
//  InteractiveStory
//
//  Created by Avijeet Sachdev on 5/31/16.
//  Copyright © 2016 Avijeet Sachdev. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    //error handling
    enum Error : ErrorType {
        case NoName
    }
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var textFieldBottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //for bringing view up when keyboard is present
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil) //show
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil) //hide
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "startAdventure" {
            do {
                if let name = nameTextField.text {
                    if name == "" {
                        throw Error.NoName
                    }
                    //if everything is good, things continue
                    if let pageController = segue.destinationViewController as? PageController {
                        pageController.page = Adventure.story(name)
                    }
                }
            }
            catch Error.NoName { // error handled empty box
                let alertController = UIAlertController(title: "Name Not Provided", message: "Provide a name to start your story.", preferredStyle: .Alert)
                let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
                alertController.addAction(action)
                presentViewController(alertController, animated: true, completion: nil)
            }
            catch let error { //any other issue
                fatalError("\(error)")
            }
        }
    }
    
    // MARK: - Making the Keyboard
    func keyboardWillShow(notification: NSNotification) {
        if let userInfoDict = notification.userInfo, keyboardFrameValue = userInfoDict [UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardFrame = keyboardFrameValue.CGRectValue()
            UIView.animateWithDuration(0.8) {
                self.textFieldBottomConstraint.constant = keyboardFrame.size.height + 10
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        UIView.animateWithDuration(0.8) {
            self.textFieldBottomConstraint.constant = 40
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

