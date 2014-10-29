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
    
    init(scene: GameScene) {
        self.menuNode = MenuScreenNode(scene: scene)
        self.helpNode = HelpScreen(scene: scene)
        
        self.pauseButton = SKSpriteNode(imageNamed: "PauseButton")
        self.resumeButton = SKSpriteNode(imageNamed: "PlayButton")
        self.pauseButton?.position = CGPoint(x: scene.frame.width - self.pauseButton!.frame.width, y: scene.frame.height - self.pauseButton!.frame.height)
        self.resumeButton?.position = CGPoint(x: scene.frame.width - self.resumeButton!.frame.width, y: scene.frame.height - self.resumeButton!.frame.height)
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
        
    }
    
    func addHelpScreen(scene: GameScene) {
        scene.addChild(self.helpNode!)
        scene.showHelpMenu = true
        scene.showMenu = false
        scene.addChild(self.dimmingLayer!)
    }
    
    func addMenuScreen(scene: GameScene) {
        scene.addChild(self.menuNode!)
        scene.showHelpMenu = false
        scene.showMenu = true
        scene.addChild(self.dimmingLayer!)
    }
    
    func generateGameOverScreen(scene: GameScene, score: UInt32) -> GameOverNode {
        self.gameOverNode = GameOverNode(scene: scene, score: score)
        scene.addChild(self.gameOverNode!)
        scene.showGameOver = true
        scene.showMenu = false
        scene.addChild(self.dimmingLayer!)
        return self.gameOverNode!
    }
}