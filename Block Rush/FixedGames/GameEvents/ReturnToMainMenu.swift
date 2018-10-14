//
//  ReturnToMainMenu.swift
//  Block Rush
//
//  Created by Sebastian Snyder on 10/13/18.
//

import Foundation
//
//  DisableAllInputs.swift
//  Block Rush
//
//  Created by Sebastian Snyder on 10/13/18.
//

import Foundation
import SpriteKit

extension GameEvent
{
    class ReturnToMainMenu: GameEvent
    {
        public convenience init(scene s:GameScene)
        {
            self.init(scene:s,trigger:nil);
        }
        public override init(scene s:GameScene, trigger t: GameEventTrigger?)
        {
            super.init(scene:s,trigger:t);
        }
        
        override func OnTrigger()
        {
            GameMenu.focusMenu = nil;
            let GameScene = Scene;
            if let scene = SKScene(fileNamed: "MainMenuScene")
            {
                // Set the scale mode to scale to fit the window
                scene.size = CGSize(width: UIScreen.main.nativeBounds.width,
                                    height: UIScreen.main.nativeBounds.height);
                scene.scaleMode = .aspectFit;
                
                GameScene.view!.presentScene(scene, transition: SKTransition.fade(withDuration: 2));
            }
            else
            {
                fatalError("Could not load MainMenuScene.");
            }
        }
        override func AwaitTrigger()
        {
            
        }
    }
}
