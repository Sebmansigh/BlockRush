//
//  SoundMenu.swift
//  Block Rush
//
//  Created by Sebastian Snyder on 4/7/18.
//

import Foundation
import SpriteKit
import GameController

final class OnlineMenu: GameMenu
{
    var helloed = false;
    
    let myTextBox = UITextField(frame: CGRect(x: 20, y: 100, width: 300, height: 40));
    
    let ConnectingLabel = SKLabelNode(fontNamed: "Avenir");
    
    override func show(node: SKNode)
    {
        GameMenu.focusMenu = self;
        inNode = node;
        let client = BlockRushMatchMakingClient.Client;
        
        helloed = false;
        client.connect();
        client.getHello();
        
    
        
        ConnectingLabel.text = "Connecting...";
        node.addChild(ConnectingLabel);
        
        showBackButton()
        {
            [unowned self] in
            client.writeLine("quit");
            client.disconnect();
            self.ConnectingLabel.removeFromParent();
        }
    }
    
    
    override func MenuUp()
    {
        if(helloed)
        {
            super.MenuUp();
        }
    }
    
    override func MenuDown()
    {
        if(helloed)
        {
            super.MenuDown();
        }
    }
    
    override func MenuChoose()
    {
        if(helloed)
        {
            super.MenuChoose();
        }
    }
    
    public func notifyHello()
    {
        helloed = true;
        ConnectingLabel.removeFromParent();
        let _ = Back?.FetchButton();
        if(GameMenu.focusMenu === self)
        {
            super.show(node: inNode!);
            let _ = Back?.FetchButton();
            
            let client = BlockRushMatchMakingClient.Client;
            
            showBackButton
            {
                [unowned self] in
                self.ConnectingLabel.removeFromParent();
                client.writeLine("quit");
                client.disconnect();
            }
        }
    }
    
    public func notifyDisconnect()
    {
        if let b = Back
        {
            hideSiblings(b);
        }
        ConnectingLabel.removeFromParent();
        ConnectingLabel.text = "Connection Error";
        inNode?.addChild(ConnectingLabel);
        helloed = false;
    }
}
