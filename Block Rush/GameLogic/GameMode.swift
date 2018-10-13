//
//  GameMode.swift
//  Block Rush
//
//  Created by Sebastian Snyder on 10/13/18.
//

import Foundation

enum GameMode
{
    case Versus;
    case Practice;
    case Survival;
    case TimeAttack;
    case Replay(name:String);
    case Fixed(name:String);
}
