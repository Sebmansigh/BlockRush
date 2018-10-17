//
//  AdeptBot.swift
//  Block Rush
//
//  Created by Sebastian Snyder on 10/13/18.
//

import Foundation

extension BotDevice
{
    public class Adept: InputDevice
    {
        public override init() {};
        
        public override func debugText() -> String
        {
            return "AdeptBot";
        }
        
        override func CanEval() -> Bool
        {
            return true;
        }
        
        var Decision: Int = -1;
        
        private func MakeDecision() -> (Int,Bool)
        {
            let ActivePiece:Piece;
            if let p = player!.readyPiece
            {
                ActivePiece = p;
            }
            else
            {
                return (-1,false);
            }
            var Best = (4,false);
            var BestScore = -1;
            
            let surfaceData = playField!.getSurfaceData(player!);
            let moveAdjustment:Int
            do
            {
                var x = playField!.moveAmount / 16;
                if player! is BottomPlayer
                {
                    x = -x;
                }
                moveAdjustment = x;
            }
            
            for i in 0...5
            {
                //Don't consider a move that puts you in game over status
                if(surfaceData[i]+moveAdjustment > 10)
                {
                    continue;
                }
                //
                for flip in [true,false]
                {
                    let frontCol = flip ? ActivePiece.FrontBlock.col : ActivePiece.RearBlock.col;
                    let rearCol  = flip ? ActivePiece.RearBlock.col : ActivePiece.FrontBlock.col;
                    var Score = 0;
                    
                    
                    
                    if(Score > BestScore)
                    {
                        Best = (i,flip);
                        BestScore = Score;
                    }
                }
            }
            return Best;
        }
        
        var FrameCt: Int = 0;
        
        override func Eval() -> UInt8
        {
            var FlipPiece = false;
            if(player!.isFrozen() || player!.readyPiece == nil)
            {
                return 0;
            }
            FrameCt += 1;
            
            var ret = Input.NONE;
            
            if(Decision != -1)
            {
                let x = MakeDecision();
                if(x.0 == -1)
                {
                    return 0;
                }
                Decision = x.0;
                FlipPiece = x.1;
            }
            
            //
            
            var inputRate = 30;
            if(player!.timeLeft < 500)
            {
                inputRate = 20;
            }
            if(player!.timeLeft < 200)
            {
                inputRate = 10;
            }
            
            //inputRate = 2;
            
            if(FrameCt % inputRate == 0)
            {
                //print("Surface state before input: "+String(describing: surfaceData));
                if(FlipPiece)
                {
                    ret = Input.FLIP;
                }
                else if(player!.columnOver == Decision)
                {
                    if(player!.readyPiece == nil)
                    {
                        ret = Input.NONE;
                    }
                    else
                    {
                        ret = Input.PLAY;
                        Decision = -1;
                    }
                }
                else if(player!.columnOver < Decision)
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
