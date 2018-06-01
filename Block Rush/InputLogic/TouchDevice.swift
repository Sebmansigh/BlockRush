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
    private var previousInput: [Input] = [];
    
    public override init() {super.init();}
    
    public override func debugText() -> String
    {
        if(previousInput.count == 0)
        {
            return "Touch: ( _ )";
        }
        var retStr = "Touch: ( ";
        for I in previousInput
        {
            switch(I)
            {
            case .LEFT:
                retStr+="L"
            case .RIGHT:
                retStr+="R"
            case .PLAY:
                retStr+="P"
            case .FLIP:
                retStr+="F"
            default:
                retStr+="?"
            }
            if(I != previousInput.last!)
            {
                retStr+=" + ";
            }
        }
        return retStr+" )"
    }
    
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
        previousInput = pendingInput;
        pendingInput = [];
        return ret;
    }
}
