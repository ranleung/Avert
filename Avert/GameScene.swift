//
//  GameScene.swift
//  Avert
//
//  Created by Randall Leung on 10/27/14.
//  Copyright (c) 2014 Randall. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var hero: SKShapeNode!
    var heroRotationSpeed = 5
   
    override func didMoveToView(view: SKView) {

        //Create starting hero and position center
        //self.hero = SKShapeNode(rect: CGRect(x: 0.0, y: 0.0, width: 50, height: 50))
        let path = CGPathCreateWithRect(CGRect(x: 0.0, y: 0.0, width: 50, height: 50), nil)
        self.hero = SKShapeNode(path: path, centered: true)
        
        self.hero.fillColor = UIColor.whiteColor()
        self.hero.xScale = 0.5
        self.hero.yScale = 0.5
        self.hero.position = CGPointMake(view.frame.width/4, view.frame.height/2)
        
        let action = SKAction.rotateByAngle(CGFloat(M_PI), duration: 1)
        self.hero.runAction(SKAction.repeatActionForever(action))
        
        self.addChild(self.hero)

    }
    
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch: AnyObject in touches {
            
            
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        //rotate the hero
//        var degreeRotation = CDouble(self.heroRotationSpeed) * M_PI / 180
//        self.hero.zRotation -= CGFloat(degreeRotation)
        
        

        
    }
}
