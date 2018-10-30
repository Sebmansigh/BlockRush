//
//  MainMenuScene.swift
//  Block Rush
//
//  Created by Sebastian Snyder on 4/7/18.
//

import Foundation
import GameController
import SpriteKit

/**
 The scene that contains the main menu navigation
 */
class MainMenuScene: SKScene
{
    /**
     The main menu.
     */
    var Menu: GameMenu? = nil;
    /**
     An `SKLabelNode` that is used by `Menu` to display the current menu's title.
     */
    var titleNode: SKLabelNode? = nil;
    
    deinit
    {
        print("Deallocated MainMenuScene");
    }
    
    
    private var loaded = false;
    /**
     Creates a closure that, when executed, presents an instance of `GameScene`.
     - Parameter bottomPlayerType: The type of the bottom player when the game starts.
     - Parameter topPlayerType: The type of the top player when the game starts.
     - Returns: A closure that presents a `GameScene` when executed.
     */
    private func toGameScene(bottomPlayerType: PlayerType,topPlayerType: PlayerType) -> ( () -> Void )
    {
        return {
            [unowned self] in
            
            GameMenu.focusMenu = nil;
            
            Audio.PrepareMusic(name: "Track" + String(Int.random(in: 1...3)));
            
            if let scene = SKScene(fileNamed: "GameScene") as? GameScene
            {
                // Set the scale mode to scale to fit the window
                scene.size = CGSize(width: UIScreen.main.nativeBounds.width,
                                    height: UIScreen.main.nativeBounds.height);
                scene.scaleMode = .aspectFit;
                
                scene.BottomPlayerType = bottomPlayerType;
                scene.TopPlayerType = topPlayerType;
                arc4random_buf(&scene.InitialSeed, MemoryLayout.size(ofValue: scene.InitialSeed));
                Audio.StopMusic();
                self.view!.presentScene(scene, transition: SKTransition.fade(withDuration: 2));
            }
            else
            {
                fatalError("Could not load GameScene.");
            }
        };
    }
    /**
     Creates a closure that, when executed, presents an instance of `GameScene` that replays a named demo game.
     - Parameter name: the name of the demo game.
     - Returns: A closure that presents a `GameScene` when executed.
     */
    private func playDemoGame(_ name: String) -> ( () -> Void )
    {
        return {
            [unowned self] in
            
            GameMenu.focusMenu = nil;
            
            Audio.PrepareMusic(name: "Track" + String(Int.random(in: 1...3)));
            
            if let scene = SKScene(fileNamed: "GameScene") as? GameScene
            {
                // Set the scale mode to scale to fit the window
                scene.size = CGSize(width: UIScreen.main.nativeBounds.width,
                                    height: UIScreen.main.nativeBounds.height);
                scene.scaleMode = .aspectFit;
                
                scene.BottomPlayerType = .Replay;
                scene.TopPlayerType = .Replay;
                scene.GameMode = .Replay(name: name);
                
                arc4random_buf(&scene.InitialSeed, MemoryLayout.size(ofValue: scene.InitialSeed));
                Audio.StopMusic();
                self.view!.presentScene(scene, transition: SKTransition.fade(withDuration: 2));
            }
            else
            {
                fatalError("Could not load GameScene.");
            }
        }
    }
    
    /**
     Creates a closure that, when executed, presents an instance of `GameScene` that plays a specific game mode.
     - Parameter name: the name of the fixed game.
     - Returns: A closure that presents a `GameScene` when executed.
     */
    private func playTypedGame(_ mode: GameMode) -> ( () -> Void )
    {
        return {
            [unowned self] in
            
            GameMenu.focusMenu = nil;
            
            Audio.PrepareMusic(name: "Track" + String(Int.random(in: 1...3)));
            
            if let scene = SKScene(fileNamed: "GameScene") as? GameScene
            {
                // Set the scale mode to scale to fit the window
                scene.size = CGSize(width: UIScreen.main.nativeBounds.width,
                                    height: UIScreen.main.nativeBounds.height);
                scene.scaleMode = .aspectFit;
                
                scene.BottomPlayerType = .Local;
                if case .Practice = mode
                {
                    scene.TopPlayerType = .Local;
                }
                else
                {
                    scene.TopPlayerType = .None;
                }
                scene.GameMode = mode;
                
                arc4random_buf(&scene.InitialSeed, MemoryLayout.size(ofValue: scene.InitialSeed));
                Audio.StopMusic();
                self.view!.presentScene(scene, transition: SKTransition.fade(withDuration: 2));
            }
            else
            {
                fatalError("Could not load GameScene.");
            }
        }
    }
    
    
    /**
     Creates a closure that, when executed, presents an the user with the matchmaking scene.
     It is assumed that Matchmaking client either is currently or was previously connected to the server.
     - Returns: A closure that presents a `MatchmakingScene` when executed.
     */
    private func toMatchmakingScene() -> ( () -> Void )
    {
        return {
            [unowned self] in
            
            GameMenu.focusMenu = nil;
            BlockRushMatchMakingClient.Client.writeLine("quickPlay");
            
            if let scene = SKScene(fileNamed: "MatchmakingScene") as? MatchmakingScene
            {
                // Set the scale mode to scale to fit the window
                scene.size = CGSize(width: UIScreen.main.nativeBounds.width,
                                    height: UIScreen.main.nativeBounds.height);
                scene.scaleMode = .aspectFit;
                
                self.view!.presentScene(scene, transition: SKTransition.fade(withDuration: 2));
            }
            else
            {
                fatalError("Could not load MatchmakingScene.");
            }
        }
    }
    
