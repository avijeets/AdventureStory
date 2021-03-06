//
//  PageController.swift
//  InteractiveStory
//
//  Created by Avijeet Sachdev on 5/31/16.
//  Copyright © 2016 Avijeet Sachdev. All rights reserved.
//

import UIKit
import AudioToolbox

class PageController: UIViewController {
    
    var page: Page?
    var sound: SystemSoundID = 0
    
    let artwork = UIImageView()
    let storyLabel = UILabel()
    let firstChoiceButton = UIButton(type: .System)
    let secondChoiceButton = UIButton(type: .System)
    
    required init? (coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(page: Page) {
        self.page = page
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .whiteColor()

        if let page = page {
            artwork.image = page.story.artwork
            let attributedString = NSMutableAttributedString(string: page.story.text)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 10
            
            attributedString.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))
            storyLabel.attributedText = attributedString
            
            
            //bring up first, pitfall, or second choice
            if let firstChoice = page.firstChoice { // first
                firstChoiceButton.setTitle(firstChoice.title, forState: .Normal)
                firstChoiceButton.addTarget(self, action: #selector(PageController.loadFirstChoice), forControlEvents: .TouchUpInside)
            }
            else { // pitfall
                firstChoiceButton.setTitle("Play again!", forState: .Normal)
                firstChoiceButton.addTarget(self, action: #selector(PageController.playAgain), forControlEvents: .TouchUpInside)
            }
            
            if let secondChoice = page.secondChoice { // second
                secondChoiceButton.setTitle(secondChoice.title, forState: .Normal)
                secondChoiceButton.addTarget(self, action: #selector(PageController.loadSecondChoice), forControlEvents: .TouchUpInside)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // all subviews
    override func viewWillLayoutSubviews() {
        //bring up artwork subview
        view.addSubview(artwork)
        artwork.translatesAutoresizingMaskIntoConstraints = false
        
        //layouts for artwork
        NSLayoutConstraint.activateConstraints([
            artwork.topAnchor.constraintEqualToAnchor(view.topAnchor),
            artwork.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor),
            artwork.rightAnchor.constraintEqualToAnchor(view.rightAnchor),
            artwork.leftAnchor.constraintEqualToAnchor(view.leftAnchor)
        ])
        
        //bring up storyLabel subview
        view.addSubview(storyLabel)
        storyLabel.translatesAutoresizingMaskIntoConstraints = false
        storyLabel.numberOfLines = 0
        
        //layouts for storyLabel
        NSLayoutConstraint.activateConstraints([
            storyLabel.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor, constant: 16.0),
            storyLabel.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor, constant: -16.0),
            storyLabel.topAnchor.constraintEqualToAnchor(view.centerYAnchor, constant: -48.0)
            //storyLabel.bottomAnchor.constraintEqualToAnchor(view.centerXAnchor, constant: 48.0)
        ])
        
        //bring up firstChoice
        view.addSubview(firstChoiceButton)
        firstChoiceButton.translatesAutoresizingMaskIntoConstraints = false
        
        //layouts for firstChoice
        NSLayoutConstraint.activateConstraints([
            firstChoiceButton.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor),
            firstChoiceButton.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor, constant: -80.0)
        ])
        
        //bring up secondChoice
        view.addSubview(secondChoiceButton)
        secondChoiceButton.translatesAutoresizingMaskIntoConstraints = false
        
        //layours for secondChoice
        NSLayoutConstraint.activateConstraints([
            secondChoiceButton.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor),
            secondChoiceButton.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor, constant: -32.0)
        ])
    }
    
    // loading choices
    func loadFirstChoice () {
        if let page = page, firstChoice = page.firstChoice {
            let nextPage = firstChoice.page
            let pageController = PageController(page: nextPage)
            playSound(nextPage.story.soundEffectURL)
            navigationController?.pushViewController(pageController, animated: true)
        }
    }
    func loadSecondChoice () {
        if let page = page, secondChoice = page.secondChoice {
            let nextPage = secondChoice.page
            let pageController = PageController(page: nextPage)
            playSound(nextPage.story.soundEffectURL)
            navigationController?.pushViewController(pageController, animated: true)
        }
    }
    
    // loading up sounds
    func playAgain() {
        navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func playSound(url: NSURL) {
        AudioServicesCreateSystemSoundID(url, &sound) //in-out parameter pointer
        AudioServicesPlaySystemSound(sound)
    }
}
