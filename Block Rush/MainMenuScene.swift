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
    
    override func sceneDidLoad()
    {
            backgroundColor = .black
            
        Menu = GameMenu(title: "Main",
                        menuOptions:
                        [MenuAction(title:"Play") {
                                if let scene = SKScene(fileNamed: "GameScene")
                                {
                                    // Set the scale mode to scale to fit the window
                                    scene.size = CGSize(width: UIScreen.main.nativeBounds.width,
                                                        height: UIScreen.main.nativeBounds.height);
                                    scene.scaleMode = .aspectFit
                                    
                                    self.view?.presentScene(scene);
                                }
                            },
                         GameMenu(title:"Lessons",
                                  menuOptions:
                                  [GameMenu(title: "Tutorial"),
                                   GameMenu(title: "Beginner"),
                                   GameMenu(title: "Intermediate"),
                                   GameMenu(title: "Expert")
                                  ]),
                         GameMenu(title:"Settings")
                         ]);
        Menu!.showImmediate(node: self);
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
