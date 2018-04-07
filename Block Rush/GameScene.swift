//
//  GameScene.swift
//  Block Rush
//
//  Created by Sebastian Snyder on 3/25/18.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene
{
    class TouchDevice: InputDevice
    {
        public var pendingInput: [Input] = [];
        
        public override init() {super.init();}
        
        internal override func CanEval() -> Bool
        {
            return true;
        }
        
        internal override func Eval() -> UInt8
        {
            var ret: UInt8 = 0;
            for I in pendingInput
            {
                ret |= I.rawValue;
            }
            pendingInput = [];
            return ret;
        }
    }
    
    
    let BDevice = TouchDevice();
    let TDevice = TouchDevice();
    var BTarget: Int? = nil;
    var TTarget: Int? = nil;
    
    var backgroundGrid : SKShapeNode? = nil;
    var playerTop: Player?;
    var playerBottom: Player?;
    
    var playField : PlayField? = nil;
    
    override func sceneDidLoad()
    {
        if(playField != nil)
        {
            return;
        }
        /*
         
        for i in 4...16
        {
            print(BlockRush.CalculateDamage(chainLevel: 2, blocksCleared: i));
        }
        */
        //*
        
        BlockRush.GameWidth = UIScreen.main.nativeBounds.width;
        BlockRush.GameHeight = min(UIScreen.main.nativeBounds.height,UIScreen.main.nativeBounds.width*2);
        
        BlockRush.BlockWidth = min(BlockRush.GameWidth * 0.12,BlockRush.GameHeight/14);
        
        var seed: UInt64 = 0;
        arc4random_buf(&seed, MemoryLayout.size(ofValue: seed))
        playerTop = TopPlayer(rngSeed: seed, scene:self, device: TDevice);
        playerBottom = BottomPlayer(rngSeed: seed, scene:self, device: BDevice);
        backgroundGrid = SKShapeNode(rectOf: CGSize(width:BlockRush.BlockWidth*6, height:BlockRush.BlockWidth*10));
        backgroundGrid?.fillColor = UIColor.black;
        self.addChild(backgroundGrid!);
        playField = PlayField(cols:6, rows:46, playerTop:playerTop!, playerBottom:playerBottom!, scene:self);
        
        backgroundGrid?.zPosition = -1;
        //*/
        
        playField!.GameReady = true;
    }
    
    override func didMove(to view: SKView)
    {
        
    }
    
    var TopTouch: UITouch? = nil;
    var TopTouchFrames = 0;
    var TopStartPos = CGPoint.zero;
    
    var BottomTouch: UITouch? = nil;
    var BottomTouchFrames = 0;
    var BottomStartPos = CGPoint.zero;
    func touchDown(touch: UITouch)
    {
        let pos = touch.location(in: self)
        if(pos.y > 0)
        {
            TopTouch = touch;
            TopStartPos = pos;
            TTarget = 2+Int(round(pos.x / BlockRush.BlockWidth));
            TopTouchFrames = 0;
        }
        else if(pos.y < 0)
        {
            BottomTouch = touch;
            BottomStartPos = pos;
            BTarget = 2+Int(round(pos.x / BlockRush.BlockWidth));
            BottomTouchFrames = 0;
        }
    }
    
    
    func touchMoved(touch: UITouch)
    {
        if(touch == TopTouch)
        {
            TTarget = 2+Int(ceil(touch.location(in: self).x / BlockRush.BlockWidth));
        }
        else if(touch == BottomTouch)
        {
            BTarget = 2+Int(ceil(touch.location(in: self).x / BlockRush.BlockWidth));
        }
    }
    
    func touchUp(touch: UITouch)
    {
        let pos = touch.location(in: self);
        if(touch == TopTouch && playerTop != nil)
        {
            TTarget = nil;
            TopTouch = nil;
            if(TopStartPos.y-pos.y > BlockRush.BlockWidth*1.5)
            {
                TDevice.pendingInput.append(Input.PLAY);
            }
            else if(TopTouchFrames < 10)
            {
                TDevice.pendingInput.append(Input.FLIP);
            }
        }
        else if(touch == BottomTouch && playerBottom != nil)
        {
            BTarget = nil;
            BottomTouch = nil;
            if(pos.y-BottomStartPos.y > BlockRush.BlockWidth*1.5)
            {
                BDevice.pendingInput.append(Input.PLAY);
            }
            else if(BottomTouchFrames < 10)
            {
                BDevice.pendingInput.append(Input.FLIP);
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        for t in touches { self.touchDown(touch: t) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        for t in touches { self.touchMoved(touch: t); }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        for t in touches { self.touchUp(touch: t); }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        for t in touches { self.touchUp(touch: t); }
    }
    
    
    override func update(_ currentTime: TimeInterval)
    {
        if(playField != nil && playField!.GameReady)
        {
            if(BottomTouch != nil)
            {
                BottomTouchFrames += 1;
                if(BTarget != playerBottom!.columnOver)
                {
                    if(BTarget! < playerBottom!.columnOver)
                    {
                        BDevice.pendingInput.append(Input.LEFT);
                    }
                    else
                    {
                        BDevice.pendingInput.append(Input.RIGHT);
                    }
                }
            }
            if(TopTouch != nil)
            {
                TopTouchFrames += 1;
                if(TTarget != playerTop!.columnOver)
                {
                    if(TTarget! < playerTop!.columnOver)
                    {
                        TDevice.pendingInput.append(Input.RIGHT);
                    }
                    else
                    {
                        TDevice.pendingInput.append(Input.LEFT);
                    }
                }
            }
            let BFrame = playerBottom!.runTo(targetFrame: playField!.GameFrame,playField: playField!);
            let TFrame = playerTop!   .runTo(targetFrame: playField!.GameFrame,playField: playField!);
            // If neither player is less than 15 frames behind
            if((playField!.GameFrame - BFrame) < 15 && (playField!.GameFrame - TFrame < 15))
            //if(BFrame == TFrame)
            {
                playField!.AdvanceFrame();
                
            }
        }
        else
        {
            print("Game is not ready!");
        }
    }
}
