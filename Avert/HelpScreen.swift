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
    var playerLabel: SKLabelNode!
    var enemyLabel: SKLabelNode!
    var friendLabel: SKLabelNode!
    var rulesTitleLabel: SKLabelNode!
    var firstRuleLabel: SKLabelNode!
    var secondRuleLabel: SKLabelNode!
    var thirdRuleLabel: SKLabelNode!
    
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
        
        self.friendLabel = SKLabelNode(text: " - Friendlies")
        self.friendLabel.fontName = "Chalkduster"
        self.friendLabel.fontSize = 20
        self.friendLabel.position = CGPoint(x: scene.frame.width * 0.2, y: scene.frame.height * 0.75)
        self.addChild(self.friendLabel)
        
        self.playerLabel = SKLabelNode(text: " - Player")
        self.playerLabel.fontName = "Chalkduster"
        self.playerLabel.fontSize = 20
        self.playerLabel.position = CGPoint(x: scene.frame.width * 0.2 - ((self.friendLabel.frame.width / 2) - (self.playerLabel.frame.width / 2)), y: scene.frame.height * 0.25)
        self.addChild(self.playerLabel)
        
        
        self.enemyLabel = SKLabelNode(text: " - Enemies")
        self.enemyLabel.fontName = "Chalkduster"
        self.enemyLabel.fontSize = 20
        self.enemyLabel.position = CGPoint(x: scene.frame.width * 0.2 - ((self.friendLabel.frame.width / 2) - (self.enemyLabel.frame.width / 2)), y: scene.frame.height * 0.5)
        self.addChild(self.enemyLabel)
        
        self.rulesTitleLabel = SKLabelNode(text: "Rules:")
        self.rulesTitleLabel.fontName = "Chalkduster"
        self.rulesTitleLabel.fontSize = 20
        self.rulesTitleLabel.position = CGPoint(x: scene.frame.width * 0.2 + self.friendLabel.frame.width * 1.5, y: scene.frame.height - self.titleLabel.frame.height)
        self.addChild(rulesTitleLabel)
        
        self.firstRuleLabel = SKLabelNode(text: "Blah")
        self.firstRuleLabel.fontName = "Chalkduster"
        self.firstRuleLabel.fontSize = 20
        self.firstRuleLabel.position = CGPoint(x: scene.frame.width * 0.2 + self.friendLabel.frame.width * 1.5, y: scene.frame.height * 0.75)
        self.addChild(firstRuleLabel)
        
        self.secondRuleLabel = SKLabelNode(text: "Blah")
        self.secondRuleLabel.fontName = "Chalkduster"
        self.secondRuleLabel.fontSize = 20
        self.secondRuleLabel.position = CGPoint(x: scene.frame.width * 0.2 + self.friendLabel.frame.width * 1.5, y: scene.frame.height * 0.5)
        self.addChild(secondRuleLabel)
        
        self.thirdRuleLabel = SKLabelNode(text: "a;lsdfj")
        self.thirdRuleLabel.fontName = "Chalkduster"
        self.thirdRuleLabel.fontSize = 20
        self.thirdRuleLabel.position = CGPoint(x: scene.frame.width * 0.2 + self.friendLabel.frame.width * 1.5, y: scene.frame.height * 0.25)
        self.addChild(thirdRuleLabel)
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
