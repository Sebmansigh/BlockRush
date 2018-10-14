//
//  EnableInput.swift
//  Block Rush
//
//  Created by Sebastian Snyder on 10/13/18.
//

import Foundation

extension GameEvent
{
    class EnableInput: GameEvent
    {
        var PlayerToEnable:Player!;
        var InputToEnable:Input!;
        public convenience init(scene s:GameScene,player p:Player,input i:Input)
        {
            self.init(scene:s,trigger:nil);
            PlayerToEnable = p;
            InputToEnable = i;
        }
        public convenience init(scene s:GameScene,player p:Player,input i:Input,trigger t:GameEventTrigger?)
        {
            self.init(scene:s,trigger:t);
            PlayerToEnable = p;
            InputToEnable = i;
        }
        public override init(scene s:GameScene, trigger t: GameEventTrigger?)
        {
            super.init(scene:s,trigger:t);
        }
        
        override func OnTrigger()
        {
            PlayerToEnable.EnableInput(input: InputToEnable);
        }
        override func AwaitTrigger()
        {
            
        }
    }
}
