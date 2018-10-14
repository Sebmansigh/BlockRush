//
//  HideTopPlayer.swift
//  Block Rush
//
//  Created by Sebastian Snyder on 10/13/18.
//

import Foundation

extension GameEvent
{
    class HideTopPlayer: GameEvent
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
            Scene.playerTop!.Hide();
        }
        override func AwaitTrigger()
        {
            
        }
    }
    
    class HideBottomPlayer: GameEvent
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
            Scene.playerBottom!.Hide();
        }
        override func AwaitTrigger()
        {
            
        }
    }
}
