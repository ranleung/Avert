//
//  GameScene.swift
//  Avert
//
//  Created by Randall Leung on 10/27/14.
//  Copyright (c) 2014 Randall. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
   
    override func didMoveToView(view: SKView) {

        /* Setup your scene here */

        let hero = SKShapeNode(rect: CGRect(x: 0.0, y: 0.0, width: 50, height: 50))
        
        hero.fillColor = UIColor.blackColor()
        hero.xScale = 0.5
        hero.yScale = 0.5
        hero.position = CGPoint(x: 400, y: 400)
        
        let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
        
        hero.runAction(SKAction.repeatActionForever(action))
        
        self.addChild(hero)

    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        

        for touch: AnyObject in touches {
            
            
            
            
            
            
            
            
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        
        
    }
}
