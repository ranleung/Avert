//
//  Powerup.swift
//  Avert
//
//  Created by William Richman on 10/28/14.
//  Copyright (c) 2014 Randall. All rights reserved.
//

import SpriteKit

class Powerup: Shape {
   
    class func spawnPowerup (team: ShapeTeam, scene: SKScene, shapesAcquired: UInt16) -> Powerup {
        let powerup = Powerup(side: randomSide(), team: team, scene: scene)
        powerup.spawnSprite(shapesAcquired)
        powerup.sprite?.color = UIColor.greenColor()
        return powerup
    }
    
    class func randomSide() -> OriginSide {
        let randomIndex = arc4random() % 4
        return Powerup.OriginSide.allValues[Int(randomIndex)]
    }
    
    func givePowerup(hero: SKSpriteNode) {
        
    }
}
