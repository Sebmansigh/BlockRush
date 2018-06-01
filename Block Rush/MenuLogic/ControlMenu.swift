//
//  SoundMenu.swift
//  Block Rush
//
//  Created by Sebastian Snyder on 4/7/18.
//

import Foundation
import SpriteKit

class ControlMenu: GameMenu
{
    var TopSelector: MenuSelector<SettingOption>!;
    var BottomSelector: MenuSelector<SettingOption>!;
    
    required init(title: String)
    {
        super.init(title: title);
        remakeSelectors();
    }
    
    override func show(node: SKNode)
    {
        GameMenu.focusMenu = self;
        inNode = node;
        
        node.addChild(TopSelector.Fetch());
        node.addChild(BottomSelector.Fetch());
        
        showBackButton()
        {
            let _ = self.TopSelector!.Fetch();
            let _ = self.BottomSelector!.Fetch();
            BlockRush.saveSettings();
        };
    }
    
    func remakeSelectors()
    {
        let _ = self.TopSelector?.Fetch();
        let _ = self.BottomSelector?.Fetch();
        
        let ControlTypeOptions = [(SettingOption.ControlType.TouchSlide,"Slide"),
                                  (SettingOption.ControlType.TouchTap,"Tap"),
                                  (SettingOption.ControlType.TouchHybrid,"Hybrid")];
        var KeyboardOptions = [(SettingOption.ControlType.KeyboardArrows,"Arrow Keys")];
        //If no keyboard detected.
        if(BlockRush.Settings[.KeyboardControlsUnlocked] == .False)
        {
            KeyboardOptions = [];
        }
        
        TopSelector = MenuSelector(title: "Top Player (VS)",
                                   initialValue: BlockRush.Settings[.TopPlayerControlType]!,
                                   options: ControlTypeOptions)
        {
            BlockRush.Settings[.TopPlayerControlType] = $0;
        };
        
        BottomSelector = MenuSelector(title: "Bottom Player",
                                      initialValue: BlockRush.Settings[.BottomPlayerControlType]!,
                                      options: ControlTypeOptions+KeyboardOptions)
        {
            BlockRush.Settings[.BottomPlayerControlType] = $0;
        };
        BottomSelector.position.y = -BlockRush.GameHeight/5;
    }
    
    override func MenuUp()
    {
        if let i = focusIndex
        {
            if(focusIndex == 0)
            {
                TopSelector.Dehighlight();
                focusIndex = 1;
                BottomSelector.Highlight();
            }
            else
            {
                BottomSelector.Dehighlight();
                focusIndex = 0;
                TopSelector.Highlight();
            }
        }
        else
        {
            TopSelector.Highlight();
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
            TopSelector.Highlight();
        }
        if(focusIndex == 0)
        {
            TopSelector.ChangeValueLeft();
        }
        else if(focusIndex == 1)
        {
            BottomSelector.ChangeValueLeft();
        }
    }
    
    override func MenuRight()
    {
        if(focusIndex == nil)
        {
            focusIndex = 0;
            TopSelector.Highlight();
        }
        if(focusIndex == 0)
        {
            TopSelector.ChangeValueRight();
        }
        else if(focusIndex == 1)
        {
            BottomSelector.ChangeValueRight();
        }
    }
    
    override func MenuChoose()
    {
        MenuRight();
    }
}
