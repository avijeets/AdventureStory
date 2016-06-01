//
//  ViewController.swift
//  InteractiveStory
//
//  Created by Avijeet Sachdev on 5/31/16.
//  Copyright © 2016 Avijeet Sachdev. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let story = Page(story: .TouchDown)
        story.firstChoice = (title: "Some Title", page: Page(story: .Droid))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "startAdventure" {
            if let pageController = segue.destinationViewController as? PageController {
                pageController.page = Adventure.story
            }
        }
    }

}

