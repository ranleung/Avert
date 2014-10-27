//
//  HelpScreen.swift
//  Avert
//
//  Created by Matthew Brightbill on 10/27/14.
//  Copyright (c) 2014 Randall. All rights reserved.
//

import UIKit
import SpriteKit

class HelpScreen: SKNode {
   
    var titleLabel: SKLabelNode!
    var backLabel: SKLabelNode!
    
    init(scene: SKScene) {
        super.init()
        
        self.titleLabel = SKLabelNode(text: "Help")
        self.titleLabel.fontName = "Chalkduster"
        self.titleLabel.fontSize = 30
        self.titleLabel.position = CGPoint(x: scene.frame.origin.x + self.titleLabel.frame.width/2, y: scene.frame.height - self.titleLabel.frame.height)
        self.addChild(self.titleLabel)
        
        self.backLabel = SKLabelNode(text: "Back")
        self.backLabel.fontName = "Chalkduster"
        self.backLabel.fontSize = 20
        self.backLabel.position = CGPoint(x: scene.frame.width - self.backLabel.frame.width/2, y: scene.frame.origin.y)
        self.backLabel.name = "BackButton"
        self.addChild(self.backLabel)
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
