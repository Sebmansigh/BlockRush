//
//  File.swift
//  Block Rush
//
//  Created by Sebastian Snyder on 3/26/18.
//

import Foundation
import SpriteKit

final class BlockRush
{
    public static var Settings: [Setting:SettingOptions] = [:];
    
    public static func loadSettings()
    {
        //Load settings from input file
        
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
                    let Data = Str.components(separatedBy: "=");
                    Settings[S[Data[0]]!] = .From(Data[1]);
                }
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
            
            print("\(s)=\(Settings[s]!.rawValue)")
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
            }
            catch
            {
                print("Error saving settings");
            }
        }
    }
    
    private init(){}
    
    public static var BlockWidth: CGFloat = 0;
    public static let BlockColors: [UIColor] = [UIColor.blue,UIColor.green,UIColor.red];
    
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
}
