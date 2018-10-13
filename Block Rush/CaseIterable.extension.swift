//
//  CaseIterableExt.swift
//  Block Rush
//
//  Created by Sebastian Snyder on 10/12/18.
//

import Foundation

extension CaseIterable
{
    var name: String
    {
        return "\(self)";
    }
    
    static var nameMap: [String:Self]
    {
        var ret = [String:Self]()
        for c in allCases
        {
            ret[c.name] = c;
        }
        return ret;
    }
}
