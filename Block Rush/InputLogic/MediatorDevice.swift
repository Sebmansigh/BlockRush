//
//  MediatorDevice.swift
//  Block Rush
//
//  Created by Sebastian Snyder on 4/28/18.
//

import Foundation

class MediatorDevice : InputDevice
{
    public var frameQueue = Queue<UInt8>();
    
    public override func debugText() -> String
    {
        return "QueueSize: \(frameQueue.count())";
    }
    
    override func CanEval() -> Bool
    {
        return !frameQueue.isEmpty();
    }
    
    override func Eval() -> UInt8
    {
        return frameQueue.dequeue();
    }
}
