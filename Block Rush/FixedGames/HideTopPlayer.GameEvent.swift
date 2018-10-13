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
        public convenience init()
        {
            self.init(nil);
        }
        public override init(_ t: ((GameScene) -> Bool)?)
        {
            super.init(t);
        }
        
        override func Execute(scene s: GameScene)
        {
            s.playerTop!.Hide();
        }
    }
}
