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
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
    {
        
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
                    UIKeyCommand(input: UIKeyInputLeftArrow, modifierFlags: .init(rawValue: 0), action: #selector(AppDelegate.LeftMenu), discoverabilityTitle: "Cycle Options" ),
                    UIKeyCommand(input: UIKeyInputRightArrow, modifierFlags: .init(rawValue: 0), action: #selector(AppDelegate.RightMenu), discoverabilityTitle: "Cycle Options" ),
                    UIKeyCommand(input: UIKeyInputUpArrow, modifierFlags: .init(rawValue: 0), action: #selector(AppDelegate.UpMenu(sender:)), discoverabilityTitle: "Go Up" ),
                    UIKeyCommand(input: UIKeyInputDownArrow, modifierFlags: .init(rawValue: 0), action: #selector(AppDelegate.DownMenu(sender:)), discoverabilityTitle: "Go Down" ),
                    UIKeyCommand(input: "", modifierFlags: .command, action: #selector(AppDelegate.UnlockKeyboardControls(sender:)), discoverabilityTitle: "Unlock Keyboard Controls"),
                    //*
                    UIKeyCommand(input: "", modifierFlags: .shift, action: #selector(AppDelegate.BackMenu(sender:)), discoverabilityTitle: "Go Back" ),
                    UIKeyCommand(input: UIKeyInputEscape, modifierFlags: .init(rawValue: 0), action: #selector(AppDelegate.BackMenu(sender:)), discoverabilityTitle: "Go Back" )
                ];
            default:
            return [
                UIKeyCommand(input: UIKeyInputUpArrow, modifierFlags: .init(rawValue: 0), action: #selector(AppDelegate.UpMenu(sender:)), discoverabilityTitle: "Go Up" ),
                UIKeyCommand(input: UIKeyInputDownArrow, modifierFlags: .init(rawValue: 0), action: #selector(AppDelegate.DownMenu(sender:)), discoverabilityTitle: "Go Down" ),
                //*
                UIKeyCommand(input: " ", modifierFlags: .init(rawValue: 0), action: #selector(AppDelegate.ChooseMenu(sender:)), discoverabilityTitle: "Choose Option" ),
                UIKeyCommand(input: "\r", modifierFlags: .init(rawValue: 0), action: #selector(AppDelegate.ChooseMenu(sender:)), discoverabilityTitle: "Choose Option" ),
                UIKeyCommand(input: "", modifierFlags: .shift, action: #selector(AppDelegate.BackMenu(sender:)), discoverabilityTitle: "Go Back" ),
                UIKeyCommand(input: UIKeyInputEscape, modifierFlags: .init(rawValue: 0), action: #selector(AppDelegate.BackMenu(sender:)), discoverabilityTitle: "Go Back" )
            ];
            }
        }
        else if(BlockRush.Settings[.BottomPlayerControlType] == SettingOption.ControlType.KeyboardArrows)
        {
            return [
                UIKeyCommand(input: UIKeyInputLeftArrow, modifierFlags: .init(rawValue: 0), action: #selector(AppDelegate.LeftInput(sender:)), discoverabilityTitle: "Move Left" ),
                UIKeyCommand(input: UIKeyInputRightArrow, modifierFlags: .init(rawValue: 0), action: #selector(AppDelegate.RightInput(sender:)), discoverabilityTitle: "Move Right" ),
                UIKeyCommand(input: UIKeyInputUpArrow, modifierFlags: .init(rawValue: 0), action: #selector(AppDelegate.PlayInput(sender:)), discoverabilityTitle: "Play Piece" ),
                UIKeyCommand(input: UIKeyInputDownArrow, modifierFlags: .init(rawValue: 0), action: #selector(AppDelegate.FlipInput(sender:)), discoverabilityTitle: "Flip Piece" ),
                //*
                UIKeyCommand(input: " ", modifierFlags: .init(rawValue: 0), action: #selector(AppDelegate.PlayInput(sender:)), discoverabilityTitle: "Play Piece" ),
                UIKeyCommand(input: "", modifierFlags: UIKeyModifierFlags.shift, action: #selector(AppDelegate.FlipInput(sender:)), discoverabilityTitle: "Flip Piece" ),
                
                UIKeyCommand(input: UIKeyInputEscape, modifierFlags: .init(rawValue: 0), action: #selector(AppDelegate.PauseInput(sender:)), discoverabilityTitle: "Pause Game" ),
                //*/
            ];
        }
        else
        {
            return [];
        }
    }
    
    //Keyboard Game input.
    @objc func PlayInput(sender: UIKeyCommand)
    {
        KeyboardDevice.Device.pendingInput.append(.PLAY);
    }
    @objc func FlipInput(sender: UIKeyCommand)
    {
        KeyboardDevice.Device.pendingInput.append(.FLIP);
    }
    @objc func LeftInput(sender: UIKeyCommand)
    {
        KeyboardDevice.Device.pendingInput.append(.LEFT);
    }
    @objc func RightInput(sender: UIKeyCommand)
    {
        KeyboardDevice.Device.pendingInput.append(.RIGHT);
    }
    @objc func PauseInput(sender: UIKeyCommand)
    {
        if let s = (window!.rootViewController!.view as! SKView).scene as? GameScene
        {
            if(s.PauseButton != nil)
            {
                s.GamePause();
            }
        }
    }
    //Keyboard Menu input.
    @objc func BackMenu(sender: UIKeyCommand)
    {
        GameMenu.focusMenu?.MenuBackChoose();
    }
    @objc func ChooseMenu(sender: UIKeyCommand)
    {
        GameMenu.focusMenu?.MenuChoose();
    }
    @objc func UpMenu(sender: UIKeyCommand)
    {
        GameMenu.focusMenu?.MenuUp();
    }
    @objc func DownMenu(sender: UIKeyCommand)
    {
        GameMenu.focusMenu?.MenuDown();
    }
    @objc func LeftMenu(sender: UIKeyCommand)
    {
        GameMenu.focusMenu?.MenuLeft();
    }
    @objc func RightMenu(sender: UIKeyCommand)
    {
        GameMenu.focusMenu?.MenuRight();
    }
    
    @objc func UnlockKeyboardControls(sender: UIKeyCommand)
    {
        //if(BlockRush.Settings[.KeyboardControlsUnlocked]! == .False)
        //{
            BlockRush.Settings[.KeyboardControlsUnlocked] = .True;
            BlockRush.PopUp("Keyboard Controls Unlocked!");
            let cm = GameMenu.focusMenu! as! ControlMenu;
            cm.remakeSelectors();
            cm.show(node: cm.inNode!);
        //}
    }
}

