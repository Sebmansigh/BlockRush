//
//  SettingsOptions.swift
//  Block Rush
//
//  Created by Sebastian Snyder on 4/8/18.
//

import Foundation
import GameKit

struct SettingOption: OptionSet
{
    let rawValue: UInt8;
    
    static let None = SettingOption(rawValue: 0b0000_0000);
    
    internal init(rawValue n: UInt8)
    {
        rawValue = n;
    }
    
    static func From(_ s:String) -> SettingOption
    {
        return SettingOption(rawValue: UInt8(s)!);
    }
    
    
    class ControlType
    {
        private init(){}
        
        static let TouchA         = SettingOption(rawValue: 0b0000_0001);
        static let TouchB         = SettingOption(rawValue: 0b0000_0010);
        static let TouchC         = SettingOption(rawValue: 0b0000_0100);
        /*
         static let KeyboardA      = SettingOption(rawValue: 0b0000_1000);
         static let KeyboardB      = SettingOption(rawValue: 0b0001_0000);
         static let KeyboardCustom = SettingOption(rawValue: 0b0010_0000);
         */
        static let GamepadDefault = SettingOption(rawValue: 0b0100_0000);
        static let GamepadCustom  = SettingOption(rawValue: 0b1000_0000);
    }
    
    static func Volume(_ x: Int) -> SettingOption
    {
        if(x < 0)
        {
            return SettingOption(rawValue:0);
        }
        else if(x > 100)
        {
            return SettingOption(rawValue:100);
        }
        return SettingOption(rawValue:UInt8(x))
    }
    
    static func Button(_ e:GCControllerElement) -> SettingOption
    {
        return SettingOption(rawValue:0);
    }
}
