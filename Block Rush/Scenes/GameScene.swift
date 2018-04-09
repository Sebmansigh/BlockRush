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
            
            let loc = touch.location(in: self);
            switch BlockRush.Settings[.TopPlayerControlType]!
            {
                
            case SettingOption.ControlType.TouchSlide:
                TTarget = 2+Int(ceil(loc.x / BlockRush.BlockWidth));
                
            case SettingOption.ControlType.TouchTap:
                if(loc.x > BlockRush.BlockWidth*3)
                {
                    TDevice.pendingInput.append(.LEFT)
                }
                else if(loc.x < BlockRush.BlockWidth * -3)
                {
                    TDevice.pendingInput.append(.RIGHT)
                }
                else
                {
                    BottomTouch  = nil;
                    if(loc.y <= BlockRush.BlockWidth*5)
                    {
                        TDevice.pendingInput.append(.PLAY)
                    }
                    else
                    {
                        TDevice.pendingInput.append(.FLIP)
                    }
                }
                
            case SettingOption.ControlType.TouchHybrid:
                if(loc.y <= BlockRush.BlockWidth*5)
                {
                    TDevice.pendingInput.append(.PLAY);
                    TopTouch = nil;
                }
                else
                {
                    TTarget = 2+Int(ceil(loc.x / BlockRush.BlockWidth));
                }
                
            default:
                break; //Non-touch control type
            }
            TopTouchFrames = 0;
        }
        else if(pos.y < 0)
        {
            BottomTouch = touch;
            BottomStartPos = pos;
            
            let loc = touch.location(in: self);
            switch BlockRush.Settings[.BottomPlayerControlType]!
            {
                
            case SettingOption.ControlType.TouchSlide:
                BTarget = 2+Int(ceil(loc.x / BlockRush.BlockWidth));
                
            case SettingOption.ControlType.TouchTap:
                if(loc.x > BlockRush.BlockWidth*3)
                {
                    BDevice.pendingInput.append(.RIGHT)
                }
                else if(loc.x < BlockRush.BlockWidth * -3)
                {
                    BDevice.pendingInput.append(.LEFT)
                }
                else
                {
                    BottomTouch  = nil;
                    if(loc.y >= -BlockRush.BlockWidth*5)
                    {
                        BDevice.pendingInput.append(.PLAY)
                    }
                    else
                    {
                        BDevice.pendingInput.append(.FLIP)
                    }
                }
                
            case SettingOption.ControlType.TouchHybrid:
                if(loc.y >= -BlockRush.BlockWidth*5)
                {
                    BDevice.pendingInput.append(.PLAY);
                    BottomTouch = nil;
                }
                else
                {
                    BTarget = 2+Int(ceil(loc.x / BlockRush.BlockWidth));
                }
                
            default:
                break; //Non-touch control type
            }
            BottomTouchFrames = 0;
        }
    }
    
    
    func touchMoved(touch: UITouch)
    {
        if(touch == TopTouch)
        {
            let loc = touch.location(in: self);
            switch BlockRush.Settings[.TopPlayerControlType]!
            {
                
            case SettingOption.ControlType.TouchSlide:
                TTarget = 2+Int(ceil(loc.x / BlockRush.BlockWidth));
                
            case SettingOption.ControlType.TouchTap:
                if(!(loc.x > BlockRush.BlockWidth*3) && !(loc.x < BlockRush.BlockWidth * -3))
                {
                    TopTouch = nil;
                }
                
            case SettingOption.ControlType.TouchHybrid:
                TTarget = 2+Int(ceil(loc.x / BlockRush.BlockWidth));
                
            default:
                break; //Non-touch control type
            }
        }
        else if(touch == BottomTouch)
        {
            let loc = touch.location(in: self);
            switch BlockRush.Settings[.BottomPlayerControlType]!
            {
                
            case SettingOption.ControlType.TouchSlide:
                BTarget = 2+Int(ceil(loc.x / BlockRush.BlockWidth));
                
            case SettingOption.ControlType.TouchTap:
                if(!(loc.x > BlockRush.BlockWidth*3) && !(loc.x < BlockRush.BlockWidth * -3))
                {
                    BottomTouch = nil;
                }
                
            case SettingOption.ControlType.TouchHybrid:
                BTarget = 2+Int(ceil(loc.x / BlockRush.BlockWidth));
                
            default:
                break; //Non-touch control type
            }
        }
    }
    
    func touchUp(touch: UITouch)
    {
        let pos = touch.location(in: self);
        if(touch == TopTouch && playerTop != nil)
        {
            switch BlockRush.Settings[.TopPlayerControlType]!
            {
                
            case SettingOption.ControlType.TouchSlide:
                if(TopStartPos.y-pos.y > BlockRush.BlockWidth*1.5)
                {
                    TDevice.pendingInput.append(.PLAY);
                }
                else if(TopTouchFrames < 10)
                {
                    TDevice.pendingInput.append(.FLIP);
                }
                TTarget = nil;
                TopTouchFrames = 0;
                
            case SettingOption.ControlType.TouchTap:
                TopTouch = nil;
                
            case SettingOption.ControlType.TouchHybrid:
                if(TopTouchFrames < 10)
                {
                    TDevice.pendingInput.append(.FLIP);
                }
                TopTouch = nil;
                TopTouchFrames = 0;
                
            default:
                break; //Non-touch control type
            }
            TopTouch = nil;
        }
        else if(touch == BottomTouch && playerBottom != nil)
        {
            switch BlockRush.Settings[.BottomPlayerControlType]!
            {
                
            case SettingOption.ControlType.TouchSlide:
                if(pos.y-BottomStartPos.y > BlockRush.BlockWidth*1.5)
                {
                    BDevice.pendingInput.append(.PLAY);
                }
                else if(BottomTouchFrames < 10)
                {
                    BDevice.pendingInput.append(.FLIP);
                }
                BTarget = nil;
                BottomTouchFrames = 0;
                
            case SettingOption.ControlType.TouchTap:
                BottomTouch = nil;
                
            case SettingOption.ControlType.TouchHybrid:
                if(BottomTouchFrames < 10)
                {
                    BDevice.pendingInput.append(.FLIP);
                }
                BTarget = nil;
                BottomTouchFrames = 0;
                
            default:
                break; //Non-touch control type
            }
        }
        BottomTouch = nil;
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
            switch BlockRush.Settings[.BottomPlayerControlType]!
            {
                
            case SettingOption.ControlType.TouchSlide:
                if(BottomTouch != nil)
                {
                    BottomTouchFrames += 1;
                    if(BTarget != playerBottom!.columnOver)
                    {
                        if(BTarget! < playerBottom!.columnOver)
                        {
                            BDevice.pendingInput.append(.LEFT);
                        }
                        else
                        {
                            BDevice.pendingInput.append(.RIGHT);
                        }
                    }
                }
                
            case SettingOption.ControlType.TouchTap:
                if(BottomTouch != nil)
                {
                    BottomTouchFrames += 1;
                    let loc = BottomTouch!.location(in: self);
                    if(BottomTouchFrames == 20)
                    {
                        if(loc.x > BlockRush.BlockWidth*3)
                        {
                            BDevice.pendingInput.append(.RIGHT)
                        }
                        else if(loc.x < BlockRush.BlockWidth * -3)
                        {
                            BDevice.pendingInput.append(.LEFT)
                        }
                        else
                        {
                            BottomTouch = nil;
                            break;
                        }
                        BottomTouchFrames = 17;
                    }
                }
                
            case SettingOption.ControlType.TouchHybrid:
                if(BottomTouch != nil)
                {
                    BottomTouchFrames += 1;
                    if(BTarget != playerBottom!.columnOver)
                    {
                        if(BTarget! < playerBottom!.columnOver)
                        {
                            BDevice.pendingInput.append(.LEFT);
                        }
                        else
                        {
                            BDevice.pendingInput.append(.RIGHT);
                        }
                    }
                }
                
            default:
                break; //Non-touch control type
            }
            
        
            switch BlockRush.Settings[.TopPlayerControlType]!
            {
                
            case SettingOption.ControlType.TouchSlide:
                if(TopTouch != nil)
                {
                    TopTouchFrames += 1;
                    if(TTarget != playerTop!.columnOver)
                    {
                        if(TTarget! < playerTop!.columnOver)
                        {
                            TDevice.pendingInput.append(.RIGHT);
                        }
                        else
                        {
                            TDevice.pendingInput.append(.LEFT);
                        }
                    }
                    
                }
                
            case SettingOption.ControlType.TouchTap:
                if(TopTouch != nil)
                {
                    TopTouchFrames += 1;
                    let loc = TopTouch!.location(in: self);
                    if(TopTouchFrames == 20)
                    {
                        if(loc.x > BlockRush.BlockWidth*3)
                        {
                            TDevice.pendingInput.append(.LEFT)
                        }
                        else if(loc.x < BlockRush.BlockWidth * -3)
                        {
                            TDevice.pendingInput.append(.RIGHT)
                        }
                        else
                        {
                            TopTouch = nil;
                            break;
                        }
                        TopTouchFrames = 17;
                    }
                }
                
            case SettingOption.ControlType.TouchHybrid:
                if(TopTouch != nil)
                {
                    TopTouchFrames += 1;
                    if(TTarget != playerTop!.columnOver)
                    {
                        if(TTarget! < playerTop!.columnOver)
                        {
                            TDevice.pendingInput.append(.RIGHT);
                        }
                        else
                        {
                            TDevice.pendingInput.append(.LEFT);
                        }
                    }
                    
                }
                
            default:
                break; //Non-touch control type
            }
            
            
            
            
            //Run game
            
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
