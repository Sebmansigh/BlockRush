//
//  DelayedDevice.swift
//  Block Rush
//
//  Created by Sebastian Snyder on 5/20/18.
//

import Foundation

class DelayedDevice: InputDevice
{
    private var frameQueue = Queue<UInt8>();
    private var frameDelay: Int;
    private var otherDevice: InputDevice;
    
    init(device: InputDevice, frames: Int)
    {
        frameDelay = frames;
        otherDevice = device;
    }
    
    public override func debugText() -> String
    {
        return otherDevice.debugText() + " Delay: \(frameQueue.count())";
    }
    
    override func CanEval() -> Bool
    {
        if(frameDelay == 0)
        {
            return otherDevice.CanEval();
        }
        //
        while(frameQueue.count() < frameDelay && otherDevice.CanEval())
        {
            frameQueue.enqueue(otherDevice.Eval());
        }
        if(frameQueue.count() < frameDelay)
        {
            return false;
        }
        if(player!.curFrame < playField!.GameFrame-frameDelay)
        {
            return true;
        }
        else
        {
            return false;
        }
    }
    
    override func Eval() -> UInt8
    {
        if(frameDelay == 0)
        {
            return otherDevice.Eval();
        }
        //
        
        if(CanEval())
        {
            return frameQueue.dequeue();
        }
        fatalError("Ahead of delay.");
    }
}
