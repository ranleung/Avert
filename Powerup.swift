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
        switch team {
        case .Friend:
            powerup.sprite?.color = UIColor.greenColor()
        case .Enemy:
            powerup.sprite?.color = UIColor.redColor()
        }
        return powerup
    }
    
    class func randomSide() -> OriginSide {
        let randomIndex = arc4random() % 4
        return Powerup.OriginSide.allValues[Int(randomIndex)]
    }
    
    func givePowerup(hero: SKSpriteNode) {
//        let randomPowerup = arc4random() % 3 + 1
        let randomPowerup = 1
        switch self.team {
        case .Friend:
            switch randomPowerup {
            case 1:
                let newscale = hero.xScale - 0.3
                if newscale >= 0.9 {
                    hero.xScale = newscale
                    hero.yScale = newscale
                }
                else {
                    hero.xScale = 0.9
                    hero.yScale = 0.9
                }
                println(hero.xScale)
            case 2:
                break
            case 3:
                break
            default:
                break
            }
        case .Enemy:
            switch randomPowerup {
            case 1:
                let newscale = hero.xScale + 0.3
                if newscale <= 2.5 {
                    hero.xScale = newscale
                    hero.yScale = newscale
                }
                else {
                    hero.xScale = 2.5
                    hero.yScale = 2.5
                }
            case 2:
                break
            case 3:
                break
            default:
                break
            }
        }
        
    }
}
