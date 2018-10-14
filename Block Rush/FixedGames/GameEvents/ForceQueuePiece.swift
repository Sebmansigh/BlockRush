//
//  ReplacePiece.swift
//  Block Rush
//
//  Created by Sebastian Snyder on 10/13/18.
//

import Foundation

extension GameEvent
{
    class ForceQueuePiece: GameEvent
    {
        private var PlayerToForce:Player!;
        private var PieceToForce:Piece!;
        public convenience init(scene s:GameScene,player p:Player,newPiece np:Piece)
        {
            self.init(scene:s,player:p,newPiece:np,trigger:nil);
        }
        public convenience init(scene s:GameScene,player p:Player,newPiece np:Piece,trigger t: GameEventTrigger?)
        {
            self.init(scene:s,trigger:t);
            PlayerToForce = p;
            PieceToForce = np;
        }
        private override init(scene s:GameScene, trigger t: GameEventTrigger?)
        {
            super.init(scene:s,trigger:t);
        }
        
        override func OnTrigger()
        {
            PlayerToForce.forcePieceQueue.enqueue(PieceToForce);
            PlayerToForce.SceneUpdate();
        }
        override func AwaitTrigger()
        {
            
        }
    }
}
