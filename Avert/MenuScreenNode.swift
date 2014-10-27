//
//  MenuScreenNode.swift
//  Avert
//
//  Created by Reid Weber on 10/27/14.
//  Copyright (c) 2014 Randall. All rights reserved.
//

import UIKit
import SpriteKit

class MenuScreenNode: SKNode {
    var playButton: SKLabelNode!
    var helpButton: SKLabelNode!
    var titleLabel: SKLabelNode!
    //var gameCenterButton: SKSpriteNode?
    
    init(scene: SKScene) {
        super.init()

        self.titleLabel = SKLabelNode(text: "Avert")
        self.titleLabel.fontName = "Chalkduster"
        self.titleLabel.fontSize = 50
        
        self.titleLabel.position = CGPoint(x: CGRectGetMidX(scene.frame), y: CGRectGetMidY(scene.frame))
        self.addChild(self.titleLabel)
        
        self.playButton = SKLabelNode(text: "Play")
        self.playButton.fontName = "Chalkduster"
        self.playButton.fontSize = 20
        self.playButton.name = "PlayButton"
        
        self.playButton.position = CGPoint(x: CGRectGetMidX(scene.frame) - self.playButton.frame.width, y: CGRectGetMidY(scene.frame) - self.titleLabel.frame.height)
        self.addChild(self.playButton)
        
        self.helpButton = SKLabelNode(text: "Help")
        self.helpButton.fontName = "Chalkduster"
        self.helpButton.fontSize = 20
        self.helpButton.name = "HelpButton"
        
        
        self.helpButton.position = CGPoint(x: CGRectGetMidX(scene.frame) + (self.titleLabel.frame.width / 3) , y: CGRectGetMidY(scene.frame) - self.titleLabel.frame.height)
        self.addChild(self.helpButton)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
}
