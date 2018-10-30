//
//  ipify.swift
//  Block Rush
//
//  Created by Sebastian Snyder on 10/29/18.
//

import Foundation

///Uses the public ipify API to acquire the user's public facing IP
struct ipify
{
    private ipify() {}
    
    func getPublicIP() -> String
    {
        getifaddrs(<#T##UnsafeMutablePointer<UnsafeMutablePointer<ifaddrs>?>!#>)
    }
}
