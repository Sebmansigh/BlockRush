//
//  ReplayDevice.swift
//  Block Rush
//
//  Created by Sebastian Snyder on 5/19/18.
//

import Foundation

class ReplayDevice : InputDevice
{
    public override func debugText() -> String
    {
        return "\(remainingFrames()) frames left";
    }
    
    public let input: [Input];
    public var pointer: Int;
    public init(_ array: [Input])
    {
        input = array;
        pointer = 0;
    }
    
    override func CanEval() -> Bool
    {
        return pointer < input.count;
    }
    
    override func Eval() -> UInt8
    {
        let get = input[pointer];
        
        pointer += 1;
        
        return get.rawValue;
    }
    public func remainingFrames() -> Int
    {
        return input.count - pointer;
    }
}
