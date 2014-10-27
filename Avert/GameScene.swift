//
//  GameScene.swift
//  Avert
//
//  Created by Randall Leung on 10/27/14.
//  Copyright (c) 2014 Randall. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var hero: SKShapeNode!
    var heroRotationSpeed = 5
    var panGestureRecognizer : UIPanGestureRecognizer!
    var lastTouchedLocation : CGPoint!
    var startPosition : CGPoint!
   
    override func didMoveToView(view: SKView) {

        //Create starting hero and position center
        //self.hero = SKShapeNode(rect: CGRect(x: 0.0, y: 0.0, width: 50, height: 50))
        let path = CGPathCreateWithRect(CGRect(x: 0.0, y: 0.0, width: 50, height: 50), nil)
        self.hero = SKShapeNode(path: path, centered: true)
        
        self.hero.fillColor = UIColor.whiteColor()
        self.hero.xScale = 0.5
        self.hero.yScale = 0.5
        self.hero.position = CGPointMake(view.frame.width/2, view.frame.height/2)
        
        let action = SKAction.rotateByAngle(CGFloat(M_PI), duration: 1)
        self.hero.runAction(SKAction.repeatActionForever(action))
        self.addChild(self.hero)

        self.panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "handlePan:")
        self.view?.addGestureRecognizer(panGestureRecognizer)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        
        for touch: AnyObject in touches {

        }
    }

    override func update(currentTime: CFTimeInterval) {
    
    }

    func handlePan (panGestureRecognizer: UIPanGestureRecognizer) {
        if panGestureRecognizer.state == UIGestureRecognizerState.Began {
            self.startPosition = self.hero.position
        }
        if panGestureRecognizer.state == UIGestureRecognizerState.Changed {
            //let translatedPoint =
            var touchLocation = self.panGestureRecognizer.translationInView(self.view!)
            touchLocation = CGPointMake(touchLocation.x, -touchLocation.y)
            var newLocation = CGPointMake(startPosition.x + touchLocation.x, startPosition.y + touchLocation.y)
//            touchLocation = self.convertPointFromView(touchLocation)
            self.hero.position = newLocation
//            var xDistance = lastTouchedLocation.x - touchLocation.x
//            var yDistance = lastTouchedLocation.y - touchLocation.y
//            if touchLocation.x < lastTouchedLocation.x {
//                xDistance = xDistance * -1
//            }
//            if touchLocation.y < lastTouchedLocation.y {
//                yDistance = yDistance * -1
//            }
//            var currentPosition = touchLocation
//            self.hero.position = currentPosition
//            self.lastTouchedLocation = touchLocation
            println("Changed \(self.panGestureRecognizer.locationInView(self.view))")
        }
        if panGestureRecognizer.state == UIGestureRecognizerState.Ended {
            println("Ended \(self.panGestureRecognizer.locationInView(self.view))")
        }
    }
}
