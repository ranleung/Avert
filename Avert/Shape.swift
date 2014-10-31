/*

Sprite creation methods, randomization methods

*/

import Spritekit

class Shape {
    
    var sprite : SKSpriteNode?
    var side : OriginSide
    var team : ShapeTeam
    var alive = true
    var scene : SKScene
    var contactCategory : UInt32?
    var originalTeam : ShapeTeam
    
    // Enums for spawning side and shape team
    enum OriginSide {
        case Up, Down, Left, Right
        static let allValues = [Up, Down, Left, Right]
    }
    
    enum ShapeTeam {
        case Friend, Enemy
        static let allValues = [Friend, Enemy]
    }
    
    init(side: OriginSide, team: ShapeTeam, scene: SKScene) {
        self.side = side
        self.team = team
        self.scene = scene
        self.originalTeam = team
    }
    
    
    // MARK: - Randomization Methods
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(#min: CGFloat, max: CGFloat) -> CGFloat {
        return self.random() * (max - min) + min
    }
    
    // MARK: - Spawning Methods
    
    class func spawnShape (squaresAcquired: Int, originSide: OriginSide, team: ShapeTeam, scene: SKScene) -> Shape {
        var shape = Shape(side: originSide, team: team, scene: scene)
        shape.spawnSprite(squaresAcquired)
        return shape
    }
    
    func spawnSprite(squaresAquired: Int) {
        let shapeSideSize = self.scene.size.width * self.random(min: 0.03, max: 0.055)
        let sprite = SKSpriteNode(texture: nil, size: CGSize(width: shapeSideSize, height: shapeSideSize))
        
        switch self.team {
        case .Friend:
            sprite.color = UIColor(red: 0, green: 144/255, blue: 1, alpha: 1)
            sprite.texture = SKTexture(image: UIImage(named: "friendlies")!)
        case .Enemy:
            sprite.color = UIColor(red: 1, green: 150/255, blue: 0, alpha: 1)
            sprite.texture = SKTexture(image: UIImage(named: "enemies")!)
        }
        
        var destination: CGPoint!
        
        switch self.side {
        case .Up:
            let randomX = random(min: sprite.frame.width / 2, max: scene.size.width - sprite.frame.width / 2)
            sprite.position = CGPoint(x: randomX, y: scene.size.height + sprite.frame.height / 2)
            destination = CGPoint(x: randomX, y: -sprite.frame.height / 2)
            
        case .Down:
            let randomX = random(min: sprite.frame.width / 2, max: scene.size.width - sprite.frame.width / 2)
            sprite.position = CGPoint(x: randomX, y: -sprite.frame.height / 2)
            destination = CGPoint(x: randomX, y: scene.size.height + sprite.frame.height / 2)
            
        case .Left:
            let randomY = random(min: sprite.frame.height / 2, max: scene.size.height - sprite.frame.height / 2)
            sprite.position = CGPoint(x: 0 - sprite.frame.width / 2, y: randomY)
            destination = CGPoint(x: scene.size.width + sprite.frame.width / 2, y: randomY)
            
        case .Right:
            let randomY = random(min: sprite.frame.height / 2, max: scene.size.height - sprite.frame.height / 2)
            sprite.position = CGPoint(x: scene.size.width + sprite.frame.width / 2, y: randomY)
            destination = CGPoint(x: -sprite.frame.width, y: randomY)
        }
        scene.addChild(sprite)
        
        var min: CGFloat = 4.0
        var max: CGFloat = 6.0
        
        switch squaresAquired {
        case 0...5:
            min = 3.0
            max = 5.0
        case 6...10:
            min = 2.5
            max = 4.5
        case 11...15:
            min = 2.0
            max = 4.0
        case 16...20:
            min = 1.5
            max = 3.5
        case 21...25:
            min = 1.4
            max = 3.25
        case 26...30:
            min = 1.3
            max = 3.125
        case 31...35:
            min = 1.2
            max = 3.0
        case 36...40:
            min = 1.1
            max = 2.75
        case 41...45:
            min = 1.0
            max = 2.5
        case 46...50:
            min = 0.9
            max = 2.25
        default:
            min = 0.8
            max = 1.5
        }
        
        var duration = self.random(min: min, max: max)
        
        switch self.side {
        case .Left, .Right:
            duration = (scene.size.width / scene.size.height) * duration
        case .Up, .Down:
            break
        }
        
        let moveAction = SKAction.moveTo(destination, duration: NSTimeInterval(duration))
        let moveActionDone = SKAction.removeFromParent()
        let respawnAction = SKAction.runBlock { () -> Void in
            self.alive = false
        }
        sprite.runAction(SKAction.sequence([moveAction, respawnAction, moveActionDone]))
        self.sprite = sprite
    }
    
    func switchTeam (scene: GameScene) {
        switch self.team {
            
        case .Friend:
            self.team = Shape.ShapeTeam.Enemy
            self.sprite?.color = UIColor(red: 1, green: 150/255, blue: 0, alpha: 1)
            self.sprite?.texture = SKTexture(image: UIImage(named: "enemies")!)
            self.sprite?.physicsBody?.categoryBitMask = scene.enemyCategory
            
        case .Enemy:
            self.team = Shape.ShapeTeam.Friend
            self.sprite?.color = UIColor(red: 0, green: 144/255, blue: 1, alpha: 1)
            self.sprite?.texture = SKTexture(image: UIImage(named: "friendlies")!)
            self.sprite?.physicsBody?.categoryBitMask = scene.friendCategory
        }
    }
    
}
