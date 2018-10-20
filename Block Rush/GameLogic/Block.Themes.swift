//
//  Block.extension.swift
//  Block Rush
//
//  Created by Sebastian Snyder on 10/19/18.
//

import Foundation
import SpriteKit

extension Block
{
    static let ColorThemes: [SettingOption: ColorTheme] =
        [
            SettingOption.ColorTheme.BasicColors: ColorTheme(
                UIColor(red:1.0  ,green:0.2  ,blue:0.2  ,alpha:1),
                UIColor(red:0.2  ,green:1.0  ,blue:0.2  ,alpha:1),
                UIColor(red:0.2  ,green:0.2  ,blue:1.0  ,alpha:1)
            ),
            SettingOption.ColorTheme.Deuteranopia: ColorTheme(
                UIColor(red:0.5  ,green:0.5  ,blue:0.5  ,alpha:1),
                UIColor(red:0.145,green:0.411,blue:0.843,alpha:1),
                UIColor(red:0.867,green:0.8  ,blue:0.271,alpha:1)
            ),
            SettingOption.ColorTheme.Tritanopia: ColorTheme(
                UIColor(red:0.91 ,green:0.494,blue:0.482,alpha:1),
                UIColor(red:0.541,green:0.275,blue:0.318,alpha:1),
                UIColor(red:0.51 ,green:0.871,blue:0.981,alpha:1)
            ),
            SettingOption.ColorTheme.Grayscale: ColorTheme(
                UIColor(red:0.20 ,green:0.20 ,blue:0.20 ,alpha:1),
                UIColor(red:0.40 ,green:0.40 ,blue:0.40 ,alpha:1),
                UIColor(red:0.85 ,green:0.85 ,blue:0.85 ,alpha:1)
            ),
        ]
    
    static let TextureThemes: [SettingOption: TextureTheme] =
        [
            SettingOption.TextureTheme.BasicShapes: TextureTheme(
                SKTexture(imageNamed: "BlockSquare"),
                SKTexture(imageNamed: "BlockDiamond"),
                SKTexture(imageNamed: "BlockCircle")
            ),
            SettingOption.TextureTheme.Flat: TextureTheme(
                SKTexture(imageNamed: "BlockFlat")
            ),
            SettingOption.TextureTheme.Solid: TextureTheme(
                SKTexture(data: Data(bytes: [255,255,255,255]), size: CGSize(width:1,height:1))
            )
        ]
    
    static func ==(lhs: Block, rhs: Block) -> Bool
    {
        return lhs === rhs;
    }
    
    static func GetColorTheme(_ option:SettingOption) -> ColorTheme
    {
        if let ct = ColorThemes[option]
        {
            return ct;
        }
        else
        {
            fatalError("Unknown color theme option:\(option.rawValue)");
        }
    }
    static func GetTextureTheme(_ option:SettingOption) -> TextureTheme
    {
        if let tt = TextureThemes[option]
        {
            return tt;
        }
        else
        {
            fatalError("Unknown texture theme option:\(option.rawValue)");
        }
    }
    
    static func CurrentColorTheme() -> ColorTheme
    {
        return GetColorTheme(BlockRush.Settings[.ColorTheme]!);
    }
    
    static func CurrentTextureTheme() -> TextureTheme
    {
        return GetTextureTheme(BlockRush.Settings[.TextureTheme]!);
    }
}
