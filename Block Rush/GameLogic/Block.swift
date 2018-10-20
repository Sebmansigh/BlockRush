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
    var col: Int?;
    let initCol: Int;
    let nod: SKSpriteNode;
    var CreditTop: Bool? = nil;
    var LockFrame: Int = -1;
    var iPos = -1;
    var jPos = -1;
    var debugLabel: SKLabelNode? = BlockRush.DEBUG_MODE ? SKLabelNode(fontNamed: "Avenir") : nil;
    init(nColor: Int)
    {
        col = nColor;
        initCol = nColor;
        //nod = SKShapeNode(rectOf: CGSize(width: BlockRush.BlockWidth, height: BlockRush.BlockWidth/2));
        nod = SKSpriteNode(texture: Block.CurrentTextureTheme()[col!],
                           color: Block.CurrentColorTheme()[col!],
                           size: CGSize(width: BlockRush.BlockWidth, height: BlockRush.BlockWidth/2));
        nod.colorBlendFactor = 1.0;
        if let ln = debugLabel
        {
            nod.addChild(ln);
            ln.fontSize = BlockRush.BlockWidth * 0.3;
            ln.verticalAlignmentMode = .center;
            ln.fontColor = .black;
        }
        nod.zPosition = 0;
    }
    var hashValue: Int
    {
        return nod.hashValue;
    }
    func blockColor() -> UIColor
    {
        return Block.CurrentColorTheme()[col!];
    }
    
    func blockTexture() -> SKTexture
    {
        return Block.CurrentTextureTheme()[col!];
    }
}
