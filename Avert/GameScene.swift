//
//  GameScene.swift
//  Avert
//
//  Created by Randall Leung on 10/27/14.
//  Copyright (c) 2014 Randall. All rights reserved.
//

import SpriteKit
import AVFoundation
import AudioToolbox
import GameKit

class GameScene: SKScene, SKPhysicsContactDelegate {
   
    // Parent View Controller Properties
    var gameViewController: GameViewController?
    
    // Menu Properties
    var menuController: MenuController!
    var menuNode: MenuScreenNode?
    var helpNode: HelpScreen?
    var gameOverNode: GameOverNode?
    var gameCenterButton: SKSpriteNode?
    var showMenu = true
    var showHelpMenu = false
    var showGameOver = false
    
    // Pause Button Properties
    var pauseButton: SKSpriteNode?
    var resumeButton: SKSpriteNode?
    var pausedLabel: SKLabelNode?
    
    // Hero Properties
    var hero : SKSpriteNode!
    var heroRotationSpeed = 5
    var panGestureRecognizer : UIPanGestureRecognizer!
    var lastTouchedLocation : CGPoint!
    var startPosition : CGPoint!
    var heroView: SKView?
    
    // Timer Properties
    var currentTime = 0.0
    var previousTime = 0.0
    var deltaTime = 0.0
    var timeSinceLastSpawn = 0.0
    var timeSincePointGiven = 0.0
    var deathTimer = 0.0
    var playerIsDead = false
    
    // Points Properties
    var points: Int = 0
    var squaresAcquired: Int = 0
    var shapesArray = [Shape]()
    var pointsCounterLabel: SKLabelNode?
    var squaresCounterLabel: SKLabelNode?
    var pointsShouldIncrease = false
    
    // Powerups Properties
    var powerupsDictionary: [String: Powerup?] = ["Friend": nil, "Enemy": nil]
    var timeSinceLastGoodPowerup = 1.0
    var timeSinceLastBadPowerup = 0.0
    var timeIntervalForGoodPowerup : Double?
    var timeIntervalForBadPowerup : Double?
    var timer : Timer?
    
    // Contact Properties
    let friendCategory : UInt32 = 0x1 << 0
    let enemyCategory : UInt32 = 0x1 << 1
    let powerupCategory : UInt32 = 0x1 << 2
    var heroCategory : UInt32?
    
    // Sound Properties
    var audioPlayer : AVAudioPlayer?
    var optionSelectedSound : SystemSoundID?
    var audioSession = AVAudioSession.sharedInstance()

    // Dimming Layer Properties
    var dimmingLayer: SKSpriteNode?
    var playerHasPaused = false
    
    // Sounds Button Properties
    var soundOn: SKSpriteNode?
    var soundOff: SKSpriteNode?
    var soundPlaying = true
    
    // Particle Emitter Properties
    var particleEmitter: SKEmitterNode?
    
    //PowerUpLabel Properties
    var powerUpLabelIsActive = false
    var currentPowerUpLabelNode : SKLabelNode?

    // UserDefaults Properties
    var userDefaultsController: UserDefaultsController?
    var highScore = 0
    var highSquares = 0
    
    // App Delegate Property
    var appDelegate: AppDelegate?

    
    // MARK: - Overwritten SKScene Methods
    
    override func didMoveToView(view: SKView) {
        
        // Checking sound preference
        self.userDefaultsController = UserDefaultsController()
        self.userDefaultsController!.userSoundPreference(self)
        
        // sending reference of self to AppDelegate
        self.appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
        self.appDelegate?.gameScene = self
        
        //keep view for addHero()
        self.menuController = MenuController(scene: self)
        
        self.helpNode = self.menuController.helpNode
        self.menuNode = self.menuController.menuNode
        self.pauseButton = self.menuController.pauseButton
        self.resumeButton = self.menuController.resumeButton
        self.pausedLabel = self.menuController.pausedLabel
        self.gameCenterButton = self.menuController.gameCenterButton
        self.dimmingLayer = self.menuController.dimmingLayer
        self.pointsCounterLabel = self.menuController.scoreLabel
        self.squaresCounterLabel = self.menuController.squaresLabel
        self.soundOn = self.menuController.soundOn
        self.soundOff = self.menuController.soundOff
        self.addChild(self.menuNode!)
        self.addChild(self.gameCenterButton!)
        
        if self.soundPlaying == true {
            self.addChild(self.soundOn!)
        } else {
            self.addChild(self.soundOff!)
        }

        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.paused = true
        
        // Initializing powerup spawns
        self.timeIntervalForGoodPowerup = Double(Float(arc4random() % 5) + 6)
        self.timeIntervalForBadPowerup = Double(Float(arc4random() % 5) + 6)

        // Play music
      //  self.playMusic()
        
        // Initialize menu sound effect
        self.initializeOptionSelectedSound()
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
        self.soundHelper(touches)
        self.gameCenterHelper(touches)
    }

