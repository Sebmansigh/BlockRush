//
//  GameViewController.swift
//  Block Rush
//
//  Created by Sebastian Snyder on 3/25/18.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView?
        {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "MainMenuScene")
            {
                // Set the scale mode to scale to fit the window
                scene.size = CGSize(width: UIScreen.main.nativeBounds.width,
                                    height: UIScreen.main.nativeBounds.height);
                scene.scaleMode = .aspectFit;
                
                // Present the scene
                view.presentScene(scene);
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
            view.showsDrawCount = true
        }
    }

    override var shouldAutorotate: Bool {
        return true;
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true;
    }
    
    override func preferredScreenEdgesDeferringSystemGestures() -> UIRectEdge {
        return .left
    }
}
