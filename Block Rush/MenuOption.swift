//
//  GameMenu.swift
//  Block Rush
//
//  Created by Sebastian Snyder on 4/7/18.
//

import Foundation
import SpriteKit

class MenuOption
{
    var title: String;
    
    init(title t: String)
    {
        title = t;
    }
    
    func CreateButton() -> SKNode
    {
        var node = SKNode();
        return node;
    }
}