    override func update(currentTime: CFTimeInterval) {
        
        if self.paused == false {
            self.pointsCounterLabel?.text = "Points: \(self.points)"
            self.squaresCounterLabel?.text = "Squares: \(self.squaresAcquired)"
            var alignment = SKLabelHorizontalAlignmentMode(rawValue: 1)
            self.pointsCounterLabel?.horizontalAlignmentMode = alignment!
            self.squaresCounterLabel?.horizontalAlignmentMode = alignment!

            if self.pointsShouldIncrease != false {
                self.currentTime = currentTime
                self.deltaTime = self.currentTime - self.previousTime
                if self.deltaTime > 1 {
                    self.deltaTime = 0
                }
                self.previousTime = currentTime
                self.timeSincePointGiven = self.timeSincePointGiven + self.deltaTime
                self.timeSinceLastGoodPowerup = self.timeSinceLastGoodPowerup + self.deltaTime
                self.timeSinceLastBadPowerup = self.timeSinceLastBadPowerup + self.deltaTime
                var timeIntervalForPoints = 1.0
                var pointsMultiplier = 1
                
                // Rate for accumulating points
                switch self.squaresAcquired {
                case 0...5:
                    timeIntervalForPoints = 1.0
                    pointsMultiplier = 1
                case 6...10:
                    timeIntervalForPoints = 0.9
                    pointsMultiplier = 1
                case 11...15:
                    timeIntervalForPoints = 0.8
                    pointsMultiplier = 1
                case 16...20:
                    timeIntervalForPoints = 0.7
                    pointsMultiplier = 1
                case 21...25:
                    timeIntervalForPoints = 0.6
                    pointsMultiplier = 1
                case 26...30:
                    timeIntervalForPoints = 0.5
                    pointsMultiplier = 1
                case 31...35:
                    timeIntervalForPoints = 0.4
                    pointsMultiplier = 2
                case 36...40:
                    timeIntervalForPoints = 0.3
                    pointsMultiplier = 2
                case 41...45:
                    timeIntervalForPoints = 0.2
                    pointsMultiplier = 3
                case 46...50:
                    timeIntervalForPoints = 0.1
                    pointsMultiplier = 4
                default:
                    timeIntervalForPoints = 0.1
                    pointsMultiplier = 5
                }
                if self.timeSincePointGiven > timeIntervalForPoints {
                    self.points += 1 * pointsMultiplier
                    self.timeSincePointGiven = 0
                }
            }
            
            if self.timeSinceLastGoodPowerup > timeIntervalForGoodPowerup {
                self.timeIntervalForGoodPowerup = Double(Float(arc4random() % 5) + 6)
                self.timeSinceLastGoodPowerup = 0
                let spawnedPowerup = Powerup.spawnPowerup(Powerup.ShapeTeam.Friend, scene: self, shapesAcquired: self.squaresAcquired)
                spawnedPowerup.sprite?.physicsBody = SKPhysicsBody(rectangleOfSize: spawnedPowerup.sprite!.size)
                spawnedPowerup.sprite?.physicsBody?.collisionBitMask = 0
                spawnedPowerup.sprite?.physicsBody?.categoryBitMask = powerupCategory
                self.powerupsDictionary["Friend"] = spawnedPowerup

                
            }
            
            if self.timeSinceLastBadPowerup > timeIntervalForGoodPowerup {
                self.timeIntervalForGoodPowerup = Double(Float(arc4random() % 5) + 6)
                self.timeSinceLastBadPowerup = 0
                let spawnedPowerup = Powerup.spawnPowerup(Powerup.ShapeTeam.Enemy, scene: self, shapesAcquired: self.squaresAcquired)
                spawnedPowerup.sprite?.physicsBody = SKPhysicsBody(rectangleOfSize: spawnedPowerup.sprite!.size)
                spawnedPowerup.sprite?.physicsBody?.collisionBitMask = 0
                spawnedPowerup.sprite?.physicsBody?.categoryBitMask = powerupCategory
                self.powerupsDictionary["Enemy"] = spawnedPowerup
            }
        }
        
        self.deathTimer += self.deltaTime
        
        for shape in shapesArray {
            if !shape.alive {
                shape.spawnSprite(self.squaresAcquired)
                shape.sprite?.physicsBody = SKPhysicsBody(rectangleOfSize: shape.sprite!.size)
                shape.sprite?.physicsBody?.collisionBitMask = 0
                shape.sprite?.physicsBody?.categoryBitMask = shape.contactCategory!
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
    }
    
    // MARK: - Character Creation Methods
    
    func newGame() {
        self.heroView = view
        addHero()
        self.addChild(self.pointsCounterLabel!)
        self.addChild(self.squaresCounterLabel!)
        self.particleEmitter?.removeFromParent()
        
        if !self.shapesArray.isEmpty {
            for shape in self.shapesArray {
                shape.sprite?.removeFromParent()
            }
        }
        
        for (team, powerup) in powerupsDictionary {
            if powerup != nil {
                powerup?.sprite?.removeFromParent()
                powerupsDictionary[team] = nil
            }
        }
        
        self.timeIntervalForGoodPowerup = Double(Float(arc4random() % 5) + 6)
        self.timeIntervalForBadPowerup = Double(Float(arc4random() % 5) + 6)
        self.timeSinceLastGoodPowerup = 1.0
        self.timeSinceLastBadPowerup = 0.0
        
        if self.timer != nil {
            self.timer!.removeFromParent()
            self.timer = nil
        }
        
        
        self.shapesArray = [Shape]()
        startSpawn()
        self.addChild(self.pauseButton!)
        self.showGameOver = false
        self.showMenu = false
        self.menuNode?.removeFromParent()
        self.dimmingLayer?.removeFromParent()
        self.paused = false
        self.pointsShouldIncrease = true
        if self.soundPlaying == true {
            AudioServicesPlaySystemSound(self.optionSelectedSound!)
        }
        if self.gameCenterButton?.parent != nil {
            self.gameCenterButton?.removeFromParent()
        }
        if self.soundOff?.parent != nil {
            self.soundOff?.removeFromParent()
        }
        if self.soundOn?.parent != nil {
            self.soundOn?.removeFromParent()
        }
    }
    
    func addHero() {
        //Create starting hero and position center
        let heroSideLength = self.heroView!.frame.width * 0.035
        let heroSize = CGSize(width: heroSideLength, height: heroSideLength)
        var texture = SKTexture(image: UIImage(named: "hero2")!)
        self.hero = SKSpriteNode(texture: texture, size: heroSize)
        self.hero.position = CGPointMake(self.heroView!.frame.width/2, self.heroView!.frame.height/2)
        self.heroCategory = (self.friendCategory | self.enemyCategory | self.powerupCategory)
        
        // Setting hero physics body
        self.hero.physicsBody = SKPhysicsBody(rectangleOfSize: heroSize)
        self.hero.physicsBody?.collisionBitMask = 0
        self.hero.physicsBody?.contactTestBitMask = self.heroCategory!
        
        // Setting hero rotation
        let action = SKAction.rotateByAngle(CGFloat(M_PI), duration: 2)
        self.hero.runAction(SKAction.repeatActionForever(action))
        
        // Adding gesture and hero to scene
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
        }
    }
    
    // MARK: - Touch Helper Methods
        
    func menuHelper(touches: NSSet) {
        for touch in touches {
            var nodeAtTouch = self.menuNode?.nodeAtPoint(touch.locationInNode(self.menuNode))
            if nodeAtTouch?.name == "PlayButton" {
                self.menuController.removeSoundButtons(self)
                self.gameCenterButton?.removeFromParent()
                self.newGame()
            }
            if nodeAtTouch?.name == "HelpButton" {
                self.dimmingLayer?.removeFromParent()
                self.menuNode?.removeFromParent()
                self.menuController.addHelpScreen(self)
                if self.soundPlaying == true {
                    AudioServicesPlaySystemSound(self.optionSelectedSound!)
                }
            }
        }
    }
    
    func helpMenuHelper(touches: NSSet) {
        for touch in touches {
            var nodeAtTouch = self.helpNode?.nodeAtPoint(touch.locationInNode(self.helpNode))
            if nodeAtTouch?.name == "BackButton" {
                self.helpNode?.removeFromParent()
                self.dimmingLayer?.removeFromParent()
                self.menuController.addMenuScreen(self)
                if self.soundPlaying == true {
                    AudioServicesPlaySystemSound(self.optionSelectedSound!)
                }
            }
        }
    }
    
    func gameOverMenuHelper(touches: NSSet) {
        for touch in touches {
            var nodeAtTouch = self.gameOverNode?.nodeAtPoint(touch.locationInNode(self.gameOverNode))
            if nodeAtTouch?.name == "NewGameButton" {
                self.gameOverNode?.removeFromParent()
                self.dimmingLayer?.removeFromParent()
                self.newGame()
            }
            if nodeAtTouch?.name == "HelpButton" {
                self.gameOverNode?.removeFromParent()
                self.dimmingLayer?.removeFromParent()
                self.menuController.addHelpScreen(self)
                if self.soundPlaying == true {
                    AudioServicesPlaySystemSound(self.optionSelectedSound!)
                }
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
                    self.menuController.addSoundButtons(self, sound: self.soundPlaying)
                    self.addChild(self.gameCenterButton!)
                    if self.soundPlaying == true {
                        AudioServicesPlaySystemSound(self.optionSelectedSound!)
                    }
                }
            }
        } else {
            for touch in touches {
                var nodeAtTouch = self.nodeAtPoint(touch.locationInNode(self.resumeButton!.parent))
                if nodeAtTouch.name == "PlayButton" {
                    self.dimmingLayer?.removeFromParent()
                    self.pauseGame()
                    self.menuController.removeSoundButtons(self)
                    self.pointsShouldIncrease = true
                    self.gameCenterButton?.removeFromParent()
                    if self.soundPlaying == true {
                        AudioServicesPlaySystemSound(self.optionSelectedSound!)
                    }
                }
            }
        }
    }
    
