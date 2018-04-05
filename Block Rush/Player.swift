//
//  Player.swift
//  Block Rush
//
//  Created by Sebastian Snyder on 3/28/18.
//

import Foundation
import SpriteKit
import GameKit

class Player
{
    public var chainLevel: Int;
    public var storedPower: Int;
    //INPUT LOGIC
    internal var curFrame: Int;      //The most recently executed frame
    internal let inputDevice: InputDevice;
    
    //GAME LOGIC
    internal var generator: GKRandomDistribution;
    internal var readyPiece: Piece?;
    internal var nextFrame: Int;     //The frame at which to deliver the player's next piece
    internal var pieceQueue: Queue<Piece>;
    private var frozen: Bool;
    public var columnOver = 3;
    
    //UI LOGIC
    internal var scene: SKScene;
    
    internal init(rngSeed: UInt64, scene s: SKScene, device: InputDevice)
    {
        let source = GKMersenneTwisterRandomSource(seed: rngSeed);
        generator = GKRandomDistribution(randomSource: source, lowestValue: 0, highestValue: BlockRush.BlockColors.count-1);
        pieceQueue = Queue<Piece>();
        scene = s;
        curFrame = 0;
        nextFrame = 200;
        readyPiece = nil;
        inputDevice = device;
        frozen = false;
        //
        chainLevel = 0;
        storedPower = 0;
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
        //Must override.
    }
    
    func Ready(_ p: Piece)
    {
        //Must override.
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
            PositionToColumn(n);
        }
    }
    
    func PositionToColumn(_ n:Int)
    {
        //Must override.
    }
    
    func ReadyNext()
    {
        let p = pieceQueue.dequeue();
        Ready(p);
        GeneratePiece();
        chainLevel = 0;
    }
    
    func Play(_ field: PlayField)
    {
        //Must override
    }
    
    func Freeze()
    {
        frozen = true;
    }
    
    func Unfreeze()
    {
        if(frozen)
        {
            frozen = false;
            nextFrame = curFrame+10;
        }
    }
    
    func Execute(input: Input,field: PlayField)
    {
        //Must override.
    }
    
    //Executes this player's inputs up to a frame number.
    //Returns the most recent successful frame (if some frames haven't arrived yet) up to the passed in Int.
    func runTo(targetFrame: Int,playField: PlayField) -> Int
    {
        //print("STARTING AT FRAME "+String(curFrame)+"; RUNNING TO FRAME "+String(targetFrame));
        while(inputDevice.CanEval() && curFrame < targetFrame)
        {
            inputDevice.EvalFrame();
            if(curFrame == nextFrame && !frozen)
            {
                ReadyNext();
            }
            
            for I in Input.ARRAY
            {
                if(inputDevice.Get(input: I))
                {
                    Execute(input: I,field: playField);
                }
            }
            //
            
            SceneUpdate();
            curFrame += 1;
        }
        return curFrame;
    }
}
