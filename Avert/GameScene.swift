//
//  GameScene.swift
//  Avert
//
//  Created by Randall Leung on 10/27/14.
//  Copyright (c) 2014 Randall. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
   
    // Menu properties
    var menuNode: MenuScreenNode?
    var helpNode: HelpScreen?
    var gameOverNode: GameOverNode?
    var showMenu = true
    var showHelpMenu = false
    var showGameOver = false
    
    // Hero properties
    var hero : SKSpriteNode!
    var heroRotationSpeed = 5
    var panGestureRecognizer : UIPanGestureRecognizer!
    var lastTouchedLocation : CGPoint!
    var startPosition : CGPoint!
    var heroView: SKView?
    
    // Timer properties
    var currentTime = 0.0
    var previousTime = 0.0
    var deltaTime = 0.0
    var timeSinceLastSpawn = 0.0
    
    var shapesArray = [Shape]()
    
    
    // MARK: - Overwritten SKScene Methods
    
    override func didMoveToView(view: SKView) {
        
        //keep view for addHero()
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

        // Timer updates, currently unused
        self.currentTime = currentTime
        self.deltaTime = self.currentTime - self.previousTime
        self.previousTime = currentTime
        self.timeSinceLastSpawn = self.timeSinceLastSpawn + self.deltaTime
        self.timeSinceLastSpawn = 0
        
        for shape in shapesArray {
            if !shape.alive {
                shape.spawnSprite()
                shape.alive = true
            }
        }
        
    }
    
    // MARK: - Control Methods

    func handlePan (panGestureRecognizer: UIPanGestureRecognizer) {
        if panGestureRecognizer.state == UIGestureRecognizerState.Began {
            self.startPosition = self.hero.position
        }
        if panGestureRecognizer.state == UIGestureRecognizerState.Changed {
            //check the location of the hero, and if hes about to go off screen, just dont do anything
            if (self.hero.position.x >= 19 &&
                self.hero.position.x <= self.view?.frame.width) && (
                self.hero.position.y >= 19 &&
                self.hero.position.y <= self.view?.frame.height) {
                    var touchLocation = self.panGestureRecognizer.translationInView(self.view!)
                    touchLocation = CGPointMake(touchLocation.x, -touchLocation.y)
                    var newLocation = CGPointMake(startPosition.x + touchLocation.x, startPosition.y + touchLocation.y)
                    self.hero.position = newLocation
            }
            //move hero back on screen
            //bottom left corner
            if self.hero.position.x <= 19 {
                self.hero.position = CGPoint(x: 20, y: self.hero.position.y)
            }
            //bottom right corner
            if self.hero.position.x >= self.view!.frame.width - 19 {
                self.hero.position = CGPoint(x: self.view!.frame.width - 20, y: self.hero.position.y)
            }
            //top left corner
            if self.hero.position.y <= 19 {
                self.hero.position = CGPoint(x: self.hero.position.x, y: 20)
            }
            //top right corner
            if self.hero.position.y >= self.view!.frame.height - 19 {
                self.hero.position = CGPoint(x: self.hero.position.x, y: self.view!.frame.height - 20)
            }
        }
        if panGestureRecognizer.state == UIGestureRecognizerState.Ended {
            println("Ended \(self.hero.position)")
        }
    }
    
    // MARK: - Character Creation Methods
    
    func addHero() {
        //Create starting hero and position center
        self.hero = SKSpriteNode(texture: nil, color: UIColor.whiteColor(), size: CGSize(width: self.heroView!.frame.width * 0.035, height: self.heroView!.frame.width * 0.035))
        self.hero.position = CGPointMake(self.heroView!.frame.width/2, self.heroView!.frame.height/2)
        self.hero.physicsBody?.dynamic = true
        
        let action = SKAction.rotateByAngle(CGFloat(M_PI), duration: 1)
        self.hero.runAction(SKAction.repeatActionForever(action))
        
        self.panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "handlePan:")
        self.view?.addGestureRecognizer(panGestureRecognizer)
        self.addChild(self.hero)


    }
    
    func startSpawn () {
        for side in Shape.OriginSide.allValues {
            self.shapesArray.append(Shape.spawnShape(side, team: Shape.ShapeTeam.Enemy, scene: self))
            self.shapesArray.append(Shape.spawnShape(side, team: Shape.ShapeTeam.Friend, scene: self))
        }
    }
    
    // MARK: - Various Menu Helper Methods
        
    func menuHelper(touches: NSSet) {
        for touch in touches {
            var nodeAtTouch = self.menuNode?.nodeAtPoint(touch.locationInNode(self.menuNode))
            if nodeAtTouch?.name == "PlayButton" {
                println("PlayButton Touched")
                
                // Instantiate game
                self.heroView = view
                addHero()
                startSpawn()
                
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
