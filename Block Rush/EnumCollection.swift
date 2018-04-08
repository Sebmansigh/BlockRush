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
    
    static func Name(_ s:Self) -> String
    {
        return "\(s)";
    }
    
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
