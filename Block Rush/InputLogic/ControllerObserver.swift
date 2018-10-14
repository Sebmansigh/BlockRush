//
//  ControllerObserver.swift
//  Block Rush
//
//  Created by Sebastian Snyder on 6/15/18.
//

import Foundation
import GameController
import SpriteKit

final class ControllerObserver
{
    public static let Observer = ControllerObserver();
    //private static var BottomDAS: Date? = nil;
    //private static var TopDAS: Date? = nil;
    private var BottomDASCount: Int = 0;
    private var BottomDASInput: Input = .NONE;
    private var TopDASCount: Int = 0;
    private var TopDASInput: Input = .NONE;
    
    private init(){}
    
    //Controller support
    func startControllerInterfacing()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(ControllerObserver.connectControllers), name: NSNotification.Name.GCControllerDidConnect, object: nil);
        
        NotificationCenter.default.addObserver(self, selector: #selector(ControllerObserver.disconnectedController), name: NSNotification.Name.GCControllerDidDisconnect, object: nil);
        
    }
    @objc func connectControllers()
    {
        for controller in GCController.controllers()
        {
            controller.playerIndex = .indexUnset;
            if(controller1 == nil)
            {
                controller1 = controller;
                controller.playerIndex = .index1;
            }
            else if(controller2 == nil)
            {
                controller2 = controller;
                controller.playerIndex = .index2;
            }
            else
            {
                controller.playerIndex = .indexUnset;
                controller.extendedGamepad?.valueChangedHandler = nil;
                controller.gamepad?.valueChangedHandler = nil;
                controller.microGamepad?.valueChangedHandler = nil;
                return;
            }
            //
            if(controller.playerIndex == .index1)
            {
                BlockRush.PopUp("Controller 1 Connected");
            }
            else// if(controller.playerIndex == .index2)
            {
                BlockRush.PopUp("Controller 2 Connected");
            }
            //
            if(controller.extendedGamepad != nil)
            {
                controller.extendedGamepad!.valueChangedHandler = nil;
                setUpExtendedController(controller);
            }
            else if(controller.gamepad != nil)
            {
                controller.gamepad!.valueChangedHandler = nil;
                setUpStandardController(controller);
            }
            else if(controller.microGamepad != nil)
            {
                controller.microGamepad!.valueChangedHandler = nil;
                setUpMicroController(controller);
            }
            else
            {
                BlockRush.PopUp("Wut?");
            }
        }
    }
    @objc func disconnectedController()
    {
        var conn1 = controller1 == nil;
        var conn2 = controller2 == nil;
        for controller in GCController.controllers()
        {
            if(controller == controller1)
            {
                conn1 = true;
            }
            else if(controller == controller2)
            {
                conn2 = true;
            }
        }
        if(conn1 && conn2)
        {
            return;
        }
        else if(!conn1)
        {
            controller1 = nil;
            BlockRush.PopUp("Controller 1 Disonnected.");
            EndDAS(false);
        }
        else if(!conn2)
        {
            controller2 = nil;
            BlockRush.PopUp("Controller 2 Disonnected.");
            EndDAS(true);
        }
        AppDelegate.HumanPauseInput();
    }
    
    func DASInput(_ input: Input, forTopPlayer: Bool)
    {
        //let start = Date();
        //let s = (AppDelegate.instance.window!.rootViewController!.view as! SKView).scene as! GameScene;
        
        AppDelegate.HumanInput(input, forTopPlayer: forTopPlayer);
        
        if(forTopPlayer)
        {
            if(TopDASInput != .NONE)
            {
                EndDAS(true);
            }
            TopDASInput = input;
        }
        else
        {
            if(BottomDASInput != .NONE)
            {
                EndDAS(false);
            }
            BottomDASInput = input;
        }
    }
    
    func EndDAS(_ forTopPlayer: Bool)
    {
        if(forTopPlayer)
        {
            TopDASInput = .NONE;
            TopDASCount = 0;
        }
        else
        {
            BottomDASInput = .NONE;
            BottomDASCount = 0;
        }
    }
 
    static func UpdateDAS()
    {
        Observer.UpdateDAS();
    }
    
    func UpdateDAS()
    {
        if(TopDASInput != .NONE)
        {
            TopDASCount += 1;
            if(TopDASCount >= 15)
            {
                if(TopDASCount % 3 == 0)
                {
                    AppDelegate.HumanInput(TopDASInput, forTopPlayer: true);
                }
            }
        }
        
        if(BottomDASInput != .NONE)
        {
            BottomDASCount += 1;
            if(BottomDASCount >= 15)
            {
                if(BottomDASCount % 3 == 0)
                {
                    AppDelegate.HumanInput(BottomDASInput, forTopPlayer: false);
                }
            }
        }
    }
    
    
    func setUpDpad(_ dpad: GCControllerDirectionPad, forTopPlayer: Bool)
    {
        dpad.left.pressedChangedHandler = {
            (button: GCControllerButtonInput, value: Float, pressed: Bool) in
            if(pressed)
            {
                if(GameMenu.focusMenu != nil)
                {
                    AppDelegate.LeftMenu();
                }
                else
                {
                    self.DASInput(.LEFT,forTopPlayer: forTopPlayer);
                }
            }
            else
            {
                self.EndDAS(forTopPlayer);
            }
        };
        dpad.right.pressedChangedHandler = {
            (button: GCControllerButtonInput, value: Float, pressed: Bool) in
            if(pressed)
            {
                if(GameMenu.focusMenu != nil)
                {
                    AppDelegate.RightMenu();
                }
                else
                {
                    self.DASInput(.RIGHT,forTopPlayer: forTopPlayer);
                }
            }
            else
            {
                self.EndDAS(forTopPlayer);
            }
        };
        dpad.up.pressedChangedHandler = {
            (button: GCControllerButtonInput, value: Float, pressed: Bool) in
            if(pressed)
            {
                if(GameMenu.focusMenu != nil)
                {
                    AppDelegate.UpMenu();
                }
                else
                {
                    AppDelegate.HumanInput(.PLAY, forTopPlayer: forTopPlayer);
                }
            }
        };
        dpad.down.pressedChangedHandler = {
            (button: GCControllerButtonInput, value: Float, pressed: Bool) in
            if(pressed)
            {
                if(GameMenu.focusMenu != nil)
                {
                    AppDelegate.DownMenu();
                }
                else
                {
                    AppDelegate.HumanInput(.FLIP, forTopPlayer: forTopPlayer);
                }
            }
        };
    }
    
    func setUpFace(confirm:[GCControllerButtonInput],cancel:[GCControllerButtonInput], forTopPlayer: Bool)
    {
        for B in confirm
        {
            B.pressedChangedHandler = {
                (button: GCControllerButtonInput, value: Float, pressed: Bool) in
                if(pressed)
                {
                    if(GameMenu.focusMenu != nil)
                    {
                        AppDelegate.ChooseMenu();
                    }
                    else
                    {
                        AppDelegate.HumanInput(.PLAY, forTopPlayer: forTopPlayer);
                    }
                    //
                    GameEvent.Fire(.OnScreenTap);
                }
            }
        }
        
        for B in cancel
        {
            B.pressedChangedHandler = {
                (button: GCControllerButtonInput, value: Float, pressed: Bool) in
                if(pressed)
                {
                    if(GameMenu.focusMenu != nil)
                    {
                        AppDelegate.BackMenu();
                    }
                    else
                    {
                        AppDelegate.HumanInput(.FLIP, forTopPlayer: forTopPlayer);
                    }
                }
            }
        }
    }
    
    func setUpAxes(_ gp: GCExtendedGamepad, forTopPlayer: Bool)
    {
        var Xpress: Bool? = nil;
        var Ypress: Bool? = nil;
        let X_BAR: Float = 0.5;
        let Y_BAR: Float = 0.5;
        
        gp.leftThumbstick.valueChangedHandler = {
            (dpad: GCControllerDirectionPad, valueX: Float, valueY: Float) in
            if let dir = Xpress
            {
                if(dir)
                {
                    if(valueX < X_BAR)
                    {
                        Xpress = nil;
                        self.EndDAS(forTopPlayer);
                    }
                }
                else
                {
                    if(valueX > -X_BAR)
                    {
                        Xpress = nil;
                        self.EndDAS(forTopPlayer);
                    }
                }
            }
            else
            {
                if(valueX <= -X_BAR)
                {
                    Xpress = false;
                    if(GameMenu.focusMenu != nil)
                    {
                        AppDelegate.LeftMenu();
                    }
                    else
                    {
                        self.DASInput(.LEFT,forTopPlayer: forTopPlayer);
                    }
                }
                else if(valueX >= X_BAR)
                {
                    Xpress = true;
                    if(GameMenu.focusMenu != nil)
                    {
                        AppDelegate.RightMenu();
                    }
                    else
                    {
                        self.DASInput(.RIGHT,forTopPlayer: forTopPlayer);
                    }
                }
            }
            
            if let dir = Ypress
            {
                if(dir)
                {
                    if(valueY < Y_BAR)
                    {
                        Ypress = nil;
                    }
                }
                else
                {
                    if(valueY > -Y_BAR)
                    {
                        Ypress = nil;
                    }
                }
            }
            else
            {
                if(valueY <= -Y_BAR)
                {
                    Ypress = false;
                    if(GameMenu.focusMenu != nil)
                    {
                        AppDelegate.DownMenu();
                    }
                    else
                    {
                        AppDelegate.HumanInput(.FLIP, forTopPlayer: forTopPlayer);
                    }
                    
                }
                else if(valueY >= Y_BAR)
                {
                    Ypress = true;
                    if(GameMenu.focusMenu != nil)
                    {
                        AppDelegate.UpMenu();
                    }
                    else
                    {
                        AppDelegate.HumanInput(.PLAY, forTopPlayer: forTopPlayer);
                    }
                }
            }
        }
    }
    
    var controller1: GCController? = nil;
    var controller2: GCController? = nil;
    
    func setUpExtendedController(_ controller:GCController)
    {
        let gp = controller.extendedGamepad!;
        setUpDpad(gp.dpad,forTopPlayer: controller == controller2);
        setUpFace(confirm: [gp.buttonA,gp.buttonY], cancel: [gp.buttonB,gp.buttonX],forTopPlayer: controller == controller2);
        setUpAxes(gp,forTopPlayer: controller == controller2);
        gp.controller!.controllerPausedHandler = {
            (_: GCController) in
            AppDelegate.HumanPauseInput();
        }
    }
    func setUpStandardController(_ controller:GCController)
    {
        let gp = controller.gamepad!;
        setUpDpad(gp.dpad,forTopPlayer: controller == controller2);
        setUpFace(confirm: [gp.buttonA,gp.buttonY], cancel: [gp.buttonB,gp.buttonX],forTopPlayer: controller == controller2);
        gp.controller!.controllerPausedHandler = {
            (_: GCController) in
            AppDelegate.HumanPauseInput();
        }
    }
    func setUpMicroController(_ controller:GCController)
    {
        let gp = controller.microGamepad!;
        setUpDpad(gp.dpad,forTopPlayer: controller == controller2);
        setUpFace(confirm: [gp.buttonA], cancel: [gp.buttonX],forTopPlayer: controller == controller2);
        gp.controller!.controllerPausedHandler = {
            (_: GCController) in
            AppDelegate.HumanPauseInput();
        }
    }
    
    private static var initialized = false;
    static func initializeControllers()
    {
        if(!initialized)
        {
            Observer.connectControllers();
            Observer.startControllerInterfacing();
            initialized = true;
        }
    }
}
