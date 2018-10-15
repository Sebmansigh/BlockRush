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
    
    //note: I know these aren't pretty, but this code won't be executed very often.
    //Players are probably only going to watch these once and I don't plan on updating or making new ones,
    //so maintainability isn't really my top concern here. Read if you want to, I guess.
    
    ///Generates a new `Queue` of `GameEvents` to be executed during a fixed game.
    public static func Generate(_ name: String,gameScene:GameScene) -> Queue<GameEvent>
    {
        let eventQueue = Queue<GameEvent>();
        
        //Just so I don't have to type it a hundred times.
        let en = eventQueue.enqueue;
        
        switch(name)
        {
        case "General Tips":
            return eventQueue;
        case "Defense":
            return eventQueue;
        case "Basic Chains":
            en(GameEvent.HideTopPlayer(scene: gameScene));
            en(GameEvent.DisableCountdown(scene:gameScene));
            en(GameEvent.SetFrameNumber(scene:gameScene,value:180));
            en(GameEvent.StopTopPlayer(scene: gameScene));
            en(GameEvent.StopBottomPlayer(scene: gameScene));
            en(GameEvent.DisableAllInputs(scene: gameScene));
            en(GameEvent.Stall(scene:gameScene, numFrames:90));
            en(GameEvent.DialogueBegin(scene:gameScene, text:"So you've likely\nnoticed that there\nare indicators on\nthe sides."));
            en(GameEvent.SetStoredMovement(scene:gameScene, value:100));
            en(GameEvent.DialogueEnd(scene: gameScene, trigger: .OnScreenTap));
            en(GameEvent.DialogueBegin(scene:gameScene, text:"They show you how\nfar the stack is\nabout to move."));
            en(GameEvent.MoveStack(scene:gameScene, trigger: .OnScreenTap));
            en(GameEvent.Stall(scene:gameScene, numFrames:100));
            en(GameEvent.DialogueEnd(scene: gameScene, trigger: .OnScreenTap));
            en(GameEvent.DialogueBegin(scene:gameScene, text:"If your opponent\nmakes a match,\nthey'll show up\non your side too."));
            en(GameEvent.SetStoredMovement(scene:gameScene, value:-159,trigger:.OnScreenTap));
            en(GameEvent.Stall(scene:gameScene, numFrames:160));
            en(GameEvent.ForceInput(scene:gameScene,player:gameScene.playerBottom!,
                                    input:.PLAY,trigger:.OnScreenTap));
            en(GameEvent.Stall(scene: gameScene, numFrames:200));
            en(GameEvent.DialogueEnd(scene: gameScene, trigger: .OnScreenTap));
            en(GameEvent.Dialogue(scene:gameScene, text:"Let's go over\nhow to get the\nmost out of the\nblocks you play."));
            en(GameEvent.BeginFixedGame(scene:gameScene, name:"Chain Forms"));
            //
            return eventQueue;
        case "Chain Forms":
            en(GameEvent.HideTopPlayer(scene: gameScene));
            en(GameEvent.DisableCountdown(scene:gameScene));
            en(GameEvent.SetFrameNumber(scene:gameScene,value:199));
            en(GameEvent.StopTopPlayer(scene: gameScene));
            en(GameEvent.StopBottomPlayer(scene: gameScene));
            en(GameEvent.DisableAllInputs(scene: gameScene));
            en(GameEvent.ForceQueuePiece(scene:gameScene,player:gameScene.playerBottom!,newPiece:Piece(nFront: 0, nRear: 2)));
            en(GameEvent.ForceQueuePiece(scene:gameScene,player:gameScene.playerBottom!,newPiece:Piece(nFront: 1, nRear: 0)));
            en(GameEvent.ForceQueuePiece(scene:gameScene,player:gameScene.playerBottom!,newPiece:Piece(nFront: 0, nRear: 1)));
            en(GameEvent.ForceQueuePiece(scene:gameScene,player:gameScene.playerBottom!,newPiece:Piece(nFront: 1, nRear: 0)));
            en(GameEvent.ForceQueuePiece(scene:gameScene,player:gameScene.playerBottom!,newPiece:Piece(nFront: 1, nRear: 1)));
            //
            en(GameEvent.ForceQueuePiece(scene:gameScene,player:gameScene.playerBottom!,newPiece:Piece(nFront: 0, nRear: 1)));
            en(GameEvent.ForceQueuePiece(scene:gameScene,player:gameScene.playerBottom!,newPiece:Piece(nFront: 0, nRear: 2)));
            en(GameEvent.ForceQueuePiece(scene:gameScene,player:gameScene.playerBottom!,newPiece:Piece(nFront: 0, nRear: 1)));
            en(GameEvent.ForceQueuePiece(scene:gameScene,player:gameScene.playerBottom!,newPiece:Piece(nFront: 2, nRear: 0)));
            en(GameEvent.ForceQueuePiece(scene:gameScene,player:gameScene.playerBottom!,newPiece:Piece(nFront: 2, nRear: 0)));
            en(GameEvent.ForceQueuePiece(scene:gameScene,player:gameScene.playerBottom!,newPiece:Piece(nFront: 2, nRear: 1)));
            //
            en(GameEvent.ForceQueuePiece(scene:gameScene,player:gameScene.playerBottom!,newPiece:Piece(nFront: 0, nRear: 1)));
            en(GameEvent.ForceQueuePiece(scene:gameScene,player:gameScene.playerBottom!,newPiece:Piece(nFront: 2, nRear: 2)));
            en(GameEvent.ForceQueuePiece(scene:gameScene,player:gameScene.playerBottom!,newPiece:Piece(nFront: 0, nRear: 1)));
            en(GameEvent.ForceQueuePiece(scene:gameScene,player:gameScene.playerBottom!,newPiece:Piece(nFront: 0, nRear: 2)));
            en(GameEvent.ForceQueuePiece(scene:gameScene,player:gameScene.playerBottom!,newPiece:Piece(nFront: 1, nRear: 1)));
            en(GameEvent.ForceQueuePiece(scene:gameScene,player:gameScene.playerBottom!,newPiece:Piece(nFront: 0, nRear: 0)));
            en(GameEvent.ForceQueuePiece(scene:gameScene,player:gameScene.playerBottom!,newPiece:Piece(nFront: 0, nRear: 2)));
            //
            en(GameEvent.ForceQueuePiece(scene:gameScene,player:gameScene.playerBottom!,newPiece:Piece(nFront: 2, nRear: 2)));
            en(GameEvent.ForceQueuePiece(scene:gameScene,player:gameScene.playerBottom!,newPiece:Piece(nFront: 2, nRear: 2)));
            en(GameEvent.ForceQueuePiece(scene:gameScene,player:gameScene.playerBottom!,newPiece:Piece(nFront: 0, nRear: 2)));
            //
            en(GameEvent.Dialogue(scene:gameScene, text:"Here are some\npatterns you should\ntry to make:"));
            en(GameEvent.DialogueBegin(scene:gameScene, text:"Lay one row under\nanother, like this:"));
            en(GameEvent.ForceInput(scene:gameScene,player:gameScene.playerBottom!,
                                    input:.RIGHT,trigger:.Repeated(.OnGameFrameUpdate,numTimes:10)));
            en(GameEvent.ForceInput(scene:gameScene,player:gameScene.playerBottom!,
                                    input:.RIGHT,trigger:.Repeated(.OnGameFrameUpdate,numTimes:10)));
            en(GameEvent.ForceInput(scene:gameScene,player:gameScene.playerBottom!,
                                    input:.PLAY,trigger:.Repeated(.OnGameFrameUpdate,numTimes:10)));
            en(GameEvent.ForceInput(scene:gameScene,player:gameScene.playerBottom!,
                                    input:.RIGHT,trigger:.Repeated(.OnGameFrameUpdate,numTimes:40)));
            en(GameEvent.ForceInput(scene:gameScene,player:gameScene.playerBottom!,
                                    input:.PLAY,trigger:.Repeated(.OnGameFrameUpdate,numTimes:10)));
            en(GameEvent.ForceInput(scene:gameScene,player:gameScene.playerBottom!,
                                    input:.FLIP,trigger:.Repeated(.OnGameFrameUpdate,numTimes:40)));
            en(GameEvent.ForceInput(scene:gameScene,player:gameScene.playerBottom!,
                                    input:.PLAY,trigger:.Repeated(.OnGameFrameUpdate,numTimes:10)));
            en(GameEvent.ForceInput(scene:gameScene,player:gameScene.playerBottom!,
                                    input:.LEFT,trigger:.Repeated(.OnGameFrameUpdate,numTimes:40)));
            en(GameEvent.ForceInput(scene:gameScene,player:gameScene.playerBottom!,
                                    input:.PLAY,trigger:.Repeated(.OnGameFrameUpdate,numTimes:10)));
            en(GameEvent.ForceInput(scene:gameScene,player:gameScene.playerBottom!,
                                    input:.LEFT,trigger:.Repeated(.OnGameFrameUpdate,numTimes:40)));
            en(GameEvent.ForceInput(scene:gameScene,player:gameScene.playerBottom!,
                                    input:.LEFT,trigger:.Repeated(.OnGameFrameUpdate,numTimes:10)));
            en(GameEvent.DialogueEnd(scene: gameScene, trigger:.Repeated(.OnGameFrameUpdate,numTimes:30)));
            en(GameEvent.DialogueBegin(scene:gameScene, text:"And match the\nblocks on the side."));
            en(GameEvent.Stall(scene: gameScene,trigger:.OnScreenTap));
            en(GameEvent.ForceInput(scene:gameScene,player:gameScene.playerBottom!,input:.PLAY));
            en(GameEvent.DialogueEnd(scene: gameScene, trigger:.Repeated(.OnGameFrameUpdate,numTimes:210)));
            en(GameEvent.Dialogue(scene:gameScene, text:"See how two\ndifferent matches\nwere made?"));
            en(GameEvent.Dialogue(scene:gameScene, text:"And notice that\nthe second match\ngenerated more\nmovement than\nthe first one?"));
            en(GameEvent.Dialogue(scene:gameScene, text:"This is called\nChaining."));
            en(GameEvent.SetStoredMovement(scene: gameScene,value:0));
            en(GameEvent.Dialogue(scene:gameScene, text:"Here's another\nbasic pattern:"));
            en(GameEvent.DialogueBegin(scene:gameScene, text:"Place one block\nunderneath a\nhorizontal row..."));
            en(GameEvent.ForceInput(scene:gameScene,player:gameScene.playerBottom!,
                                    input:.RIGHT,trigger:.Repeated(.OnGameFrameUpdate,numTimes:10)));
            en(GameEvent.ForceInput(scene:gameScene,player:gameScene.playerBottom!,
                                    input:.RIGHT,trigger:.Repeated(.OnGameFrameUpdate,numTimes:10)));
            en(GameEvent.ForceInput(scene:gameScene,player:gameScene.playerBottom!,
                                    input:.PLAY,trigger:.Repeated(.OnGameFrameUpdate,numTimes:10)));
            en(GameEvent.ForceInput(scene:gameScene,player:gameScene.playerBottom!,
                                    input:.RIGHT,trigger:.Repeated(.OnGameFrameUpdate,numTimes:40)));
            en(GameEvent.ForceInput(scene:gameScene,player:gameScene.playerBottom!,
                                    input:.PLAY,trigger:.Repeated(.OnGameFrameUpdate,numTimes:10)));
            en(GameEvent.ForceInput(scene:gameScene,player:gameScene.playerBottom!,
                                    input:.PLAY,trigger:.Repeated(.OnGameFrameUpdate,numTimes:40)));
            en(GameEvent.ForceInput(scene:gameScene,player:gameScene.playerBottom!,
                                    input:.LEFT,trigger:.Repeated(.OnGameFrameUpdate,numTimes:40)));
            en(GameEvent.ForceInput(scene:gameScene,player:gameScene.playerBottom!,
                                    input:.FLIP,trigger:.Repeated(.OnGameFrameUpdate,numTimes:10)));
            en(GameEvent.ForceInput(scene:gameScene,player:gameScene.playerBottom!,
                                    input:.PLAY,trigger:.Repeated(.OnGameFrameUpdate,numTimes:10)));
            en(GameEvent.DialogueEnd(scene: gameScene, trigger:.OnScreenTap));
            en(GameEvent.DialogueBegin(scene:gameScene, text:"...and clear it\nwith a\ndiagonal match:"));
            en(GameEvent.ForceInput(scene:gameScene,player:gameScene.playerBottom!,
                                    input:.PLAY,trigger:.Repeated(.OnGameFrameUpdate,numTimes:90)));
            en(GameEvent.ForceInput(scene:gameScene,player:gameScene.playerBottom!,
                                    input:.LEFT,trigger:.Repeated(.OnGameFrameUpdate,numTimes:40)));
            en(GameEvent.ForceInput(scene:gameScene,player:gameScene.playerBottom!,
                                    input:.FLIP,trigger:.Repeated(.OnGameFrameUpdate,numTimes:60)));
            en(GameEvent.ForceInput(scene:gameScene,player:gameScene.playerBottom!,
                                    input:.PLAY,trigger:.Repeated(.OnGameFrameUpdate,numTimes:60)));
            en(GameEvent.Stall(scene: gameScene,numFrames:210));
            en(GameEvent.DialogueEnd(scene: gameScene, trigger:.OnScreenTap));
            en(GameEvent.SetStoredMovement(scene: gameScene,value:0));
            en(GameEvent.DialogueBegin(scene:gameScene, text:"Speaking of\ndiagonal matches..."));
            en(GameEvent.ForceInput(scene:gameScene,player:gameScene.playerBottom!,
                                    input:.FLIP,trigger:.Repeated(.OnGameFrameUpdate,numTimes:10)));
            en(GameEvent.ForceInput(scene:gameScene,player:gameScene.playerBottom!,
                                    input:.PLAY,trigger:.Repeated(.OnGameFrameUpdate,numTimes:10)));
            en(GameEvent.ForceInput(scene:gameScene,player:gameScene.playerBottom!,
                                    input:.RIGHT,trigger:.Repeated(.OnGameFrameUpdate,numTimes:40)));
            en(GameEvent.ForceInput(scene:gameScene,player:gameScene.playerBottom!,
                                    input:.PLAY,trigger:.Repeated(.OnGameFrameUpdate,numTimes:10)));
            en(GameEvent.ForceInput(scene:gameScene,player:gameScene.playerBottom!,
                                    input:.RIGHT,trigger:.Repeated(.OnGameFrameUpdate,numTimes:40)));
            en(GameEvent.ForceInput(scene:gameScene,player:gameScene.playerBottom!,
                                    input:.FLIP,trigger:.Repeated(.OnGameFrameUpdate,numTimes:10)));
            en(GameEvent.DialogueEnd(scene: gameScene, trigger:.OnScreenTap));
            en(GameEvent.DialogueBegin(scene:gameScene, text:"Place a horizontal\nrow underneath\nthe top of\na diagonal."));
            en(GameEvent.ForceInput(scene:gameScene,player:gameScene.playerBottom!,
                                    input:.PLAY,trigger:.Repeated(.OnGameFrameUpdate,numTimes:10)));
            en(GameEvent.ForceInput(scene:gameScene,player:gameScene.playerBottom!,
                                    input:.LEFT,trigger:.Repeated(.OnGameFrameUpdate,numTimes:40)));
            en(GameEvent.ForceInput(scene:gameScene,player:gameScene.playerBottom!,
                                    input:.FLIP,trigger:.Repeated(.OnGameFrameUpdate,numTimes:10)));
            en(GameEvent.ForceInput(scene:gameScene,player:gameScene.playerBottom!,
                                    input:.PLAY,trigger:.Repeated(.OnGameFrameUpdate,numTimes:10)));
            en(GameEvent.ForceInput(scene:gameScene,player:gameScene.playerBottom!,
                                    input:.RIGHT,trigger:.Repeated(.OnGameFrameUpdate,numTimes:40)));
            en(GameEvent.ForceInput(scene:gameScene,player:gameScene.playerBottom!,
                                    input:.PLAY,trigger:.Repeated(.OnGameFrameUpdate,numTimes:10)));
            en(GameEvent.Stall(scene: gameScene,numFrames:40));
            en(GameEvent.DialogueEnd(scene: gameScene, trigger:.OnScreenTap));
            en(GameEvent.DialogueBegin(scene:gameScene, text:"Then make the\nhorizontal match."));
            en(GameEvent.ForceInput(scene:gameScene,player:gameScene.playerBottom!,
                                    input:.LEFT,trigger:.Repeated(.OnGameFrameUpdate,numTimes:40)));
            en(GameEvent.ForceInput(scene:gameScene,player:gameScene.playerBottom!,
                                    input:.LEFT,trigger:.Repeated(.OnGameFrameUpdate,numTimes:10)));
            en(GameEvent.ForceInput(scene:gameScene,player:gameScene.playerBottom!,
                                    input:.PLAY,trigger:.Repeated(.OnGameFrameUpdate,numTimes:10)));
            en(GameEvent.ForceInput(scene:gameScene,player:gameScene.playerBottom!,
                                    input:.LEFT,trigger:.Repeated(.OnGameFrameUpdate,numTimes:40)));
            en(GameEvent.ForceInput(scene:gameScene,player:gameScene.playerBottom!,
                                    input:.LEFT,trigger:.Repeated(.OnGameFrameUpdate,numTimes:10)));
            en(GameEvent.DialogueEnd(scene: gameScene, trigger:.OnScreenTap));
            en(GameEvent.Dialogue(scene:gameScene, text:"Wait."));
            en(GameEvent.Dialogue(scene:gameScene, text:"If we place it like\nthis, we'll get\nour 2-chain."));
            en(GameEvent.Dialogue(scene:gameScene, text:"But if you look\nat what our next\npieces are..."));
            en(GameEvent.Dialogue(scene:gameScene, text:"...and consider\nthe last pattern\nwe learned..."));
            en(GameEvent.DialogueBegin(scene:gameScene, text:"...we could turn\nit into a 3-chain!"));
            en(GameEvent.Stall(scene: gameScene,trigger:.OnScreenTap));
            en(GameEvent.ForceInput(scene:gameScene,player:gameScene.playerBottom!,
                                    input:.FLIP,trigger:.Repeated(.OnGameFrameUpdate,numTimes:10)));
            en(GameEvent.ForceInput(scene:gameScene,player:gameScene.playerBottom!,
                                    input:.PLAY,trigger:.Repeated(.OnGameFrameUpdate,numTimes:60)));
            en(GameEvent.ForceInput(scene:gameScene,player:gameScene.playerBottom!,
                                    input:.LEFT,trigger:.Repeated(.OnGameFrameUpdate,numTimes:40)));
            en(GameEvent.ForceInput(scene:gameScene,player:gameScene.playerBottom!,
                                    input:.PLAY,trigger:.Repeated(.OnGameFrameUpdate,numTimes:10)));
            en(GameEvent.ForceInput(scene:gameScene,player:gameScene.playerBottom!,
                                    input:.PLAY,trigger:.Repeated(.OnGameFrameUpdate,numTimes:40)));
            en(GameEvent.ForceInput(scene:gameScene,player:gameScene.playerBottom!,
                                    input:.RIGHT,trigger:.Repeated(.OnGameFrameUpdate,numTimes:40)));
            en(GameEvent.ForceInput(scene:gameScene,player:gameScene.playerBottom!,
                                    input:.FLIP,trigger:.Repeated(.OnGameFrameUpdate,numTimes:10)));
            en(GameEvent.Stall(scene: gameScene,trigger:.OnScreenTap));
            en(GameEvent.ForceInput(scene:gameScene,player:gameScene.playerBottom!,
                                    input:.PLAY,trigger:.Repeated(.OnGameFrameUpdate,numTimes:10)));
            en(GameEvent.Stall(scene: gameScene,numFrames:300));
            en(GameEvent.DialogueEnd(scene: gameScene, trigger:.OnScreenTap));
            en(GameEvent.Dialogue(scene:gameScene, text:"There are more\npatterns than these."));
            en(GameEvent.Dialogue(scene:gameScene, text:"And ways to make\nmuch larger chains."));
            en(GameEvent.Dialogue(scene:gameScene, text:"I'm sure you're\nmore creative than\nI am."));
            en(GameEvent.Dialogue(scene:gameScene, text:"So get out there\nand see what crazy\nchains you can\ncome up with!"));
            en(GameEvent.ReturnToMainMenu(scene:gameScene));
            //
            return eventQueue;
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
            en(GameEvent.Stall(scene: gameScene,numFrames:90));
            en(GameEvent.DialogueEnd(scene: gameScene,trigger:.OnScreenTap));
            en(GameEvent.DialogueBegin(scene: gameScene, text:"...vertically, ..."));
            en(GameEvent.ForceInput(scene:gameScene,player:gameScene.playerBottom!,
                                    input:.PLAY,trigger:.Repeated(.OnGameFrameUpdate,numTimes:45)));
            en(GameEvent.ForceInput(scene:gameScene,player:gameScene.playerBottom!,
                                    input:.FLIP,trigger:.Repeated(.OnGameFrameUpdate,numTimes:60)));
            en(GameEvent.ForceInput(scene:gameScene,player:gameScene.playerBottom!,
                                    input:.PLAY,trigger:.Repeated(.OnGameFrameUpdate,numTimes:45)));
            en(GameEvent.Stall(scene: gameScene,numFrames:90));
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
            en(GameEvent.Stall(scene: gameScene,numFrames:90));
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
