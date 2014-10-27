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
    var helpNode: HelpScreen?
    var showMenu = true
    var showHelpMenu = false
    var showGameOver = false
    
    override func didMoveToView(view: SKView) {
        self.menuNode = MenuScreenNode(scene: self)
        self.addChild(self.menuNode!)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        if self.showMenu == true {
            self.menuHelper(touches)
        }
        if self.showHelpMenu == true {
            self.helpMenuHelper(touches)
        }
    }
    
    func menuHelper(touches: NSSet) {
        for touch in touches {
            var nodeAtTouch = self.menuNode?.nodeAtPoint(touch.locationInNode(self.menuNode))
            if nodeAtTouch?.name == "PlayButton" {
                println("PlayButton Touched")
                self.showMenu = false
                self.menuNode?.removeFromParent()
            }
            if nodeAtTouch?.name == "HelpButton" {
                println("HelpButton Touched")
                self.menuNode?.removeFromParent()
                self.addHelpScreen()
            }
        }
    }
    
    func helpMenuHelper(touches: NSSet) {
        for touch in touches {
            var nodeAtTouch = self.helpNode?.nodeAtPoint(touch.locationInNode(self.helpNode))
            if nodeAtTouch?.name == "BackButton" {
                print("BackButton Touched")
                self.helpNode?.removeFromParent()
                self.addMenuScreen()
            }
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        
        
    }
    
    func addHelpScreen() {
        self.helpNode = HelpScreen(scene: self)
        self.addChild(self.helpNode!)
        self.showHelpMenu = true
        self.showMenu = false
    }
    
    func addMenuScreen() {
        self.addChild(self.menuNode!)
        self.showHelpMenu = false
        self.showMenu = true
    }
}
