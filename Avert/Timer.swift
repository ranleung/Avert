/*

Timer for measuring all enemies and all friends powerups

*/

import SpriteKit

class Timer : SKSpriteNode {
    var timerArray = [SKSpriteNode]()
    var timeRemaining = 3.0
    
    class func addTimer(scene: SKScene) -> Timer {
        let newTimerHeight = scene.size.width * 0.025
        let newTimerWidth = newTimerHeight * 6
        var newTimer = Timer(color: UIColor.clearColor(), size: CGSize(width: newTimerWidth, height: newTimerHeight))
        newTimer.anchorPoint = CGPoint(x: 0, y: 0)
        while newTimer.timerArray.count < 6 {
            let pixelSide = newTimerHeight
            let pixelSize = CGSize(width: pixelSide, height: pixelSide)
            let pixel = SKSpriteNode(color: UIColor(red: 1, green: 214/255, blue: 0, alpha: 1), size: pixelSize)
            pixel.alpha = 1
            pixel.position = CGPoint(x: (pixel.size.width / 2) + (pixel.size.width * CGFloat(newTimer.timerArray.count)), y: pixel.size.width / 2)
            newTimer.timerArray.append(pixel)
            newTimer.addChild(pixel)
        }
        return newTimer
    }
    
    func runTimer(completionHandler: () -> Void) {
        let timerTickAction = SKAction.runBlock({ () -> Void in
            println("TICK")
            var removedPixel = self.timerArray.removeLast()
            removedPixel.removeFromParent()
        })
        let timerDelay = SKAction.waitForDuration(0.5)
        let timerFullTick = SKAction.sequence([timerDelay, timerTickAction])
        let timerSequence = SKAction.sequence([timerFullTick, timerFullTick, timerFullTick, timerFullTick, timerFullTick, timerFullTick])
        self.runAction(timerSequence, completion: { () -> Void in
            completionHandler()
        })
        
            
    }
    
    
}
