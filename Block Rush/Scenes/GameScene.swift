//
//  GameScene.swift
//  Block Rush
//
//  Created by Sebastian Snyder on 3/25/18.
//

import SpriteKit
import GameplayKit

/**
 The scene in which a round of block rush is played.
 */
class GameScene: SKScene
{
    ///Whether or not to advance the game forward
    public var Paused: Bool = false;

    /**
     The type of the top player.
     
     This variable is to be set before the scene is presented and its value is used in the initialization of the game scene.
     */
    public var BottomPlayerType: PlayerType = .None;
    /**
     The type of the bottom player.
     
     This variable is to be set before the scene is presented and its value is used in the initialization of the game scene.
     */
    public var TopPlayerType: PlayerType = .None;
    /**
     The initial seed of the piece sequences.
     
     This variable is to be set before the scene is presented and its value is used in the initialization of the game scene.
     */
    public var InitialSeed: UInt64 = 0;
    /**
     The name of the demo game, if this game is a demo game.
     
     This variable is to be set before the scene is presented and its value is used in the initialization of the game scene.
     */
    public var ReplayName: String? = nil;
    
    
    
    /**
     A touch device for _potential_ use by the bottom player.
     
     If the bottom player is using a different touch device, then
     this input device will not affect the game.
     */
    private let BDevice = TouchDevice();
    /**
     A touch device for _potential_ use by the top player.
     
     If the top player is using a different touch device, then
     this input device will not affect the game.
     */
    private let TDevice = TouchDevice();
    /**
     The column that the bottom player's touch device should seek.
     */
    var BTarget: Int? = nil;
    /**
     The column that the top player's touch device should seek.
     */
    var TTarget: Int? = nil;
    
    /**
     The black rectangle with white border that defines the boundary of the play area.
     */
    var backgroundGrid : SKShapeNode? = nil;
    /**
     The top player.
     */
    var playerTop: Player?;
    /**
     The bottom player.
     */
    var playerBottom: Player?;
    
    /**
     The playfield.
     */
    var playField : PlayField? = nil;
    
    /**
     Whether or not the game has ended
     */
    var EndGame = false;
    
    /**
     A node that contains the menu to be shown when the game ends
     */
    var EndMenuNode: SKNode?;
    /**
     The menu to be shown when the game ends
     */
    var EndMenu: GameMenu?;
    
    /**
     If the game is pausable, holds a reference to the pause button
     */
    var PauseButton: SKSpriteNode? = nil;
    /**
     A node that contains the menu to be shown when the game is paused
     */
    var PauseMenuNode: SKNode?;
    /**
     The menu to be shown when the game is paused
     */
    var PauseMenu: GameMenu?;
    
    
    // Variables to be used during the debug process.
    var DebugNodeTop = SKLabelNode(fontNamed: "Avenir");
    var DebugTopObj: Any? = nil;
    var DebugNodeBottom = SKLabelNode(fontNamed: "Avenir");
    var DebugBottomObj: Any? = nil;
    
    var DebugNodeTopColumn = [SKLabelNode?](repeating: nil, count: 6);
    var DebugNodeBottomColumn = [SKLabelNode?](repeating: nil, count: 6);
    
    deinit
    {
        print("Deallocated GameScene");
    }
    
