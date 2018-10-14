//
//  ReplacePiece.swift
//  Block Rush
//
//  Created by Sebastian Snyder on 10/13/18.
//

import Foundation

extension GameEvent
{
    class ReplaceActivePiece: GameEvent
    {
        private var PlayerToSwitch:Player!;
        private var NewPiece:Piece!;
        public convenience init(scene s:GameScene,player p:Player,newPiece np:Piece)
        {
            self.init(scene:s,player:p,newPiece:np,trigger:nil);
        }
        public convenience init(scene s:GameScene,player p:Player,newPiece np:Piece, trigger t: GameEventTrigger?)
        {
            self.init(scene:s,trigger:t);
            PlayerToSwitch = p;
            NewPiece = np;
        }
        private override init(scene s:GameScene, trigger t: GameEventTrigger?)
        {
            super.init(scene:s,trigger:t);
        }
        
        override func OnTrigger()
        {
            if let rp = PlayerToSwitch.readyPiece
            {
                rp.FrontBlock.nod.removeFromParent();
                rp.FrontBlock.nod.removeFromParent();
            }
            else
            {
                fatalError("No ready piece to switch");
            }
            Scene.addChild(NewPiece.FrontBlock.nod);
            Scene.addChild(NewPiece.RearBlock.nod);
            PlayerToSwitch.readyPiece = NewPiece;
            PlayerToSwitch.MoveToColumn(PlayerToSwitch.columnOver);
        }
        override func AwaitTrigger()
        {
            
        }
    }
}
