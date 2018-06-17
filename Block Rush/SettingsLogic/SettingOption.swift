//
//  SettingsOptions.swift
//  Block Rush
//
//  Created by Sebastian Snyder on 4/8/18.
//

import Foundation
import GameKit

/**
 A struct representing a potential value of a setting.
 */
struct SettingOption: OptionSet, Hashable
{
    let rawValue: UInt8;
    
    static let None  = SettingOption(rawValue: 0b0000_0000);
    static let True  = SettingOption(rawValue: 0b0000_0001);
    static let False = SettingOption(rawValue: 0b0000_0000);
    
    internal init(rawValue n: UInt8)
    {
        rawValue = n;
    }
    
    static func From(_ s:String) -> SettingOption
    {
        return SettingOption(rawValue: UInt8(s)!);
    }
    
    /**
     A class containing `SettingOptions` for use with control type settings.
     */
    final class ControlType
    {
        private init(){}
        
        static let TouchSlide     = SettingOption(rawValue: 0b0000_0001);
        static let TouchTap       = SettingOption(rawValue: 0b0000_0010);
        static let TouchHybrid    = SettingOption(rawValue: 0b0000_0100);
        static let KeyboardArrows = SettingOption(rawValue: 0b0000_1000);
    }
    
    /**
     Creates a `SettingOption` from an integer value.
     - Parameter x: The desired volume value.
        This value will be clamped to the range `0` to `100`.
     - Returns: The created `SettingOption`.
     */
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
