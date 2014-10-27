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
        
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
    }
   
    override func update(currentTime: CFTimeInterval) {
        self.currentTime = currentTime
        self.deltaTime = self.currentTime - self.previousTime
        self.previousTime = currentTime
        self.timeSinceLastSpawn = self.timeSinceLastSpawn + self.deltaTime
        if self.timeSinceLastSpawn > 2.0 {
            spawner.spawnShape(Spawner.OriginSide.Up, scene: self)
            spawner.spawnShape(Spawner.OriginSide.Down, scene: self)
            spawner.spawnShape(Spawner.OriginSide.Left, scene: self)
            spawner.spawnShape(Spawner.OriginSide.Right, scene: self)
            self.timeSinceLastSpawn = 0
        }
    }
    
}
