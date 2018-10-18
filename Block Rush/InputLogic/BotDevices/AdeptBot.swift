//
//  AdeptBot.swift
//  Block Rush
//
//  Created by Sebastian Snyder on 10/13/18.
//

import Foundation

extension BotDevices
{
    public class Adept: InputDevice, BotDevice
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
        
        ///Which column to play in. -1 if undecided
        var Decision: Int = -1;
        ///The block that causes the chain to clear if removed
        var Trigger: Block? = nil;
        /// The blocks in the second link of the chain.
        var InChain = [Block]();
        ///Which direction a match should be made from in order to clear the chain.
        var TriggerDir: (Int,Int) = (0,0);
        
        //Doesn't work 100% yet.
        private func MakeDecision() -> (Int,Bool)
        {
            if let t = Trigger
            {
                var forget = false;
                if(t.col == -1)
                {
                    forget = true;
                }
                //if any blocks in the chain link have been cleared, forget the chain.
                if(!forget)
                {
                    for c in InChain
                    {
                        if(c.col == -1)
                        {
                            forget = true;
                            break;
                        }
                    }
                }
                if(forget)
                {
                    Trigger = nil;
                    InChain = [];
                    TriggerDir = (0,0);
                }
            }
            let ActivePiece:Piece;
            if let p = player!.readyPiece
            {
                ActivePiece = p;
            }
            else
            {
                return (-1,false);
            }
            
            //If all scores are -1(death), then accept your fate by playing in column 4.
            var BestMove = (4,false);
            var BestScore = -1;
            
            let surfaceData = playField!.getSurfaceData(player!);
            let moveAdjustment:Int;
            //
            let pieceMatch: (Int,Int,Int) -> ([Block],Int)
            do
            {
                var x = playField!.moveAmount / 16;
                if player! is BottomPlayer
                {
                    x = -x;
                    pieceMatch = playField!.PieceMatchesBottom;
                }
                else
                {
                    pieceMatch = playField!.PieceMatchesTop;
                }
                moveAdjustment = x;
            }
            
            ////Implementation note: currently only works if Bot is Top player. Will fix in the future.
            
            for i in 0...5
            {
                var OverTop = false;
                //Don't consider a move that puts you in game over status if you have a move that doesn't
                if(surfaceData[i]+moveAdjustment >= 9)
                {
                    if(BestScore > -1)
                    {
                        continue;
                    }
                    else
                    {
                        OverTop = true;
                    }
                }
                //
                for flip in [false,true]
                {
                    let frontCol = flip ? ActivePiece.FrontBlock.col! : ActivePiece.RearBlock.col!;
                    let rearCol  = flip ? ActivePiece.RearBlock.col! : ActivePiece.FrontBlock.col!;
                    
                    if(frontCol == rearCol)
                    {
                        if(flip) //The cases are identical.
                        {
                            break;
                        }
                    }
                    
                    var Score = 100;
                    if(OverTop)
                    {
                        Score = -1;
                    }
                    //If matches are made in this choice, add twice the number of blocks cleared to the score
                    //  If the trigger is in the blocks matched, add 20 to the score
                    //    If blocks from the second chain link are in this set, deduct 100 from the score
                    //Otherwise, if this choice extends the trigger, add 30 to the score
                    //Otherwise, if this choice creates a new, uninterfered chain link, add 40 to the score
                    //  If the stack has 6 or more blocks of height, deduct 50 from the score.
                    //Otherwise, if the trigger is interfered with, deduct 100 from the score.
                    //Otherwise, look at the field to determine how to make a match part larger
                    
                    let PotentialData = pieceMatch(i,frontCol,rearCol);
                    let MatchBlocks = PotentialData.0;
                    if(!MatchBlocks.isEmpty)
                    {
                        print("Match deteced!");
                        Score += MatchBlocks.count*2;
                        if let t = Trigger,
                           MatchBlocks.contains(t)
                        {
                            Score+=30;
                            for chainblock in InChain
                            {
                                if(MatchBlocks.contains(chainblock))
                                {
                                    Score -= 100;
                                    break;
                                }
                            }
                        }
                    }
                    else
                    {
                        Score += PotentialData.1-surfaceData[i]*2;
                    }
                    
                    //
                    if(Score > BestScore)
                    {
                        BestMove = (i,flip);
                        BestScore = Score;
                    }
                }
            }
            print("Best Move found \(BestMove) with score \(BestScore)")
            return BestMove;
        }
        
        var FrameCt: Int = 0;
        
        override func Eval() -> UInt8
        {
            //print("EVAL CALLED ON ADEPT BOT");
            var FlipPiece = false;
            if(player!.isFrozen() || player!.readyPiece == nil)
            {
                return 0;
            }
            FrameCt += 1;
            
            var ret = Input.NONE;
            
            if(Decision == -1)
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
        
        func ResetState()
        {
            Decision = -1;
            Trigger = nil;
            InChain = [];
            TriggerDir = (0,0);
        }
    }
    
    
}
