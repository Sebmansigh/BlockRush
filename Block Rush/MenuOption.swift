//
//  GameMenu.swift
//  Block Rush
//
//  Created by Sebastian Snyder on 4/7/18.
//

import Foundation
import SpriteKit
import UIKit

class MenuOption
{
    class ButtonNode: SKSpriteNode
    {
        let BGnode: SKSpriteNode;
        let Tnode : SKLabelNode;
        let owner: MenuOption;
        var confirming = false;
        
        var width: CGFloat
        {
            get
            {
                return BGnode.size.width;
            }
            set
            {
                BGnode.size.width = newValue;
                size.width = newValue+BlockRush.GameWidth/48;
            }
        }
        
        init(owner o: MenuOption)
        {
            let Bw = BlockRush.GameWidth;
            let Bh = BlockRush.GameHeight;
            let Mw = Bw/48;
            
            
            BGnode = SKSpriteNode(color: .darkGray, size: CGSize(width: Bw*3/4, height: Bh/14));
            Tnode = SKLabelNode(text: o.title);
            owner = o;
            
            //super.init(color: .white   , size: CGSize(width: Bw*3/4+Mw, height: Bh/12+Mw));
            super.init(texture: nil, color: .white, size: CGSize(width: Bw*3/4+Mw, height: Bh/14+Mw));
            isUserInteractionEnabled = true;
            
            Tnode.fontName = "Avenir-Heavy";
            Tnode.fontSize = Bh/14-Mw;
            Tnode.verticalAlignmentMode = .center;
            Tnode.fontColor = .white;
            
            addChild(BGnode);
            addChild(Tnode);
        }
        
        required init(coder: NSCoder)
        {
            fatalError("init(coder:) has not been implemented.");
        }
        
        var validTouches: Set<UITouch> = [];
        
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
        {
            validTouches.formUnion(touches);
            Highlight();
        }
        
        override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
        {
            for t in touches
            {
                if(!nodes(at: t.location(in: self)).contains(BGnode))
                {
                    touchesCancelled([t], with: event)
                }
            }
        }
        
        override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
        {
            if(!touches.intersection(validTouches).isEmpty)
            {
                if(!confirming)
                {
                    confirming = true;
                    validTouches = [];
                    Confirm();
                }
            }
        }
        
        override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?)
        {
            validTouches.subtract(touches)
            if(validTouches.isEmpty)
            {
                Dehighlight();
            }
        }
        
        func Highlight()
        {
            self.color = .yellow;
            BGnode.color = .gray;
            Tnode.fontColor = .yellow;
        }
        
        func Dehighlight()
        {
            self.color = .white;
            BGnode.color = .darkGray;
            Tnode.fontColor = .white;
        }
        
        func Confirm()
        {
            owner.Confirm();
        }
    }
    
    var title: String;
    var superMenu: GameMenu?;
    private var Btn: ButtonNode?;
    
    required init(title t: String)
    {
        title = t;
    }
    
    func FetchButton() -> ButtonNode
    {
        if(Btn != nil)
        {
            Btn!.removeFromParent();
            Btn!.confirming = false;
            Btn!.Dehighlight();
            Btn!.removeAllActions();
            return Btn!;
        }
        Btn = ButtonNode(owner: self);
        return Btn!;
    }
    
    func Confirm()
    {
        superMenu!.hideSiblings(self);
        Btn!.run(.sequence([.repeat(.sequence([.run(Btn!.Dehighlight),
                                    .wait(forDuration: 0.125),
                                    .run(Btn!.Highlight),
                                    .wait(forDuration: 0.125)]), count: 2),
                            .wait(forDuration: 0.5)]))
        {
            let _ = self.FetchButton();
            self.EvalPress();
        };
    }
    
    func EvalPress()
    {
        fatalError("Confirm() not implemented by a subclass");
    }
}
