//
//  GameEventTrigger.swift
//  Block Rush
//
//  Created by Sebastian Snyder on 10/13/18.
//

import Foundation

indirect enum GameEventTrigger: Equatable
{
    case Repeated(_ trigger: GameEventTrigger,numTimes: Int);
    case OnFrameUpdate;
    case OnGameFrameUpdate;
    case OnScreenTap;
    case OnPlayerMove;
    case OnBottomPlayerColumn(Int);
    case OnTopPlayerColumn(Int);
    case OnPlayerFlip;
    case OnPlayerPlay;
}
