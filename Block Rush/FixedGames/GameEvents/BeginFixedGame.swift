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
    class BeginFixedGame: GameEvent
    {
        var Name:String!;
        public convenience init(scene s:GameScene,name:String)
        {
            self.init(scene:s,trigger:nil);
            Name = name;
        }
        public convenience init(scene s:GameScene,name:String,trigger t:GameEventTrigger?)
        {
            self.init(scene:s,trigger:t);
            Name = name;
        }
        private override init(scene s:GameScene,trigger t: GameEventTrigger?)
        {
            super.init(scene:s,trigger:t);
        }
        
        override func OnTrigger()
        {
            GameMenu.focusMenu = nil;
            if let scene = SKScene(fileNamed: "GameScene") as? GameScene
            {
                // Set the scale mode to scale to fit the window
                scene.size = CGSize(width: UIScreen.main.nativeBounds.width,
                                    height: UIScreen.main.nativeBounds.height);
                scene.scaleMode = .aspectFit;
                
                scene.BottomPlayerType = .Local;
                scene.TopPlayerType = .None;
                scene.GameMode = .Fixed(name: Name);
                
                arc4random_buf(&scene.InitialSeed, MemoryLayout.size(ofValue: scene.InitialSeed));
                Audio.StopMusic();
                Scene.view!.presentScene(scene, transition: SKTransition.fade(withDuration: 2));
            }
            else
            {
                fatalError("Could not load GameScene.");
            }
        }
        override func AwaitTrigger()
        {
            
        }
    }
}
