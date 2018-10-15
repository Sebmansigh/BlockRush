//
//  Stall.swift
//  Block Rush
//
//  Created by Sebastian Snyder on 10/13/18.
//

import Foundation

extension GameEvent
{
    class Stall: GameEvent
    {
        public convenience init(scene s:GameScene)
        {
            self.init(scene:s,trigger:nil);
        }
        public convenience init(scene s:GameScene,numFrames: Int)
        {
            self.init(scene:s,trigger:.Repeated(.OnGameFrameUpdate,numTimes: numFrames));
        }
        public override init(scene s:GameScene, trigger t: GameEventTrigger?)
        {
            super.init(scene:s,trigger:t);
        }
        
        override func OnTrigger()
        {
            
        }
        override func AwaitTrigger()
        {
            
        }
    }
}
