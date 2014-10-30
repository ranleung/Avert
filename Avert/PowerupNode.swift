//
//  PowerupNode.swift
//  Avert
//
//  Created by Jeff Chavez on 10/30/14.
//  Copyright (c) 2014 Randall. All rights reserved.
//

import SpriteKit

class PowerupNode : SKNode {
    var decreaseSizePowerUp : SKLabelNode!
    var allFriendliesPowerUp : SKLabelNode!
    var addPointsPowerup : SKLabelNode!
    var increaseSizePowerDown : SKLabelNode!
    var minus500PowerDown : SKLabelNode!
    var allEnemiesPowerDown : SKLabelNode!
    var font = "Audiowide-Regular"
    
    init (scene: SKScene) {
        super.init()
        
        self.decreaseSizePowerUp = SKLabelNode(text: "Mini Square")
        self.decreaseSizePowerUp.fontName = self.font
        self.decreaseSizePowerUp.fontSize = 20
        self.decreaseSizePowerUp.name = "decreaseSizePowerUpLabel"
        
        
        
    }
}
