//
//  Spawner.swift
//  Avert
//
//  Created by Joshua Winskill on 10/27/14.
//  Copyright (c) 2014 Randall. All rights reserved.
//

import Spritekit

class Spawner {
    
    enum OriginSide {
        case Up, Down, Left, Right
    }
    
    enum ShapeTeam {
        case Friend, Enemy
    }
    
    
    // MARK - randomization functions
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(#min: CGFloat, max: CGFloat) -> CGFloat {
        return self.random() * (max - min) + min
    }
    
    func spawnShape (originSide: OriginSide, scene: SKScene) {
        
        let rect = CGRect(x: 0, y: 0, width: 50, height: 50)
        let shape = SKShapeNode(rect: rect)
        var destination: CGPoint!
        
        switch originSide {
        case .Up:
            let randomX = random(min: shape.frame.width / 2, max: scene.size.width - shape.frame.width / 2)
            shape.position = CGPoint(x: randomX, y: scene.size.height + shape.frame.height / 2)
            destination = CGPoint(x: randomX, y: -shape.frame.height / 2)
            
        case .Down:
            let randomX = random(min: shape.frame.width / 2, max: scene.size.width - shape.frame.width / 2)
            shape.position = CGPoint(x: randomX, y: -shape.frame.height / 2)
            destination = CGPoint(x: randomX, y: scene.size.height + shape.frame.height / 2)
            
        case .Left:
            let randomY = random(min: shape.frame.height / 2, max: scene.size.height - shape.frame.height / 2)
            shape.position = CGPoint(x: 0 - shape.frame.width / 2, y: randomY)
            destination = CGPoint(x: scene.size.width + shape.frame.width / 2, y: randomY)
            
        case .Right:
            let randomY = random(min: shape.frame.height / 2, max: scene.size.height - shape.frame.height / 2)
            shape.position = CGPoint(x: scene.size.width + shape.frame.width / 2, y: randomY)
            destination = CGPoint(x: -shape.frame.width, y: randomY)
        }
        
        scene.addChild(shape)
        
        let duration = CGFloat(2.0)
        
        let moveAction = SKAction.moveTo(destination, duration: NSTimeInterval(duration))
        let moveActionDone = SKAction.removeFromParent()
        shape.runAction(SKAction.sequence([moveAction, moveActionDone]))
        
        
        
    }
    
}
