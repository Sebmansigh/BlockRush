//
//  SoundMenu.swift
//  Block Rush
//
//  Created by Sebastian Snyder on 4/7/18.
//

import Foundation
import SpriteKit
import GameController

final class TestDelegate: NSObject, UITextFieldDelegate
{
    public static let Instance = TestDelegate();
    
    private override init (){}
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder();
        return true;
    }
    public func textFieldDidEndEditing(_ textField: UITextField)
    {
        let message = textField.text ?? "";
        textField.text = "";
        BlockRushMatchMakingClient.Client.writeLine(message);
        BlockRushMatchMakingClient.Client.readLine(onComplete: BlockRush.PopUp);
    }
}

class OnlineMenu: GameMenu
{
    required init(title: String,option: MenuOption)
    {
        super.init(title: title,menuOptions:[option]);
    }
    
    required init(title: String)
    {
        super.init(title: title);
    }
    
    let myTextBox = UITextField(frame: CGRect(x: 20, y: 100, width: 300, height: 40));
    
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
        BlockRushMatchMakingClient.Client.connect();
        
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
        Label.text = "Send Message:";
        
        Label.fontSize = BlockRush.BlockWidth/2;
        Label.position.y = 0*Bh/20;
        Label.horizontalAlignmentMode = .center;
        node.addChild(Label);
        
        myTextBox.placeholder = "Enter text here"
        myTextBox.font = UIFont.systemFont(ofSize: 15)
        myTextBox.borderStyle = .roundedRect;
        myTextBox.autocorrectionType = .no;
        myTextBox.keyboardType = .default;
        myTextBox.returnKeyType = .done;
        myTextBox.clearButtonMode = .whileEditing;
        myTextBox.contentVerticalAlignment = .center;
        myTextBox.delegate = TestDelegate.Instance;
        GameView.curview!.addSubview(myTextBox);
        
        let Lines = [SKLabelNode(text: "Play against others worldwide")];
        
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
            [unowned myTextBox] in
            myTextBox.removeFromSuperview();
            Label.removeFromParent();
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
