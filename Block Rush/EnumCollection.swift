//
//  EnumCollection.swift
//  Block Rush
//
//  Created by Sebastian Snyder on 4/8/18.
//

import Foundation

protocol EnumCollection: Hashable
{
    static func All() -> AnySequence<Self>;
    static func Name(_ :Self) -> String;
    static func NameMap() -> [String: Self];
}

extension EnumCollection
{
    /**
     Creates a sequence containing all pre-defined values of an enum
     in the order that they were defined.
     
     - Returns: The final sequence object.
     */
    static func All() -> AnySequence<Self>
    {
        //typealias S = Self
        return AnySequence
        {
            () -> AnyIterator<Self> in
                var raw = 0
                return AnyIterator
                {
                    let current: Self = withUnsafePointer(to: &raw)
                    {
                        $0.withMemoryRebound(to: self, capacity: 1)
                        {
                            return $0.pointee;
                        }
                    }
                    guard current.hashValue == raw
                    else
                    {
                        return nil;
                    }
                    raw += 1;
                    return current;
                }
        }
    }
    
    /**
     Returns the `String` representation of this value.
     - Returns: The `String` representation of this value.
     */
    static func Name(_ s:Self) -> String
    {
        return "\(s)";
    }
    
    /**
     Constructs a map of all `String` representations to their enum value.
     - Returns: The final map.
     */
    static func NameMap() -> [String: Self]
    {
        var ret:[String:Self] = [:];
        
        for s in All()
        {
            ret[Name(s)] = s;
        }
        
        return ret;
    }
}
