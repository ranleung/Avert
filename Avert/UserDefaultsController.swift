/*

Setting user defaults for sound preferences and high score

*/

import Foundation

class UserDefaultsController {
    
    func userSoundPreference(scene: GameScene) {
        let soundKey = "SoundIsOn"
        
        if NSUserDefaults.standardUserDefaults().valueForKey(soundKey) != nil {
            let previousSoundPreference = NSUserDefaults.standardUserDefaults().boolForKey(soundKey)
            
            if previousSoundPreference == false {
                scene.soundPlaying = false
            } else {
                scene.soundPlaying = true
                NSUserDefaults.standardUserDefaults().setValue(previousSoundPreference, forKey: soundKey)
                NSUserDefaults.standardUserDefaults().synchronize()
            }
        } else {
            NSUserDefaults.standardUserDefaults().setValue(scene.soundPlaying, forKey: soundKey)
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    func userSoundPreferenceSave(scene: GameScene) {
        let soundKey = "SoundIsOn"
        
        let soundPreference = scene.soundPlaying
        if soundPreference == true {
            NSUserDefaults.standardUserDefaults().setValue(soundPreference, forKey: soundKey)
            NSUserDefaults.standardUserDefaults().synchronize()
        } else {
            NSUserDefaults.standardUserDefaults().setValue(soundPreference, forKey: soundKey)
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