    /**
     Creates a closure that, when executed, presents an the user with the server lobby scene.
     It is assumed that Matchmaking client either is currently or was previously connected to the server.
     - Returns: A closure that presents a `ServerLobbyScene` when executed.
     */
    private func toServerLobbyScene() -> ( () -> Void )
    {
        return {
            [unowned self] in
            
            GameMenu.focusMenu = nil;
            BlockRushMatchMakingClient.Client.writeLine("enterLobby");
            
            if let scene = SKScene(fileNamed: "ServerLobbyScene") as? ServerLobbyScene
            {
                // Set the scale mode to scale to fit the window
                scene.size = CGSize(width: UIScreen.main.nativeBounds.width,
                                    height: UIScreen.main.nativeBounds.height);
                scene.scaleMode = .aspectFit;
                
                self.view!.presentScene(scene, transition: SKTransition.fade(withDuration: 2));
            }
            else
            {
                fatalError("Could not load ServerLobbyScene.");
            }
        }
    }
    
    /**
     Creates a closure that, when executed, presents an the user with the bluetooth lobby scene.
     - Returns: A closure that presents a `BluetoothLobbyScene` when executed.
     */
    private func toBluetoothLobbyScene() -> ( () -> Void )
    {
        return {
            [unowned self] in
            
            GameMenu.focusMenu = nil;
            
            if let scene = SKScene(fileNamed: "BluetoothLobbyScene") as? BluetoothLobbyScene
            {
                // Set the scale mode to scale to fit the window
                scene.size = CGSize(width: UIScreen.main.nativeBounds.width,
                                    height: UIScreen.main.nativeBounds.height);
                scene.scaleMode = .aspectFit;
                
                self.view!.presentScene(scene, transition: SKTransition.fade(withDuration: 2));
            }
            else
            {
                fatalError("Could not load BluetoothLobbyScene.");
            }
        }
    }
    
    override func sceneDidLoad()
    {
        backgroundColor = .black;
        if(loaded)
        {
            return;
        }
        ControllerObserver.initializeControllers();
        
        GameEvent.ClearEvents();
        
        Audio.SoundScene = self;
        
        titleNode = SKLabelNode(text: "BLOCK RUSH");
        titleNode!.position.y = CGFloat(BlockRush.GameHeight/4);
        titleNode!.verticalAlignmentMode = .bottom;
        
        titleNode!.fontColor = .white;
        titleNode!.fontSize = min(BlockRush.GameWidth/7,BlockRush.GameHeight/12);
        titleNode!.fontName = "Avenir-Black";
        addChild(titleNode!);
            
        Menu = GameMenu(title: "main",
                        menuOptions:
                        [GameMenu(title:"Play Solo",
                            menuOptions:
                            [SurvivalMenu(title:"Survival", option: MenuAction(title:"Play", action: playTypedGame(.Survival))),
                             TimeAttackMenu(title:"Time Attack", option: MenuAction(title:"Play", action: playTypedGame(.TimeAttack))),
                             /*
                             PracticeMenu(title:"Practice VS", action: playTypedGame(.Practice))
                             */
                            ]),
                            GameMenu(title:"Play VS",
                                  menuOptions:
                                  [MenuAction(title:"VS Local", action: toGameScene(bottomPlayerType: .Local, topPlayerType: .Local)),
                                   GameMenu(title:"VS Bot",
                                            menuOptions:
                                            [MenuAction(title:"Novice Bot", action: toGameScene(bottomPlayerType: .Local, topPlayerType: .BotNovice)),
                                             MenuAction(title:"Adept Bot", action: toGameScene(bottomPlayerType: .Local, topPlayerType: .BotAdept)),
                                             /*
                                             MenuAction(title:"Expert Bot", action: toGameScene(bottomPlayerType: .Local, topPlayerType: .BotExpert)),
                                             MenuAction(title:"Master Bot", action: toGameScene(bottomPlayerType: .Local, topPlayerType: .BotMaster))
                                            */
                                            ]),
                                   MenuAction(title:"VS Bluetooth", action: toBluetoothLobbyScene()),
                                   OnlineMenu(title: "VS Online",
                                              menuOptions:
                                              [MenuAction(title: "Quick Play", action: toMatchmakingScene()),
                                               MenuAction(title: "Game Lobby", action: toServerLobbyScene())
                                              ])
                                  ]),
                         GameMenu(title:"Lessons",
                                  menuOptions:
                                  [MenuAction(title: "Tutorial", action: playTypedGame(.Fixed(name: "Tutorial"))),
                                   MenuAction(title: "Basic Chains", action: playTypedGame(.Fixed(name: "Basic Chains"))),
                                   MenuAction(title: "Defense", action: playTypedGame(.Fixed(name: "Defense"))),
                                   MenuAction(title: "General Tips", action: playTypedGame(.Fixed(name: "General Tips")))
                                  ]),
                         GameMenu(title:"Settings",
                                  menuOptions:
                                    [BlockThemeMenu(title:"Block Theme"),
                                     SoundMenu(title: "Sound"),
                                     ControlMenu(title: "Controls"),
                                    ])
                         ]);
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0)
        {
            Audio.PrepareMusic(name: "Intro")
            Audio.PlayMusic();
            self.Menu!.show(node: self);
        }
        loaded = true;
    }
    
    override func didMove(to view: SKView)
    {
        //view.presentScene(self);
        sceneDidLoad();
    }
    
}
