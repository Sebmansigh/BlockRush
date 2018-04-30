//
//  DebugTools.swift
//  Block Rush
//
//  Created by Sebastian Snyder on 4/29/18.
//

import Foundation

final class DebugTools
{
    private init() {}
    
    static func TimeExecution<T>(toCall: () -> T) -> T
    {
        return TimeExecution("", toCall: toCall);
    }
    
    static func TimeExecution<T>(_ label: String, toCall: () -> T) -> T
    {
        let start = Date();
        let ret = toCall();
        let end = Date();
        print("Timed execution \(label); Duration: \(end.timeIntervalSince(start))");
        return ret;
    }
}
