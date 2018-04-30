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
    internal var timeGaugeNode: SKSpriteNode;
    internal var timeGaugeBar: SKSpriteNode;
    private var frozen: Bool;
    public var columnOver = 3;
    public var hasLost = false;
    public var timeLeft = 1800;
    
    
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
        
        timeGaugeNode = SKSpriteNode(color: .gray,
                                 size: CGSize(width:BlockRush.BlockWidth/2, height: BlockRush.GameHeight/3));
        timeGaugeBar = timeGaugeNode.copy() as! SKSpriteNode;
        timeGaugeBar.color = .green;
        
        timeGaugeNode.position.x =  BlockRush.GameWidth * 0.45;
        timeGaugeNode.position.y = -BlockRush.GameHeight * (-0.3);
        
        let timeLabelNode = SKLabelNode(text:"TIME");
        timeLabelNode.fontName = "Avenir-Black";
        timeLabelNode.fontSize = BlockRush.BlockWidth*2/7;
        timeLabelNode.position.y = timeGaugeNode.size.height/2;
        timeLabelNode.zRotation = .pi;
        timeLabelNode.verticalAlignmentMode = .top;
        
        timeLabelNode.fontColor = .white;
        //
        
        inputDevice.player = self;
        
        for _ in 0...4
        {
            GeneratePiece();
        }
        
        timeGaugeNode.addChild(timeGaugeBar);
        timeGaugeNode.addChild(timeLabelNode);
        scene.addChild(timeGaugeNode);
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
        fatalError("SceneUpdate() not implemented by a subclass");
    }
    
    func TimeGaugeUpdate()
    {
        let ys = CGFloat(timeLeft)/1800
        timeGaugeBar.yScale = ys;
        timeGaugeBar.position.y = timeGaugeNode.size.height/2*(1-ys);
        
        timeGaugeNode.color = .gray;
        
        if(timeLeft <= 300)
        {
            timeGaugeBar.color = .red;
            if(curFrame % 30 == 0)
            {
                timeGaugeNode.color = .red;
            }
        }
        else if(timeLeft <= 600)
        {
            timeGaugeBar.color = .yellow;
        }
        else
        {
            timeGaugeBar.color = .green;
        }
    }
    
    func Ready(_ p: Piece)
    {
        fatalError("Ready(Piece) not implemented by a subclass");
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
        fatalError("PositionToColumn(Int) not implemented by a subclass");
    }
    
    func ReadyNext()
    {
        GainTime(180);
        
        let p = pieceQueue.dequeue();
        Ready(p);
        GeneratePiece();
        chainLevel = 0;
    }
    
    func Play(_ field: PlayField)
    {
        fatalError("Play(PlayField) not implemented by a subclass");
    }
    
    func Freeze()
    {
        frozen = true;
    }
    
    func Unfreeze() -> Int
    {
        if(frozen)
        {
            frozen = false;
            nextFrame = curFrame+10;
            
            let r = storedPower;
            storedPower = 0;
            return r;
        }
        else
        {
            return 0;
        }
    }
    
    func isFrozen() -> Bool
    {
        return frozen;
    }
    
    func Execute(input: Input,field: PlayField)
    {
        fatalError("Execute(input:field:) not implemented by a subclass");
    }
    
    func GainTime(_ t: Int)
    {
        timeLeft += t;
        if(timeLeft > 1800)
        {
            timeLeft = 1800;
        }
    }
    
    //Executes this player's inputs up to a frame number.
    //Returns the most recent successful frame (if some frames haven't arrived yet) up to the passed in Int.
    func runTo(targetFrame: Int,playField: PlayField) -> Int
    {
        //print("STARTING AT FRAME "+String(curFrame)+"; RUNNING TO FRAME "+String(targetFrame));
        while(inputDevice.CanEval() && curFrame < targetFrame)
        {
            if(readyPiece != nil)
            {
                timeLeft -= 1;
            }
            
            inputDevice.EvalFrame();
            if(curFrame == nextFrame && !frozen)
            {
                hasLost = playField.DetectPlayerLoss(player: self);
                if(hasLost)
                {
                    playField.acceptDefeat(player: self);
                }
                else
                {
                    ReadyNext();
                }
            }
            
            if(curFrame+1 == nextFrame && !frozen)
            {
                if(playField.StackMove(player: self))
                {
                    nextFrame += 1;
                }
            }
            
            for I in Input.ARRAY
            {
                if(inputDevice.Get(input: I))
                {
                    Execute(input: I,field: playField);
                }
            }
            //
            if(timeLeft <= 0)
            {
                Execute(input: .PLAY, field: playField);
                timeLeft = 0;
            }
            
            SceneUpdate();
            curFrame += 1;
        }
        return curFrame;
    }
}
