/*

Help Screen settings, intialization, and properties

*/

import UIKit
import SpriteKit

class HelpScreen: SKNode {
   
    var titleLabel: SKLabelNode!
    var backLabel: SKLabelNode!
    var playerLabel: SKLabelNode!
    var enemyLabel: SKLabelNode!
    var friendLabel: SKLabelNode!
    var powerUpsLabel: SKLabelNode!
    var rulesTitleLabel: SKLabelNode!
    var firstRuleLabel: SKLabelNode!
    var secondRuleLabel: SKLabelNode!
    var thirdRuleLabel: SKLabelNode!
    var thirdRuleLabelLine2: SKLabelNode!
    var fourthRuleLabel: SKLabelNode!
    var fourthRuleLabelLine2: SKLabelNode!
    var fifthRuleLabel: SKLabelNode!
    var playerAsset: SKSpriteNode!
    var friendlyAsset: SKSpriteNode!
    var enemyAsset: SKSpriteNode!
    var powerUpsGoodAsset: SKSpriteNode!
    var powerUpsBadAsset: SKSpriteNode!
    var font = "Audiowide-Regular"
    var ipadReference: UIDevice?
    var myFontSize = 20 as CGFloat
    
    init(scene: SKScene) {
        super.init()
        
        self.playerAsset = SKSpriteNode(imageNamed: "hero")
        self.playerAsset.xScale = 0.2
        self.playerAsset.yScale = 0.2
        self.playerAsset.position = CGPoint(x: scene.frame.origin.x + self.playerAsset.frame.width * 0.75, y: scene.frame.height * 0.8)
        self.addChild(self.playerAsset)
        
        self.friendlyAsset = SKSpriteNode(imageNamed: "friendlies2")
        self.friendlyAsset.xScale = 0.2
        self.friendlyAsset.yScale = 0.2
        self.friendlyAsset.position = CGPoint(x: scene.frame.origin.x + self.friendlyAsset.frame.width * 0.75, y: scene.frame.height * 0.6)
        self.addChild(self.friendlyAsset)
        
        self.enemyAsset = SKSpriteNode(imageNamed: "enemies")
        self.enemyAsset.xScale = 0.2
        self.enemyAsset.yScale = 0.2
        self.enemyAsset.position = CGPoint(x: scene.frame.origin.x + self.enemyAsset.frame.width * 0.75, y: scene.frame.height * 0.4)
        self.addChild(self.enemyAsset)
        
        self.powerUpsGoodAsset = SKSpriteNode(imageNamed: "goodpowerup")
        self.powerUpsGoodAsset.xScale = 0.2
        self.powerUpsGoodAsset.yScale = 0.2
        self.powerUpsGoodAsset.position = CGPoint(x: scene.frame.origin.x + self.powerUpsGoodAsset.frame.width * 0.75, y: scene.frame.height * 0.2)
        self.addChild(self.powerUpsGoodAsset)
        
        self.powerUpsBadAsset = SKSpriteNode(imageNamed: "badpowerup")
        self.powerUpsBadAsset.xScale = 0.2
        self.powerUpsBadAsset.yScale = 0.2
        self.powerUpsBadAsset.position = CGPoint(x: scene.frame.origin.x + self.powerUpsGoodAsset.frame.width * 2, y: scene.frame.height * 0.2)
        self.addChild(self.powerUpsBadAsset)
        
        self.titleLabel = SKLabelNode(text: "Help!")
        self.titleLabel.fontName = self.font
        self.titleLabel.fontSize = self.myFontSize + 10
        self.titleLabel.position = CGPoint(x: scene.frame.origin.x + self.titleLabel.frame.width * 0.75, y: scene.frame.height - self.titleLabel.frame.height)
        self.addChild(self.titleLabel)
        
        self.backLabel = SKLabelNode(text: "Main Menu ->")
        self.backLabel.fontName = self.font
        self.backLabel.fontSize = self.myFontSize
        self.backLabel.position = CGPoint(x: scene.frame.width - self.backLabel.frame.width, y: scene.frame.origin.y + self.backLabel.frame.height / 2)
        self.backLabel.name = "BackButton"
        self.addChild(self.backLabel)
        
        self.friendLabel = SKLabelNode(text: " - Friendlies")
        self.friendLabel.fontName = self.font
        self.friendLabel.fontSize = self.myFontSize
        self.friendLabel.position = CGPoint(x: scene.frame.origin.x + self.friendLabel.frame.width * 0.85, y: scene.frame.height * 0.6 - self.friendLabel.frame.height / 2)
        self.addChild(self.friendLabel)
        
        self.playerLabel = SKLabelNode(text: " - Player")
        self.playerLabel.fontName = self.font
        self.playerLabel.fontSize = self.myFontSize
        self.playerLabel.position = CGPoint(x: scene.frame.origin.x + self.playerLabel.frame.width, y: scene.frame.height * 0.8 - self.playerLabel.frame.height / 2)
        self.addChild(self.playerLabel)
        
        
        self.enemyLabel = SKLabelNode(text: " - Enemies")
        self.enemyLabel.fontName = self.font
        self.enemyLabel.fontSize = self.myFontSize
        self.enemyLabel.position = CGPoint(x: scene.frame.origin.x + self.enemyLabel.frame.width * 0.9, y: scene.frame.height * 0.4 - self.enemyLabel.frame.height / 2)
        self.addChild(self.enemyLabel)
        
        self.powerUpsLabel = SKLabelNode(text: " - PowerUps")
        self.powerUpsLabel.fontName = self.font
        self.powerUpsLabel.fontSize = self.myFontSize
        self.powerUpsLabel.position = CGPoint(x: scene.frame.origin.x + self.powerUpsLabel.frame.width * 1.2, y: scene.frame.height * 0.2 - self.powerUpsLabel.frame.height / 2)
        self.addChild(self.powerUpsLabel)
        
        var rulesPosition = CGPoint(x: scene.frame.width * 0.2 + self.friendLabel.frame.width * 3.7, y: scene.frame.height - self.titleLabel.frame.height * 5)
        var rulesFontSize = self.myFontSize + 10
        self.rulesTitleLabel = SKLabelNode(text: "Rules:")
        self.rulesTitleLabel.fontName = self.font
        if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad {
            self.rulesTitleLabel.position = rulesPosition
            self.rulesTitleLabel.fontSize = rulesFontSize
            self.myFontSize = rulesFontSize
        } else {
            self.rulesTitleLabel.fontSize = self.myFontSize
            self.rulesTitleLabel.position = CGPoint(x: scene.frame.width * 0.2 + self.friendLabel.frame.width * 1.8, y: scene.frame.height - self.titleLabel.frame.height)
        }
        self.addChild(rulesTitleLabel)
        
        self.firstRuleLabel = SKLabelNode(text: "1. Move the player with your finger")
        self.firstRuleLabel.fontName = self.font
        self.firstRuleLabel.fontSize = self.myFontSize - 5
        self.firstRuleLabel.position = CGPoint(x: self.rulesTitleLabel.position.x, y: scene.frame.height * 0.75)
        self.addChild(firstRuleLabel)
        
        self.secondRuleLabel = SKLabelNode(text: "2. Avoid enemies at all costs")
        self.secondRuleLabel.fontName = self.font
        self.secondRuleLabel.fontSize = self.myFontSize - 5
        self.secondRuleLabel.position = CGPoint(x: self.rulesTitleLabel.position.x, y: self.firstRuleLabel.frame.origin.y - self.secondRuleLabel.frame.height * 1.5)
        self.addChild(secondRuleLabel)
        
        self.thirdRuleLabel = SKLabelNode(text: "3. Move the player into the")
        self.thirdRuleLabel.fontName = self.font
        self.thirdRuleLabel.fontSize = self.myFontSize - 5
        self.thirdRuleLabel.position = CGPoint(x: self.rulesTitleLabel.position.x, y: self.secondRuleLabel.frame.origin.y - self.thirdRuleLabel.frame.height * 1.5)
        self.addChild(thirdRuleLabel)
        
        self.thirdRuleLabelLine2 = SKLabelNode(text: "friendlies to accumulate points")
        self.thirdRuleLabelLine2.fontName = self.font
        self.thirdRuleLabelLine2.fontSize = self.myFontSize - 5
        self.thirdRuleLabelLine2.position = CGPoint(x: self.rulesTitleLabel.position.x, y: self.secondRuleLabel.frame.origin.y - self.thirdRuleLabel.frame.height * 2.5)
        self.addChild(thirdRuleLabelLine2)
        
        self.fourthRuleLabel = SKLabelNode(text: "4. Quickly grab the good powerups,")
        self.fourthRuleLabel.fontName = self.font
        self.fourthRuleLabel.fontSize = self.myFontSize - 5
        self.fourthRuleLabel.position = CGPoint(x: self.rulesTitleLabel.position.x, y: self.thirdRuleLabelLine2.frame.origin.y - self.fourthRuleLabel.frame.height * 1.5)
        self.addChild(self.fourthRuleLabel)
        
        self.fourthRuleLabelLine2 = SKLabelNode(text: "but try to avoid the bad ones")
        self.fourthRuleLabelLine2.fontName = self.font
        self.fourthRuleLabelLine2.fontSize = self.myFontSize - 5
        self.fourthRuleLabelLine2.position = CGPoint(x: self.rulesTitleLabel.position.x, y: self.fourthRuleLabel.frame.origin.y - self.fourthRuleLabelLine2.frame.height * 0.9)
        self.addChild(self.fourthRuleLabelLine2)
        
        self.fifthRuleLabel = SKLabelNode(text: "5. Profit!")
        self.fifthRuleLabel.fontName = self.font
        self.fifthRuleLabel.fontSize = self.myFontSize - 5
        self.fifthRuleLabel.position = CGPoint(x: self.rulesTitleLabel.position.x, y: self.fourthRuleLabelLine2.frame.origin.y - self.fifthRuleLabel.frame.height * 1.5)
        self.addChild(self.fifthRuleLabel)
        
        self.zPosition = 2.0
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