    override func sceneDidLoad()
    {
        if(BottomPlayerType == .None && TopPlayerType == .None)
        {
            return;
        }
        if(playField != nil)
        {
            return;
        }
        
        
        if(BlockRush.DEBUG_MODE)
        {
            DebugNodeTop.position.y = BlockRush.ScreenHeight/2-32;
            DebugNodeTop.verticalAlignmentMode = .center
            addChild(DebugNodeTop);
            
            DebugNodeBottom.position.y = -BlockRush.ScreenHeight/2+32;
            DebugNodeBottom.verticalAlignmentMode = .center
            addChild(DebugNodeBottom);
            for i in 0...5
            {
                let n = SKLabelNode(fontNamed: "Avenir");
                DebugNodeTopColumn[i] = n;
                n.text = "0 =";
                n.fontColor = .white;
                n.fontSize = BlockRush.BlockWidth * 0.3;
                n.position.y = BlockRush.BlockWidth * 5;
                n.position.x = BlockRush.BlockWidth * (CGFloat(i)-2.5);
                addChild(n);
            }
            for i in 0...5
            {
                let n = SKLabelNode(fontNamed: "Avenir");
                DebugNodeBottomColumn[i] = n;
                n.text = "0 =";
                n.fontColor = .white;
                n.fontSize = BlockRush.BlockWidth * 0.3;
                n.position.y = BlockRush.BlockWidth * -5;
                n.position.x = BlockRush.BlockWidth * (CGFloat(i)-2.5);
                addChild(n);
            }
        }
        BlockRush.SoundScene = self;
        
        let TopDevice: InputDevice;
        var Data: (UInt64,[Input],[Input])? = nil;
        if(ReplayName != nil)
        {
            Data = DemoGame.Get(ReplayName!);
            InitialSeed = Data!.0;
        }
        switch TopPlayerType
        {
        case .Local:
            TopDevice = TDevice;
            CreatePauseButton();
        case .Replay:
            TopDevice = DelayedDevice(device: ReplayDevice(Data!.2), frames:15);
            CreatePauseButton();
        case .BotNovice:
            TopDevice = BotDevice.Novice();
            CreatePauseButton();
        case .BotAdept:
            TopDevice = BotDevice.Adept();
            CreatePauseButton();
        case .BotExpert:
            TopDevice = BotDevice.Expert();
            CreatePauseButton();
        case .BotMaster:
            TopDevice = BotDevice.Master();
            CreatePauseButton();
        default:
            fatalError("Unkown Top Player Type: "+String(describing: TopPlayerType));
        }
        
        let BottomDevice: InputDevice;
        switch BottomPlayerType
        {
        case .Local:
            if(BlockRush.Settings[.BottomPlayerControlType]! == SettingOption.ControlType.KeyboardArrows)
            {
                KeyboardDevice.Device.pendingInput = [];
                BottomDevice = KeyboardDevice.Device;
            }
            else
            {
                BottomDevice = BDevice;
            }
        case .Replay:
            BottomDevice = ReplayDevice(Data!.1);
        case .BotNovice:
            BottomDevice = BotDevice.Novice();
        case .BotAdept:
            BottomDevice = BotDevice.Adept();
        case .BotExpert:
            BottomDevice = BotDevice.Expert();
        case .BotMaster:
            BottomDevice = BotDevice.Master();
        default:
            fatalError("Unkown Bottom Player Type: "+String(describing: TopPlayerType));
        }
        
        DebugTopObj = TopDevice;
        DebugBottomObj = BottomDevice;
        playerTop = TopPlayer(rngSeed: InitialSeed, scene:self, device: TopDevice);
        playerBottom = BottomPlayer(rngSeed: InitialSeed, scene:self, device: BottomDevice);
        
        playerTop!.foe = playerBottom;
        playerBottom!.foe = playerTop;
        
        backgroundGrid = SKShapeNode(rectOf: CGSize(width:BlockRush.BlockWidth*6, height:BlockRush.BlockWidth*10));
        backgroundGrid?.fillColor = UIColor.black;
        self.addChild(backgroundGrid!);
        playField = PlayField(cols:6, rows:46, playerTop:playerTop!, playerBottom:playerBottom!, scene:self);
        TopDevice.playField = playField;
        BottomDevice.playField = playField;
        
        backgroundGrid?.zPosition = -4;
        //*/
        
        
        EndMenu = GameMenu(title: "main",
                        menuOptions:
            [
                MenuAction(title: "Play Again")
                {
                    [unowned self] in
                    GameMenu.focusMenu = nil;
                    if let scene = SKScene(fileNamed: "GameScene") as? GameScene
                    {
                        // Set the scale mode to scale to fit the window
                        scene.size = CGSize(width: UIScreen.main.nativeBounds.width,
                                            height: UIScreen.main.nativeBounds.height);
                        scene.scaleMode = .aspectFit;
                        
                        scene.BottomPlayerType = self.BottomPlayerType;
                        scene.TopPlayerType = self.TopPlayerType;
                        arc4random_buf(&scene.InitialSeed, MemoryLayout.size(ofValue: scene.InitialSeed));
                        scene.ReplayName = self.ReplayName;
                        
                        self.view!.presentScene(scene, transition: SKTransition.fade(withDuration: 2));
                    }
                    else
                    {
                        fatalError("Could not load GameScene.");
                    }
                },
                MenuAction(title: "Main Menu")
                {
                    [unowned self] in
                    GameMenu.focusMenu = nil;
                    if let scene = SKScene(fileNamed: "MainMenuScene")
                    {
                        // Set the scale mode to scale to fit the window
                        scene.size = CGSize(width: UIScreen.main.nativeBounds.width,
                                            height: UIScreen.main.nativeBounds.height);
                        scene.scaleMode = .aspectFit;
                        
                        self.view!.presentScene(scene, transition: SKTransition.fade(withDuration: 2));
                    }
                    else
                    {
                        fatalError("Could not load MainMenuScene.");
                    }
                }
            ]);
        EndMenuNode = SKSpriteNode(color: UIColor(red: 0, green: 0, blue: 0, alpha: 0.6),
                                size: CGSize(width: BlockRush.ScreenWidth, height: BlockRush.ScreenHeight));
        EndMenuNode!.zPosition = 100;
        
        //
        PauseMenu = GameMenu(title: "main",
                           menuOptions:
            [
                MenuAction(title: "Resume")
                {
                    [unowned self] in
                    GameMenu.focusMenu = nil;
                    self.Paused = false;
                    self.PauseMenuNode!.removeAllActions();
                    self.PauseMenuNode!.removeFromParent();
                },
                MenuAction(title: "Restart")
                {
                    [unowned self] in
                    GameMenu.focusMenu = nil;
                    if let scene = SKScene(fileNamed: "GameScene") as? GameScene
                    {
                        // Set the scale mode to scale to fit the window
                        scene.size = CGSize(width: UIScreen.main.nativeBounds.width,
                                            height: UIScreen.main.nativeBounds.height);
                        scene.scaleMode = .aspectFit;
                        
                        scene.BottomPlayerType = self.BottomPlayerType;
                        scene.TopPlayerType = self.TopPlayerType;
                        arc4random_buf(&scene.InitialSeed, MemoryLayout.size(ofValue: scene.InitialSeed));
                        scene.ReplayName = self.ReplayName;
                        
                        self.view!.presentScene(scene, transition: SKTransition.fade(withDuration: 2));
                    }
                    else
                    {
                        fatalError("Could not load GameScene.");
                    }
                },
                MenuAction(title: "Main Menu")
                {
                    [unowned self] in
                    GameMenu.focusMenu = nil;
                    if let scene = SKScene(fileNamed: "MainMenuScene")
                    {
                        // Set the scale mode to scale to fit the window
                        scene.size = CGSize(width: UIScreen.main.nativeBounds.width,
                                            height: UIScreen.main.nativeBounds.height);
                        scene.scaleMode = .aspectFit;
                        
                        self.view!.presentScene(scene, transition: SKTransition.fade(withDuration: 2));
                    }
                    else
                    {
                        fatalError("Could not load MainMenuScene.");
                    }
                }
            ]);
        PauseMenuNode = SKSpriteNode(color: UIColor(red: 0, green: 0, blue: 0, alpha: 0.6),
                                   size: CGSize(width: BlockRush.ScreenWidth, height: BlockRush.ScreenHeight));
        PauseMenuNode!.zPosition = 100;
        
        playField!.GameReady = true;
    }
    
