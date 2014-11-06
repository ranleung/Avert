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
    var squaresLabel: SKLabelNode!
    var highScoreLabel: SKLabelNode!
    var highSquaresLabel: SKLabelNode!
    var font = "Audiowide-Regular"
    var gameScene = GameScene()
    
    init(scene: SKScene, score: Int, squaresAcquired: Int) {
        super.init()
        
        self.titleLabel = SKLabelNode(text: "Game Over")
        self.titleLabel.fontName = self.font
        self.titleLabel.fontSize = 40
        
        self.titleLabel.position = CGPoint(x: CGRectGetMidX(scene.frame), y: CGRectGetMidY(scene.frame) - self.titleLabel.frame.height * 1.3)
        self.addChild(self.titleLabel)
        
        self.scoreLabel = SKLabelNode(text: "Score: \(score)")
        self.scoreLabel.fontName = self.font
        self.scoreLabel.fontSize = 40
        
        self.scoreLabel.position = CGPoint(x: CGRectGetMidX(scene.frame), y: CGRectGetMidY(scene.frame) + self.titleLabel.frame.height * 1.1)
        self.addChild(self.scoreLabel)
        
        self.newGameLabel = SKLabelNode(text: "New Game")
        self.newGameLabel.fontName = self.font
        self.newGameLabel.fontSize = 20
        self.newGameLabel.name = "NewGameButton"
        
        self.newGameLabel.position = CGPoint(x: scene.frame.origin.x + self.newGameLabel.frame.width * 1.1, y: scene.frame.origin.y + self.newGameLabel.frame.height * 1.25)
        self.addChild(self.newGameLabel)
        
        self.helpScreenLabel = SKLabelNode(text: "Help")
        self.helpScreenLabel.fontName = self.font
        self.helpScreenLabel.fontSize = 20
        self.helpScreenLabel.name = "HelpButton"
        
        self.helpScreenLabel.position = CGPoint(x: scene.frame.width - self.newGameLabel.frame.width * 0.9, y: scene.frame.origin.y + self.newGameLabel.frame.height * 1.25)
        self.addChild(self.helpScreenLabel)
        
        self.highScoreLabel = SKLabelNode(text: "High Score: \(UserDefaultsController.returnHighScore())")
        self.highScoreLabel.fontName = self.font
        self.highScoreLabel.fontSize = 20
        var alignmentLeft = SKLabelHorizontalAlignmentMode(rawValue: 1)
        self.highScoreLabel.horizontalAlignmentMode = alignmentLeft!
        
        self.highScoreLabel.position = CGPoint(x: CGRectGetMidX(scene.frame) * 0.04, y: scene.frame.height - self.highScoreLabel.frame.height * 1.25)
        self.addChild(self.highScoreLabel)
        
        self.highSquaresLabel = SKLabelNode(text: "High Squares: \(UserDefaultsController.returnHighSquares())")
        self.highSquaresLabel.fontName = self.font
        self.highSquaresLabel.fontSize = 20
        
        self.highSquaresLabel.position = CGPoint(x: CGRectGetMidX(scene.frame) * 1.93, y: scene.frame.height - self.highSquaresLabel.frame.height * 1.25)
        var alignment = SKLabelHorizontalAlignmentMode(rawValue: 2)
        self.highSquaresLabel.horizontalAlignmentMode = alignment!
        self.addChild(self.highSquaresLabel)
        
        self.squaresLabel = SKLabelNode(text: "Squares: \(squaresAcquired)")
        self.squaresLabel.fontName = self.font
        self.squaresLabel.fontSize = 25
        
        self.squaresLabel.position = CGPoint(x: CGRectGetMidX(scene.frame), y: CGRectGetMidY(scene.frame))
        self.addChild(self.squaresLabel)
        
        self.zPosition = 2.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
