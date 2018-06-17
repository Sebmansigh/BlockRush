//
//  InputDevice.swift
//  Block Rush
//
//  Created by Sebastian Snyder on 3/28/18.
//

import Foundation

class InputDevice
{
    //All input from outside sources goes here. There is no guarantee that this input device honors these inputs.
    public var pendingInput: [Input] = [];
    internal var inputLog: [UInt8] = [];
    internal var curInput: UInt8 = 0;
    public var player: Player? = nil;
    public var playField: PlayField? = nil;
    
    internal init() {};
    
    public func debugText() -> String
    {
        return "Please override the base InputDevice class.";
    }
    
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
