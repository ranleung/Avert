//
//  GameScene.swift
//  Avert
//
//  Created by Randall Leung on 10/27/14.
//  Copyright (c) 2014 Randall. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
   
    var menuNode: MenuScreenNode?
    var showMenu = true
    
    override func didMoveToView(view: SKView) {
        self.menuNode = MenuScreenNode(scene: self)
        self.addChild(self.menuNode!)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        if self.showMenu == true {
            for touch in touches {
                var nodeAtTouch = self.menuNode?.nodeAtPoint(touch.locationInNode(self.menuNode))
                if nodeAtTouch?.name == "PlayButton" {
                    println("PlayButton Touched")
                }
            }
        }
        
    }
   
    override func update(currentTime: CFTimeInterval) {
        
        
    }
}
