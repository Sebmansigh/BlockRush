//
//  File.swift
//  Block Rush
//
//  Created by Sebastian Snyder on 10/13/18.
//

import Foundation

/**
 A class containing fixed games.
 A fixed game is one that is predetermined all the way through and has events that occur throughout.
 A good example of this is the tutorials, which the player may interact with, but all matches happen the same way.
 */
final class FixedGame
{
    private init() {}
    
    /**
     Generates a fixed game with the specified name.
     */
    public static func Generate(_ name: String,gameScene:GameScene) -> Queue<GameEvent>
    {
        let eventQueue = Queue<GameEvent>();
        
        //Just so I don't have to type it a hundred times.
        let en = eventQueue.enqueue;
        
        switch(name)
        {
        case "Tutorial":
            
            en(GameEvent.HideTopPlayer(scene: gameScene));
            en(GameEvent.DisableCountdown(scene:gameScene));
            en(GameEvent.StopTopPlayer(scene: gameScene));
            en(GameEvent.StopBottomPlayer(scene: gameScene));
            en(GameEvent.DisableAllInputs(scene: gameScene));
            en(GameEvent.ForceQueuePiece(scene:gameScene,player:gameScene.playerBottom!,newPiece:Piece(nFront: 1, nRear: 2)));
            en(GameEvent.ForceQueuePiece(scene:gameScene,player:gameScene.playerBottom!,newPiece:Piece(nFront: 2, nRear: 1)));
            en(GameEvent.ForceQueuePiece(scene:gameScene,player:gameScene.playerBottom!,newPiece:Piece(nFront: 0, nRear: 2)));
            en(GameEvent.ForceQueuePiece(scene:gameScene,player:gameScene.playerBottom!,newPiece:Piece(nFront: 2, nRear: 0)));
            en(GameEvent.ForceQueuePiece(scene:gameScene,player:gameScene.playerBottom!,newPiece:Piece(nFront: 1, nRear: 1)));
            en(GameEvent.ForceQueuePiece(scene:gameScene,player:gameScene.playerBottom!,newPiece:Piece(nFront: 0, nRear: 1)));
            en(GameEvent.ForceQueuePiece(scene:gameScene,player:gameScene.playerBottom!,newPiece:Piece(nFront: 0, nRear: 0)));
            en(GameEvent.ForceQueuePiece(scene:gameScene,player:gameScene.playerBottom!,newPiece:Piece(nFront: 0, nRear: 1)));
            en(GameEvent.ForceQueuePiece(scene:gameScene,player:gameScene.playerBottom!,newPiece:Piece(nFront: 2, nRear: 0)));
            en(GameEvent.ForceQueuePiece(scene:gameScene,player:gameScene.playerBottom!,newPiece:Piece(nFront: 2, nRear: 0)));
            en(GameEvent.Stall(scene:gameScene, numFrames:200));
            en(GameEvent.Dialogue(scene:gameScene, text:"Hi there."));
            en(GameEvent.Dialogue(scene:gameScene, text:"Welcome to \nBLOCK RUSH!"));
            
            if(BlockRush.Settings[.BottomPlayerControlType] == SettingOption.ControlType.TouchTap)
            {
                en(GameEvent.DialogueBegin(scene:gameScene, text:"Tap the\nbottom corners\nto move."));
            }
            else
            {
                en(GameEvent.DialogueBegin(scene:gameScene, text:"Slide along the\nbottom of the\nscreen to move."));
            }
            en(GameEvent.EnableInput(scene:gameScene,player:gameScene.playerBottom!,input:.LEFT));
            en(GameEvent.EnableInput(scene:gameScene,player:gameScene.playerBottom!,input:.RIGHT));
            en(GameEvent.Stall(scene: gameScene,trigger:.Repeated(.OnPlayerMove,numTimes:12)));
            en(GameEvent.Stall(scene: gameScene,trigger:.OnBottomPlayerColumn(3)));
            en(GameEvent.DisableAllInputs(scene: gameScene));
            en(GameEvent.DialogueEnd(scene: gameScene));
            if(BlockRush.Settings[.BottomPlayerControlType] == SettingOption.ControlType.TouchSlide)
            {
                en(GameEvent.DialogueBegin(scene:gameScene, text:"Tap to\nflip your piece."));
            }
            else
            {
                en(GameEvent.DialogueBegin(scene:gameScene, text:"Tap the bottom\nof the screen to\nflip your piece."));
            }
            en(GameEvent.EnableInput(scene:gameScene,player:gameScene.playerBottom!,input:.FLIP));
            en(GameEvent.Stall(scene: gameScene,trigger:.Repeated(.OnPlayerFlip,numTimes:3)));
            en(GameEvent.DisableAllInputs(scene: gameScene));
            en(GameEvent.DialogueEnd(scene: gameScene));
            if(BlockRush.Settings[.BottomPlayerControlType] == SettingOption.ControlType.TouchSlide)
            {
                en(GameEvent.DialogueBegin(scene:gameScene, text:"Swipe up to\nplay your piece."));
            }
            else
            {
                en(GameEvent.DialogueBegin(scene:gameScene, text:"Tap in the\nplay area to\nplay your piece."));
            }
            en(GameEvent.EnableInput(scene:gameScene,player:gameScene.playerBottom!,input:.PLAY));
            en(GameEvent.Stall(scene: gameScene,trigger:.OnPlayerPlay));
            en(GameEvent.DialogueEnd(scene: gameScene));
            en(GameEvent.DisableAllInputs(scene: gameScene));
            
            en(GameEvent.Dialogue(scene:gameScene, text:"Your goal is\nto line up 4\nblocks of the\nsame color..."));
            en(GameEvent.DialogueBegin(scene:gameScene, text:"...horizontally, ..."));
            //
            en(GameEvent.ForceInput(scene:gameScene,player:gameScene.playerBottom!,
                                    input:.LEFT,trigger:.Repeated(.OnGameFrameUpdate,numTimes:45)));
            en(GameEvent.ForceInput(scene:gameScene,player:gameScene.playerBottom!,
                                    input:.PLAY,trigger:.Repeated(.OnGameFrameUpdate,numTimes:45)));
            en(GameEvent.ForceInput(scene:gameScene,player:gameScene.playerBottom!,
                                    input:.LEFT,trigger:.Repeated(.OnGameFrameUpdate,numTimes:60)));
            en(GameEvent.ForceInput(scene:gameScene,player:gameScene.playerBottom!,
                                    input:.LEFT,trigger:.Repeated(.OnGameFrameUpdate,numTimes:45)));
            en(GameEvent.ForceInput(scene:gameScene,player:gameScene.playerBottom!,
                                    input:.FLIP,trigger:.Repeated(.OnGameFrameUpdate,numTimes:45)));
            en(GameEvent.ForceInput(scene:gameScene,player:gameScene.playerBottom!,
                                    input:.PLAY,trigger:.Repeated(.OnGameFrameUpdate,numTimes:45)));
            en(GameEvent.ForceInput(scene:gameScene,player:gameScene.playerBottom!,
                                    input:.LEFT,trigger:.Repeated(.OnGameFrameUpdate,numTimes:60)));
            en(GameEvent.ForceInput(scene:gameScene,player:gameScene.playerBottom!,
                                    input:.LEFT,trigger:.Repeated(.OnGameFrameUpdate,numTimes:45)));
            en(GameEvent.ForceInput(scene:gameScene,player:gameScene.playerBottom!,
                                    input:.LEFT,trigger:.Repeated(.OnGameFrameUpdate,numTimes:45)));
            en(GameEvent.ForceInput(scene:gameScene,player:gameScene.playerBottom!,
                                    input:.LEFT,trigger:.Repeated(.OnGameFrameUpdate,numTimes:45)));
            en(GameEvent.ForceInput(scene:gameScene,player:gameScene.playerBottom!,
                                    input:.PLAY,trigger:.Repeated(.OnGameFrameUpdate,numTimes:45)));
            en(GameEvent.DialogueEnd(scene: gameScene,trigger:.OnScreenTap));
            en(GameEvent.DialogueBegin(scene: gameScene, text:"...vertically, ..."));
            en(GameEvent.ForceInput(scene:gameScene,player:gameScene.playerBottom!,
                                    input:.PLAY,trigger:.Repeated(.OnGameFrameUpdate,numTimes:45)));
            en(GameEvent.ForceInput(scene:gameScene,player:gameScene.playerBottom!,
                                    input:.FLIP,trigger:.Repeated(.OnGameFrameUpdate,numTimes:60)));
            en(GameEvent.ForceInput(scene:gameScene,player:gameScene.playerBottom!,
                                    input:.PLAY,trigger:.Repeated(.OnGameFrameUpdate,numTimes:45)));
            en(GameEvent.DialogueEnd(scene: gameScene,trigger:.OnScreenTap));
            en(GameEvent.DialogueBegin(scene: gameScene, text:"...or diagonally"));
            en(GameEvent.ForceInput(scene:gameScene,player:gameScene.playerBottom!,
                                    input:.LEFT,trigger:.Repeated(.OnGameFrameUpdate,numTimes:45)));
            en(GameEvent.ForceInput(scene:gameScene,player:gameScene.playerBottom!,
                                    input:.PLAY,trigger:.Repeated(.OnGameFrameUpdate,numTimes:45)));
            en(GameEvent.ForceInput(scene:gameScene,player:gameScene.playerBottom!,
                                    input:.LEFT,trigger:.Repeated(.OnGameFrameUpdate,numTimes:60)));
            en(GameEvent.ForceInput(scene:gameScene,player:gameScene.playerBottom!,
                                    input:.LEFT,trigger:.Repeated(.OnGameFrameUpdate,numTimes:45)));
            en(GameEvent.ForceInput(scene:gameScene,player:gameScene.playerBottom!,
                                    input:.PLAY,trigger:.Repeated(.OnGameFrameUpdate,numTimes:45)));
            en(GameEvent.ForceInput(scene:gameScene,player:gameScene.playerBottom!,
                                    input:.PLAY,trigger:.Repeated(.OnGameFrameUpdate,numTimes:60)));
            en(GameEvent.ForceInput(scene:gameScene,player:gameScene.playerBottom!,
                                    input:.FLIP,trigger:.Repeated(.OnGameFrameUpdate,numTimes:60)));
            en(GameEvent.ForceInput(scene:gameScene,player:gameScene.playerBottom!,
                                    input:.PLAY,trigger:.Repeated(.OnGameFrameUpdate,numTimes:45)));
            en(GameEvent.DialogueEnd(scene: gameScene,trigger:.OnScreenTap));
            en(GameEvent.DialogueBegin(scene: gameScene, text:"and push\nthe stack into\nyour opponent."));
            en(GameEvent.MoveStack(scene: gameScene,trigger:.OnScreenTap));
            en(GameEvent.DialogueEnd(scene: gameScene,trigger:.OnScreenTap));
            en(GameEvent.Dialogue(scene: gameScene, text:"Have fun!"));
            en(GameEvent.ReturnToMainMenu(scene:gameScene));
            return eventQueue;
        default:
            fatalError("Unknown fixed game name \(name)");
        }
    }
}
