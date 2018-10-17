//
//  NoviceBot.swift
//  Block Rush
//
//  Created by Sebastian Snyder on 10/13/18.
//

import Foundation

extension BotDevices
{
    class Novice: InputDevice,BotDevice
    {
    public override init() {};
    
    public override func debugText() -> String
    {
        return "NoviceBot";
    }
    
    override func CanEval() -> Bool
    {
        return true;
    }
        
    func ResetState()
    {
        FrameCt = 0;
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
                    let AtCol = playField!.SurfaceBlockAtColumn(column: t, player: player!)?.col;
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
}
