//
//  TouchDevice.swift
//  Block Rush
//
//  Created by Sebastian Snyder on 4/7/18.
//

import Foundation

class TouchDevice: InputDevice
{
    public var pendingInput: [Input] = [];
    
    public override init() {super.init();}
    
    internal override func CanEval() -> Bool
    {
        return true;
    }
    
    internal override func Eval() -> UInt8
    {
        var ret: UInt8 = 0;
        for I in pendingInput
        {
            ret |= I.rawValue;
        }
        pendingInput = [];
        return ret;
    }
}
