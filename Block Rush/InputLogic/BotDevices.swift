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
            var ret = Input.NONE;
            
            //
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
            var inputRate = 100;
            if(player!.timeLeft < 500)
            {
                inputRate = 70;
            }
            if(player!.timeLeft < 200)
            {
                inputRate = 40;
            }
            
            //inputRate = 2;
            
            if(FrameCt % inputRate == 0)
            {
                //print("Surface state before input: "+String(describing: surfaceData));
                if(player!.columnOver == t)
                {
                    if(player!.readyPiece == nil)
                    {
                        return 0;
                    }
                    else if let r = player!.readyPiece
                    {
                        let AtCol = playField!.TopBlockAtColumn(column: t, player: player!)?.col;
                        if(r.FrontBlock.col == AtCol)
                        {
                            ret = Input.PLAY;
                        }
                        else if(r.RearBlock.col == AtCol)
                        {
                            ret = Input.FLIP;
                        }
                        else
                        {
                            ret = Input.PLAY;
                        }
                    }
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
