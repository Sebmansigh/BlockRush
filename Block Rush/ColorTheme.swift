//
//  ColorTheme.swift
//  Block Rush
//
//  Created by Sebastian Snyder on 10/19/18.
//

import Foundation
import SpriteKit

struct ColorTheme
{
    private let colors: [UIColor];
    public init(_ c1:UIColor,_ c2:UIColor,_ c3:UIColor)
    {
        colors = [c1,c2,c3];
    }
    
    subscript(_ index: Int) -> UIColor
    {
        return colors[index];
    }
}
