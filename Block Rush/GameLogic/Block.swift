//
//  Block.swift
//  Block Rush
//
//  Created by Sebastian Snyder on 4/2/18.
//

import Foundation
import SpriteKit

class Block:Hashable
{
    static func ==(lhs: Block, rhs: Block) -> Bool
    {
        return lhs === rhs;
    }
    
    var col: Int?;
    let initCol: Int;
    let nod: SKSpriteNode;
    var CreditTop: Bool? = nil;
    var LockFrame: Int = -1;
    var iPos = -1;
    var jPos = -1;
    init(nColor: Int)
    {
        col = nColor;
        initCol = nColor;
        //nod = SKShapeNode(rectOf: CGSize(width: BlockRush.BlockWidth, height: BlockRush.BlockWidth/2));
        nod = SKSpriteNode(texture: nil,
                           color: BlockRush.BlockColors[col!],
                           size: CGSize(width: BlockRush.BlockWidth-2, height: BlockRush.BlockWidth/2-2));
        
        //nod.st
        nod.zPosition = 0;
    }
    var hashValue: Int
    {
        return (initCol*initCol*initCol)+(nod.hashValue)+LockFrame;
    }
}