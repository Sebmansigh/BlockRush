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
    private init(){}
    
    public static var BlockWidth: CGFloat = 0;
    public static let BlockColors: [UIColor] = [UIColor.blue,UIColor.green,UIColor.red];
    
    public static func CalculateDamage(chainLevel: Int, blocksCleared: Int) -> Int
    {
        let ClearMult: Int;
        
        if(blocksCleared <= 6)
        {
            ClearMult = blocksCleared*2;
        }
        else if(blocksCleared <= 9)
        {
            ClearMult = blocksCleared*4-12;
        }
        else if(blocksCleared <= 12)
        {
            ClearMult = blocksCleared*6-30
        }
        else
        {
            ClearMult = blocksCleared*8-56;
        }
        if(chainLevel > 1)
        {
            return ClearMult * chainLevel;
        }
        else
        {
            return ClearMult / 2;
        }
    }
}
