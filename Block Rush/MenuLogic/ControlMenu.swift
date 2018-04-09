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
    let TopSelector: MenuSelector<SettingOption>;
    let BottomSelector: MenuSelector<SettingOption>;
    
    required init(title: String)
    {
        let ControlTypeOptions = [(SettingOption.ControlType.TouchSlide,"Slide"),
                                  (SettingOption.ControlType.TouchTap,"Tap"),
                                  (SettingOption.ControlType.TouchHybrid,"Hybrid")];
        
        TopSelector = MenuSelector(title: "Top Player (VS)",
                                   initialValue: BlockRush.Settings[.TopPlayerControlType]!,
                                   options: ControlTypeOptions)
        {
            BlockRush.Settings[.TopPlayerControlType] = $0;
        };
        
        BottomSelector = MenuSelector(title: "Bottom Player",
                                      initialValue: BlockRush.Settings[.BottomPlayerControlType]!,
                                      options: ControlTypeOptions)
        {
            BlockRush.Settings[.BottomPlayerControlType] = $0;
        };
        BottomSelector.position.y = -BlockRush.GameHeight/5;
        
        super.init(title: title);
    }
    
    override func show(node: SKNode)
    {
        inNode = node;
        GameMenu.titleNode.text = title;
        
        node.addChild(TopSelector.Fetch());
        node.addChild(BottomSelector.Fetch());
        
        showBackButton()
        {
            let _ = self.TopSelector.Fetch();
            let _ = self.BottomSelector.Fetch();
            BlockRush.saveSettings();
        };
    }
}
