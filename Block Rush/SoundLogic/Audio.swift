//
//  Audio.swift
//  Block Rush
//
//  Created by Sebastian Snyder on 10/28/18.
//

import Foundation
import SpriteKit
import MediaPlayer
import AVFoundation

struct Audio
{
    private init() {}
    
    
    static let Sounds: [String: SKAction] =
    [
        //"MatchBoom": SKAction.playSoundFileNamed("MatchBoom.aif", waitForCompletion: false),
        "MoveTick" : SKAction.playSoundFileNamed("MoveTick.wav", waitForCompletion: false),
        "PlaySnap" : SKAction.playSoundFileNamed("PlaySnap.wav", waitForCompletion: false),
        
        "Chain1"   : SKAction.playSoundFileNamed("Chain1.wav", waitForCompletion: false),
        "Chain2"   : SKAction.playSoundFileNamed("Chain2.wav", waitForCompletion: false),
        "Chain3"   : SKAction.playSoundFileNamed("Chain3.wav", waitForCompletion: false),
        "Chain4"   : SKAction.playSoundFileNamed("Chain4.wav", waitForCompletion: false),
        "Chain5"   : SKAction.playSoundFileNamed("Chain5.wav", waitForCompletion: false),
        "Chain6"   : SKAction.playSoundFileNamed("Chain6.wav", waitForCompletion: false),
        "Chain7"   : SKAction.playSoundFileNamed("Chain7.wav", waitForCompletion: false),
        
        "Winner"   : SKAction.playSoundFileNamed("Winner.wav", waitForCompletion: false),
        "Loser"    : SKAction.playSoundFileNamed("Loser.wav", waitForCompletion: false),
    ];
    
    public static var SoundScene: SKScene? = nil;
    public static var BGMplayer: AVAudioPlayer? = nil;
    
    public static var preparedBGM: String? = nil;
    private static var lastPrepareAttempt: String? = nil;
    
    static func PlaySound(name:String)
    {
        //print("Playing sound: "+name);
        //let SfxVolume = Float(Settings[ .SoundEffectVolume ]!.rawValue)/100.0;
        
        let action = Sounds[name]!.copy() as! SKAction;
        let vol = Float(BlockRush.Settings[.SoundEffectVolume]!.rawValue)/100.0;
        SoundScene!.run(.group([action,.changeVolume(to: vol, duration: 0.25)]));
    }
    
    static func PrepareMusic(name:String)
    {
        lastPrepareAttempt = name;
        
        guard let url = Bundle.main.url(forResource: name, withExtension: "aiff")
            else
        {
            print("Could not play music file "+name+".aiff");
            preparedBGM = nil;
            return;
        }
        do
        {
            if(BGMplayer != nil)
            {
                BGMplayer!.stop();
            }
            
            if #available(iOS 10.0, *)
            {
                try AVAudioSession.sharedInstance().setCategory(.ambient,mode:.default);
            }
            else
            {
                //Older version...
            }
            try AVAudioSession.sharedInstance().setActive(true);
            BGMplayer = try AVAudioPlayer(contentsOf: url);
            BGMplayer!.numberOfLoops = -1;
            
            BGMplayer!.volume = Float(BlockRush.Settings[.BackgroundMusicVolume]!.rawValue)/100;
            
            BGMplayer!.prepareToPlay();
            preparedBGM = name;
        }
        catch let error
        {
            print(error.localizedDescription);
        }
    }
    
    static func ReprepareMusic()
    {
        if let reprepName = lastPrepareAttempt
        {
            PrepareMusic(name: reprepName);
        }
    }
    
    static func PauseMusic()
    {
        BGMplayer?.pause();
    }
    
    static func StopMusic()
    {
        BGMplayer?.stop();
        preparedBGM = nil;
    }
    
    static func PlayMusic()
    {
        let musicPlayer = MPMusicPlayerController.systemMusicPlayer;
        if(musicPlayer.playbackState != MPMusicPlaybackState.playing)
        {
            BGMplayer?.play();
        }
    }
    
}
