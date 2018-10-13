//
//  Dialogue.GameEvent.swift
//  Block Rush
//
//  Created by Sebastian Snyder on 10/13/18.
//

import Foundation
import SpriteKit

extension GameEvent
{
    class Dialogue: GameEvent
    {
        var label = SKLabelNode();
        
        public convenience init(text t: String)
        {
            self.init(nil);
            label = SKLabelNode(fontNamed: "Avenir");
            label.text = t;
        }
        public convenience init(label l: SKLabelNode)
        {
            self.init(nil);
            label = l;
        }
        public override init(_ t: ((GameScene) -> Bool)?)
        {
            super.init(t);
        }
        
        override func Execute(scene s: GameScene)
        {
            //
        }
    }
}
