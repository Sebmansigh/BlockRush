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
     Holds the queue of `GameEvent`s in a fixed game
     */
    public static var EventQueue: Queue<GameEvent>? = nil;
    /**
     Whether or not this event is at the top of the queue.
     */
    private var ActiveEvent = false;
    /**
     If not nil, stores a closure that is run every frame. If it returns true, it is executed.
     If it is nil, this event is executed immediatly when it is at the head of the queue.
     */
    private var Trigger: GameEventTrigger?;
    
    
    /**
     Stores a reference to the current game scene
     */
    internal unowned let Scene: GameScene;
    
    internal convenience init(scene s:GameScene)
    {
        self.init(scene: s,trigger: nil);
    }
    
    internal init (scene s:GameScene, trigger t:GameEventTrigger?)
    {
        Scene = s;
        Trigger = t;
    }
    
    static func ClearEvents()
    {
        EventQueue = nil;
        Dialogue.labels = [];
    }
    
    /**
     Causes an event at the front of the queue to recieve the specified event
    */
    static func Fire(_ tArg:GameEventTrigger)
    {
        if let eq = EventQueue,
            !eq.isEmpty()
        {
            let Event = eq.peek();
            let et = Event.Trigger!
            if case .Repeated(let trig,var num) = et,
                case trig = tArg
            {
                num -= 1;
                if(num == 1)
                {
                    Event.Trigger = tArg;
                }
                else if(num == 0)
                {
                    DoEvent(Event);
                }
                else
                {
                    Event.Trigger = .Repeated(tArg,numTimes:num);
                }
            }
            else if(et == tArg)
            {
                DoEvent(Event);
            }
        }
    }
    
    /**
     Does the event and removes it from the queue
     */
    private static func DoEvent(_ event:GameEvent)
    {
        if let eq = EventQueue
        {
            if(event === eq.peek())
            {
                let _ = eq.dequeue();
                event.OnTrigger();
                print("Out of queue: \(type(of: event))");
                DoEvents();
            }
        }
    }
    
    /**
     Called when an event reaches the front of the queue.
     Processes events until one with a trigger is found
     */
    public static func DoEvents()
    {
        if let eq = EventQueue,
            !eq.isEmpty()
        {
            var ev = eq.peek();
            ev.ActiveEvent = true;
            print("Top of queue: \(type(of: ev))");
            ev.AwaitTrigger();
            while ev.Trigger == nil
            {
                let _ = eq.dequeue();
                ev.OnTrigger();
                print("Out of queue: \(type(of: ev))");
                if(eq.isEmpty())
                {
                    break;
                }
                else
                {
                    ev = eq.peek();
                    ev.ActiveEvent = true;
                    print("Top of queue: \(type(of: ev))");
                    ev.AwaitTrigger();
                }
            }
        }
    }
    
    /**
     Called immediately when this `GameEvent` reaches the top of the Event Queue.
     If `Trigger` is set to `nil`, then `Triggered()` will be called immediately afterwards.
     */
    func AwaitTrigger()
    {
        fatalError("Execute(scene:) not overriden by a subclass.");
    }
    
    /**
     If `Trigger` is not set to `nil`, this function will be called whenever its `GameEventTrigger` fires.
     If it is, this function will be called immediately after `TopOfQueue()`.
     */
    func OnTrigger()
    {
        fatalError("Execute(scene:) not overriden by a subclass.");
    }
}