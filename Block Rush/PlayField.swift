//
//  PlayField.swift
//  Block Rush
//
//  Created by Sebastian Snyder on 3/26/18.
//

import Foundation
import SpriteKit

class PlayField
{
    var Field: [[Block?]]
    var GameFrame: Int;
    var GameReady: Bool;
    let CenterBar: SKSpriteNode;
    var TopMatches: [Int: Set<Block> ];
    var BtmMatches: [Int: Set<Block> ]
    var NilMatches: [Int: Set<Block> ];
    var playerTop: Player;
    var playerBottom: Player;
    
    init(cols:Int, rows:Int, playerTop t:Player, playerBottom b: Player, scene:SKScene)
    {
        GameFrame = 0;
        GameReady = false;
        
        TopMatches = [:];
        BtmMatches = [:];
        NilMatches = [:];
        
        playerTop = t;
        playerBottom = b;
        
        let inArr = Array<Block?>(repeating: nil, count:rows);
        Field = Array<Array<Block?>>(repeating: inArr, count:cols);
        CenterBar = SKSpriteNode(texture: nil,
                                 color: .white,
                                 size: CGSize(width: BlockRush.BlockWidth*6, height: 8));
        scene.addChild(CenterBar);
        CenterBar.zPosition = 2;
    }
    
    func columns() -> Int
    {
        return Field.count;
    }
    
    func rows() -> Int
    {
        return Field[0].count;
    }
    
    func PushBottom(column: Int, piece: Piece, frame: Int)
    {
        PushBottom(column:column, block:piece.FrontBlock, frame:frame);
        PushBottom(column:column, block:piece.RearBlock, frame:frame);
    }
    
    func PushBottom(column: Int, block: Block,frame: Int)
    {
        for i in rows()/2...rows()-1
        {
            if(Field[column][i] == nil)
            {
                block.nod.position = GetPosition(column:column,row:i);
                block.CreditTop = false;
                block.LockFrame = frame;
                Field[column][i] = block;
                block.iPos = column;
                block.jPos = i;
                return;
            }
        }
    }
    
    func PushTop(column: Int, piece: Piece, frame: Int)
    {
        PushTop(column:column, block:piece.FrontBlock, frame:frame);
        PushTop(column:column, block:piece.RearBlock, frame:frame);
    }
    
    func PushTop(column: Int, block: Block,frame: Int)
    {
        for i in (0...rows()/2-1).reversed()
        {
            if(Field[column][i] == nil)
            {
                block.nod.position = GetPosition(column:column,row:i);
                block.CreditTop = true;
                block.LockFrame = frame;
                Field[column][i] = block;
                block.iPos = column;
                block.jPos = i;
                return;
            }
        }
    }
    
    func GetPosition(column:Int,row:Int) -> CGPoint
    {
        let offsetRows = CGFloat(rows())/2;
        
        let pX = BlockRush.BlockWidth/2 + BlockRush.BlockWidth * CGFloat(column-3);
        let pY = BlockRush.BlockWidth * ((offsetRows-CGFloat(row))/2-0.25);
        
        return CGPoint(x: pX, y: pY);
    }
    
    func EvalChain(player: Player, numMatched: Int) -> Int
    {
        player.chainLevel += 1;
        let linkDamage = BlockRush.CalculateDamage(chainLevel: player.chainLevel, blocksCleared: numMatched)
        //
        return linkDamage;
    }
    
    func AnimChainTop(frame: Int)
    {
        
    }
    
    func AnimChainBottom(frame: Int)
    {
        
    }
    
    func AdvanceFrame()
    {
        let DoFrame = GameFrame-20;
        EvalMatches(frame: DoFrame);
        //
        AnimMatches(frame: DoFrame);
        let Fell = Cascade(frame: DoFrame);
        if(!Fell)
        {
            if(TopMatches.isEmpty)
            {
                playerTop.Unfreeze();
            }
            if(BtmMatches.isEmpty)
            {
                playerBottom.Unfreeze();
            }
        }
        //
        GameFrame += 1;
    }
    
