//
//  GameScene.swift
//  Avert
//
//  Created by Randall Leung on 10/27/14.
//  Copyright (c) 2014 Randall. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
   
    
    let spawner = Spawner()
    var currentTime = 0.0
    var previousTime = 0.0
    var deltaTime = 0.0
    var timeSinceLastSpawn = 0.0
    
    
    // MARK - Overwritten SKScene functions
    override func didMoveToView(view: SKView) {
        startSpawn()
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
    
}
