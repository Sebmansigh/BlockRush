//
//  DebugTools.swift
//  Block Rush
//
//  Created by Sebastian Snyder on 4/29/18.
//

import Foundation

/**
 A class containing functions for use in debugging
*/
final class DebugTools
{
    private init() {}
    
    /**
     Executes a given closure and prints the time in seconds it took to run.
     
     - Parameters:
        - toCall: The closure to execute.
     
     - Returns: The value returned by the closure.
    */
    static func TimeExecution<T>(toCall: () -> T) -> T
    {
        return TimeExecution("", toCall: toCall);
    }
    
    /**
     Executes a given closure and prints the time in seconds it took to run.
     
     - Parameters:
        - label: A string to print alongside the execution time
        - toCall: The closure to execute.
     
     - Returns: The value returned by the closure.
     */
    static func TimeExecution<T>(_ label: String, toCall: () -> T) -> T
    {
        let start = Date();
        let ret = toCall();
        let end = Date();
        print("Timed execution \(label); Duration: \(end.timeIntervalSince(start))");
        return ret;
    }
}