    func soundHelper(touches: NSSet) {
        if soundPlaying == true {
            for touch in touches {
                var nodeAtTouch = self.nodeAtPoint(touch.locationInNode(self.soundOn!.parent))
                if nodeAtTouch.name == "SoundOn" {
                    self.soundOn?.removeFromParent()
                    self.addChild(self.soundOff!)
                    self.soundPlaying = false
                    self.stopMusic()
                    self.userDefaultsController?.userSoundPreferenceSave(self)
                }
            }
        } else {
            for touch in touches {
                var nodeAtTouch = self.nodeAtPoint(touch.locationInNode(self.soundOff!.parent))
                if nodeAtTouch.name == "SoundOff" {
                    var error : NSError?
                    self.soundOff?.removeFromParent()
                    self.addChild(self.soundOn!)
                    self.soundPlaying = true
                    self.audioPlayer?.volume = 0.25
                    self.audioPlayer?.play()
                    self.playMusic()
                    self.userDefaultsController?.userSoundPreferenceSave(self)
                }
            }
        }
    }
    
    func gameCenterHelper(touches: NSSet) {
        for touch in touches {
            var nodeAtTouch = self.nodeAtPoint(touch.locationInNode(self.gameCenterButton!.parent))
            if nodeAtTouch.name == "GameCenterButton" {
                self.gameViewController!.showLeaderBoardAndAchievements(true)
            }
        }
    }

