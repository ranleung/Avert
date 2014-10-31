/*

Power Up label properties, methods, and animations

*/

import SpriteKit

class PowerUpLabelNode {
    var powerUpLabel : SKLabelNode!
    var powerUpName: String!
    var mainScene : SKScene!
    var font = "Audiowide-Regular"
    
    init (powerUpName: String, scene : GameScene) {
        self.powerUpName = powerUpName
        self.mainScene = scene
        self.powerUpLabel = SKLabelNode(text: powerUpName)
        self.powerUpLabel.fontName = self.font
        self.powerUpLabel.fontSize = 20
        self.powerUpLabel.name = "PowerUpLabel"
        self.powerUpLabel.position = CGPoint(x: scene.frame.origin.x + self.powerUpLabel.frame.width * 0.5, y: -20)
        self.powerUpLabel.zPosition = -1
        let moveUpAction = SKAction.moveTo(CGPoint(x: scene.frame.origin.x + self.powerUpLabel.frame.width * 0.5, y: scene.frame.height * 0.05), duration: 0.4)
        let moveDownAction = SKAction.moveTo(CGPoint(x: scene.frame.origin.x + self.powerUpLabel.frame.width * 0.5, y: -20), duration: 0.4)
        var waitAction = SKAction.waitForDuration(3)
        var removePowerUpLabelFromScreen = SKAction.runBlock { () -> Void in
            scene.powerUpLabelIsActive = false
        }
        let moveActionDone = SKAction.removeFromParent()
        if scene.powerUpLabelIsActive == false {
            scene.powerUpLabelIsActive = true
            self.powerUpLabel.runAction(SKAction.sequence([moveUpAction, waitAction, removePowerUpLabelFromScreen, moveDownAction, moveActionDone]))
            scene.addChild(self.powerUpLabel)
            scene.currentPowerUpLabelNode = self.powerUpLabel
        } else {
            self.powerUpLabel.runAction(SKAction.sequence([moveUpAction, waitAction, removePowerUpLabelFromScreen, moveDownAction, moveActionDone]))
            scene.addChild(self.powerUpLabel)
            self.cancelCurrentPowerUpLabelActions(scene)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func cancelCurrentPowerUpLabelActions (scene: GameScene) {
        var currentPowerUp = scene.currentPowerUpLabelNode
        currentPowerUp?.removeAllActions()
        let moveDownAction = SKAction.moveTo(CGPoint(x: scene.frame.origin.x + currentPowerUp!.frame.width * 0.5, y: -20), duration: 0.4)
        let moveActionDone = SKAction.removeFromParent()
        currentPowerUp?.runAction(SKAction.sequence([moveDownAction, moveActionDone]))
        scene.currentPowerUpLabelNode = self.powerUpLabel
    }
}