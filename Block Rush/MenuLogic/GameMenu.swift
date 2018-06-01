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
    public static var focusMenu: GameMenu? = nil;
    public var focusIndex: Int? = nil;
    
    internal let options: [MenuOption];
    internal weak var inNode: SKNode? = nil;
    let titleNode = SKLabelNode(text: "!");
    static var currentTitleNode: SKLabelNode? = nil;
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
    
    func showBackButton(_ onClose: @escaping ()->Void)
    {
        Back = MenuAction(title: "Back")
        {
            [unowned self] in
            onClose();
            self.superMenu!.show(node: self.inNode!);
        }
        Back!.superMenu = self;
        
        let BackBtn = Back!.FetchButton();
        BackBtn.position.x = -BlockRush.GameWidth/4;
        BackBtn.position.y = -BlockRush.GameHeight*7/16;
        BackBtn.width = BlockRush.GameWidth*7/16;
        inNode!.addChild(BackBtn);
    }
    
    func showBackButton()
    {
        showBackButton() {};
    }
    
    func show(node: SKNode)
    {
        GameMenu.focusMenu = self;
        let Bh = BlockRush.GameHeight;
        inNode = node;
        
        for i in 0...options.count-1
        {
            let subnode = options[i].FetchButton();
            let targetY = CGFloat(-i)*Bh/10
            node.addChild(subnode);
            subnode.position.y = targetY - Bh;
            subnode.run(.move(to: CGPoint(x:0,y:targetY), duration: 1));
        }
        if let i = focusIndex
        {
            options[i].RefButton()?.Highlight();
        }
        if(titleNode.text == "!")
        {
            titleNode.text = "";
            titleNode.position.y = Bh/8;
            titleNode.fontName = "Avenir-Black";
            titleNode.fontSize = Bh/10;
        }
        if(title == "main")
        {
            titleNode.text = "";
        }
        else
        {
            titleNode.text = title;
            showBackButton();
        }
        GameMenu.currentTitleNode?.removeFromParent();
        GameMenu.currentTitleNode = titleNode;
        node.addChild(titleNode);
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
    
    func MenuUp()
    {
        if let i = focusIndex
        {
            options[i].RefButton()?.Dehighlight();
            focusIndex = (i+options.count-1) % options.count;
            options[focusIndex!].RefButton()?.Highlight();
        }
        else
        {
            options[0].RefButton()?.Highlight();
            focusIndex = 0;
        }
    }
    
    func MenuDown()
    {
        if let i = focusIndex
        {
            options[i].RefButton()?.Dehighlight();
            focusIndex = (i+1) % options.count;
            options[focusIndex!].RefButton()?.Highlight();
        }
        else
        {
            options[0].RefButton()?.Highlight();
            focusIndex = 0;
        }
    }
    
    func MenuLeft()
    {
        //No Default functionality
    }
    
    func MenuRight()
    {
        //No Default functionality
    }
    
    func MenuChoose()
    {
        let i: Int;
        if(focusIndex == nil)
        {
            i = 0;
        }
        else
        {
            i = focusIndex!;
        }
        let o = options[i];
        o.Confirm();
        if let m = o as? GameMenu
        {
            if(m.focusIndex == nil)
            {
                m.focusIndex = 0;
            }
        }
    }
    
    func MenuBackChoose()
    {
        Back?.Confirm();
    }
}
