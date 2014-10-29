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
    
    init(scene: GameScene) {
        self.menuNode = MenuScreenNode(scene: scene)
        self.helpNode = HelpScreen(scene: scene)
        
        self.pauseButton = SKSpriteNode(imageNamed: "PauseButton")
        self.resumeButton = SKSpriteNode(imageNamed: "PlayButton")
        self.pauseButton?.position = CGPoint(x: scene.frame.width - self.pauseButton!.frame.width/2, y: scene.frame.height - self.pauseButton!.frame.height/2.5)
        self.resumeButton?.position = CGPoint(x: scene.frame.width - self.pauseButton!.frame.width/2, y: scene.frame.height - self.pauseButton!.frame.height/2.5)
        self.pauseButton?.name = "PauseButton"
        self.resumeButton?.name = "PlayButton"
        self.pausedLabel = SKLabelNode(text: "Paused")
        self.pausedLabel?.fontName = "Optima-Bold"
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
        self.scoreLabel?.position = CGPoint(x: scene.frame.origin.x + self.scoreLabel!.frame.width * 0.5, y: scene.frame.height - self.scoreLabel!.frame.height * 1.5)
        self.scoreLabel?.zPosition = 2.0
        self.scoreLabel?.fontName = "Optima-Bold"
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
        
        self.pauseButton?.xScale = 0.4
        self.pauseButton?.yScale = 0.4
        self.resumeButton?.xScale = 0.4
        self.resumeButton?.yScale = 0.4
    }
    
    func addHelpScreen(scene: GameScene) {
        scene.addChild(self.helpNode!)
        scene.showHelpMenu = true
        scene.showMenu = false
        scene.addChild(self.dimmingLayer!)
        self.removeSoundButtons(scene)
    }
    
    func addMenuScreen(scene: GameScene) {
        scene.addChild(self.menuNode!)
        scene.showHelpMenu = false
        scene.showMenu = true
        scene.addChild(self.dimmingLayer!)
        if scene.soundOn?.parent == nil && scene.soundOff?.parent == nil {
            self.addSoundButtons(scene, sound: scene.soundPlaying)
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