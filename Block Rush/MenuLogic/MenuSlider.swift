//
//  Slider.swift
//  Block Rush
//
//  Created by Sebastian Snyder on 4/8/18.
//

import Foundation
import SpriteKit

class MenuSlider: SKNode
{
    let title: String;
    let BGnode: SKSpriteNode;
    let Tnode: SKLabelNode;
    let Snode: SKSpriteNode;
    let Max: Int;
    let Min: Int;
    var value: Int;
    let Action: (Int) -> Void;
    
    
    init(title t: String,initialValue: Int, min: Int, max: Int, onSlideEnd: @escaping (Int) -> Void)
    {
        let Bw = BlockRush.GameWidth;
        let Bh = BlockRush.GameHeight;
        let Mw = Bw/48;
        
        value = initialValue;
        Action = onSlideEnd;
        Max = max;
        Min = min;
        BGnode = SKSpriteNode(color: .darkGray, size: CGSize(width: Bw*3/4, height: Bw*1/32));
        BGnode.position.y = -Bh/10;
        Snode = SKSpriteNode(color: .white, size: CGSize(width: Bw/8, height: Bw/8));
        Snode.position.y = -Bh/10;
        Snode.position.x = CGFloat(initialValue-Min) / CGFloat(Max-Min);
        Snode.position.x -= 0.5;
        Snode.position.x *= Bw*3/4
        
        title = t;
        
        Tnode = SKLabelNode(text: t);
        
        super.init();
        isUserInteractionEnabled = true;
        
        Tnode.fontName = "Avenir-Heavy";
        Tnode.fontSize = Bh/14-Mw;
        Tnode.verticalAlignmentMode = .center;
        Tnode.fontColor = .white;
        
        addChild(BGnode);
        addChild(Snode);
        addChild(Tnode);
    }
    
    required init(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented.");
    }
    
    func SetSlideValue(newValue:Int)
    {
        value = newValue;
        
        Snode.position.x = CGFloat(value-Min) / CGFloat(Max-Min);
        Snode.position.x -= 0.5;
        Snode.position.x *= BlockRush.GameWidth*3/4;
        
        Action(value);
    }
    
    func MoveSlideValue(amount:Int)
    {
        let newVal = value+amount;
        if(newVal < Min)
        {
            SetSlideValue(newValue: Min);
        }
        else if(newVal > Max)
        {
            SetSlideValue(newValue: Max);
        }
        else
        {
            SetSlideValue(newValue: newVal);
        }
    }
    
    var validTouch: UITouch? = nil;
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        validTouch = touches.first!;
        Highlight();
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        if(validTouch == nil)
        {
            return;
        }
        for t in touches
        {
            if(t == validTouch!)
            {
                
                let Bw = BlockRush.GameWidth;
                
                var tX = t.location(in: self).x;
                
                if(tX > Bw*3/8)
                {
                    tX = Bw*3/8
                }
                else if(tX < -Bw*3/8)
                {
                    tX = -Bw*3/8
                }
                
                Snode.position.x = tX;
                
                break;
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        if(validTouch == nil)
        {
            return;
        }
        for t in touches
        {
            if(t == validTouch!)
            {
                let num = Snode.position.x*CGFloat(Max-Min);
                let den = BlockRush.GameWidth*3/4
                let newValue = Int(round(num/den))+Min+(Max-Min)/2;
                
                SetSlideValue(newValue: newValue);
                
                validTouch = nil;
                Dehighlight();
                break;
            }
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        if(validTouch == nil)
        {
            return;
        }
        for t in touches
        {
            if(t == validTouch!)
            {
                validTouch = nil;
                Dehighlight();
                break;
            }
        }
    }
    
    func Highlight()
    {
        Snode.color = .yellow;
        BGnode.color = .gray;
    }
    
    func Dehighlight()
    {
        Snode.color = .white;
        BGnode.color = .darkGray;
    }
    
    func Fetch() -> MenuSlider
    {
        self.removeFromParent();
        return self;
    }
}
