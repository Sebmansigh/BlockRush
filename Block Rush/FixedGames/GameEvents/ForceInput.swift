//
//  ForceInput.swift
//  Block Rush
//
//  Created by Sebastian Snyder on 10/13/18.
//

import Foundation
extension GameEvent
{
    class ForceInput: GameEvent
    {
        var PlayerToForce:Player!;
        var InputToForce:Input!;
        public convenience init(scene s:GameScene,player p:Player,input i:Input)
        {
            self.init(scene:s,trigger:nil);
            PlayerToForce = p;
            InputToForce = i;
        }
        public convenience init(scene s:GameScene,player p:Player,input i:Input,trigger t: GameEventTrigger?)
        {
            self.init(scene:s,trigger:t);
            PlayerToForce = p;
            InputToForce = i;
        }
        public override init(scene s:GameScene, trigger t: GameEventTrigger?)
        {
            super.init(scene:s,trigger:t);
        }
        
        override func OnTrigger()
        {
            PlayerToForce.forcedInputs.append(InputToForce);
        }
        override func AwaitTrigger()
        {
            
        }
    }
}
