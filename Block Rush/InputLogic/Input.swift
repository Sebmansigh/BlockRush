//
//  Input.swift
//  Block Rush
//
//  Created by Sebastian Snyder on 3/28/18.
//

import Foundation

struct Input : OptionSet
{
    
    let rawValue: UInt8;
    
    static let NONE   = Input(rawValue: 0b0000_0000);
    
    static let LEFT   = Input(rawValue: 0b0000_0001);
    static let RIGHT  = Input(rawValue: 0b0000_0010);
    static let FLIP   = Input(rawValue: 0b0000_0100);
    static let PLAY   = Input(rawValue: 0b0000_1000);
    static let INPUT4 = Input(rawValue: 0b0001_0000);
    static let INPUT5 = Input(rawValue: 0b0010_0000);
    static let INPUT6 = Input(rawValue: 0b0100_0000);
    static let INPUT7 = Input(rawValue: 0b1000_0000);
    
    static let ARRAY = [LEFT,RIGHT,FLIP,PLAY,INPUT4,INPUT5,INPUT6,INPUT7];
}
