//
//  Dialogue.GameEvent.swift
//  Block Rush
//
//  Created by Sebastian Snyder on 10/13/18.
//

import Foundation
import SpriteKit

extension GameEvent
{
    class Dialogue: GameEvent
    {
        var labels = [SKLabelNode]();
        
        public convenience init(scene s:GameScene, text t: String)
        {
            self.init(scene:s,trigger:.OnScreenTap);
            for line in t.split(separator: "\n")
            {
                let label = SKLabelNode(fontNamed: "Avenir");
                label.position.y = BlockRush.GameHeight/4;
                label.fontSize = BlockRush.BlockWidth*2/3;
                label.text = String(line);
                labels.append(label);
            }
            for i in 0...labels.count-1
            {
                labels[i].position.y -= BlockRush.BlockWidth*CGFloat(i);
            }
        }
        public convenience init(scene s:GameScene,label l: SKLabelNode)
        {
            self.init(scene:s,trigger:.OnScreenTap);
            labels = [l];
        }
        public convenience init(scene s:GameScene,labels l: [SKLabelNode])
        {
            self.init(scene:s,trigger:.OnScreenTap);
            labels = l;
        }
        private override init(scene s:GameScene,trigger t: GameEventTrigger?)
        {
            super.init(scene:s,trigger:t);
        }
        
        override func AwaitTrigger()
        {
            for label in labels
            {
                label.alpha = 0;
                Scene.addChild(label);
                label.run(.group([
                    .fadeIn(withDuration: 0.5),
                    .moveBy(x:0,y:BlockRush.BlockWidth/2,duration:0.5)]));
            }
        }
        
        override func OnTrigger()
        {
            for label in labels
            {
                label.run(.group([
                    .fadeOut(withDuration: 0.5),
                    .moveBy(x:0, y: -BlockRush.BlockWidth/2, duration: 0.5)]))
                {
                    label.removeFromParent();
                }
            }
        }
        
        ///For use with DialogueBegin and DialogueEnd events
        internal static var labels = [SKLabelNode]();
    }
    
    class DialogueBegin: GameEvent
    {
        private var labels = [SKLabelNode]();
        public convenience init(scene s:GameScene, text t: String)
        {
            self.init(scene:s,trigger:nil);
            for line in t.split(separator: "\n")
            {
                let label = SKLabelNode(fontNamed: "Avenir");
                label.position.y = BlockRush.GameHeight/4;
                label.fontSize = BlockRush.BlockWidth*2/3;
                label.text = String(line);
                labels.append(label);
            }
            for i in 0...labels.count-1
            {
                labels[i].position.y -= BlockRush.BlockWidth*CGFloat(i);
            }
        }
        public convenience init(scene s:GameScene,label l: SKLabelNode)
        {
            self.init(scene:s,trigger:nil);
            Dialogue.labels = [l];
        }
        public convenience init(scene s:GameScene,labels l: [SKLabelNode])
        {
            self.init(scene:s,trigger:nil);
            Dialogue.labels = l;
        }
        private override init(scene s:GameScene,trigger t: GameEventTrigger?)
        {
            super.init(scene:s,trigger:t);
        }
        
        override func AwaitTrigger()
        {
            if(!Dialogue.labels.isEmpty)
            {
                fatalError("DialogueEnd not triggered before another DialogueBegin reached the top of the queue");
            }
            Dialogue.labels = labels;
            for label in Dialogue.labels
            {
                label.alpha = 0;
                Scene.addChild(label);
                label.run(.group([
                    .fadeIn(withDuration: 0.5),
                    .moveBy(x:0,y:BlockRush.BlockWidth/2,duration:0.5)]));
            }
        }
        
        override func OnTrigger()
        {
            
        }
    }
    
    class DialogueEnd: GameEvent
    {
        public convenience init(scene s:GameScene)
        {
            self.init(scene:s,trigger:nil);
        }
        public override init(scene s:GameScene,trigger t: GameEventTrigger?)
        {
            super.init(scene:s,trigger:t);
        }
        
        override func AwaitTrigger()
        {
            
        }
        
        override func OnTrigger()
        {
            for label in Dialogue.labels
            {
                label.run(.group([
                    .fadeOut(withDuration: 0.5),
                    .moveBy(x:0, y: -BlockRush.BlockWidth/2, duration: 0.5)]))
                {
                    label.removeFromParent();
                }
            }
            Dialogue.labels = [];
        }
    }
}
