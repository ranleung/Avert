//
//  GameOverNode.swift
//  Avert
//
//  Created by Reid Weber on 10/27/14.
//  Copyright (c) 2014 Randall. All rights reserved.
//

import UIKit
import SpriteKit

class GameOverNode: SKNode {
    var titleLabel: SKLabelNode!
    var newGameLabel: SKLabelNode!
    var helpScreenLabel: SKLabelNode!
    var scoreLabel: SKLabelNode!
    var font = "Optima-Bold"
    
    init(scene: SKScene) {
        super.init()
        
        self.titleLabel = SKLabelNode(text: "Game Over")
        self.titleLabel.fontName = self.font
        self.titleLabel.fontSize = 30
        
        self.titleLabel.position = CGPoint(x: CGRectGetMidX(scene.frame), y: CGRectGetMidY(scene.frame))
        self.addChild(self.titleLabel)
        
        self.scoreLabel = SKLabelNode(text: "Score: 0000")
        self.scoreLabel.fontName = self.font
        self.scoreLabel.fontSize = 50
        
        self.scoreLabel.position = CGPoint(x: CGRectGetMidX(scene.frame), y: CGRectGetMidY(scene.frame) + self.titleLabel.frame.height)
        self.addChild(self.scoreLabel)
        
        self.newGameLabel = SKLabelNode(text: "New Game")
        self.newGameLabel.fontName = self.font
        self.newGameLabel.fontSize = 20
        self.newGameLabel.name = "NewGameButton"
        
        self.newGameLabel.position = CGPoint(x: CGRectGetMidX(scene.frame) - (self.scoreLabel.frame.width / 2), y: CGRectGetMidY(scene.frame) - self.titleLabel.frame.height)
        self.addChild(self.newGameLabel)
        
        self.helpScreenLabel = SKLabelNode(text: "Help")
        self.helpScreenLabel.fontName = self.font
        self.helpScreenLabel.fontSize = 20
        self.helpScreenLabel.name = "HelpButton"
        
        self.helpScreenLabel.position = CGPoint(x: CGRectGetMidX(scene.frame) + (self.scoreLabel.frame.width / 2), y: CGRectGetMidY(scene.frame) - self.titleLabel.frame.height)
        self.addChild(self.helpScreenLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
}
