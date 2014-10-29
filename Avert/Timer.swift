//
//  Timer.swift
//  Avert
//
//  Created by William Richman on 10/29/14.
//  Copyright (c) 2014 Randall. All rights reserved.
//

import SpriteKit

class Timer : SKSpriteNode {
    var timerArray = [SKSpriteNode]()
    
    
    class func addTimer(scene: SKScene) -> Timer {
        let newTimerHeight = scene.size.width * 0.025
        let newTimerWidth = newTimerHeight * 6
        var newTimer = Timer(color: UIColor.clearColor(), size: CGSize(width: newTimerWidth, height: newTimerHeight))
        newTimer.anchorPoint = CGPoint(x: 0, y: 0)
        while newTimer.timerArray.count < 6 {
            let pixelSide = newTimerHeight
            let pixelSize = CGSize(width: pixelSide, height: pixelSide)
            let pixel = SKSpriteNode(color: UIColor.purpleColor(), size: pixelSize)
            pixel.alpha = 0.5
            pixel.position = CGPoint(x: (pixel.size.width / 2) + (pixel.size.width * CGFloat(newTimer.timerArray.count)), y: pixel.size.width / 2)
            newTimer.timerArray.append(pixel)
            newTimer.addChild(pixel)
        }
        return newTimer
    }
    
    
    
}
