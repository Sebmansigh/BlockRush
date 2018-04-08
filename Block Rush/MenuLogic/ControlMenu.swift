//
//  SoundMenu.swift
//  Block Rush
//
//  Created by Sebastian Snyder on 4/7/18.
//

import Foundation
import SpriteKit

class ControlMenu: GameMenu
{
    required init(title: String)
    {
        super.init(title: title)
    }
    
    override func show(node: SKNode)
    {
        inNode = node;
        GameMenu.titleNode.text = title;
        showBackButton(BlockRush.saveSettings);
    }
}
