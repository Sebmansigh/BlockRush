//
//  KeyboardDevice.swift
//  Block Rush
//
//  Created by Sebastian Snyder on 5/24/18.
//

import Foundation
import UIKit

final class KeyboardDevice: InputDevice
{
    public var pendingInput: [Input] = [];
    private var previousInput: [Input] = [];
    public static var Device = KeyboardDevice();
    
    private override init() {super.init();}
    
    public override func debugText() -> String
    {
        if(previousInput.count == 0)
        {
            return "KB: ( _ )";
        }
        var retStr = "KB: ( ";
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