    func ApplyMatch(blocks: [Block],frame: Int, creditTop: Bool?)
    {
        for block in blocks
        {
            block.nod.size.width*=1.2;
            block.nod.size.height*=1.2;
            block.nod.zPosition = 2;
        }
        if(creditTop == nil)
        {
            if(NilMatches[frame] == nil)
            {
                NilMatches[frame] = (Set<Block>()).union(blocks);
            }
            else
            {
                NilMatches[frame]!.formUnion(blocks);
            }
        }
        else if(creditTop! == true)
        {
            playerTop.Freeze();
            if(TopMatches[frame] == nil)
            {
                TopMatches[frame] = (Set<Block>()).union(blocks);
            }
            else
            {
                TopMatches[frame]!.formUnion(blocks);
            }
        }
        else
        {
            playerBottom.Freeze();
            if(BtmMatches[frame] == nil)
            {
                BtmMatches[frame] = (Set<Block>()).union(blocks);
            }
            else
            {
                BtmMatches[frame]!.formUnion(blocks);
            }
        }
    }
    
    func EvalMatches(frame: Int)
    {
        var TotalMatched: Set<Block> = [];
        //Detect Horizontal Matches
        
        let DetectVec = [(0,1),(1,0),(1,1),(1,-1)];
        for v in DetectVec
        {
            var DirMatched: Set<Block> = [];
            let x = v.0;
            let y = v.1;
            for i in 0...(columns()-1-3*x)
            {
                let s: [Int];
                if(y >= 0)
                {
                    s = (0...(rows()-1-3*y)).sorted();
                }
                else
                {
                    s = (-3*y...(rows()-1)).reversed();
                }
                for j in s
                {
                    if(Field[i][j] == nil)
                    {
                        continue;
                    }
                    if(Field[i][j]!.LockFrame > frame)
                    {
                        continue;
                    }
                    if(Field[i][j]!.col == nil)
                    {
                        continue;
                    }
                    let curBlk = Field[i][j]!;
                    if(DirMatched.contains(curBlk))
                    {
                        //If you've already matched in this direction on this block,
                        continue;
                    }
                    else
                    {
                        let MatchCol = curBlk.col;
                        var Matched = [curBlk];
                        var I = i+x;
                        var J = j+y;
                        while(I >= 0 && I < columns() && J >= 0 && J < rows() )
                        {
                            let NewBlk = Field[I][J];
                            if(NewBlk == nil || NewBlk!.col == nil || NewBlk!.col! != MatchCol)
                            {
                                break;
                            }
                            else if(NewBlk!.LockFrame > frame)
                            {
                                break;
                            }
                            else
                            {
                                Matched.append(NewBlk!);
                            }
                            I+=x;
                            J+=y;
                        }
                        if(Matched.count >= 4)
                        {
                            DirMatched.formUnion(Matched);
                            //credit match to proper player
                            var Mframe = -1;
                            var MplayerTop: Bool? = nil;
                            for b in Matched
                            {
                                if(b.LockFrame == Mframe)
                                {
                                    if(MplayerTop != b.CreditTop)
                                    {
                                        MplayerTop = nil;
                                    }
                                }
                                else if(b.LockFrame > Mframe)
                                {
                                    Mframe = b.LockFrame;
                                    MplayerTop = b.CreditTop;
                                }
                            }
                            ApplyMatch(blocks: Matched, frame: frame, creditTop: MplayerTop);
                        }
                    }
                }
            }
            TotalMatched.formUnion(DirMatched);
        }
        for block in TotalMatched
        {
            block.col = nil;
        }
    }
    
