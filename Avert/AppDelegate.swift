//
//  AppDelegate.swift
//  Avert
//
//  Created by Randall Leung on 10/27/14.
//  Copyright (c) 2014 Randall. All rights reserved.
//

import UIKit
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var gameScene: GameScene?
    var audioSession = AVAudioSession.sharedInstance()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        // Check if the user is already playing music
        var audioAlreadyPlaying = self.audioSession?.otherAudioPlaying
        
        if audioAlreadyPlaying == true {
            var error: NSError?
            self.audioSession?.setCategory("AVAudioSessionCategoryAmbient", error: &error)
            if error != nil {
                println(error!.description)
            }
        } else {
            gameScene?.playMusic()
        }

        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        
        var audioAlreadyPlaying = self.audioSession?.otherAudioPlaying
        if audioAlreadyPlaying == true {
            var error: NSError?
            self.audioSession?.setCategory("AVAudioSessionCategoryAmbient", error: &error)
            if error != nil {
                println(error!.description)
            }
        } else {
            gameScene?.playMusic()
        }
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

