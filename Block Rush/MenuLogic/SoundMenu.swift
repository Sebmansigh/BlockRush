//
//  SoundMenu.swift
//  Block Rush
//
//  Created by Sebastian Snyder on 4/7/18.
//

import Foundation
import SpriteKit

class SoundMenu: GameMenu
{
    let BGMslider: MenuSlider;
    let SFXslider: MenuSlider;
    
    required init(title: String)
    {
        BGMslider = MenuSlider(title: "Music Volume",
                               initialValue: Int(BlockRush.Settings[.BackgroundMusicVolume]!.rawValue),
                               min: 0, max: 100)
        {
            BlockRush.Settings[.BackgroundMusicVolume] = .Volume($0);
            BlockRush.player?.volume = Float($0)/100;
        };
        SFXslider = MenuSlider(title: "Sound Volume",
                   initialValue: Int(BlockRush.Settings[.SoundEffectVolume]!.rawValue),
                   min: 0, max: 100)
        {
            BlockRush.Settings[.SoundEffectVolume] = .Volume($0);
        };
        SFXslider.position.y = -BlockRush.GameHeight/5;

        super.init(title: title);
    }
    
    override func show(node: SKNode)
    {
        GameMenu.focusMenu = self;
        inNode = node;
        titleNode.text = title;
        
        node.addChild(BGMslider.Fetch());
        node.addChild(SFXslider.Fetch());
        
        showBackButton()
        {
            let _ = self.BGMslider.Fetch();
            let _ = self.SFXslider.Fetch();
            BlockRush.saveSettings();
        };
    }
}
