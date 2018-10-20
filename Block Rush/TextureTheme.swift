//
//  ColorTheme.swift
//  Block Rush
//
//  Created by Sebastian Snyder on 10/19/18.
//

import Foundation
import SpriteKit

struct TextureTheme
{
    private let textures: [SKTexture];
    
    public init(_ t:SKTexture)
    {
        textures = [t,t,t];
    }
    
    public init(_ t1:SKTexture,_ t2:SKTexture,_ t3:SKTexture)
    {
        textures = [t1,t2,t3];
    }
    
    subscript(_ index: Int) -> SKTexture
    {
        return textures[index];
    }
}
