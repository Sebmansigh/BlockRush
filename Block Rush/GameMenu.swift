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
    internal let options: [MenuOption];
    internal var inNode: SKNode? = nil;
    static let titleNode = SKLabelNode(text: "!");
    var Back: MenuAction?;
    
    init(title: String, menuOptions: [MenuOption])
    {
        /*
        if(menuOptions.isEmpty)
        {
            fatalError("cannot initialize base GameMenu with no options.");
        }
        */
        options = menuOptions;
        
        Back = nil;
        
        super.init(title: title);
        
        for o in options
        {
            o.superMenu = self;
        }
    }
    
    required init(title: String)
    {
        //fatalError("cannot initialize base GameMenu with no options.");
        options = [];
        Back = nil;
        super.init(title: title);
    }
    
    func showBackButton()
    {
        Back = MenuAction(title: "Back")
        {
            self.superMenu!.show(node: self.inNode!);
        }
        Back!.superMenu = self;
        
        let BackBtn = Back!.FetchButton();
        BackBtn.position.x = -BlockRush.GameWidth/4;
        BackBtn.position.y = -BlockRush.GameHeight*3/8;
        BackBtn.width = BlockRush.GameWidth*3/8;
        inNode!.addChild(BackBtn);
    }
    
    func show(node: SKNode)
    {
        let Bh = BlockRush.GameHeight;
        inNode = node;
        
        for i in 0...options.count-1
        {
            let subnode = options[i].FetchButton();
            let targetY = CGFloat(-i)*Bh/12
            node.addChild(subnode);
            subnode.position.y = targetY - Bh;
            subnode.run(.move(to: CGPoint(x:0,y:targetY), duration: 1));
        }
        let tn = GameMenu.titleNode
        if(tn.text == "!")
        {
            tn.text = "";
            tn.position.y = Bh/8;
            tn.fontName = "Avenir-Black";
            tn.fontSize = Bh/10;
            node.addChild(tn);
        }
        if(title == "main")
        {
            tn.text = "";
        }
        else
        {
            tn.text = title;
            showBackButton();
        }
    }
    
    func hideSiblings(_ highlight: MenuOption)
    {
        for o in options
        {
            if(o !== highlight)
            {
                let _ = o.FetchButton();
            }
        }
        if(Back != nil && highlight !== Back!)
        {
            let _ = Back!.FetchButton();
        }
    }
    
    override func EvalPress()
    {
        show(node: superMenu!.inNode!);
    }
    
}
