//
//  GameScene.swift
//  Avert
//
//  Created by Randall Leung on 10/27/14.
//  Copyright (c) 2014 Randall. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
   
    // Menu properties
    var menuController: MenuController!
    var menuNode: MenuScreenNode?
    var helpNode: HelpScreen?
    var gameOverNode: GameOverNode?
    var showMenu = true
    var showHelpMenu = false
    var showGameOver = false
    
    // Pause Button Properties
    var pauseButton: SKSpriteNode?
    var resumeButton: SKSpriteNode?
    var pausedLabel: SKLabelNode?
    
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
    var timeSincePointGiven = 0.0
    var deathTimer = 0.0
    var playerIsDead = false
    
    // Points properties
    var points: UInt32 = 0
    var squaresAcquired: UInt16 = 0
    var shapesArray = [Shape]()
    var pointsCounterLabel: SKLabelNode?
    
    // Contact properties
    let friendCategory : UInt32 = 0x1 << 0
    let enemyCategory : UInt32 = 0x1 << 1
    var heroCategory : UInt32?
    
    // Dimming layer
    var dimmingLayer: SKSpriteNode?
    var playerHasPaused = false
    
    // Particle Emitter
    var particleEmitter: SKEmitterNode?
    
    
    // MARK: - Overwritten SKScene Methods
    
    override func didMoveToView(view: SKView) {
        
        // sending reference of self to AppDelegate
        var appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        appDelegate.gameScene = self
        
        //keep view for addHero()
        self.menuController = MenuController(scene: self)
        
        self.helpNode = self.menuController.helpNode
        self.menuNode = self.menuController.menuNode
        self.pauseButton = self.menuController.pauseButton
        self.resumeButton = self.menuController.resumeButton
        self.pausedLabel = self.menuController.pausedLabel
        self.dimmingLayer = self.menuController.dimmingLayer
        self.pointsCounterLabel = self.menuController.scoreLabel
        
        let uncastedEmitter: AnyObject = NSKeyedUnarchiver.unarchiveObjectWithFile(NSBundle.mainBundle().pathForResource("DeathParticleEmitter", ofType: "sks")!)!
        self.particleEmitter = uncastedEmitter as? SKEmitterNode
        
        self.addChild(self.menuNode!)
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.paused = true
        
        self.registerAppTransitionEvents()
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
        self.pauseHelper(touches)
    }

    override func update(currentTime: CFTimeInterval) {

        // Timer updates, currently unused
        if self.paused == false {
            self.currentTime = currentTime
            self.deltaTime = self.currentTime - self.previousTime
            self.previousTime = currentTime
            self.timeSincePointGiven = self.timeSincePointGiven + self.deltaTime
            var timeIntervalForPoints = 1.0
            
            switch self.squaresAcquired {
            case 0...5:
                timeIntervalForPoints = 1.0
            case 6...10:
                timeIntervalForPoints = 0.9
            case 11...15:
                timeIntervalForPoints = 0.8
            case 16...20:
                timeIntervalForPoints = 0.7
            case 21...25:
                timeIntervalForPoints = 0.6
            case 26...30:
                timeIntervalForPoints = 0.5
            case 31...35:
                timeIntervalForPoints = 0.4
            case 36...40:
                timeIntervalForPoints = 0.3
            case 41...45:
                timeIntervalForPoints = 0.2
            case 46...50:
                timeIntervalForPoints = 0.1
            default:
                timeIntervalForPoints = 0.1
            }
            if self.timeSincePointGiven > timeIntervalForPoints {
                self.points += 1
                self.pointsCounterLabel?.text = "Points: \(self.points)"
                self.timeSincePointGiven = 0
                println("points: \(self.points)")
            }
        }
        
        for shape in shapesArray {
            if !shape.alive {
                shape.spawnSprite(self.squaresAcquired)
                shape.sprite?.physicsBody = SKPhysicsBody(rectangleOfSize: shape.sprite!.size)
                shape.sprite?.physicsBody?.collisionBitMask = 0
                shape.sprite?.physicsBody?.categoryBitMask = shape.contactCategory!
                shape.alive = true
            }
        }
        
        if self.playerIsDead == true {
            self.currentTime = currentTime
            self.deltaTime = self.currentTime - self.previousTime
            self.previousTime = currentTime
            self.deathTimer += self.deltaTime
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
        let heroSideLength = self.heroView!.frame.width * 0.035
        let heroSize = CGSize(width: heroSideLength, height: heroSideLength)
        self.hero = SKSpriteNode(texture: nil, color: UIColor.whiteColor(), size: heroSize)
        self.hero.position = CGPointMake(self.heroView!.frame.width/2, self.heroView!.frame.height/2)
        self.heroCategory = (self.friendCategory | self.enemyCategory)
        
        self.hero.physicsBody = SKPhysicsBody(rectangleOfSize: heroSize)
        self.hero.physicsBody?.collisionBitMask = 0
        self.hero.physicsBody?.contactTestBitMask = self.heroCategory!
        
        let action = SKAction.rotateByAngle(CGFloat(M_PI), duration: 1)
        self.hero.runAction(SKAction.repeatActionForever(action))
        
        self.panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "handlePan:")
        self.view?.addGestureRecognizer(panGestureRecognizer)
        self.addChild(self.hero)

    }
    
    func startSpawn () {
        for side in Shape.OriginSide.allValues {
            let enemyShape = Shape.spawnShape(self.squaresAcquired, originSide: side, team: Shape.ShapeTeam.Enemy, scene: self)
            enemyShape.contactCategory = enemyCategory
            enemyShape.sprite?.physicsBody = SKPhysicsBody(rectangleOfSize: enemyShape.sprite!.size)
            enemyShape.sprite?.physicsBody?.collisionBitMask = 0
            enemyShape.sprite?.physicsBody?.categoryBitMask = enemyCategory
            self.shapesArray.append(enemyShape)
            
            let friendShape = Shape.spawnShape(self.squaresAcquired, originSide: side, team: Shape.ShapeTeam.Friend, scene: self)
            friendShape.contactCategory = friendCategory
            friendShape.sprite?.physicsBody = SKPhysicsBody(rectangleOfSize: friendShape.sprite!.size)
            friendShape.sprite?.physicsBody?.collisionBitMask = 0
            friendShape.sprite?.physicsBody?.categoryBitMask = friendCategory
            self.shapesArray.append(friendShape)
            //self.addChild(self.dimmingLayer!)
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
                
                self.addChild(self.pointsCounterLabel!)
                
                if !self.shapesArray.isEmpty {
                    for shape in self.shapesArray {
                        shape.sprite?.removeFromParent()
                    }
                }
                
                self.shapesArray = [Shape]()
                startSpawn()
                self.addChild(self.pauseButton!)
                
                self.showGameOver = false
                self.showMenu = false
                self.menuNode?.removeFromParent()
                self.dimmingLayer?.removeFromParent()
                self.paused = false
                self.dimmingLayer?.removeFromParent()
            }
            if nodeAtTouch?.name == "HelpButton" {
                println("HelpButton Touched")
                self.dimmingLayer?.removeFromParent()
                self.menuNode?.removeFromParent()
                //self.addHelpScreen()
                self.menuController.addHelpScreen(self)
            }
        }
    }
    
    func helpMenuHelper(touches: NSSet) {
        for touch in touches {
            var nodeAtTouch = self.helpNode?.nodeAtPoint(touch.locationInNode(self.helpNode))
            if nodeAtTouch?.name == "BackButton" {
                print("BackButton Touched")
                self.helpNode?.removeFromParent()
                self.dimmingLayer?.removeFromParent()
                //self.addMenuScreen()
                self.menuController.addMenuScreen(self)
            }
        }
    }
    
    func gameOverMenuHelper(touches: NSSet) {
        for touch in touches {
            var nodeAtTouch = self.gameOverNode?.nodeAtPoint(touch.locationInNode(self.gameOverNode))
            if nodeAtTouch?.name == "NewGameButton" {
                println("New Game Touched")
                self.gameOverNode?.removeFromParent()
                self.dimmingLayer?.removeFromParent()
                //self.addMenuScreen()
                self.menuController.addMenuScreen(self)
            }
            if nodeAtTouch?.name == "HelpButton" {
                println("Help Button Pressed")
                self.gameOverNode?.removeFromParent()
                self.dimmingLayer?.removeFromParent()
                //self.addHelpScreen()
                self.menuController.addHelpScreen(self)
            }
        }
    }
    
    func pauseHelper(touches: NSSet) {
        if self.paused == false {
            for touch in touches {
                var nodeAtTouch = self.nodeAtPoint(touch.locationInNode(self.pauseButton!.parent))
                if nodeAtTouch.name == "PauseButton" {
                    println("Pause Touched")
                    self.addChild(self.dimmingLayer!)
                    self.pauseGame()
                }
            }
        } else {
            for touch in touches {
                var nodeAtTouch = self.nodeAtPoint(touch.locationInNode(self.resumeButton!.parent))
                if nodeAtTouch.name == "PlayButton" {
                    println("Resume Touched")
                    self.dimmingLayer?.removeFromParent()
                    self.pauseGame()
                }
            }
        }
    }
    
        // Check to see which body in the contact is the hero and shape
        //MARK: - Contact Delegate Methods
        
    func didBeginContact(contact: SKPhysicsContact) {
        var shapeTouched : SKNode

         // Check to see which body in the contact is the hero and shape
        if contact.bodyA.node?.zRotation == 0 {
            shapeTouched = contact.bodyA.node!
        } else {
            shapeTouched = contact.bodyB.node!
        }
        
        if self.showGameOver == false {
            for shape in shapesArray {
                if shapeTouched == shape.sprite {
                    println("Found sprite")
                    if shape.team == Shape.ShapeTeam.Friend {
                        shape.alive = false
                        
                        // Increase total points and squares acquired count
                        self.squaresAcquired += 1
                        println("squares acquired: \(self.squaresAcquired)")
                        var pointsConstant = 20
                        
                        switch self.squaresAcquired {
                        case 0...5:
                            pointsConstant = 20
                        case 6...10:
                            pointsConstant = 25
                        case 11...15:
                            pointsConstant = 30
                        case 16...20:
                            pointsConstant = 35
                        case 21...25:
                            pointsConstant = 40
                        case 26...30:
                            pointsConstant = 45
                        case 31...35:
                            pointsConstant = 50
                        case 36...40:
                            pointsConstant = 55
                        case 41...45:
                            pointsConstant = 60
                        case 46...50:
                            pointsConstant = 65
                        default:
                            pointsConstant = 70
                        }
                        self.points += pointsConstant
                        println("scale: \(self.hero.xScale)")
                       
                        // Increase size of hero square
                        if self.hero.xScale <= 2.5 {
                            self.hero.xScale = self.hero.xScale + 0.03
                            self.hero.yScale = self.hero.yScale + 0.03
                        }
                        
                        shape.sprite?.removeFromParent()
                    }
                    else {
                        self.hero.addChild(self.particleEmitter!)
                        self.playerIsDead = true
                        while self.deathTimer < 1.0 {
                            println(self.deathTimer)
                        }
                        self.pointsCounterLabel?.removeFromParent()
                        self.gameOverNode = self.menuController.generateGameOverScreen(self, score: self.points)
                        self.paused = false
                        self.pauseButton?.removeFromParent()
                        self.hero.removeFromParent()
                        self.points = 0
                        self.playerIsDead = false
                    }
                }
            }
        }
    }
    
    func pauseGame() {
        if self.gameOverNode?.parent == nil && self.menuNode?.parent == nil && self.helpNode?.parent == nil {
            if self.paused == false {
                self.pauseButton?.removeFromParent()
                self.addChild(self.resumeButton!)
                self.panGestureRecognizer.enabled = false
                self.addChild(self.pausedLabel!)
            } else {
                self.resumeButton?.removeFromParent()
                self.addChild(self.pauseButton!)
                self.panGestureRecognizer.enabled = true
                self.pausedLabel?.removeFromParent()
            }
            self.playerHasPaused = !self.playerHasPaused
            self.paused = self.playerHasPaused
        }
    }
    
    func registerAppTransitionEvents() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "applicationDidBecomeActive:", name: UIApplicationDidBecomeActiveNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "applicationWillResignActive:", name: UIApplicationWillResignActiveNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "applicationDidEnterBackground:", name: UIApplicationDidEnterBackgroundNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "applicationWillEnterForeground:", name: UIApplicationWillEnterForegroundNotification, object: nil)
    }
    
    func applicationWillResignActive(application: UIApplication) {
        if self.playerHasPaused == true {
            self.paused = self.playerHasPaused
        }
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        if self.playerHasPaused == true {
            self.paused = self.playerHasPaused
        }
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        if self.playerHasPaused == true {
            self.paused = self.playerHasPaused
        }
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        if self.playerHasPaused == true {
            self.paused = self.playerHasPaused
        }
    }
    
}
