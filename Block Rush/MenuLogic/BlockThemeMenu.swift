//
//  SoundMenu.swift
//  Block Rush
//
//  Created by Sebastian Snyder on 4/7/18.
//

import Foundation
import SpriteKit
import GameController

class BlockThemeMenu: GameMenu
{
    var ColorSelector: MenuSelector<SettingOption>!;
    var TextureSelector: MenuSelector<SettingOption>!;
    let ShowNode: SKShapeNode;
    var Block1: Block;
    var Block2: Block;
    var Block3: Block;
    
    required init(title: String)
    {
        ShowNode = SKShapeNode(rectOf: CGSize(width:BlockRush.BlockWidth*7, height:BlockRush.BlockWidth*2));
        ShowNode.fillColor = .black;
        ShowNode.strokeColor = .white;
        ShowNode.lineWidth = 1;
        
        let ColorThemeOptions = BlockThemeMenu.CreateColorThemeOptions();
        let TextureThemeOptions = BlockThemeMenu.CreateTextureThemeOptions();
        
        Block1 = Block(nColor: 0);
        Block2 = Block(nColor: 1);
        Block3 = Block(nColor: 2);
        
        
        super.init(title: title);
        
        ColorSelector = MenuSelector(title: "",
                                   initialValue: BlockRush.Settings[.ColorTheme]!,
                                   options: ColorThemeOptions)
        {
            [unowned self] in
            BlockRush.Settings[.ColorTheme] = $0;
            
            self.RemoveBlocks();
            self.Block1 = Block(nColor: 0);
            self.Block2 = Block(nColor: 1);
            self.Block3 = Block(nColor: 2);
            self.AddBlocks();
        };
        
        ColorSelector.position.y = -BlockRush.GameHeight/10;
        
        TextureSelector = MenuSelector(title: "",
                                      initialValue: BlockRush.Settings[.TextureTheme]!,
                                      options: TextureThemeOptions)
        {
            [unowned self] in
            BlockRush.Settings[.TextureTheme] = $0;
            
            self.RemoveBlocks();
            self.Block1 = Block(nColor: 0);
            self.Block2 = Block(nColor: 1);
            self.Block3 = Block(nColor: 2);
            self.AddBlocks();
        };
        TextureSelector.position.y = -BlockRush.GameHeight/5;
    }
    
    override func show(node: SKNode)
    {
        titleNode.text = title;
        
        GameMenu.focusMenu = self;
        inNode = node;
        
        node.addChild(ShowNode);
        node.addChild(ColorSelector.Fetch());
        node.addChild(TextureSelector.Fetch());
        
        RemoveBlocks();
        AddBlocks();
        
        showBackButton()
        {
            let _ = self.ColorSelector.Fetch();
            let _ = self.TextureSelector.Fetch();
            self.ShowNode.removeFromParent();
            BlockRush.saveSettings();
        };
    }
    
    override func MenuUp()
    {
        if let i = focusIndex
        {
            if(i == 0)
            {
                ColorSelector.Dehighlight();
                focusIndex = 1;
                TextureSelector.Highlight();
            }
            else
            {
                TextureSelector.Dehighlight();
                focusIndex = 0;
                ColorSelector.Highlight();
            }
        }
        else
        {
            ColorSelector.Highlight();
            focusIndex = 0;
        }
    }
    
    override func MenuDown()
    {
        MenuUp();
    }
    
    override func MenuLeft()
    {
        if(focusIndex == nil)
        {
            focusIndex = 0;
            ColorSelector.Highlight();
        }
        if(focusIndex == 0)
        {
            ColorSelector.ChangeValueLeft();
        }
        else if(focusIndex == 1)
        {
            TextureSelector.ChangeValueLeft();
        }
    }
    
    override func MenuRight()
    {
        if(focusIndex == nil)
        {
            focusIndex = 0;
            ColorSelector.Highlight();
        }
        if(focusIndex == 0)
        {
            ColorSelector.ChangeValueRight();
        }
        else if(focusIndex == 1)
        {
            TextureSelector.ChangeValueRight();
        }
    }
    
    override func MenuChoose()
    {
        MenuRight();
    }
    
    private func RemoveBlocks()
    {
        Block1.nod.removeFromParent();
        Block2.nod.removeFromParent();
        Block3.nod.removeFromParent();
    }
    
    private func AddBlocks()
    {
        ShowNode.addChild(Block1.nod);
        ShowNode.addChild(Block2.nod);
        ShowNode.addChild(Block3.nod);
        
        Block1.nod.position.x = -BlockRush.BlockWidth*2;
        Block3.nod.position.x =  BlockRush.BlockWidth*2;
    }
    
    static func CreateColorThemeOptions() -> [(SettingOption,String)]
    {
        let ret = [
            (SettingOption.ColorTheme.BasicColors, "Basic Colors"),
            (SettingOption.ColorTheme.Deuteranopia, "Deuteranopia"),
            (SettingOption.ColorTheme.Tritanopia, "Tritanopia"),
            (SettingOption.ColorTheme.Grayscale, "Grayscale"),
        ];
        return ret;
    }
    static func CreateTextureThemeOptions() -> [(SettingOption,String)]
    {
        let ret = [
            (SettingOption.TextureTheme.BasicShapes, "Basic Shapes"),
            (SettingOption.TextureTheme.Flat, "Flat"),
            (SettingOption.TextureTheme.Solid, "Solid"),
        ];
        return ret;
    }
}
