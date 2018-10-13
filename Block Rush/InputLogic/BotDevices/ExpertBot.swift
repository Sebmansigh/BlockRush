//
//  ExpertBot.swift
//  Block Rush
//
//  Created by Sebastian Snyder on 10/13/18.
//

import Foundation

extension BotDevice
{
    public class Expert: InputDevice
    {
        public override init() {fatalError("Expert Bot is not ready to play.");};
        
        public override func debugText() -> String
        {
            return "ExpertBot";
        }
    }
}
