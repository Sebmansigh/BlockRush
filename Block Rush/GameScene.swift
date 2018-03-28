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
    class BottomTouchDevice: InputDevice
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
    
    let BDevice = BottomTouchDevice();
    var BTarget: Int? = nil;
    
    var backgroundGrid : SKShapeNode? = nil;
    //var playerTop: Player?;
    var playerBottom: Player?;
    
    var playField : PlayField? = nil;
    
    var GameReady = false;
    var GameFrame: Int = 0;
    
    
    override func sceneDidLoad()
    {
        //*
        BlockRush.BlockWidth = frame.width * 0.12;
        
        var seed: UInt64 = 0;
        arc4random_buf(&seed, MemoryLayout.size(ofValue: seed))
        //playerTop = Player(rngSeed: seed, scene:self);
        playerBottom = Player(rngSeed: seed, scene:self, device: BDevice);
        backgroundGrid = SKShapeNode(rectOf: CGSize(width:BlockRush.BlockWidth*6, height:BlockRush.BlockWidth*10));
        backgroundGrid?.fillColor = UIColor.black;
        self.addChild(backgroundGrid!);
        playField = PlayField(cols:6,rows:20);
        
        backgroundGrid?.zPosition = -1;
        //*/
        
        GameReady = true;
    }
    
    override func didMove(to view: SKView)
    {
        
    }
    
    var numTouchDownFrames = 0;
    var startPos = CGPoint.zero;
    func touchDown(atPoint pos : CGPoint)
    {
        numTouchDownFrames = 0;
        startPos = pos;
        BTarget = 2+Int(pos.x / BlockRush.BlockWidth);
    }
    
    
    func touchMoved(toPoint pos : CGPoint)
    {
        BTarget = 2+Int(pos.x / BlockRush.BlockWidth);
    }
    
    func touchUp(atPoint pos : CGPoint)
    {
        if(playerBottom != nil)
        {
            BTarget = nil;
            if(pos.y-startPos.y > BlockRush.BlockWidth*1.5)
            {
                BDevice.pendingInput.append(Input.PLAY);
            }
            else if(numTouchDownFrames < 10)
            {
                BDevice.pendingInput.append(Input.FLIP);
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval)
    {
        if(GameReady)
        {
            if(BTarget != nil)
            {
                numTouchDownFrames = numTouchDownFrames+1;
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
            let _ = playerBottom!.runTo(targetFrame: GameFrame,playField: playField!);
            // Get most recent frame from player
            
            GameFrame+=1;
        }
        else
        {
            print("Game is not ready!");
        }
    }
}