    private func AnimMatchesPartial(frame: Int, Matches: inout [Int:Set<Block>],CreditTop: Bool?)
    {
        let decayFactor: CGFloat = 0.92;
        let preFrames: Int = 30;
        let stayFrames: Int = 50;
        let endFrame: Int = 90;
        
        for (MatchFrame,S) in Matches
        {
            let AnimFrame = frame-MatchFrame;
            if(AnimFrame < preFrames)
            {
                continue;
            }
            if(AnimFrame == preFrames)
            {
                if(CreditTop != nil)
                {
                    let linkDamage: Int;
                    let p : Player;
                    if(CreditTop!)
                    {
                        print("TOP PLAYER-----");
                        p = playerTop;
                    }
                    else
                    {
                        print("BOTTOM PLAYER-----");
                        p = playerBottom;
                    }
                    linkDamage = EvalChain(player: p, numMatched: S.count);
                    print(String(p.chainLevel)+" CHAIN => "+String(linkDamage)+" DAMAGE!");
                }
            }
            if(CreditTop != nil)
            {
                if(CreditTop!)
                {
                    AnimChainTop(frame: frame)
                }
                else
                {
                    AnimChainBottom(frame: frame)
                }
            }
            for block in S
            {
                block.nod.color = .white;
                
                if(AnimFrame >= stayFrames)
                {
                    block.nod.alpha *= decayFactor;
                    block.nod.size.width *= decayFactor;
                    block.nod.size.height *= decayFactor;
                    if(AnimFrame == endFrame)
                    {
                        let I = block.iPos;
                        let J = block.jPos;
                        Field[I][J] = nil;
                        if(J <= rows()/2-1)
                        {
                            if(J-1 >= 0 && Field[I][J-1] != nil)
                            {
                                Field[I][J-1]?.CreditTop = CreditTop;
                            }
                        }
                        else
                        {
                            if(J+1 < rows() && Field[I][J+1] != nil)
                            {
                                Field[I][J+1]?.CreditTop = CreditTop;
                            }
                        }
                        block.nod.removeFromParent();
                    }
                }
            }
            if(AnimFrame == endFrame)
            {
                Matches[MatchFrame] = nil;
            }
        }
    }
    
    func AnimMatches(frame: Int)
    {
        AnimMatchesPartial(frame: frame, Matches: &TopMatches, CreditTop: true);
        AnimMatchesPartial(frame: frame, Matches: &BtmMatches, CreditTop: false);
        AnimMatchesPartial(frame: frame, Matches: &NilMatches, CreditTop: nil);
    }
    
    
    func Cascade(frame:Int) -> Bool
    {
        var ret = false;
        for i in 0...columns()-1
        {
            var jFrom = rows()/2-2;
            var Credit: Bool? = nil;
            var blockFell = false;
        columnBaseLoop:
            for jTo in (0...rows()/2-1).reversed()
            {
                if(Field[i][jTo] == nil)
                {
                    let block: Block;
                    while(Field[i][jFrom] == nil || jTo <= jFrom)
                    {
                        jFrom-=1;
                        if(jFrom == -1)
                        {
                            break columnBaseLoop;
                        }
                    }
                    block = Field[i][jFrom]!;
                    
                    if(block.col == nil)
                    {
                        continue;
                    }
                    if(!blockFell)
                    {
                        Credit = block.CreditTop;
                        blockFell = true
                        ret = true;
                    }
                    
                    block.CreditTop = Credit;
                    block.LockFrame = frame;
                    Field[i][jFrom] = nil;
                    
                    Field[i][jTo] = block;
                    block.nod.position = GetPosition(column:i,row:jTo);
                    block.iPos = i;
                    block.jPos = jTo;
                }
            }
            
            jFrom = rows()/2+1;
            blockFell = false;
            
        columnBaseLoop:
            for jTo in rows()/2...rows()-1
            {
                if(Field[i][jTo] == nil)
                {
                    let block: Block;
                    while(Field[i][jFrom] == nil || jTo >= jFrom)
                    {
                        jFrom+=1;
                        if(jFrom == rows())
                        {
                            break columnBaseLoop;
                        }
                    }
                    block = Field[i][jFrom]!;
                    
                    if(block.col == nil)
                    {
                        continue;
                    }
                    if(!blockFell)
                    {
                        Credit = block.CreditTop;
                        blockFell = true
                        ret = true;
                    }
                    
                    block.CreditTop = Credit;
                    block.LockFrame = frame;
                    
                    Field[i][jFrom] = nil;
                    
                    Field[i][jTo] = block;
                    block.nod.position = GetPosition(column:i,row:jTo);block.iPos = i;
                    block.jPos = jTo;
                }
            }
        }
        return ret;
    }
}
