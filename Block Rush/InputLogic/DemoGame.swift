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
        switch(name)
        {
        case "Demo1":
            bottom.append(contentsOf: wait(240));
            for _ in 0...10
            {
                bottom.append(contentsOf: wait(70));
                bottom.append(.LEFT);
                bottom.append(contentsOf: wait(5));
                bottom.append(.LEFT);
                bottom.append(contentsOf: wait(5));
                bottom.append(Input(rawValue: Input.LEFT.rawValue | Input.PLAY.rawValue));
                bottom.append(contentsOf: wait(70));
                bottom.append(.LEFT);
                bottom.append(contentsOf: wait(5));
                bottom.append(Input(rawValue: Input.LEFT.rawValue | Input.PLAY.rawValue));
                bottom.append(contentsOf: wait(70));
                bottom.append(Input(rawValue: Input.LEFT.rawValue | Input.PLAY.rawValue));
                bottom.append(contentsOf: wait(70));
                bottom.append(.PLAY);
                bottom.append(contentsOf: wait(70));
                bottom.append(Input(rawValue: Input.RIGHT.rawValue | Input.PLAY.rawValue));
                bottom.append(contentsOf: wait(70));
                bottom.append(.RIGHT);
                bottom.append(contentsOf: wait(5));
                bottom.append(Input(rawValue: Input.RIGHT.rawValue | Input.PLAY.rawValue));
            }
            bottom.append(contentsOf: wait(0));
            return (1029784756,bottom,bottom);
        default:
            fatalError("Bad demo name :\(name)")
        }
    }
    private static func wait(_ frames: Int) -> [Input]
    {
        return [Input](repeating: .NONE, count: frames);
    }
}
