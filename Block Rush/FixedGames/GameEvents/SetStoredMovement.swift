//
//  EnableInput.swift
//  Block Rush
//
//  Created by Sebastian Snyder on 10/13/18.
//

import Foundation

extension GameEvent
{
    class SetStoredMovement: GameEvent
    {
        var Value: Int!;
        public convenience init(scene s:GameScene,value x:Int)
        {
            self.init(scene:s,trigger:nil);
            Value = x;
        }
        public convenience init(scene s:GameScene,value x:Int,trigger t:GameEventTrigger?)
        {
            self.init(scene:s,trigger:t);
            Value = x;
        }
        private override init(scene s:GameScene, trigger t: GameEventTrigger?)
        {
            super.init(scene:s,trigger:t);
        }
        
        override func OnTrigger()
        {
            Scene.playField!.movePower = Value;
        }
        override func AwaitTrigger()
        {
            
        }
    }
}
