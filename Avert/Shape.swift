//
//  Shape.swift
//  Avert
//
//  Created by William Richman on 10/28/14.
//  Copyright (c) 2014 Randall. All rights reserved.
//

import Spritekit

class Shape {
    
    var sprite : SKSpriteNode?
    var side : OriginSide
    var team : ShapeTeam
    var alive = true
    var scene : SKScene
    var contactCategory : UInt32?
    
    enum OriginSide {
        case Up, Down, Left, Right
        static let allValues = [Up, Down, Left, Right]
    }
    
    enum ShapeTeam {
        case Friend, Enemy
    }
    
    init(side: OriginSide, team: ShapeTeam, scene: SKScene) {
        self.side = side
        self.team = team
        self.scene = scene
    }
    
    
    // MARK: - Randomization Methods
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(#min: CGFloat, max: CGFloat) -> CGFloat {
        return self.random() * (max - min) + min
    }
    
    // MARK: - Spawning Methods
    
    class func spawnShape (originSide: OriginSide, team: ShapeTeam, scene: SKScene) -> Shape {
        let shape = Shape(side: originSide, team: team, scene: scene)
        shape.spawnSprite()
        return shape
    }
    
    func spawnSprite() {
        
        let shapeSideSize = self.scene.size.width * self.random(min: 0.03, max: 0.055)
        
        let sprite = SKSpriteNode(texture: nil, size: CGSize(width: shapeSideSize, height: shapeSideSize))
        
        switch self.team {
        case .Friend:
            sprite.color = UIColor.blueColor()
        case .Enemy:
            sprite.color = UIColor.orangeColor()
        }
        
        var destination: CGPoint!
        
        switch self.side {
        case .Up:
            let randomX = random(min: sprite.frame.width / 2, max: scene.size.width - sprite.frame.width / 2)
            sprite.position = CGPoint(x: randomX, y: scene.size.height + sprite.frame.height / 2)
            destination = CGPoint(x: randomX, y: -sprite.frame.height / 2)
            
        case .Down:
            let randomX = random(min: sprite.frame.width / 2, max: scene.size.width - sprite.frame.width / 2)
            sprite.position = CGPoint(x: randomX, y: -sprite.frame.height / 2)
            destination = CGPoint(x: randomX, y: scene.size.height + sprite.frame.height / 2)
            
        case .Left:
            let randomY = random(min: sprite.frame.height / 2, max: scene.size.height - sprite.frame.height / 2)
            sprite.position = CGPoint(x: 0 - sprite.frame.width / 2, y: randomY)
            destination = CGPoint(x: scene.size.width + sprite.frame.width / 2, y: randomY)
            
        case .Right:
            let randomY = random(min: sprite.frame.height / 2, max: scene.size.height - sprite.frame.height / 2)
            sprite.position = CGPoint(x: scene.size.width + sprite.frame.width / 2, y: randomY)
            destination = CGPoint(x: -sprite.frame.width, y: randomY)
        }
        
        scene.addChild(sprite)
        
        let duration = self.random(min: 2.0, max: 4.0)
        
        let moveAction = SKAction.moveTo(destination, duration: NSTimeInterval(duration))
        let moveActionDone = SKAction.removeFromParent()
        let respawnAction = SKAction.runBlock { () -> Void in
            self.alive = false
        }
        
        sprite.runAction(SKAction.sequence([moveAction, respawnAction, moveActionDone]))

        self.sprite = sprite
    }
    
}
