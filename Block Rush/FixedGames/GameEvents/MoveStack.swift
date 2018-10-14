//
//  MoveField.swift
//  Block Rush
//
//  Created by Sebastian Snyder on 10/13/18.
//

import Foundation

extension GameEvent
{
    class MoveStack: GameEvent
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
            Scene.playerTop!.readyPiece = nil;
            Scene.playerTop!.Freeze();
        }
        override func AwaitTrigger()
        {
            
        }
    }
}
