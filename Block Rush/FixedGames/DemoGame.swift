//
//  DemoGame.swift
//  Block Rush
//
//  Created by Sebastian Snyder on 5/19/18.
//

import Foundation

final class DemoGame
{
    private init () {}
    
    public static func Get(_ name: String) -> (UInt64,[Input],[Input])
    {
        var bottom = [Input]();
        var top = [Input]();
        func bothwait(_ frames: Int)
        {
            bottom.append(contentsOf: wait(frames));
            top.append(contentsOf: wait(frames));
        }
        switch(name)
        {
        case "Tutorial":
            return (100,[],[]);
        case "Demo1":
            bothwait(240);
            
            bottom += [.LEFT,.LEFT,.PLAY];
            top += [.RIGHT,.FLIP,.PLAY];
            bothwait(40);
            bottom += [.LEFT,.PLAY];
            top += [.RIGHT,.PLAY];
            bothwait(40);
            bottom += [.NONE,.PLAY];
            top += [.LEFT,.PLAY];
            bothwait(40);
            top += [.LEFT,.FLIP,.PLAY];
            bottom += [.NONE,.NONE,.PLAY];
            bothwait(40)
            top += [.FLIP,.PLAY];
            bothwait(40);
            top += [.PLAY];
            bothwait(40);
            top += [.RIGHT,.RIGHT,.FLIP];
            bottom.append(contentsOf: wait(6));
            top += [.RIGHT,.RIGHT,.PLAY];
            bothwait(40);
            top += [.PLAY];
            bothwait(40);
            top += [.RIGHT,.RIGHT,.PLAY];
            bothwait(40);
            top += [.RIGHT,.RIGHT,.PLAY];
            bothwait(125);
            top += [.RIGHT,.RIGHT];
            bottom.append(contentsOf: wait(12));
            
            //print(top.count);
            //print(bottom.count);
            
            bothwait(120);
            bottom += [.PLAY];
            //If the number of wait frames is set to 90, bottom player gets a 2-chain. If set to 91, both players get a 1-chain.
            top.append(contentsOf: wait(90));
            top += [.PLAY];
            bothwait(600);
            //print(top.count);
            //print(bottom.count);
            return (1029784756,bottom,top);
        default:
            fatalError("Bad demo name :\(name)")
        }
    }
    private static func wait(_ frames: Int) -> [Input]
    {
        return [Input](repeating: .NONE, count: frames);
    }
}
