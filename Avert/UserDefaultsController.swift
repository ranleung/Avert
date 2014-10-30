//
//  UserDefaultsController.swift
//  Avert
//
//  Created by Reid Weber on 10/30/14.
//  Copyright (c) 2014 Randall. All rights reserved.
//

import Foundation

class UserDefaultsController {
    
    func userSoundPreference(scene: GameScene) {
        let soundKey = "SoundIsOn"
        
        if let previousSoundPreference = NSUserDefaults.standardUserDefaults().valueForKey(soundKey) as? Bool {
            if scene.soundPlaying != previousSoundPreference {
                scene.soundPlaying = previousSoundPreference
            }
        } else {
            NSUserDefaults.standardUserDefaults().setValue(scene.soundPlaying, forKey: soundKey)
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    func userSoundPreferenceSave(scene: GameScene) {
        let soundKey = "SoundIsOn"
        
        if let previousSoundPreference = NSUserDefaults.standardUserDefaults().valueForKey(soundKey) as? Bool {
            if scene.soundPlaying != previousSoundPreference {
                NSUserDefaults.standardUserDefaults().setValue(scene.soundPlaying, forKey: soundKey)
                NSUserDefaults.standardUserDefaults().synchronize()
            }
        } else {
            NSUserDefaults.standardUserDefaults().setValue(scene.soundPlaying, forKey: soundKey)
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    func checkForHighScores (scene: GameScene) {
        let pointsKey = "Points"
        let squaresKey = "Squares"
        
        if let previousHighScore = NSUserDefaults.standardUserDefaults().valueForKey(pointsKey) as? Int {
            if scene.points > previousHighScore {
                NSUserDefaults.standardUserDefaults().setValue(scene.points, forKey: pointsKey)
                NSUserDefaults.standardUserDefaults().synchronize()
                scene.highScore = scene.points
            }
        } else {
            NSUserDefaults.standardUserDefaults().setValue(scene.points, forKey: pointsKey)
            NSUserDefaults.standardUserDefaults().synchronize()
        }
        
        if let previousHighSquares = NSUserDefaults.standardUserDefaults().valueForKey(squaresKey) as? Int {
            if scene.squaresAcquired > previousHighSquares {
                scene.highSquares = scene.squaresAcquired
                NSUserDefaults.standardUserDefaults().setValue(scene.squaresAcquired, forKey: squaresKey)
                NSUserDefaults.standardUserDefaults().synchronize()
            }
        } else {
            NSUserDefaults.standardUserDefaults().setValue(scene.squaresAcquired, forKey: squaresKey)
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    class func returnHighScore() -> Int {
        let pointsKey = "Points"
        if let highScore = NSUserDefaults.standardUserDefaults().valueForKey(pointsKey) as? Int {
            return highScore
        } else {
            return 0
        }
    }
    
    class func returnHighSquares() -> Int {
        let squaresKey = "Squares"
        if let highSquares = NSUserDefaults.standardUserDefaults().valueForKey(squaresKey) as? Int {
            return highSquares
        } else {
            return 0
        }
    }
    
}