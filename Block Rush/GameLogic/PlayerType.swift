//
//  PlayerType.swift
//  Block Rush
//
//  Created by Sebastian Snyder on 4/28/18.
//

import Foundation

enum PlayerType
{
    case None; //Implementation note: always crash when this case is found with the bottom player.
    case Local;
    case Replay;
    case BotNovice;
    case BotAdept;
    case BotExpert;
    case BotMaster;
    case Network;
}
