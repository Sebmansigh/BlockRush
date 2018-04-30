//
//  BotDevices.swift
//  Block Rush
//
//  Created by Sebastian Snyder on 4/28/18.
//

import Foundation

final class BotDevice
{
    private init(){}
    
    public class Novice: InputDevice
    {
        public override init() {};
        
        override func CanEval() -> Bool
        {
            return true;
        }
        
        var FrameCt: Int = 0;
        
        override func Eval() -> UInt8
        {
            if(player!.isFrozen() || player!.readyPiece == nil)
            {
                return 0;
            }
            FrameCt += 1;
            //
            var ret = Input.NONE;
            var t = 0;
            var min = playField!.rows();
            
            let surfaceData = playField!.getSurfaceData(player!);
            for i in 0...playField!.columns()-1
            {
                if(surfaceData[i] < min)
                {
                    t = i;
                    min = surfaceData[i];
                }
            }
            if(FrameCt % 20 == 0)
            {
                if(player!.columnOver == t)
                {
                    ret = Input.PLAY;
                }
                else if(player!.columnOver < t)
                {
                    if(player === playField!.playerBottom)
                    {
                        ret = Input.RIGHT;
                    }
                    else
                    {
                        ret = Input.LEFT;
                    }
                }
                else
                {
                    if(player === playField!.playerBottom)
                    {
                        ret = Input.LEFT;
                    }
                    else
                    {
                        ret = Input.RIGHT;
                    }
                }
            }
            
            //
            return ret.rawValue;
        }
    }
    
    public class Adept: InputDevice
    {
        public override init() {fatalError("Adept Bot is not ready to play.");};
    }
    
    public class Expert: InputDevice
    {
        public override init() {fatalError("Expert Bot is not ready to play.");};
    }
    
    public class Master: InputDevice
    {
        public override init() {fatalError("Master Bot is not ready to play.");};
    }
}
