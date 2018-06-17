//
//  Player.swift
//  Block Rush
//
//  Created by Sebastian Snyder on 3/28/18.
//

import Foundation
import SpriteKit
import GameKit

/**
 A player on either side of the field
 */
class Player
{
    
    
    //INPUT LOGIC
    
    ///The most recently executed frame
    internal var curFrame: Int;
    ///The `InputDevice` from which to detect and execute game inputs.
    public let inputDevice: InputDevice;
    
    //GAME LOGIC
    ///The length of a chain in progress.
    public var chainLevel: Int;
    /**
     The total amount of movement a chain in progress has generated.
     This will be animated together with `PlayField`'s  `movePower` variable, but differs in that it the field won't move until the chain has resolved.
     (In short, the opponent can continue to play safely until the chain fully resolves.)
     */
    public var storedPower: Int;
    
    
    ///The other player
    weak public var foe: Player!;
    ///The random number generator to use to generate new pieces
    internal var generator: GKRandomDistribution;
    ///The current Active Piece the player can move in the game
    internal var readyPiece: Piece?;
    ///The frame at which to deliver the player's next piece
    internal var nextFrame: Int;
    ///Contains the next pieces to be delivered to the player.
    ///These are visible along the right side of the screen.
    internal var pieceQueue: Queue<Piece>;
    ///The grey background of the Time Gauge.
    internal var timeGaugeNode: SKSpriteNode;
    ///The colored portion of the Time Gauge.
    internal var timeGaugeBar: SKSpriteNode;
    
    ///Whether or not the playfield is accepting input from the player.
    ///The player can be frozen if, for instance, a chain from this player is resolving.
    private var frozen: Bool;
    ///The frame on which the player unfreezes, if `Unfreeze` has been called.
    private var unfreezeFrame: Int? = nil;
    
    ///Which column the player's active piece is over.
    public var columnOver = 3;
    ///Whether or not this player's loss condition has been met.
    public var hasLost = false;
    ///Whether or not this player has notified the playfield of its loss condition
    public var acceptedDefeat = false;
    
    ///How much of this player's Time Gauge is remaining.
    public var timeLeft = 1800;
    
    
    ///The `GameScene` in which the game is being played.
    internal unowned var scene: GameScene;
    
    internal init(rngSeed: UInt64, scene s: GameScene, device: InputDevice)
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
        
        timeGaugeNode.position.x =  BlockRush.GameWidth * 0.44;
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
    
    /**
     Generate a new piece and addit to the Piece Queue.
     */
    func GeneratePiece()
    {
        let x1 = generator.nextInt();
        let x2 = generator.nextInt();
        pieceQueue.enqueue(Piece(nFront:x1,nRear:x2));
    }
    
    /**
     Updates this player's UI elements.
     */
    func SceneUpdate()
    {
        fatalError("SceneUpdate() not implemented by a subclass");
    }
    
    /**
     Updates this player's Time Gauge UI elements.
     */
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
    
    /**
     Sets a piece as the Active Piece.
     - Parameter p: The piece to be set as the Active Piece.
     */
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
    
    /**
     Sets the location of the nodes of the Active Piece to be over the specified column.
     - Parameter n: The column number to put the piece over.
     */
    func PositionToColumn(_ n:Int)
    {
        fatalError("PositionToColumn(Int) not implemented by a subclass");
    }
    
    /**
     Sets the next piece in the Piece Queue to be the Active Piece and generate a new piece at the end of the Piece Queue.
     */
    func ReadyNext()
    {
        GainTime(180);
        
        let p = pieceQueue.dequeue();
        Ready(p);
        GeneratePiece();
        chainLevel = 0;
    }
    
    
    /**
     Places the current Active Piece onto the playfield.
     - Parameter field: The current playfield.
     */
    func Play(_ field: PlayField)
    {
        fatalError("Play(PlayField) not implemented by a subclass");
    }
    
    
    /**
     Sets this player's `frozen` property to `true`
     */
    func Freeze(untilFrame: Int)
    {
        frozen = true;
        unfreezeFrame = untilFrame;
    }
    
    /**
     Returns the value of this player's `frozen` property.
     - Returns: the value of this player's `frozen` property.
     */
    func isFrozen() -> Bool
    {
        return frozen;
    }
    
    /**
     Execute the effects of a given input on the given playfield.
     - Parameter input: The input to execute.
     - Parameter field: The playfield the game is played on.
     */
    func Execute(input: Input,field: PlayField)
    {
        fatalError("Execute(input:field:) not implemented by a subclass");
    }
    
    /**
     Add time to this player's time gauge.
     - Parameter t: The amount of time to gain.
     */
    func GainTime(_ t: Int)
    {
        timeLeft += t;
        if(timeLeft > 1800)
        {
            timeLeft = 1800;
        }
    }
    
    /**
     Executes this player's inputs up to a frame number.
     - Parameter targetFrame: the current game frame.
     - Parameter playfield: the field on which the game is played.
     - Returns: the most recent successful frame (if some frames haven't arrived yet) up to the passed in Int.
     */
    final func runTo(targetFrame: Int,playField: PlayField) -> Int
    {
        //print("STARTING AT FRAME "+String(curFrame)+"; RUNNING TO FRAME "+String(targetFrame));
        while(!acceptedDefeat && inputDevice.CanEval() && curFrame < targetFrame)
        {
            if(readyPiece != nil)
            {
                timeLeft -= 1;
            }
            
            inputDevice.EvalFrame();
            if(frozen)
            {
                if let f = unfreezeFrame
                {
                    if(curFrame == f)
                    {
                        frozen = false;
                        nextFrame = curFrame+1;
                        unfreezeFrame = nil;
                        if(self is BottomPlayer)
                        {
                            playField.movePower += storedPower;
                        }
                        else if(self is TopPlayer)
                        {
                            playField.movePower -= storedPower;
                        }
                        else
                        {
                            fatalError("wat?");
                        }
                        storedPower = 0;
                    }
                }
            }
            else if(curFrame == nextFrame)
            {
                hasLost = playField.DetectPlayerLoss(player: self);
                if(hasLost)
                {
                    if(foe.isFrozen())
                    {
                        nextFrame += 1;
                    }
                    else
                    {
                        acceptedDefeat = true;
                        playField.acceptDefeat(player: self,frame: curFrame);
                    }
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
