//
//  File.swift
//  Block Rush
//
//  Created by Sebastian Snyder on 3/26/18.
//

import Foundation
import SpriteKit
/**
 A class containing functions and properties relating to the game as a whole.
 */
final class BlockRush
{
    public static let DEBUG_MODE = false;//264
    
    ///A publically readable and writable map of settings and their values.
    public static var Settings: [Setting:SettingOption] = [:];
    
    ///The highest score earned in survival mode
    public static var SurvivalHighScore = 0;
    ///The highest score earned in time attack mode
    public static var TimeAttackHighScore = 0;
    
    ///To be called exactly once when the app launches.
    public static func Initialize()
    {
        loadSettings();
        loadHighScores();
        
        ScreenWidth = UIScreen.main.nativeBounds.width;
        ScreenHeight = UIScreen.main.nativeBounds.height;
        
        GameWidth = UIScreen.main.nativeBounds.width;
        GameHeight = min(UIScreen.main.nativeBounds.height,UIScreen.main.nativeBounds.width*2);
        
        BlockWidth = min(GameWidth * 0.12,GameHeight/14);
    }
    
    ///Initializes `BlockRush.Settings` using the contents of the local .settings file
    public static func loadSettings()
    {
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        {
            let fileURL = dir.appendingPathComponent(".settings");
            do
            {
                let SettingsFileString = try String(contentsOf: fileURL,encoding: .utf8);
                let StoredSettings = SettingsFileString.components(separatedBy: .newlines);
                
                let S = Setting.nameMap;
                
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
        
        print("Entering Loop");
        //Assign default values for settings that weren't found
        for s in Setting.allCases
        {
            if(Settings[s] == nil)
            {
                Settings[s] = Setting.getDefault(s);
            }
            
            //print("\(s)=\(Settings[s]!.rawValue)")
        }
    }
    ///Initializes `BlockRush.SurvivalHighScore` and `BlockRush.TimeAttackHighScore` from their files.
    public static func loadHighScores()
    {
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        {
            do
            {
                let fileURL = dir.appendingPathComponent("survival.hs");
                let FileString = try String(contentsOf: fileURL,encoding: .utf8);
                let ScoreStrings = FileString.components(separatedBy: .newlines);
                
                for Str in ScoreStrings
                {
                    if(Str != "")
                    {
                        if let hs = Int(Str)
                        {
                            SurvivalHighScore = hs;
                        }
                        else
                        {
                            print("Error loading Survival High Score");
                        }
                    }
                }
                print("Survival High Score Loaded: \(TimeAttackHighScore)");
            }
            catch
            {
                print("Error loading Survival High Score");
            }
            //
            do
            {
                let fileURL = dir.appendingPathComponent("timeattack.hs");
                let FileString = try String(contentsOf: fileURL,encoding: .utf8);
                let ScoreStrings = FileString.components(separatedBy: .newlines);
                
                for Str in ScoreStrings
                {
                    if(Str != "")
                    {
                        if let hs = Int(Str)
                        {
                            TimeAttackHighScore = hs;
                        }
                        else
                        {
                            print("Error loading Time Attack High Score");
                        }
                    }
                }
                print("Time Attack High Score Loaded: \(TimeAttackHighScore)");
            }
            catch
            {
                print("Error loading Time Attack High Score");
            }
        }
        
    }
    
    ///Saves the settings map to a file.
    public static func saveSettings()
    {
        var settingsString = "";
        for s in Setting.allCases
        {
            settingsString.append(s.name);
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
    
    ///Saves the high scores to their files.
    public static func saveHighScores()
    {
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        {
            do
            {
                let fileURL = dir.appendingPathComponent("survival.hs");
                try String(SurvivalHighScore).write(to: fileURL, atomically: true, encoding: .utf8);
                print("Survival High Score Saved");
            }
            catch
            {
                print("Error saving Survival High Score");
            }
            do
            {
                let fileURL = dir.appendingPathComponent("timeattack.hs");
                try String(TimeAttackHighScore).write(to: fileURL, atomically: true, encoding: .utf8);
                print("Time Attack High Score Saved");
            }
            catch
            {
                print("Error saving Time Attack High Score");
            }
        }
    }
    
    private init(){}
    
    public static var BlockWidth: CGFloat = 0;
    
    public static var ScreenWidth: CGFloat = 0;
    public static var ScreenHeight: CGFloat = 0;
    
    public static var GameWidth: CGFloat = 0;
    public static var GameHeight: CGFloat = 0;
    
    public static let NumberOfGameBlocks: Int = 3;
    
    public static func CalculateScore(chainLevel c: Int, blocksCleared n: Int) -> Int
    {
        let BlockScore = n*(n+1)/2 * 10;
        let ChainBonus = 3+c+c*(c+1)/2;
        return BlockScore*Int(ChainBonus);
    }
    
    public static func CalculateOverpowerBonus(units u: Int) -> Int
    {
        return 1000 + u*(u+1);
    }
    
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
    
    static func Commafy(value: Int) -> String
    {
        var x = value;
        var ret = "";
        while(x >= 1000)
        {
            let part = x % 1000;
            x -= part;
            if(part < 10)
            {
                ret = ",00\(part)"+ret;
            }
            else if(part < 100)
            {
                ret = ",0\(part)"+ret;
            }
            else
            {
                ret = ",\(part)"+ret;
            }
            
            x /= 1000;
        }
        return "\(x)"+ret;
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
