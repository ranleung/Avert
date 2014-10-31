/*

Game Over settings, initialization, and properties

*/

import UIKit
import SpriteKit

class GameOverNode: SKNode {
    var titleLabel: SKLabelNode!
    var newGameLabel: SKLabelNode!
    var helpScreenLabel: SKLabelNode!
    var scoreLabel: SKLabelNode!
    var highScoreLabel: SKLabelNode!
    var highSquaresLabel: SKLabelNode!
    var font = "Audiowide-Regular"
    
    init(scene: SKScene, score: Int) {
        super.init()
        
        self.titleLabel = SKLabelNode(text: "Game Over")
        self.titleLabel.fontName = self.font
        self.titleLabel.fontSize = 30
        
        self.titleLabel.position = CGPoint(x: CGRectGetMidX(scene.frame), y: CGRectGetMidY(scene.frame))
        self.addChild(self.titleLabel)
        
        self.scoreLabel = SKLabelNode(text: "Score: \(score)")
        self.scoreLabel.fontName = self.font
        self.scoreLabel.fontSize = 50
        
        self.scoreLabel.position = CGPoint(x: CGRectGetMidX(scene.frame), y: CGRectGetMidY(scene.frame) + self.titleLabel.frame.height)
        self.addChild(self.scoreLabel)
        
        self.newGameLabel = SKLabelNode(text: "New Game")
        self.newGameLabel.fontName = self.font
        self.newGameLabel.fontSize = 20
        self.newGameLabel.name = "NewGameButton"
        
        self.newGameLabel.position = CGPoint(x: CGRectGetMidX(scene.frame) - (self.scoreLabel.frame.width / 2), y: CGRectGetMidY(scene.frame) - self.titleLabel.frame.height)
        self.addChild(self.newGameLabel)
        
        self.helpScreenLabel = SKLabelNode(text: "Help")
        self.helpScreenLabel.fontName = self.font
        self.helpScreenLabel.fontSize = 20
        self.helpScreenLabel.name = "HelpButton"
        
        self.helpScreenLabel.position = CGPoint(x: CGRectGetMidX(scene.frame) + (self.scoreLabel.frame.width / 2), y: CGRectGetMidY(scene.frame) - self.titleLabel.frame.height)
        self.addChild(self.helpScreenLabel)
        
        self.highScoreLabel = SKLabelNode(text: "High Score: \(UserDefaultsController.returnHighScore())")
        self.highScoreLabel.fontName = self.font
        self.highScoreLabel.fontSize = 20
        
        self.highScoreLabel.position = CGPoint(x: CGRectGetMidX(scene.frame), y: CGRectGetMidY(scene.frame) + self.highScoreLabel.frame.height * 3)
        self.addChild(self.highScoreLabel)
        
        self.highSquaresLabel = SKLabelNode(text: "High Squares: \(UserDefaultsController.returnHighSquares())")
        self.highSquaresLabel.fontName = self.font
        self.highSquaresLabel.fontSize = 20
        
        self.highSquaresLabel.position = CGPoint(x: CGRectGetMidX(scene.frame), y: CGRectGetMidY(scene.frame) + self.highSquaresLabel.frame.height * 4)
        self.addChild(self.highSquaresLabel)
        
        self.zPosition = 2.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
