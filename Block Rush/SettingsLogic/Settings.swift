//
//  Settings.swift
//  Block Rush
//
//  Created by Sebastian Snyder on 4/8/18.
//

import Foundation

enum Setting: EnumCollection
{
    
    case BottomPlayerControlType;
    
    /*
    case BottomPlayerKeyboardCustomInputLeft;
    case BottomPlayerKeyboardCustomInputRight;
    case BottomPlayerKeyboardCustomInputFlip;
    case BottomPlayerKeyboardCustomInputPlay;
    case BottomPlayerKeyboardCustomInput4;
    case BottomPlayerKeyboardCustomInput5;
    case BottomPlayerKeyboardCustomInput6;
    case BottomPlayerKeyboardCustomInput7;
    */
    
    case BottomPlayerGamepadCustomInputLeft;
    case BottomPlayerGamepadCustomInputRight;
    case BottomPlayerGamepadCustomInputFlip;
    case BottomPlayerGamepadCustomInputPlay;
    case BottomPlayerGamepadCustomInput4;
    case BottomPlayerGamepadCustomInput5;
    case BottomPlayerGamepadCustomInput6;
    case BottomPlayerGamepadCustomInput7;
    
    
    case TopPlayerControlType;
    
    /*
    case TopPlayerKeyboardCustomInputLeft;
    case TopPlayerKeyboardCustomInputRight;
    case TopPlayerKeyboardCustomInputFlip;
    case TopPlayerKeyboardCustomInputPlay;
    case TopPlayerKeyboardCustomInput4;
    case TopPlayerKeyboardCustomInput5;
    case TopPlayerKeyboardCustomInput6;
    case TopPlayerKeyboardCustomInput7;
    */
    
    case TopPlayerGamepadCustomInputLeft;
    case TopPlayerGamepadCustomInputRight;
    case TopPlayerGamepadCustomInputFlip;
    case TopPlayerGamepadCustomInputPlay;
    case TopPlayerGamepadCustomInput4;
    case TopPlayerGamepadCustomInput5;
    case TopPlayerGamepadCustomInput6;
    case TopPlayerGamepadCustomInput7;
    
    case SoundEffectVolume;
    case BackgroundMusicVolume;
    
    static func getDefault(_ s:Setting) -> SettingOption
    {
        switch s
        {
        case .BottomPlayerControlType, .TopPlayerControlType:
            return SettingOption.ControlType.TouchA;
            
        case .SoundEffectVolume:
            return .Volume(80);
            
        case .BackgroundMusicVolume:
            return .Volume(100);
            
        default:
            return .None;
        }
    }
    
    
}
