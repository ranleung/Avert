/*

Game initialization and Game Center methods

*/

import UIKit
import SpriteKit
import GameKit


class GameViewController: UIViewController, GKGameCenterControllerDelegate {

    var leaderboardIdentifier: String?
    var gameCenterEnabled: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Configure the view.
        let scene = GameScene(size: self.view.bounds.size)
        
        let skView = self.view as SKView
        skView.showsFPS = false
        skView.showsNodeCount = false
        
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true
        
        /* Set the scale mode to scale to fit the window */
        scene.scaleMode = .AspectFill
        
        scene.gameViewController = self
        skView.presentScene(scene)
        
        self.authenticateLocalPlayer()
        
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    // MARK - Game Center Functions
    
    func authenticateLocalPlayer() {
        let localPlayer = GKLocalPlayer.localPlayer()
        
        localPlayer.authenticateHandler = {(viewController: UIViewController?, error: NSError?) -> Void in
            if viewController != nil {
                self.presentViewController(viewController!, animated: true, completion: nil)
            } else {
                
                if localPlayer.authenticated {
                    self.gameCenterEnabled = true
                    
                    localPlayer.loadDefaultLeaderboardIdentifierWithCompletionHandler({ (leaderboardIdentifier, error) -> Void in
                        if error != nil {
                            println("\(error.description)")
                        } else {
                            self.leaderboardIdentifier = leaderboardIdentifier
                        }
                    })
                }
                else {
                    self.gameCenterEnabled = false
                }
            }
        }
    }
    
    func reportScore(intForScore: Int64, forLeaderboard: String) {
        var score = GKScore(leaderboardIdentifier: forLeaderboard)
        score.value = intForScore

        GKScore.reportScores([score], withCompletionHandler: { (error) -> Void in
            if error != nil {
                println(error.description)
            }
        })
    }
    
    func showLeaderBoardAndAchievements(shouldShowLeaderboard: Bool) {
        var gcViewController = GKGameCenterViewController()
        gcViewController.gameCenterDelegate = self
        if shouldShowLeaderboard == true {
            gcViewController.viewState = GKGameCenterViewControllerState.Leaderboards
            gcViewController.leaderboardIdentifier = self.leaderboardIdentifier
        } else {
            gcViewController.viewState = GKGameCenterViewControllerState.Achievements
        }
        self.presentViewController(gcViewController, animated: true, completion: nil)
    }
    
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController!) {
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
