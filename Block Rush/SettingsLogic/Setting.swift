//
//  Settings.swift
//  Block Rush
//
//  Created by Sebastian Snyder on 4/8/18.
//

import Foundation

/**
 An enum containing all setting values the game uses.
 */
enum Setting: CaseIterable
{
    case ColorTheme;
    case TextureTheme;
    
    case BottomPlayerControlType;
    
    case TopPlayerControlType;
    
    case SoundEffectVolume;
    case BackgroundMusicVolume;
    
    /**
     Returns the default value of a given setting
     - Parameter s: The setting to get the default of.
     - Returns: The default value.
     */
    static func getDefault(_ s:Setting) -> SettingOption
    {
        switch s
        {
        case .ColorTheme:
            return SettingOption.ColorTheme.BasicColors;
        case .TextureTheme:
            return SettingOption.TextureTheme.BasicShapes;
        case .BottomPlayerControlType, .TopPlayerControlType:
            return SettingOption.ControlType.TouchSlide;
            
        case .SoundEffectVolume:
            return .Volume(100);
            
        case .BackgroundMusicVolume:
            return .Volume(80);
        }
    }
    
    
}
