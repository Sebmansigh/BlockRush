//
//  File.swift
//  Block Rush
//
//  Created by Sebastian Snyder on 10/13/18.
//

import Foundation

/**
 A class containing fixed games.
 A fixed game is one that is predetermined all the way through and has events that occur throughout.
 A good example of this is the tutorials, which the player may interact with, but all matches happen the same way.
 */
final class FixedGame
{
    private init() {}
    
    /**
     Generates a fixed game with the specified name.
     */
    public static func Get(_ name: String) -> (Int,Queue<GameEvent>)
    {
        switch(name)
        {
        case "Tutorial":
            let initSeed = 0;
            let eventQueue = Queue<GameEvent>();
            eventQueue.enqueue(GameEvent.HideTopPlayer());
            eventQueue.enqueue(GameEvent.Wait(2));
            eventQueue.enqueue(GameEvent.Dialogue(text:"Hi there."));
            return (0,eventQueue);
        default:
            fatalError("Unknown fixed game name \(name)");
        }
    }
}