    override func didMove(to view: SKView)
    {
        sceneDidLoad();
    }
    
    /**
     Creates the pause button above the bottom player's time gauge
     */
    func CreatePauseButton()
    {
        let s = BlockRush.BlockWidth
        let P = SKSpriteNode(texture: SKTexture(imageNamed: "PauseButton"), color: .white, size: CGSize(width: s, height: s));
        P.position.x = -BlockRush.GameWidth * 0.44;
        P.position.y = -BlockRush.GameHeight * 0.09;
        P.zPosition = 10;
        addChild(P);
        PauseButton = P;
    }
    
    /**
     The UITouch on the top half of the screen for use by `TDevice`.
     */
    var TopTouch: UITouch? = nil;
    /**
     A variable whose meaning varies on the value of `TopPlayerControlType`.
     
     - If the value is `ControlType.TouchHybrid`, it represents how long until Auto-repeat kicks in.
     - Otherwise, it represents how many frames the `TopTouch` has been held.
     */
    var TopTouchFrames = 0;
    /**
     The point where `TopTouch` began.
     */
    var TopStartPos = CGPoint.zero;
    
    /**
     The UITouch on the bottom half of the screen for use by `BDevice`.
     */
    var BottomTouch: UITouch? = nil;
    /**
     A variable whose meaning varies on the value of `BottomPlayerControlType`.
     
     - If the value is `ControlType.TouchHybrid`, it represents how long until Auto-repeat kicks in.
     - Otherwise, it represents how many frames the `BottomTouch` has been held.
     */
    var BottomTouchFrames = 0;
    /**
     The point where `BottomTouch` began.
     */
    var BottomStartPos = CGPoint.zero;
    
