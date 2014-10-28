//
//  GameScene.swift
//  Avert
//
//  Created by Randall Leung on 10/27/14.
//  Copyright (c) 2014 Randall. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var hero: SKSpriteNode!
    var heroRotationSpeed = 5
    var panGestureRecognizer : UIPanGestureRecognizer!
    var lastTouchedLocation : CGPoint!
    var startPosition : CGPoint!
    var heroCategory = 0x1 << 0
    var wallsCategory = 0x1 << 1
    var collisionBehvaior : UICollisionBehavior!
    var animator : UIDynamicAnimator!
    
    
    override func didMoveToView(view: SKView) {

        //Create starting hero and position center
        let path = CGPathCreateWithRect(CGRect(x: 0.0, y: 0.0, width: 50, height: 50), nil)
        self.hero = SKSpriteNode(texture: nil, color: UIColor.whiteColor(), size: CGSize(width: 50, height: 50))
        self.hero.xScale = 0.5
        self.hero.yScale = 0.5
        self.hero.position = CGPointMake(view.frame.width/2, view.frame.height/2)
        let action = SKAction.rotateByAngle(CGFloat(M_PI), duration: 1)
        
        self.hero.runAction(SKAction.repeatActionForever(action))
        self.hero.physicsBody?.dynamic = true
        self.hero.physicsBody?.restitution = 1
        self.hero.physicsBody?.friction = 0.2
        self.hero.physicsBody?.mass = 1
        self.hero.physicsBody = SKPhysicsBody(edgeLoopFromRect: self.hero.frame)
        
//        self.hero.physicsBody?.categoryBitMask = UInt32(self.heroCategory)
//        self.hero.physicsBody?.collisionBitMask = 0
        //self.physicsBody = SKPhysicsBody(edgeLoopFromRect: self.view!.frame)
//        scene?.physicsBody?.categoryBitMask = UInt32(wallsCategory)
//        scene?.physicsBody?.collisionBitMask = 0
        
//        self.animator = UIDynamicAnimator(referenceView: self.view!)
//        self.collisionBehvaior = UICollisionBehavior(items: [self.hero])
//        self.collisionBehvaior.translatesReferenceBoundsIntoBoundary = true
//        self.animator.addBehavior(collisionBehvaior)
//        

        self.panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "handlePan:")
        self.view?.addGestureRecognizer(panGestureRecognizer)
        self.addChild(self.hero)
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
            //check the location of the hero, and if hes about to go off screen, just dont do anything
            if (self.hero.position.x >= 19 &&
                self.hero.position.x <= self.view?.frame.width) && (
                self.hero.position.y >= 19 &&
                self.hero.position.y <= self.view?.frame.height) {
                    var touchLocation = self.panGestureRecognizer.translationInView(self.view!)
                    touchLocation = CGPointMake(touchLocation.x, -touchLocation.y)
                    var newLocation = CGPointMake(startPosition.x + touchLocation.x, startPosition.y + touchLocation.y)
                    self.hero.position = newLocation
                    println("Changed \(self.hero.position)")
            }
            //bottom left corner
            if self.hero.position.x <= 19 {
                self.hero.position = CGPoint(x: 20, y: self.hero.position.y)
            }
            //bottom right corner
            if self.hero.position.x >= self.view!.frame.width - 19 {
                self.hero.position = CGPoint(x: self.view!.frame.width - 20, y: self.hero.position.y)
            }
            //top left corner
            if self.hero.position.y <= 19 {
                self.hero.position = CGPoint(x: self.hero.position.x, y: 20)
            }
            //top right corner
            if self.hero.position.y >= self.view!.frame.height - 19 {
                self.hero.position = CGPoint(x: self.hero.position.x, y: self.view!.frame.height - 20)
            }
        }
        if panGestureRecognizer.state == UIGestureRecognizerState.Ended {
            println("Ended \(self.hero.position)")
        }
    }
}
