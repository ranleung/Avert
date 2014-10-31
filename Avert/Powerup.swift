/*

Powerup class and methods

*/

import SpriteKit

class Powerup: Shape {
   
    class func spawnPowerup (team: ShapeTeam, scene: SKScene, shapesAcquired: Int) -> Powerup {
        let powerup = Powerup(side: randomSide(), team: team, scene: scene)
        powerup.spawnSprite(shapesAcquired)
        switch team {
        case .Friend:
            powerup.sprite?.color = UIColor.greenColor()
            powerup.sprite?.texture = SKTexture(image: UIImage(named: "goodpowerup")!)
        case .Enemy:
            powerup.sprite?.color = UIColor.redColor()
            powerup.sprite?.texture = SKTexture(image: UIImage(named: "badpowerup")!)
        }
        return powerup
    }
    
    class func randomSide() -> OriginSide {
        let randomIndex = arc4random() % 4
        return Powerup.OriginSide.allValues[Int(randomIndex)]
    }
    
    func givePowerup(hero: SKSpriteNode, scene: GameScene) {
        let randomPowerup = arc4random() % 3 + 1
        switch self.team {
        case .Friend:
            switch randomPowerup {
            case 1:
                let newscale = hero.xScale - CGFloat(0.3)
                if newscale >= 0.9 {
                    hero.xScale = newscale
                    hero.yScale = newscale
                    var powerUpLabel = PowerUpLabelNode(powerUpName: "Mini Square!", scene: scene)
                }
                else {
                    hero.xScale = 0.9
                    hero.yScale = 0.9
                    var powerUpLabel = PowerUpLabelNode(powerUpName: "Mini Square!", scene: scene)
                }
                println(hero.xScale)
            case 2:
                scene.points += 500
                println("New points: \(scene.points)")
                var powerUpLabel = PowerUpLabelNode(powerUpName: "+500 Points!", scene: scene)
            case 3:
                self.swapPowerup(scene, team: ShapeTeam.Friend)
                var powerUpLabel = PowerUpLabelNode(powerUpName: "All Squares Friendlies!", scene: scene)
            default:
                break
            }
        case .Enemy:
            switch randomPowerup {
            case 1:
                let newscale = hero.xScale + CGFloat(0.3)
                if newscale <= 2.5 {
                    hero.xScale = newscale
                    hero.yScale = newscale
                    var powerUpLabel = PowerUpLabelNode(powerUpName: "Big Square!", scene: scene)
                }
                else {
                    hero.xScale = 2.5
                    hero.yScale = 2.5
                    var powerUpLabel = PowerUpLabelNode(powerUpName: "Big Square!", scene: scene)
                }
            case 2:
                scene.points -= 500
                println("New points: \(scene.points)")
                var powerUpLabel = PowerUpLabelNode(powerUpName: "-500 Points", scene: scene)
            case 3:
                self.swapPowerup(scene, team: ShapeTeam.Enemy)
                var powerUpLabel = PowerUpLabelNode(powerUpName: "All Squares Enemies!", scene: scene)
            default:
                break
            }
        }
    }
    
    func swapPowerup(scene: GameScene, team: ShapeTeam) {
        if scene.timer != nil {
            scene.timer?.removeFromParent()
            scene.timer = nil
        }
        var timer = Timer.addTimer(scene)
        scene.timer = timer
        timer.zPosition = -1
        timer.position = CGPoint(x: (scene.size.width / 2) - (timer.size.width / 2), y: scene.size.height - (2 * timer.size.height))
        scene.addChild(timer)
        timer.runTimer { () -> Void in
            timer.removeFromParent()
            for shape in scene.shapesArray {
                if shape.originalTeam != team {
                    shape.switchTeam(scene)
                }
            }
            scene.timer = nil
            
        }
        for shape in scene.shapesArray {
            if shape.team != team {
                shape.switchTeam(scene)
            }
        }
        
        
    }
}
