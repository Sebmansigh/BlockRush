//
//  Player.swift
//  Block Rush
//
//  Created by Sebastian Snyder on 3/25/18.
//

import Foundation
import SpriteKit
import GameKit

class Player
{
    let generator: GKRandomDistribution;
    let pieceQueue: Queue<Piece>;
    let scene: SKScene;
    
    var curFrame: Int;      //The most recently executed frame
    var nextFrame: Int;     //The frame at which to deliver the player's next piece
    var readyPiece: Piece?;
    var columnOver = 3;
    let inputDevice: InputDevice;
    
    init(rngSeed: UInt64, scene s: SKScene,device: InputDevice)
    {
        let source = GKMersenneTwisterRandomSource(seed: rngSeed);
        generator = GKRandomDistribution(randomSource: source, lowestValue: 0, highestValue: BlockRush.BlockColors.count-1);
        pieceQueue = Queue<Piece>();
        scene = s;
        curFrame = 0;
        nextFrame = 200;
        readyPiece = nil;
        inputDevice = device;
        //
        
        for _ in 0...4
        {
            GeneratePiece();
        }
        
        SceneUpdate();
        
    }
    
    func GeneratePiece()
    {
        let x1 = generator.nextInt();
        let x2 = generator.nextInt();
        pieceQueue.enqueue(Piece(nFront:x1,nRear:x2));
    }
    
    func SceneUpdate()
    {
        for i in 0...pieceQueue.count()-1
        {
            let sX = scene.frame.width * 0.45;
            let sY = scene.frame.height * (CGFloat(i-4)/10.0);
            let CenterPt = CGPoint(x: sX, y: sY);
            pieceQueue.peek(i).SceneAdd(scene: scene, position: CenterPt);
        }
    }
    
    func Ready(_ p: Piece)
    {
        readyPiece = p;
        columnOver = -1;
        MoveToColumn(3);
    }
    
    func ReadyNext()
    {
        let p = pieceQueue.dequeue();
        Ready(p);
        GeneratePiece();
    }
    
    func Play(_ field: PlayField)
    {
        field.Push(column: columnOver, piece: readyPiece!);
        readyPiece = nil;
        nextFrame = curFrame + 30;
    }
    
    func MoveToColumn(_ n:Int)
    {
        if(n < 0)
        {
            MoveToColumn(0);
        }
        else if(n > 5)
        {
            MoveToColumn(5);
        }
        else if(n != columnOver)
        {
            columnOver = n;
            let pX = BlockRush.BlockWidth/2 + BlockRush.BlockWidth*CGFloat(n-3);
            readyPiece?.FrontBlock.nod.position = CGPoint(x: pX,
                                                y:-scene.frame.height/2+BlockRush.BlockWidth);
            readyPiece?.RearBlock.nod.position = CGPoint(x: pX,
                                               y:-scene.frame.height/2+BlockRush.BlockWidth/2);
        }
    }
    
    //Executes this player's inputs up to a frame number.
    //Returns the most recent successful frame (if some frames haven't arrived yet) up to the passed in Int.
    func runTo(targetFrame: Int,playField: PlayField) -> Int
    {
        //print("STARTING AT FRAME "+String(curFrame)+"; RUNNING TO FRAME "+String(targetFrame));
        while(inputDevice.CanEval() && curFrame < targetFrame)
        {
            inputDevice.EvalFrame();
            if(curFrame == nextFrame)
            {
                ReadyNext();
            }
            
            if(inputDevice.Get(input: .LEFT))
            {
                print("Recieved LEFT  input!");
                MoveToColumn(columnOver-1);
            }
            if(inputDevice.Get(input: .RIGHT))
            {
                print("Recieved RIGHT input!");
                MoveToColumn(columnOver+1);
            }
            if(inputDevice.Get(input: .FLIP))
            {
                print("Recieved FLIP  input!");
                readyPiece?.Flip();
            }
            if(inputDevice.Get(input: .PLAY))
            {
                print("Recieved PLAY  input!");
                if(readyPiece != nil)
                {
                    Play(playField);
                }
            }
            //
            
            SceneUpdate();
            curFrame += 1;
        }
        return curFrame;
    }
}
