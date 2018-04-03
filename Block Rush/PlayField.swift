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
    
    init(cols:Int, rows:Int, scene:SKScene)
    {
        GameFrame = 0;
        GameReady = false;
        
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
    
    func AdvanceFrame()
    {
        GameFrame += 1;
        var TotalMatched: Set<Block> = [];
        //Detect Horizontal Matches
        
        let DetectVec = [(0,1),(1,0),(1,1)];
        for v in DetectVec
        {
            var DirMatched: Set<Block> = [];
            let x = v.0;
            let y = v.1;
            for i in 0...(columns()-1-3*x)
            {
                for j in 0...(rows()-1-3*y)
                {
                    if(Field[i][j] == nil)
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
                        while(I < columns() && j < rows())
                        {
                            let NewBlk = Field[I][J];
                            if(NewBlk == nil || NewBlk!.col != MatchCol)
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
                        }
                    }
                }
            }
            TotalMatched.formUnion(DirMatched);
        }
        for n in TotalMatched
        {
            n.nod.color = .cyan;
        }
    }
}
