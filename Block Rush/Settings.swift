//
//  Settings.swift
//  Block Rush
//
//  Created by Sebastian Snyder on 4/8/18.
//

import Foundation
import GameKit

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
    
    static func getDefault(_ s:Setting) -> SettingOptions
    {
        switch s
        {
        case .BottomPlayerControlType, .TopPlayerControlType:
            return SettingOptions.ControlType.TouchA;
            
        case .SoundEffectVolume:
            return .Volume(100);
            
        case .BackgroundMusicVolume:
            return .Volume(80);
            
        default:
            return .None;
        }
    }
    
    
}

struct SettingOptions: OptionSet
{
    let rawValue: UInt8;
    
    static let None = SettingOptions(rawValue: 0b0000_0000);
    
    internal init(rawValue n: UInt8)
    {
        rawValue = n;
    }
    
    static func From(_ s:String) -> SettingOptions
    {
        return SettingOptions(rawValue: UInt8(s)!);
    }
    
    
    class ControlType
    {
        private init(){}
        
        static let TouchA         = SettingOptions(rawValue: 0b0000_0001);
        static let TouchB         = SettingOptions(rawValue: 0b0000_0010);
        static let TouchC         = SettingOptions(rawValue: 0b0000_0100);
        /*
        static let KeyboardA      = SettingOptions(rawValue: 0b0000_1000);
        static let KeyboardB      = SettingOptions(rawValue: 0b0001_0000);
        static let KeyboardCustom = SettingOptions(rawValue: 0b0010_0000);
        */
        static let GamepadDefault = SettingOptions(rawValue: 0b0100_0000);
        static let GamepadCustom  = SettingOptions(rawValue: 0b1000_0000);
    }
    
    static func Volume(_ x: Int) -> SettingOptions
    {
        if(x < 0)
        {
            return SettingOptions(rawValue:0);
        }
        else if(x > 100)
        {
            return SettingOptions(rawValue:100);
        }
        return SettingOptions(rawValue:UInt8(x))
    }
    
    static func Button(_ e:GCControllerElement) -> SettingOptions
    {
        return SettingOptions(rawValue:0);
    }
}
