//
//  File.swift
//  Block Rush
//
//  Created by Sebastian Snyder on 3/26/18.
//

import Foundation
import SpriteKit
import AVFoundation

/**
 A class containing functions and properties relating to the game as a whole.
 */
final class BlockRush
{
    public static let DEBUG_MODE = false;//264
    /**
     A publically readable and writable map of settings and their values.
     */
    public static var Settings: [Setting:SettingOption] = [:];
    
    /**
     To be called exactly once when the app launches.
     */
    public static func Initialize()
    {
        loadSettings();
        
        ScreenWidth = UIScreen.main.nativeBounds.width;
        ScreenHeight = UIScreen.main.nativeBounds.height;
        
        GameWidth = UIScreen.main.nativeBounds.width;
        GameHeight = min(UIScreen.main.nativeBounds.height,UIScreen.main.nativeBounds.width*2);
        
        BlockWidth = min(GameWidth * 0.12,GameHeight/14);
        print(BlockWidth);
    }
    
    /**
     Initializes `BlockRush.Settings` using the contents of the local .settings file
     */
    public static func loadSettings()
    {
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        {
            let fileURL = dir.appendingPathComponent(".settings");
            do
            {
                let SettingsFileString = try String(contentsOf: fileURL,encoding: .utf8);
                let StoredSettings = SettingsFileString.components(separatedBy: .newlines);
                
                let S = Setting.NameMap();
                
                for Str in StoredSettings
                {
                    if(Str != "")
                    {
                        let Data = Str.components(separatedBy: "=");
                        Settings[S[Data[0]]!] = .From(Data[1]);
                    }
                }
                print("Settings Loaded");
            }
            catch
            {
                print("Error loading settings");
            }
        }
        
        //Assign default values for settings that weren't found
        for s in Setting.All()
        {
            if(Settings[s] == nil)
            {
                Settings[s] = Setting.getDefault(s);
            }
            
            //print("\(s)=\(Settings[s]!.rawValue)")
        }
    }
    
    public static func saveSettings()
    {
        var settingsString = "";
        for s in Setting.All()
        {
            settingsString.append(Setting.Name(s));
            settingsString.append("=");
            settingsString.append(String(Settings[s]!.rawValue));
            settingsString.append("\n");
        }
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        {
            let fileURL = dir.appendingPathComponent(".settings");
            do
            {
                try settingsString.write(to: fileURL, atomically: true, encoding: .utf8);
                print("Settings Saved");
            }
            catch
            {
                print("Error saving settings");
            }
        }
    }
    
    private init(){}
    
    public static var BlockWidth: CGFloat = 0;
    public static let BlockColors: [UIColor] = [
        UIColor(red:1,green:0.2,blue:0.2,alpha:1),
        UIColor(red:0.2,green:1,blue:0.2,alpha:1),
        UIColor(red:0.2,green:0.2,blue:1,alpha:1)];
    
    public static var ScreenWidth: CGFloat = 0;
    public static var ScreenHeight: CGFloat = 0;
    
    public static var GameWidth: CGFloat = 0;
    public static var GameHeight: CGFloat = 0;
    
    public static func CalculateDamage(chainLevel: Int, blocksCleared: Int) -> Int
    {
        let ClearVal: Int;
        
        switch(blocksCleared)
        {
        case 4: ClearVal = 8;       // Minimum match: One 4-group.
        case 5: ClearVal = 9;
        case 6: ClearVal = 10;
        case 7: ClearVal = 11;
        case 8: ClearVal = 12;      // Two 4-groups.
        case 9: ClearVal = 14;
        case 10: ClearVal = 16;
        case 11: ClearVal = 18;
        case 12: ClearVal = 20;     // Three 4-groups or Two 6-groups.
        case 13: ClearVal = 22;
        case 14: ClearVal = 24;
        case 15: ClearVal = 28;     // Three 5-groups.
        case 16: ClearVal = 32;     // Four 4-groups.
        default:
            ClearVal = 32+(blocksCleared-16)*5;
        }
        // The curve I want:
        //  4 =  1     half-row
        //  5 =  1 1/8 half-rows
        //  6 =  1 2/8 half-rows
        //  7 =  1 3/8 half-rows
        //  8 =  1 4/8 half-rows
        //  9 =  1 6/8 half-rows
        // 10 =  2     half-rows
        // 11 =  2 1/4 half-rows
        // 12 =  2 1/2 half-rows
        // 13 =  2 3/4 half-rows
        // 14 =  3     half-rows
        // 15 =  3 1/2 half-rows
        // 16 =  4     half-rows
        // Each Block thereafter is worth an additional 5/8 half-rows.
        
        return ClearVal * chainLevel;
    }
    
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
    
    static func PlaySound(name:String)
    {
        //print("Playing sound: "+name);
        //let SfxVolume = Float(Settings[ .SoundEffectVolume ]!.rawValue)/100.0;
        
        let action = Sounds[name]!.copy() as! SKAction;
        
        SoundScene!.run(action);
    }
    
    public static var player: AVAudioPlayer? = nil;
    static func PlayMusic(name:String)
    {
        guard let url = Bundle.main.url(forResource: name, withExtension: "aiff")
        else
        {
            print("Could not play music file "+name+".aiff");
            return;
        }
        do
        {
            if(player != nil)
            {
                player!.stop();
            }
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback);
            try AVAudioSession.sharedInstance().setActive(true);
            player = try AVAudioPlayer(contentsOf: url);
            player!.numberOfLoops = -1;
            player!.volume = Float(Settings[Setting.BackgroundMusicVolume]!.rawValue)/100;
            player!.play();
        }
        catch let error
        {
            print(error.localizedDescription);
        }
    }
    static func StopMusic()
    {
        player?.stop();
    }
    
    static func PopUp(_ text: String)
    {
        let bgNode = SKSpriteNode(color: .darkGray, size: CGSize(width: BlockRush.BlockWidth*8, height: BlockRush.BlockWidth*0.75));
        let label = SKLabelNode(text: text);
        label.verticalAlignmentMode = .center;
        label.fontName = "Avenir";
        label.fontSize = BlockRush.BlockWidth * 0.5;
        
        bgNode.run(.sequence([.wait(forDuration: 3) ,.fadeOut(withDuration: 2)]))
        {
            bgNode.removeFromParent();
        };
        bgNode.addChild(label);
        bgNode.zPosition = 10000000;
        GameView.curview?.scene?.addChild(bgNode);
    }
}
