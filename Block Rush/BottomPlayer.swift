//
//  Player.swift
//  Block Rush
//
//  Created by Sebastian Snyder on 3/25/18.
//

import Foundation
import SpriteKit
import GameKit

class BottomPlayer: Player
{
    /*
    public override init(rngSeed: UInt64, scene: SKScene, device: InputDevice)
    {
        super.init(rngSeed: rngSeed, scene: scene, device: device);
    }
    */
    
    override func SceneUpdate()
    {
        for i in 0...pieceQueue.count()-1
        {
            let sX = BlockRush.GameWidth * 0.45;
            let sY = BlockRush.GameHeight * (CGFloat(i-4)/10.0);
            let CenterPt = CGPoint(x: sX, y: sY);
            pieceQueue.peek(i).SceneAdd(scene: scene, position: CenterPt,reversed:true);
        }
    }
    
    override func Ready(_ p: Piece)
    {
        if(readyPiece != nil)
        {
            fatalError("Piece already readied!");
        }
        readyPiece = p;
        columnOver = -1;
        MoveToColumn(3);
    }
    
    override func Play(_ field: PlayField)
    {
        field.PushBottom(column: columnOver, piece: readyPiece!, frame:curFrame);
        readyPiece = nil;
        nextFrame = curFrame + 30;
    }
    
    override func PositionToColumn(_ n:Int)
    {
        let pX = BlockRush.BlockWidth/2 + BlockRush.BlockWidth*CGFloat(n-3);
        readyPiece?.FrontBlock.nod.position = CGPoint(x: pX,
                                                      y:-scene.frame.height/2+BlockRush.BlockWidth);
        readyPiece?.RearBlock.nod.position = CGPoint(x: pX,
                                                     y:-scene.frame.height/2+BlockRush.BlockWidth/2);
    }
    
    override func Execute(input: Input, field: PlayField)
    {
        switch(input)
        {
        case .LEFT:
            MoveToColumn(columnOver-1);
        case .RIGHT:
            MoveToColumn(columnOver+1);
        case .FLIP:
            readyPiece?.Flip()
        case .PLAY:
            if(readyPiece != nil)
            {
                Play(field);
            }
        case .INPUT4:
            break;//Ignore
        case .INPUT5:
            break;//Ignore
        case .INPUT6:
            break;//Ignore
        case .INPUT7:
            break;//Ignore
        default:
            break;//Ignore
        }
    }
}
