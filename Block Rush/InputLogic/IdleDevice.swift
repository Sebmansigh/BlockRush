//
//  IdleDevice.swift
//  Block Rush
//
//  Created by Sebastian Snyder on 5/20/18.
//

import Foundation

class IdleDevice : InputDevice
{
    public override func debugText() -> String
    {
        return "IdleDevice";
    }
    
    override func Eval() -> UInt8
    {
        return 0;
    }
    
    override func CanEval() -> Bool
    {
        return true;
    }
}
