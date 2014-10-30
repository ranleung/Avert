//
//  MenuController.swift
//  Avert
//
//  Created by Reid Weber on 10/29/14.
//  Copyright (c) 2014 Randall. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit

class MenuController {
    
    var menuNode: MenuScreenNode?
    var helpNode: HelpScreen?
    var gameOverNode: GameOverNode?
    var pauseButton: SKSpriteNode?
    var resumeButton: SKSpriteNode?
    var pausedLabel: SKLabelNode?
    var dimmingLayer: SKSpriteNode?
    var scoreLabel: SKLabelNode?
    var soundOn: SKSpriteNode!
    var soundOff: SKSpriteNode!
    var gameCenterButton: SKSpriteNode!
    
    
    init(scene: GameScene) {
        self.menuNode = MenuScreenNode(scene: scene)
        self.helpNode = HelpScreen(scene: scene)
        self.pauseButton = SKSpriteNode(imageNamed: "PauseButton")
        self.resumeButton = SKSpriteNode(imageNamed: "PlayButton")
        self.pauseButton?.position = CGPoint(x: scene.frame.width - self.pauseButton!.frame.width/2, y: scene.frame.height - self.pauseButton!.frame.height/3)
        self.resumeButton?.position = CGPoint(x: scene.frame.width - self.pauseButton!.frame.width/2, y: scene.frame.height - self.pauseButton!.frame.height/3)
        self.pauseButton?.name = "PauseButton"
        self.resumeButton?.name = "PlayButton"
        self.pausedLabel = SKLabelNode(text: "Paused")
        self.pausedLabel?.fontName = "Audiowide-Regular"
        self.pausedLabel?.fontSize = 50
        self.pausedLabel?.position = CGPoint(x: CGRectGetMidX(scene.frame), y: CGRectGetMidY(scene.frame))
        self.pauseButton?.zPosition = 2.0
        self.resumeButton?.zPosition = 2.0
        self.pausedLabel?.zPosition = 2.0
        
        self.dimmingLayer = SKSpriteNode(color: UIColor.blackColor(), size: scene.frame.size)
        self.dimmingLayer?.alpha = 0.5
        self.dimmingLayer?.zPosition = 1.0
        self.dimmingLayer?.position = CGPoint(x: CGRectGetMidX(scene.frame), y: CGRectGetMidY(scene.frame))
        
        self.scoreLabel = SKLabelNode(text: "Points: 0")
        self.scoreLabel?.position = CGPoint(x: scene.frame.origin.x + scene.frame.width * 0.03, y: scene.frame.height - scene.frame.height * 0.07)
        self.scoreLabel?.zPosition = 2.0
        self.scoreLabel?.fontName = "Audiowide-Regular"
        self.scoreLabel?.fontSize = 20
        
        self.soundOn = SKSpriteNode(imageNamed: "SoundOn")
        self.soundOff = SKSpriteNode(imageNamed: "SoundOff")
        self.soundOn.position = CGPoint(x: scene.frame.width - self.soundOn.frame.width/2, y: scene.frame.origin.y + self.soundOn.frame.height/2)
        self.soundOff.position = CGPoint(x: scene.frame.width - self.soundOn.frame.width/2, y: scene.frame.origin.y + self.soundOn.frame.height/2)
        self.soundOn?.name = "SoundOn"
        self.soundOff?.name = "SoundOff"
        self.soundOn.xScale = 0.35
        self.soundOn.yScale = 0.35
        self.soundOff.xScale = 0.35
        self.soundOff.yScale = 0.35
        self.soundOn.zPosition = 2.0
        self.soundOff.zPosition = 2.0
        
        self.pauseButton?.xScale = 0.3
        self.pauseButton?.yScale = 0.3
        self.resumeButton?.xScale = 0.3
        self.resumeButton?.yScale = 0.3
        
        self.gameCenterButton = SKSpriteNode(imageNamed: "GameCenter")
        self.gameCenterButton.name = "GameCenterButton"
        self.gameCenterButton.position = CGPoint(x: scene.frame.origin.x + self.gameCenterButton.frame.width/4, y: scene.frame.origin.y + self.gameCenterButton.frame.height/4)
        self.gameCenterButton.xScale = 0.35
        self.gameCenterButton.yScale = 0.35
        self.gameCenterButton.zPosition = 2.0
    }
    
    func addHelpScreen(scene: GameScene) {
        scene.addChild(self.helpNode!)
        scene.showHelpMenu = true
        scene.showMenu = false
        scene.addChild(self.dimmingLayer!)
        self.removeSoundButtons(scene)
        if scene.gameCenterButton?.parent != nil {
            scene.gameCenterButton?.removeFromParent()
        }
    }
    
    func addMenuScreen(scene: GameScene) {
        scene.addChild(self.menuNode!)
        scene.showHelpMenu = false
        scene.showMenu = true
        scene.addChild(self.dimmingLayer!)
        if scene.soundOn?.parent == nil && scene.soundOff?.parent == nil {
            self.addSoundButtons(scene, sound: scene.soundPlaying)
        }
        if scene.gameCenterButton?.parent == nil {
            scene.addChild(self.gameCenterButton)
        }
    }
    
    func generateGameOverScreen(scene: GameScene, score: Int) -> GameOverNode {
        self.gameOverNode = GameOverNode(scene: scene, score: score)
        scene.addChild(self.gameOverNode!)
        scene.showGameOver = true
        scene.showMenu = false
        scene.addChild(self.dimmingLayer!)
        if scene.soundOn?.parent == nil && scene.soundOff?.parent == nil {
            self.addSoundButtons(scene, sound: scene.soundPlaying)
        }
        if scene.gameCenterButton?.parent == nil {
            scene.addChild(self.gameCenterButton)
        }
        return self.gameOverNode!
    }
    
    func addSoundButtons(scene: GameScene, sound: Bool) {
        
        if sound == true {
            scene.addChild(scene.soundOn!)

        } else {
            scene.addChild(scene.soundOff!)
        }
    }
    
    func removeSoundButtons(scene: GameScene) {
        scene.soundOn?.removeFromParent()
        scene.soundOff?.removeFromParent()
    }
}