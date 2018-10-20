//
//  SoundMenu.swift
//  Block Rush
//
//  Created by Sebastian Snyder on 4/7/18.
//

import Foundation
import SpriteKit
import GameController

class SurvivalMenu: GameMenu
{
    required init(title: String,option: MenuOption)
    {
        super.init(title: title,menuOptions:[option]);
    }
    
    required init(title: String)
    {
        super.init(title: title);
    }
    override func show(node: SKNode)
    {
        GameMenu.focusMenu = self;
        
        let Bh = BlockRush.GameHeight;
        inNode = node;
        
        let subnode = options[0].FetchButton();
        let targetY = CGFloat(-3)*Bh/10;
        node.addChild(subnode);
        subnode.position.y = targetY - Bh;
        subnode.run(.move(to: CGPoint(x:0,y:targetY), duration: 1));
        
        if let i = focusIndex
        {
            options[i].RefButton()?.Highlight();
        }
        if(titleNode.text == "!")
        {
            titleNode.text = title;
            titleNode.position.y = Bh/8;
            titleNode.fontName = "Avenir-Black";
            titleNode.fontSize = Bh/10;
        }
        //
        
        let Label = SKLabelNode(fontNamed: "Avenir");
        Label.text = "Current High Score:";
        
        Label.fontSize = BlockRush.BlockWidth/2;
        Label.position.y = 0*Bh/20;
        Label.horizontalAlignmentMode = .center;
        node.addChild(Label);
        
        let HSLabel = SKLabelNode(fontNamed: "Avenir");
        HSLabel.text = BlockRush.Commafy(value: BlockRush.SurvivalHighScore);
        
        HSLabel.fontSize = BlockRush.BlockWidth;
        HSLabel.position.y = -3*Bh/40;
        HSLabel.horizontalAlignmentMode = .center;
        node.addChild(HSLabel);
        
        let Lines = [SKLabelNode(text: "Hold back the wall"),
                     SKLabelNode(text: "as long as you can")];
        
        for i in 0...Lines.count-1
        {
            let Line = Lines[i];
            Line.fontName = "Avenir";
            Line.fontSize = BlockRush.BlockWidth/2;
            Line.position.y = CGFloat(-3-i)*Bh/20;
            Line.horizontalAlignmentMode = .center;
            node.addChild(Line);
        }
        
        //
        
        showBackButton()
        {
            Label.removeFromParent();
            HSLabel.removeFromParent();
            for Line in Lines
            {
                Line.removeFromParent();
            }
        }
        
        GameMenu.currentTitleNode?.removeFromParent();
        GameMenu.currentTitleNode = titleNode;
        node.addChild(titleNode);
    }
}
