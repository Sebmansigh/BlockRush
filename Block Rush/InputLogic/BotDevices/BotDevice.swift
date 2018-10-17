//
//  BotDevices.swift
//  Block Rush
//
//  Created by Sebastian Snyder on 4/28/18.
//

import Foundation

protocol BotDevice
{
    ///To be called when a game begins.
    ///BotDevices should set their state to start-of-game status here.
    func ResetState() -> Void
}

struct BotDevices
{
}
