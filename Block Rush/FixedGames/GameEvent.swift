//
//  GameEvent.swift
//  Block Rush
//
//  Created by Sebastian Snyder on 10/12/18.
//

import Foundation

/**
 Causes some specified behavior in a Fixed Game.
 */
class GameEvent
{
    /**
     If not nil, stores a closure that is run every frame. If it returns true, it is executed.
     If it is nil, this event is executed immediatly when it is at the head of the queue.
     */
    private var Trigger: ((GameScene) -> Bool)?;
    
    internal convenience init ()
    {
        self.init(nil);
    }
    
    internal init (_ t:((GameScene) -> Bool)?)
    {
        Trigger = t;
    }
    
    final func TestTrigger(scene s:GameScene) -> Bool
    {
        if let t = Trigger
        {
            return t(s);
        }
        else
        {
            return true;
        }
    }
    
    func Execute(scene s: GameScene)
    {
        fatalError("Execute(scene:) not overriden by a subclass.");
    }
}
