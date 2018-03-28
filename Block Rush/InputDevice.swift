//
//  InputDevice.swift
//  Block Rush
//
//  Created by Sebastian Snyder on 3/28/18.
//

import Foundation

class InputDevice
{
    internal var inputLog: [UInt8] = [];
    internal var curInput: UInt8 = 0;
    
    internal init() {};
    
    //Override Eval.
    //This function returns a bitmask whose bits are all active inputs.
    internal func Eval() -> UInt8
    {
        return 0;
    }
    
    //Override CanEval.
    //This function returns whether or not it is ready to return a frame of input.
    internal func CanEval() -> Bool
    {
        return false;
    }
    
    //Log input for this frame.
    public final func EvalFrame()
    {
        curInput = Eval();
        inputLog.append(curInput);
    }
    
    //Send back to the Player
    //Individual input
    public final func Get(input: Input) -> Bool
    {
        return (curInput & input.rawValue) != 0;
    }
    
}
