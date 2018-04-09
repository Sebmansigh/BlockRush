//
//  Slider.swift
//  Block Rush
//
//  Created by Sebastian Snyder on 4/8/18.
//

import Foundation
import SpriteKit
import UIKit

class MenuSelector<T: Equatable>: SKNode
{
    let title: String;
    let Lnode: SKShapeNode;
    let Rnode: SKShapeNode;
    let Tnode: SKLabelNode;
    let Vnode: SKLabelNode;
    var value: Int;
    var valueText: String;
    let Action: (T) -> Void;
    let options: [(T,String)];
    
    init(title t: String,initialValue: T,options o: [(T,String)], onValueChanged: @escaping (T) -> Void)
    {
        let Bw = BlockRush.GameWidth;
        let Bh = BlockRush.GameHeight;
        let Mw = Bw/48;
        
        Action = onValueChanged;
        options = o;
        value = -1;
        valueText = "";
        
        for i in 0...options.count-1
        {
            if(options[i].0 == initialValue)
            {
                value = i;
                valueText = options[i].1;
                break;
            }
        }
        
        if(value == -1)
        {
            value = 0;
            valueText = options[0].1;
        }
        let path = CGMutablePath();
        path.move(to: CGPoint(x:-Bh/21,y:0.0));
        path.addLine(to: CGPoint(x:0.0,y:-Bh/28));
        path.addLine(to: CGPoint(x:0.0,y:Bh/28));
        path.addLine(to: CGPoint(x:-Bh/21,y:0.0));
        
        Lnode = SKShapeNode(path: path);
        
        Lnode.position.y = -Bh/10;
        Lnode.fillColor = .white;
        
        Rnode = Lnode.copy() as! SKShapeNode;
        
        Rnode.zRotation = .pi;
        Rnode.position.x = Bw*3/8;
        Lnode.position.x = -Bw*3/8;
        title = t;
        
        Tnode = SKLabelNode(text: t);
        
        Tnode.fontName = "Avenir-Heavy";
        Tnode.fontSize = Bh/14-Mw;
        Tnode.verticalAlignmentMode = .center;
        Tnode.fontColor = .white;
        
        
        Vnode = SKLabelNode(text: valueText);
        
        Vnode.fontName = "Avenir-Heavy";
        Vnode.fontSize = Bh/16-Mw;
        Vnode.verticalAlignmentMode = .baseline;
        Vnode.fontColor = .white;
        Vnode.position.y = -Bh/10;
        
        super.init();
        isUserInteractionEnabled = true;
        
        addChild(Lnode);
        addChild(Rnode);
        addChild(Tnode);
        addChild(Vnode);
    }
    
    required init(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented.");
    }
    
    var validTouchL: UITouch? = nil;
    var validTouchR: UITouch? = nil;
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        for t in touches
        {
            let ns = nodes(at: t.location(in: self));
            if(ns.contains(Lnode))
            {
                validTouchL = t;
                HighlightL();
            }
            if(ns.contains(Rnode))
            {
                validTouchR = t;
                HighlightR();
            }
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        for t in touches
        {
            if(t == validTouchL)
            {
                validTouchL = nil;
                DehighlightL();
            }
            if(t == validTouchR)
            {
                validTouchR = nil;
                DehighlightR();
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        for t in touches
        {
            if(t == validTouchL)
            {
                validTouchL = nil;
                DehighlightL();
                value -= 1;
                if(value < 0)
                {
                    value = options.count-1;
                }
                let v = options[value];
                valueText = v.1;
                Vnode.text = valueText;
                Action(v.0);
            }
            if(t == validTouchR)
            {
                validTouchR = nil;
                DehighlightR();
                value += 1;
                if(value == options.count)
                {
                    value = 0;
                }
                let v = options[value];
                valueText = v.1;
                Vnode.text = valueText;
                Action(v.0);
            }
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        /*
        if(validTouch == nil)
        {
            return;
        }
        for t in touches
        {
            if(t == validTouch!)
            {
                //revert to initial position.
                print("Slide end.");
                validTouch = nil;
                Dehighlight();
                break;
            }
        }
 */
    }
    func HighlightL()
    {
        Lnode.fillColor = .yellow;
    }
    
    func DehighlightL()
    {
        Lnode.fillColor = .white;
    }
    
    func HighlightR()
    {
        Rnode.fillColor = .yellow;
    }
    
    func DehighlightR()
    {
        Rnode.fillColor = .white;
    }
    func Fetch() -> MenuSelector<T>
    {
        self.removeFromParent();
        return self;
    }
}
