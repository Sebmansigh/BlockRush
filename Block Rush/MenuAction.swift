//
//  MenuAction.swift
//  Block Rush
//
//  Created by Sebastian Snyder on 4/7/18.
//

import Foundation

class MenuAction: MenuOption
{
    let onPressAction: ()->Void;
    init(title:String, action: @escaping ()->Void)
    {
        onPressAction = action;
        super.init(title: title);
    }
    required init(title: String)
    {
        onPressAction = {};
        super.init(title: title);
    }
    
    override func EvalPress()
    {
        onPressAction();
    }
    
}
