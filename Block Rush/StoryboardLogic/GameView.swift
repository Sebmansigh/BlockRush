//
//  GameView.swift
//  Block Rush
//
//  Created by Sebastian Snyder on 5/25/18.
//

import Foundation
import SpriteKit

class GameView: SKView
{
    weak static var curview: GameView?;
    
    override var canBecomeFirstResponder: Bool
    {
        return true;
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        GameView.curview = self;
    }
}
