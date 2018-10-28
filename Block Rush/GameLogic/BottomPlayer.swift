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
    public override init(rngSeed: UInt64, scene: GameScene, device: InputDevice)
    {
        super.init(rngSeed: rngSeed, scene: scene, device: device);
        timeGaugeNode.zRotation = .pi;
        timeGaugeNode.position.x *= -1;
        timeGaugeNode.position.y *= -1;
    }
    
    override func SceneUpdate()
    {
        TimeGaugeUpdate();
        
        var numShow = 5;
        if(!forcePieceQueue.isEmpty)
        {
            for i in 0...forcePieceQueue.count()-1
            {
                let sX = BlockRush.GameWidth * 0.45;
                let sY = BlockRush.GameHeight * (CGFloat(1-numShow)/10.0);
                let CenterPt = CGPoint(x: sX, y: sY);
                forcePieceQueue.peek(i).SceneAdd(scene: scene, position: CenterPt,reversed:true);
                numShow -= 1;
                if(numShow == 0)
                {
                    return;
                }
            }
        }
        for i in 0...pieceQueue.count()-1
        {
            let sX = BlockRush.GameWidth * 0.45;
            let sY = BlockRush.GameHeight * (CGFloat(1-numShow)/10.0);
            let CenterPt = CGPoint(x: sX, y: sY);
            pieceQueue.peek(i).SceneAdd(scene: scene, position: CenterPt,reversed:true);
            numShow -= 1;
            if(numShow == 0)
            {
                return;
            }
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
        Audio.PlaySound(name: "PlaySnap");
        readyPiece = nil;
        nextFrame = curFrame + 30;
        if case .Survival = field.gameScene.GameMode
        {
            field.gameScene.Score += 50;
        }
        else if case .TimeAttack = field.gameScene.GameMode
        {
            field.gameScene.Score += 50 * field.gameScene.Level;
        }
        
        GameEvent.Fire(.OnPlayerPlay);
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
            if(readyPiece != nil && columnOver != 0)
            {
                MoveToColumn(columnOver-1);
                Audio.PlaySound(name: "MoveTick");
                GameEvent.Fire(.OnPlayerMove);
            }
        case .RIGHT:
            if(readyPiece != nil && columnOver != 5)
            {
                MoveToColumn(columnOver+1);
                Audio.PlaySound(name: "MoveTick");
                GameEvent.Fire(.OnPlayerMove);
            }
        case .FLIP:
            if let rp = readyPiece
            {
                rp.Flip();
                GameEvent.Fire(.OnPlayerFlip);
            }
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