    func touchDown(touch: UITouch)
    {
        if let b = PauseButton
        {
            if(nodes(at: touch.location(in: self)).contains(b))
            {
                GamePause();
                return;
            }
        }
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
    
    func GamePause()
    {
        if(Paused)
        {
            return;
        }
        print("PAUSING");
        Paused = true;
        addChild(PauseMenuNode!);
        PauseMenuNode!.run(.fadeIn(withDuration: 1));
        PauseMenu!.show(node: PauseMenuNode!);
    }
    
    override func update(_ currentTime: TimeInterval)
    {
        if(Paused)
        {
            return;
        }
        if(EndGame)
        {
            Paused = true;
            if(playField!.Loser === playerTop)
            {
                PlayLoseEffect(top: true);
                PlayWinEffect(top: false);
                BlockRush.PlaySound(name: "Winner");
            }
            else if(playField!.Loser === playerBottom)
            {
                PlayLoseEffect(top: false);
                PlayWinEffect(top: true);
                if(TopPlayerType == .Local)
                {
                    BlockRush.PlaySound(name: "Winner");
                }
                else
                {
                    BlockRush.PlaySound(name: "Loser");
                }
            }
            else
            {
                PlayLoseEffect(top: true);
                PlayLoseEffect(top: false);
                BlockRush.PlaySound(name: "Loser");
            }
            BlockRush.StopMusic();
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0)
            {
                self.addChild(self.EndMenuNode!);
                
                self.EndMenuNode!.run(.fadeIn(withDuration: 1));
                self.EndMenu!.show(node: self.EndMenuNode!);
            };
            
        }
        if(playField != nil)
        {
            let f = playField!;
            if(f.GameOverFrame != nil && playerTop!.curFrame == playerBottom!.curFrame)
            {
                // Do things
            }
            else if(playField!.GameReady)
            {
                ControllerObserver.UpdateDAS();
                
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
                if(playField!.GameOverFrame != nil)
                {
                    if let l = playField!.Loser
                    {
                        if(l.curFrame <= l.foe.curFrame) //If loser is behind or at opponent, end game
                        {
                            ReadyEndOfGame();
                        }
                    }
                    else //both have lost
                    {
                        ReadyEndOfGame();
                    }
                }
                // Hang if either player is more than 15 frames behind.
                if((playField!.GameFrame - BFrame) <= 15 && (playField!.GameFrame - TFrame <= 15))
                {
                    if(playField!.GameFrame <= 200)
                    {
                        if((playField!.GameFrame-20) % 60 == 0)
                        {
                            let n = 3 - (playField!.GameFrame-20)/60;
                            let Str: String;
                            if(n == 0)
                            {
                                Str = "GO!";
                                BlockRush.PlayMusic(name: "Track" + String(1+(InitialSeed % 3)) );
                            }
                            else
                            {
                                Str = String(n);
                            }
                            
                            let Bnode = SKLabelNode(text: Str);
                            Bnode.fontName = "Avenir-Black";
                            Bnode.fontSize = BlockRush.GameHeight/4;
                            Bnode.verticalAlignmentMode = .center;
                            if(n == 0)
                            {
                                Bnode.run(.group([.fadeOut(withDuration: 1),.scale(by: 2.0, duration: 1)]));
                            }
                            else
                            {
                                Bnode.run(.group([.fadeOut(withDuration: 1),.scale(by: 0.5, duration: 1)]));
                            }
                            
                            let Tnode = Bnode.copy() as! SKLabelNode;
                            Tnode.position.y =  BlockRush.GameHeight/6;
                            Bnode.position.y = -BlockRush.GameHeight/6;
                            Tnode.zRotation = .pi;
                            addChild(Bnode);
                            addChild(Tnode);
                        }
                    }
                    playField!.AdvanceFrame();
                }
                else
                {
                    /*
                    print("HANGING");
                    //Game is hung, check for end of game
                    if(playField!.GameOverFrame != nil)
                    {
                        ReadyEndOfGame();
                    }
                     */
                }
            }
            else
            {
                print("Game is not ready!");
            }
        }
        
        if(BlockRush.DEBUG_MODE)
        {
            //Show debug text.
            let T = DebugTopObj as? InputDevice;
            let B = DebugBottomObj as? InputDevice;
            if(T != nil)
            {
                DebugNodeTop.text = "\(playerTop!.hasLost) \(playerTop!.curFrame)";//T!.debugText();
            }
            if(B != nil)
            {
                DebugNodeBottom.text = "\(playField!.GameFrame) = \(playerBottom!.curFrame)";//B!.debugText();
            }
        }
    }
    
