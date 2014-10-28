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
    var gameOverNode: GameOverNode?
    var showMenu = true
    var showHelpMenu = false
    var showGameOver = false
    
    let spawner = Spawner()
    var currentTime = 0.0
    var previousTime = 0.0
    var deltaTime = 0.0
    var timeSinceLastSpawn = 0.0
    
    
    // MARK - Overwritten SKScene functions
    override func didMoveToView(view: SKView) {
        startSpawn()
        self.gameOverNode = GameOverNode(scene: self)
        self.helpNode = HelpScreen(scene: self)
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
        if self.showGameOver == true {
            self.gameOverMenuHelper(touches)
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        
        
        self.currentTime = currentTime
        self.deltaTime = self.currentTime - self.previousTime
        self.previousTime = currentTime
        self.timeSinceLastSpawn = self.timeSinceLastSpawn + self.deltaTime

        self.timeSinceLastSpawn = 0

    }
    
    func startSpawn () {
        for side in Spawner.OriginSide.allValues {
            spawner.spawnShape(side, team: Spawner.ShapeTeam.Enemy, scene: self)
            spawner.spawnShape(side, team: Spawner.ShapeTeam.Friend, scene: self)
        }
    }
    
    // MARK: Various Menu Helper Functions
        
    func menuHelper(touches: NSSet) {
        for touch in touches {
            var nodeAtTouch = self.menuNode?.nodeAtPoint(touch.locationInNode(self.menuNode))
            if nodeAtTouch?.name == "PlayButton" {
                println("PlayButton Touched")
                self.showMenu = false
                self.menuNode?.removeFromParent()
                self.addGameOverScreen()
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
    
    func gameOverMenuHelper(touches: NSSet) {
        for touch in touches {
            var nodeAtTouch = self.gameOverNode?.nodeAtPoint(touch.locationInNode(self.gameOverNode))
            if nodeAtTouch?.name == "NewGameButton" {
                println("New Game Touched")
                self.gameOverNode?.removeFromParent()
                self.addMenuScreen()
            }
            if nodeAtTouch?.name == "HelpButton" {
                println("Help Button Pressed")
                self.gameOverNode?.removeFromParent()
                self.addHelpScreen()
            }
        }
    }
    
    func addHelpScreen() {
        self.addChild(self.helpNode!)
        self.showHelpMenu = true
        self.showMenu = false
    }
    
    func addMenuScreen() {
        self.addChild(self.menuNode!)
        self.showHelpMenu = false
        self.showMenu = true
    }
    func addGameOverScreen() {
        self.addChild(self.gameOverNode!)
        self.showGameOver = true
        self.showMenu = false
    }
}
