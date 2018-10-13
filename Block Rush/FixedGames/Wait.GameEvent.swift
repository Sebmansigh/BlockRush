//
//  Wait.swift
//  Block Rush
//
//  Created by Sebastian Snyder on 10/13/18.
//

import Foundation

extension GameEvent
{
    class Wait: GameEvent
    {
        public convenience init(_ frames: Int)
        {
            var framesLeft = frames;
            self.init(
            { (s: GameScene) -> Bool in
                framesLeft -= 1;
                return framesLeft == 0;
            });
        }
        
        private override init(_ t: ((GameScene) -> Bool)?)
        {
            super.init(t);
        }
        
        override func Execute(scene s: GameScene)
        {
        }
    }
}
