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
    init(cols:Int,rows:Int)
    {
        let inArr = Array<Block?>(repeating: nil, count:rows);
        Field = Array<Array<Block?>>(repeating: inArr, count:cols);
    }
    
    func columns() -> Int {
        return Field.count;
    }
    
    func rows() -> Int {
        return Field[0].count;
    }
    
    func Push(column: Int, piece: Piece)
    {
        Push(column:column,block:piece.FrontBlock);
        Push(column:column,block:piece.RearBlock);
    }
    
    func Push(column: Int, block: Block)
    {
        for i in 0...rows()-1
        {
            if(Field[column][i] == nil)
            {
                block.nod.position = GetPosition(column:column,row:i);
                Field[column][i] = block;
                return;
            }
        }
    }
    func GetPosition(column:Int,row:Int) -> CGPoint
    {
        let pX = BlockRush.BlockWidth/2 + BlockRush.BlockWidth * CGFloat(column-3);
        let pY = BlockRush.BlockWidth * ((10-CGFloat(row))/2-0.25);
        return CGPoint(x: pX, y: pY);
    }
}