    /**
     Prepare for the game to end next frame.
     */
    func ReadyEndOfGame()
    {
        EndGame = true;
    }
    
    /**
     Place the WINNER! banner on the specified player's side of the field.
     - Parameter top: Whether or not to place the banner on the top player's side. It will be placed on the bottom player's side if `false`
     */
    func PlayWinEffect(top: Bool)
    {
        let GroupNode = SKNode();
        let BGNode = SKSpriteNode(color: .red, size: CGSize(width: BlockRush.GameWidth, height: BlockRush.BlockWidth*2));
        let TextNode = SKLabelNode(text: "WINNER!");
        TextNode.fontName = "Avenir-Black";
        TextNode.fontSize = BlockRush.BlockWidth*1.25;
        TextNode.verticalAlignmentMode = .center;
        TextNode.fontColor = .yellow;
        
        GroupNode.addChild(BGNode);
        GroupNode.addChild(TextNode);
        
        if(top)
        {
            GroupNode.position.y = BlockRush.GameHeight/4;
            GroupNode.zRotation = .pi;
        }
        else
        {
            GroupNode.position.y = -BlockRush.GameHeight/4;
        }
        GroupNode.zPosition = 10;
        self.addChild(GroupNode);
        
        //
        
        BGNode.run(.fadeIn(withDuration: 0.2))
        {
            TextNode.run(.sequence( [
                            .fadeIn(withDuration: 0.1),
                            .repeatForever(
                                .sequence(
                                    [.scale(by: 1.25, duration: 0.5),
                                     .scale(by: 0.80, duration: 0.5)]
                                )
                            )
                        ]
                    )
                );
        };
        
    }
    
    /**
     Place the LOSER... banner on the specified player's side of the field.
     - Parameter top: Whether or not to place the banner on the top player's side. It will be placed on the bottom player's side if `false`
     */
    func PlayLoseEffect(top: Bool)
    {
        let GroupNode = SKNode();
        let BGNode = SKSpriteNode(color: .blue, size: CGSize(width: BlockRush.GameWidth, height: BlockRush.BlockWidth*2));
        let TextNode = SKLabelNode(text: "LOSER...");
        TextNode.fontName = "Avenir-Black";
        TextNode.fontSize = BlockRush.BlockWidth*1.25;
        TextNode.verticalAlignmentMode = .center;
        TextNode.fontColor = .purple;
        
        GroupNode.addChild(BGNode);
        GroupNode.addChild(TextNode);
        
        if(top)
        {
            GroupNode.position.y = BlockRush.GameHeight/4;
            GroupNode.zRotation = .pi;
        }
        else
        {
            GroupNode.position.y = -BlockRush.GameHeight/4;
        }
        GroupNode.zPosition = 10;
        self.addChild(GroupNode);
    }
    
}
