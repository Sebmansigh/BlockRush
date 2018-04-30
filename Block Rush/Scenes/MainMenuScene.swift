//
//  MainMenuScene.swift
//  Block Rush
//
//  Created by Sebastian Snyder on 4/7/18.
//

import Foundation
import SpriteKit

class MainMenuScene: SKScene
{
    var Menu: GameMenu? = nil;
    var titleNode: SKLabelNode? = nil;
    var loaded = false;
    
    private func toGameScene(bottomPlayerType: PlayerType,topPlayerType: PlayerType) ->( () -> Void )
    {
        return {
            if let scene = SKScene(fileNamed: "GameScene") as? GameScene
            {
                // Set the scale mode to scale to fit the window
                scene.size = CGSize(width: UIScreen.main.nativeBounds.width,
                                    height: UIScreen.main.nativeBounds.height);
                scene.scaleMode = .aspectFit;
                
                scene.BottomPlayerType = bottomPlayerType;
                scene.TopPlayerType = topPlayerType;
                
                self.view!.presentScene(scene, transition: SKTransition.fade(withDuration: 2));
            }
            else
            {
                fatalError("Could not load GameScene.");
            }
        };
    }
    
    override func sceneDidLoad()
    {
        backgroundColor = .black;
        if(loaded)
        {
            return;
        }
        titleNode = SKLabelNode(text: "BLOCK RUSH");
        titleNode!.position.y = CGFloat(BlockRush.GameHeight/4);
        titleNode!.verticalAlignmentMode = .bottom;
        
        titleNode!.fontColor = .white;
        titleNode!.fontSize = min(BlockRush.GameWidth/7,BlockRush.GameHeight/12);
        titleNode!.fontName = "Avenir-Black";
        addChild(titleNode!);
            
        Menu = GameMenu(title: "main",
                        menuOptions:
                        [GameMenu(title:"Play",
                                  menuOptions:
                                  [MenuAction(title:"VS Local", action: toGameScene(bottomPlayerType: .Local, topPlayerType: .Local)),
                                   GameMenu(title:"VS Bot",
                                            menuOptions:
                                            [MenuAction(title:"Novice Bot", action: toGameScene(bottomPlayerType: .BotNovice, topPlayerType: .BotNovice)),
                                             MenuAction(title:"Adept Bot", action: toGameScene(bottomPlayerType: .Local, topPlayerType: .BotAdept)),
                                             MenuAction(title:"Expert Bot", action: toGameScene(bottomPlayerType: .Local, topPlayerType: .BotExpert)),
                                             MenuAction(title:"Master Bot", action: toGameScene(bottomPlayerType: .Local, topPlayerType: .BotMaster))
                                            ]),
                                   GameMenu(title:"VS Bluetooth"),
                                   GameMenu(title:"VS Online")
                                  ]),
                         GameMenu(title:"Lessons",
                                  menuOptions:
                                  [GameMenu(title: "Tutorial"),
                                   GameMenu(title: "Novice"),
                                   GameMenu(title: "Adept"),
                                   GameMenu(title: "Expert")
                                  ]),
                         GameMenu(title:"Settings",
                                  menuOptions:
                                    [SoundMenu(title: "Sound"),
                                     ControlMenu(title: "Controls")
                                    ])
                         ]);
        
        Menu!.show(node: self);
        loaded = true;
    }
    
    override func didMove(to view: SKView)
    {
        //view.presentScene(self);
        sceneDidLoad();
    }
    
    func touchDown(touch: UITouch)
    {
        
    }
    
    func touchMoved(touch: UITouch)
    {
        
    }
    
    func touchUp(touch: UITouch)
    {
        
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
    
}
