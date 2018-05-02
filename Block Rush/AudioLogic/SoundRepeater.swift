//
//  SoundRepeater.swift
//  Block Rush
//
//  Created by Sebastian Snyder on 5/2/18.
//

import Foundation
import AVFoundation

class SoundPlayer
{
    let AVPlayers: [AVAudioPlayer];
    var curPlayer = 0;
    init(file: String, players: Int)
    {
        var p: [AVAudioPlayer] = [];
        for _ in 0...players
        {
            p.append( try! AVAudioPlayer(contentsOf: URL(fileURLWithPath:
                                    Bundle.main.path(forResource: file, ofType:nil)! )) );
        }
        AVPlayers = p;
    }
    convenience init(file: String)
    {
        self.init(file: file, players: 1);
    }
    
    func play(volume: Float)
    {
        let p = AVPlayers[curPlayer];
        p.volume = volume;
        p.play();
        curPlayer = (curPlayer + 1) % AVPlayers.count;
    }
}
