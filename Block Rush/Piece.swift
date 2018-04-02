//
//  Piece.swift
//  Block Rush
//
//  Created by Sebastian Snyder on 3/25/18.
//

import Foundation
import SpriteKit

class Piece
{
    var FrontBlock: Block;
    var RearBlock: Block;
    
    init(nFront: Int, nRear: Int)
    {
        FrontBlock = Block(nColor: nFront);
        RearBlock = Block(nColor: nRear);
        
    }
    
    func Flip()
    {
        swap(&FrontBlock,&RearBlock);
        swap(&(FrontBlock.nod.position),&(RearBlock.nod.position));
    }
    
    func SceneAdd(scene: SKScene, position: CGPoint)
    {
        SceneAdd(scene: scene, position: position, reversed: false)
    }
    
    func SceneAdd(scene: SKScene, position: CGPoint, reversed: Bool)
    {
        FrontBlock.nod.position = CGPoint(x:position.x, y:position.y - BlockRush.BlockWidth/4);
        RearBlock .nod.position = CGPoint(x:position.x, y:position.y + BlockRush.BlockWidth/4);
        
        FrontBlock.nod.removeFromParent();
        scene.addChild(FrontBlock.nod);
        
        RearBlock.nod.removeFromParent();
        scene.addChild(RearBlock.nod);
        
        if(reversed)
        {
            swap(&(FrontBlock.nod.position), &(RearBlock.nod.position));
        }
    }
}

class Block
{
    let col: Int;
    let nod: SKSpriteNode;
    init(nColor: Int)
    {
        col = nColor;
        //nod = SKShapeNode(rectOf: CGSize(width: BlockRush.BlockWidth, height: BlockRush.BlockWidth/2));
        nod = SKSpriteNode(texture: nil,
                           color: BlockRush.BlockColors[col],
                           size: CGSize(width: BlockRush.BlockWidth-2, height: BlockRush.BlockWidth/2-2));
        
        //nod.st
        nod.zPosition = 0;
    }
}