    // MARK: - Contact Delegate Methods
        
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
                       
                        // Increase size of hero square
                        if self.hero.xScale <= 2.5 {
                            self.hero.xScale = self.hero.xScale + 0.03
                            self.hero.yScale = self.hero.yScale + 0.03
                        }
                        let collectSFX = SKAction.playSoundFileNamed("avert_collect.caf", waitForCompletion: false)
                        if self.soundPlaying == true {
                            self.hero.runAction(collectSFX)
                        }
                        shape.sprite?.removeFromParent()
                    } else {
                        self.userDefaultsController?.checkForHighScores(self)
                        
                        // Death Sound Effect Activated
                        let deathSFX = SKAction.playSoundFileNamed("avert_death.caf", waitForCompletion: false)
                        if self.soundPlaying == true {
                            shape.sprite?.runAction(deathSFX)
                        }
                        
                        // Report score to Game Center
                        if self.gameViewController!.gameCenterEnabled == true {
                            let pointTotal = Int64(self.points)
                            let squaresTotal = Int64(self.squaresAcquired)
                            self.gameViewController!.reportScore(pointTotal, forLeaderboard: "Avert_Points_Leaderboard")
                            self.gameViewController!.reportScore(squaresTotal, forLeaderboard: "Avert_Squares_Leaderboard")
                        }
                        
                        // Particle Emitter Method Calls
                        self.deathTimer = 0.0
                        self.createParticleEmitter()
                        self.particleEmitter?.position = CGPoint(x: CGRectGetMidX(self.hero.frame), y: CGRectGetMidY(self.hero.frame))
                        self.addChild(self.particleEmitter!)
                        self.pointsCounterLabel?.removeFromParent()
                        self.squaresCounterLabel?.removeFromParent()
                        self.gameOverNode = self.menuController.generateGameOverScreen(self, score: self.points, squaresAcquired: self.squaresAcquired)
                        self.paused = false
                        self.pauseButton?.removeFromParent()
                        self.hero.removeFromParent()
                        self.points = 0
                        self.squaresAcquired = 0
                        self.pointsShouldIncrease = false
                    }
                }
            }
            for (team, powerup) in powerupsDictionary {
                if powerup != nil {
                    if shapeTouched == powerup!.sprite {
                        powerup?.givePowerup(self.hero, scene: self)
                        switch powerup!.team {
                        case .Friend:
                            self.powerupsDictionary["Friend"] = nil
                            let powerupSFX = SKAction.playSoundFileNamed("avert_powerup.caf", waitForCompletion: false)
                            if self.soundPlaying == true {
                                self.hero.runAction(powerupSFX)
                            }

                        case .Enemy:
                            self.powerupsDictionary["Enemy"] = nil
                            let powerdownSFX = SKAction.playSoundFileNamed("avert_powerdown.caf", waitForCompletion: false)
                            if self.soundPlaying == true {
                                self.hero.runAction(powerdownSFX)
                            }

                        }
                        powerup?.sprite?.removeFromParent()
                    }
                }
            }
        }
    }
    
    func pauseGame() {
        if self.paused == false {
            self.pauseButton?.removeFromParent()
            self.addChild(self.resumeButton!)
            if self.panGestureRecognizer != nil {
                self.panGestureRecognizer.enabled = false
            }
            self.addChild(self.pausedLabel!)
            if self.dimmingLayer?.parent == nil {
                self.addChild(self.dimmingLayer!)
            }
            self.pointsShouldIncrease = true
        } else {
            self.resumeButton?.removeFromParent()
            self.addChild(self.pauseButton!)
            self.panGestureRecognizer.enabled = true
            self.pausedLabel?.removeFromParent()
            if self.dimmingLayer?.parent != nil {
                self.dimmingLayer?.removeFromParent()
            }
            self.pointsShouldIncrease = false
        }
        self.playerHasPaused = !self.playerHasPaused
        self.paused = self.playerHasPaused
    }
    
    func createParticleEmitter() {
        var uncastedEmitter: AnyObject = NSKeyedUnarchiver.unarchiveObjectWithFile(NSBundle.mainBundle().pathForResource("DeathParticleEmitter", ofType: "sks")!)!
        self.particleEmitter = uncastedEmitter as? SKEmitterNode
    }
    
    //MARK: - AVAudio Methods
    
    func playMusic() {
        var error : NSError?
        var localURL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("avertmusic.mp3", ofType: nil)!)
        self.audioPlayer = AVAudioPlayer(contentsOfURL: localURL, error: &error)
        if error != nil {
            println("something bad happened")
        } else {
            self.audioPlayer?.prepareToPlay()
            self.audioPlayer?.numberOfLoops = -1
            self.audioPlayer?.volume = 0.25
            self.audioPlayer?.play()
        }
    }
    
    func stopMusic() {
        if self.audioPlayer?.playing == true || self.paused == true {
            self.audioPlayer?.stop()
        }
    }
    
    func initializeOptionSelectedSound() {
        var soundID: SystemSoundID = 0
        let soundURL = CFBundleCopyResourceURL(CFBundleGetMainBundle(), "avert_select", "caf", nil)
        AudioServicesCreateSystemSoundID(soundURL, &soundID)
        println(soundID)
        self.optionSelectedSound = soundID
    }
    
    // MARK: - GameScene Observer Methods

    func registerAppTransitionEvents() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "applicationDidBecomeActive:", name: UIApplicationDidBecomeActiveNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "applicationWillResignActive:", name: UIApplicationWillResignActiveNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "applicationDidEnterBackground:", name: UIApplicationDidEnterBackgroundNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "applicationWillEnterForeground:", name: UIApplicationWillEnterForegroundNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "applicationWillTerminate:", name: UIApplicationWillTerminateNotification, object: nil)
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
        self.view?.paused = true
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        self.view?.paused = false
        if self.playerHasPaused {
            self.paused = true
        } else if self.gameOverNode?.parent == nil && self.menuNode?.parent == nil && self.helpNode?.parent == nil {
            self.playerHasPaused = false
            self.pauseGame()
        }
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}
