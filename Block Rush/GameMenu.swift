//
//  File.swift
//  Block Rush
//
//  Created by Sebastian Snyder on 4/7/18.
//

import Foundation
import SpriteKit

class GameMenu: MenuOption
{
    let options: [MenuOption];
    
    init(title: String, menuOptions: [MenuOption])
    {
        options = menuOptions;
        super.init(title: title);
    }
    
    override init(title: String)
    {
        options = [];
        super.init(title: title);
    }
    
    func showImmediate(node: SKNode)
    {
        for i in 0...options.count-1
        {
            let subnode = options[i].CreateButton();
            node.addChild(subnode);
            subnode.position.y = CGFloat(i*40);
        }
    }
}
