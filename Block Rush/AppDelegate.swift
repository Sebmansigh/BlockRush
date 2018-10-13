//
//  AppDelegate.swift
//  Block Rush
//
//  Created by Sebastian Snyder on 3/25/18.
//

import UIKit
import SpriteKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{
    static var instance: AppDelegate!;
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
    {
        AppDelegate.instance = (UIApplication.shared.delegate as! AppDelegate)
        BlockRush.Initialize();
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    override var keyCommands: [UIKeyCommand]?
    {
        if(GameMenu.focusMenu != nil)
        {
            switch(GameMenu.focusMenu)
            {
            case is ControlMenu:
                return [
                    UIKeyCommand(input: UIKeyCommand.inputLeftArrow, modifierFlags: .init(rawValue: 0), action: #selector(AppDelegate.KBLeftMenu), discoverabilityTitle: "Cycle Options" ),
                    UIKeyCommand(input: UIKeyCommand.inputRightArrow, modifierFlags: .init(rawValue: 0), action: #selector(AppDelegate.KBRightMenu), discoverabilityTitle: "Cycle Options" ),
                    UIKeyCommand(input: UIKeyCommand.inputUpArrow, modifierFlags: .init(rawValue: 0), action: #selector(AppDelegate.KBUpMenu(sender:)), discoverabilityTitle: "Go Up" ),
                    UIKeyCommand(input: UIKeyCommand.inputDownArrow, modifierFlags: .init(rawValue: 0), action: #selector(AppDelegate.KBDownMenu(sender:)), discoverabilityTitle: "Go Down" ),
                    //*
                    UIKeyCommand(input: "", modifierFlags: .shift, action: #selector(AppDelegate.KBBackMenu(sender:)), discoverabilityTitle: "Go Back" ),
                    UIKeyCommand(input: UIKeyCommand.inputEscape, modifierFlags: .init(rawValue: 0), action: #selector(AppDelegate.KBBackMenu(sender:)), discoverabilityTitle: "Go Back" )
                ];
            default:
            return [
                UIKeyCommand(input: UIKeyCommand.inputUpArrow, modifierFlags: .init(rawValue: 0), action: #selector(AppDelegate.KBUpMenu(sender:)), discoverabilityTitle: "Go Up" ),
                UIKeyCommand(input: UIKeyCommand.inputDownArrow, modifierFlags: .init(rawValue: 0), action: #selector(AppDelegate.KBDownMenu(sender:)), discoverabilityTitle: "Go Down" ),
                //*
                UIKeyCommand(input: " ", modifierFlags: .init(rawValue: 0), action: #selector(AppDelegate.KBChooseMenu(sender:)), discoverabilityTitle: "Choose Option" ),
                UIKeyCommand(input: "\r", modifierFlags: .init(rawValue: 0), action: #selector(AppDelegate.KBChooseMenu(sender:)), discoverabilityTitle: "Choose Option" ),
                UIKeyCommand(input: "", modifierFlags: .shift, action: #selector(AppDelegate.KBBackMenu(sender:)), discoverabilityTitle: "Go Back" ),
                UIKeyCommand(input: UIKeyCommand.inputEscape, modifierFlags: .init(rawValue: 0), action: #selector(AppDelegate.KBBackMenu(sender:)), discoverabilityTitle: "Go Back" )
            ];
            }
        }
        else
        {
            return [
                UIKeyCommand(input: UIKeyCommand.inputLeftArrow, modifierFlags: .init(rawValue: 0), action: #selector(AppDelegate.KBLeftInput(sender:)), discoverabilityTitle: "Move Left" ),
                UIKeyCommand(input: UIKeyCommand.inputRightArrow, modifierFlags: .init(rawValue: 0), action: #selector(AppDelegate.KBRightInput(sender:)), discoverabilityTitle: "Move Right" ),
                UIKeyCommand(input: UIKeyCommand.inputUpArrow, modifierFlags: .init(rawValue: 0), action: #selector(AppDelegate.KBPlayInput(sender:)), discoverabilityTitle: "Play Piece" ),
                UIKeyCommand(input: UIKeyCommand.inputDownArrow, modifierFlags: .init(rawValue: 0), action: #selector(AppDelegate.KBFlipInput(sender:)), discoverabilityTitle: "Flip Piece" ),
                //*
                UIKeyCommand(input: " ", modifierFlags: .init(rawValue: 0), action: #selector(AppDelegate.KBPlayInput(sender:)), discoverabilityTitle: "Play Piece" ),
                UIKeyCommand(input: "", modifierFlags: UIKeyModifierFlags.shift, action: #selector(AppDelegate.KBFlipInput(sender:)), discoverabilityTitle: "Flip Piece" ),
                
                UIKeyCommand(input: UIKeyCommand.inputEscape, modifierFlags: .init(rawValue: 0), action: #selector(AppDelegate.KBPauseInput(sender:)), discoverabilityTitle: "Pause Game" ),
                //*/
            ];
        }
    }
    
    //Game input.
    static func HumanInput(_ input: Input,forTopPlayer: Bool)
    {
        if let s = (AppDelegate.instance.window!.rootViewController!.view as! SKView).scene as? GameScene
        {
            let p = forTopPlayer ? s.playerTop! : s.playerBottom!;
            
            p.inputDevice.pendingInput.append(input);
        }
    }
    @objc func KBPlayInput(sender: UIKeyCommand)
    {
        AppDelegate.HumanInput(.PLAY,forTopPlayer: false);
    }
    @objc func KBFlipInput(sender: UIKeyCommand)
    {
        AppDelegate.HumanInput(.FLIP,forTopPlayer: false);
    }
    @objc func KBLeftInput(sender: UIKeyCommand)
    {
        AppDelegate.HumanInput(.LEFT,forTopPlayer: false);
    }
    @objc func KBRightInput(sender: UIKeyCommand)
    {
        AppDelegate.HumanInput(.RIGHT,forTopPlayer: false);
    }
    
    static func HumanPauseInput()
    {
        if let s = (AppDelegate.instance.window!.rootViewController!.view as! SKView).scene as? GameScene
        {
            if(s.PauseButton != nil)
            {
                s.GamePause();
            }
        }
    }
    @objc func KBPauseInput(sender: UIKeyCommand)
    {
        if let s = (window!.rootViewController!.view as! SKView).scene as? GameScene
        {
            if(s.PauseButton != nil)
            {
                s.GamePause();
            }
        }
    }
    
    
    //Menu input.
    static func BackMenu()
    {
        GameMenu.focusMenu?.MenuBackChoose();
    }
    @objc func KBBackMenu(sender: UIKeyCommand)
    {
        AppDelegate.BackMenu();
    }
    
    static func ChooseMenu()
    {
        GameMenu.focusMenu?.MenuChoose();
    }
    @objc func KBChooseMenu(sender: UIKeyCommand)
    {
        AppDelegate.ChooseMenu();
    }
    
    static func UpMenu()
    {
        GameMenu.focusMenu?.MenuUp();
    }
    @objc func KBUpMenu(sender: UIKeyCommand)
    {
        AppDelegate.UpMenu();
    }
    
    static func DownMenu()
    {
        GameMenu.focusMenu?.MenuDown();
    }
    @objc func KBDownMenu(sender: UIKeyCommand)
    {
        AppDelegate.DownMenu();
    }
    static func LeftMenu()
    {
        GameMenu.focusMenu?.MenuLeft();
    }
    @objc func KBLeftMenu(sender: UIKeyCommand)
    {
        AppDelegate.LeftMenu();
    }
    
    static func RightMenu()
    {
        GameMenu.focusMenu?.MenuRight();
    }
    @objc func KBRightMenu(sender: UIKeyCommand)
    {
        AppDelegate.RightMenu();
    }
    
    
}

