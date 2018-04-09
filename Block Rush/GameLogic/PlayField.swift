//
//  PlayField.swift
//  Block Rush
//
//  Created by Sebastian Snyder on 3/26/18.
//

import Foundation
import SpriteKit

class PlayField
{
    var Field: [[Block?]]
    var GameFrame: Int;
    var GameReady: Bool;
    let CenterBar: SKSpriteNode;
    let BackBar: SKSpriteNode;
    var TopMatches: [Int: Set<Block> ];
    var BtmMatches: [Int: Set<Block> ]
    var NilMatches: [Int: Set<Block> ];
    var playerTop: Player;
    var playerBottom: Player;
    var gameScene: SKScene;
    var fieldNode: SKNode;
    var movePower: Int;
    var moveAmount: Int;
    var LPowerNodes: [SKSpriteNode];
    var RPowerNodes: [SKSpriteNode];
    var LBigNodes: [SKSpriteNode];
    var RBigNodes: [SKSpriteNode];
    var curPowerVal: Int;
    
    init(cols:Int, rows:Int, playerTop t:Player, playerBottom b: Player, scene:SKScene)
    {
        fieldNode = SKNode();
        GameFrame = 0;
        GameReady = false;
        
        TopMatches = [:];
        BtmMatches = [:];
        NilMatches = [:];
        
        playerTop = t;
        playerBottom = b;
        movePower = 0;
        moveAmount = 0;
        
        let inArr = Array<Block?>(repeating: nil, count:rows);
        Field = Array<Array<Block?>>(repeating: inArr, count:cols);
        CenterBar = SKSpriteNode(texture: nil,
                                 color: .white,
                                 size: CGSize(width: BlockRush.BlockWidth*6, height: BlockRush.BlockWidth/16));
        BackBar = SKSpriteNode(texture: nil,
                                 color: .gray,
                                 size: CGSize(width: BlockRush.BlockWidth*6, height: BlockRush.BlockWidth/16));
        fieldNode.addChild(CenterBar);
        scene.addChild(fieldNode);
        scene.addChild(BackBar);
        gameScene = scene;
        CenterBar.zPosition = 2;
        BackBar.zPosition = -1;
        
        LPowerNodes = [];
        RPowerNodes = [];
        LBigNodes = [];
        RBigNodes = [];
        curPowerVal = 0;
    }
    
    func columns() -> Int
    {
        return Field.count;
    }
    
    func rows() -> Int
    {
        return Field[0].count;
    }
    
    
    func AnimPower()
    {
        let targetPowVal = playerBottom.storedPower-playerTop.storedPower+movePower;
        if(curPowerVal == targetPowVal)
        {
            return;
        }
        let Bw = BlockRush.BlockWidth;
        
        if(curPowerVal < 0 || (curPowerVal==0 && targetPowVal < 0))
        {
            //Displayed power is towards bottom player!
            
            let cp = curPowerVal % 8;
            
            if(curPowerVal > targetPowVal)
            {
                
                //Total power is also towards bottom player!
                curPowerVal -= 1;
                if(cp == 0)
                {
                    if(LPowerNodes.count == rows()/2-3)
                    {
                        for n in LPowerNodes
                        {
                            n.removeFromParent();
                        }
                        for n in RPowerNodes
                        {
                            n.removeFromParent();
                        }
                        LPowerNodes = [];
                        RPowerNodes = [];
                        let NewNodeL = SKSpriteNode(color: .yellow, size: CGSize(width: Bw*2/3-4, height: Bw/2-4));
                        let NewNodeR = SKSpriteNode(color: .yellow, size: CGSize(width: Bw*2/3-4, height: Bw/2-4));
                        
                        LBigNodes.append(NewNodeL);
                        RBigNodes.append(NewNodeR);
                        
                        let pY = CGFloat(LBigNodes.count)*Bw/2-Bw/4;
                        
                        //Total power is towards bottom player
                        NewNodeL.position = CGPoint(x:-Bw*3,y:pY);
                        NewNodeR.position = CGPoint(x: Bw*3,y:pY);
                        
                        NewNodeL.zPosition = 10;
                        NewNodeR.zPosition = 10;
                        
                        gameScene.addChild(NewNodeL);
                        gameScene.addChild(NewNodeR);
                    }
                    
                    
                    let NewNodeL = SKSpriteNode(color: .yellow, size: CGSize(width: Bw/2-4, height: Bw/4-4));
                    let NewNodeR = SKSpriteNode(color: .yellow, size: CGSize(width: Bw/2-4, height: Bw/4-4));
                    
                    LPowerNodes.append(NewNodeL)
                    RPowerNodes.append(NewNodeR);
                    
                    let pY = -CGFloat(LPowerNodes.count)*Bw/4+Bw/8;
                    
                    //Total power is towards bottom player
                    NewNodeL.position = CGPoint(x:-Bw*3,y:pY);
                    NewNodeR.position = CGPoint(x: Bw*3,y:pY);
                    
                    NewNodeL.alpha = 0.125;
                    NewNodeR.alpha = 0.125;
                    
                    gameScene.addChild(NewNodeL);
                    gameScene.addChild(NewNodeR);
                    
                }
                else
                {
                    //Increase alpha of topmost node
                    let Lnode = LPowerNodes.last!;
                    let Rnode = RPowerNodes.last!;
                    var a = -CGFloat(curPowerVal % 8)/8;
                    if(a == 0)
                    {
                        a = 1;
                    }
                    Lnode.alpha = a;
                    Rnode.alpha = a;
                }
            }
            else
            {
                if(LPowerNodes.count == 0)
                {
                    for _ in 1...rows()/2-3
                    {
                        let NewNodeL = SKSpriteNode(color: .yellow, size: CGSize(width: Bw/2-4, height: Bw/4-4));
                        let NewNodeR = SKSpriteNode(color: .yellow, size: CGSize(width: Bw/2-4, height: Bw/4-4));
                        
                        LPowerNodes.append(NewNodeL)
                        RPowerNodes.append(NewNodeR);
                        
                        let pY = -CGFloat(LPowerNodes.count)*Bw/4+Bw/8;
                        
                        //Total power is towards bottom player
                        NewNodeL.position = CGPoint(x:-Bw*3,y:pY);
                        NewNodeR.position = CGPoint(x: Bw*3,y:pY);
                        
                        NewNodeL.alpha = 1;
                        NewNodeR.alpha = 1;
                        
                        gameScene.addChild(NewNodeL);
                        gameScene.addChild(NewNodeR);
                    }
                    
                    let L = LBigNodes.popLast();
                    let R = RBigNodes.popLast();
                    L!.removeFromParent();
                    R!.removeFromParent();
                }
                //Total power is less towards bottom player!
                curPowerVal += 1;
                
                //Decrease alpha of topmost node
                let Lnode = LPowerNodes.last!;
                let Rnode = RPowerNodes.last!;
                let a = -CGFloat(curPowerVal % 8)/8;
                if(a == 0)
                {
                    LPowerNodes.removeLast();
                    RPowerNodes.removeLast();
                    Lnode.removeFromParent();
                    Rnode.removeFromParent();
                }
                else
                {
                    Lnode.alpha = a;
                    Rnode.alpha = a;
                }
            }
        }
        else
        {
            //Displayed power is towards top player!
            
            let cp = curPowerVal % 8;
            
            if(curPowerVal < targetPowVal)
            {
                //Total power is also towards top player!
                curPowerVal += 1;
                if(cp == 0)
                {
                    if(LPowerNodes.count == rows()/2-3)
                    {
                        for n in LPowerNodes
                        {
                            n.removeFromParent();
                        }
                        for n in RPowerNodes
                        {
                            n.removeFromParent();
                        }
                        LPowerNodes = [];
                        RPowerNodes = [];
                        let NewNodeL = SKSpriteNode(color: .yellow, size: CGSize(width: Bw*2/3-4, height: Bw/2-4));
                        let NewNodeR = SKSpriteNode(color: .yellow, size: CGSize(width: Bw*2/3-4, height: Bw/2-4));
                        
                        LBigNodes.append(NewNodeL);
                        RBigNodes.append(NewNodeR);
                        
                        let pY = -CGFloat(LBigNodes.count)*Bw/2+Bw/4;
                        
                        //Total power is towards bottom player
                        NewNodeL.position = CGPoint(x:-Bw*3,y:pY);
                        NewNodeR.position = CGPoint(x: Bw*3,y:pY);
                        
                        NewNodeL.zPosition = 10;
                        NewNodeR.zPosition = 10;
                        
                        gameScene.addChild(NewNodeL);
                        gameScene.addChild(NewNodeR);
                    }
                    
                    let Bw = BlockRush.BlockWidth;
                    let NewNodeL = SKSpriteNode(color: .yellow, size: CGSize(width: Bw/2-4, height: Bw/4-4));
                    let NewNodeR = SKSpriteNode(color: .yellow, size: CGSize(width: Bw/2-4, height: Bw/4-4));
                    
                    LPowerNodes.append(NewNodeL)
                    RPowerNodes.append(NewNodeR);
                    
                    let pY = CGFloat(LPowerNodes.count)*Bw/4-Bw/8;
                    
                    //Total power is towards bottom player
                    NewNodeL.position = CGPoint(x:-Bw*3,y:pY);
                    NewNodeR.position = CGPoint(x: Bw*3,y:pY);
                    
                    NewNodeL.alpha = 0.125;
                    NewNodeR.alpha = 0.125;
                    
                    gameScene.addChild(NewNodeL);
                    gameScene.addChild(NewNodeR);
                    
                }
                else
                {
                    //Increase alpha of bottommost node
                    let Lnode = LPowerNodes.last!;
                    let Rnode = RPowerNodes.last!;
                    var a = CGFloat(curPowerVal % 8)/8;
                    if(a == 0)
                    {
                        a = 1;
                    }
                    Lnode.alpha = a;
                    Rnode.alpha = a;
                }
            }
            else
            {
                if(LPowerNodes.count == 0)
                {
                    for _ in 1...rows()/2-3
                    {
                        let NewNodeL = SKSpriteNode(color: .yellow, size: CGSize(width: Bw/2-4, height: Bw/4-4));
                        let NewNodeR = SKSpriteNode(color: .yellow, size: CGSize(width: Bw/2-4, height: Bw/4-4));
                        
                        LPowerNodes.append(NewNodeL)
                        RPowerNodes.append(NewNodeR);
                        
                        let pY = CGFloat(LPowerNodes.count)*Bw/4-Bw/8;
                        
                        //Total power is towards bottom player
                        NewNodeL.position = CGPoint(x:-Bw*3,y:pY);
                        NewNodeR.position = CGPoint(x: Bw*3,y:pY);
                        
                        NewNodeL.alpha = 1;
                        NewNodeR.alpha = 1;
                        
                        gameScene.addChild(NewNodeL);
                        gameScene.addChild(NewNodeR);
                    }
                    
                    let L = LBigNodes.popLast();
                    let R = RBigNodes.popLast();
                    L!.removeFromParent();
                    R!.removeFromParent();
                }
                
                //Total power is less towards bottom player!
                curPowerVal -= 1;
                
                //Decrease alpha of topmost node
                let Lnode = LPowerNodes.last!;
                let Rnode = RPowerNodes.last!;
                let a = CGFloat(curPowerVal % 8)/8;
                if(a == 0)
                {
                    LPowerNodes.removeLast();
                    RPowerNodes.removeLast();
                    Lnode.removeFromParent();
                    Rnode.removeFromParent();
                }
                else
                {
                    Lnode.alpha = a;
                    Rnode.alpha = a;
                }
            }
        }
    }
    
    func PushBottom(column: Int, piece: Piece, frame: Int)
    {
        PushBottom(column:column, block:piece.FrontBlock, frame:frame);
        PushBottom(column:column, block:piece.RearBlock, frame:frame);
    }
    
    func PushBottom(column: Int, block: Block,frame: Int)
    {
        for i in rows()/2...rows()-1
        {
            if(Field[column][i] == nil)
            {
                block.nod.position = GetPosition(column:column,row:i);
                block.CreditTop = false;
                block.LockFrame = frame;
                Field[column][i] = block;
                block.iPos = column;
                block.jPos = i;
                block.nod.removeFromParent();
                fieldNode.addChild(block.nod);
                return;
            }
        }
    }
    
    func PushTop(column: Int, piece: Piece, frame: Int)
    {
        PushTop(column:column, block:piece.FrontBlock, frame:frame);
        PushTop(column:column, block:piece.RearBlock, frame:frame);
    }
    
    func PushTop(column: Int, block: Block,frame: Int)
    {
        for i in (0...rows()/2-1).reversed()
        {
            if(Field[column][i] == nil)
            {
                block.nod.position = GetPosition(column:column,row:i);
                block.CreditTop = true;
                block.LockFrame = frame;
                Field[column][i] = block;
                block.iPos = column;
                block.jPos = i;
                block.nod.removeFromParent();
                fieldNode.addChild(block.nod);
                return;
            }
        }
    }
    
    func GetPosition(column:Int,row:Int) -> CGPoint
    {
        let offsetRows = CGFloat(rows())/2;
        
        let pX = BlockRush.BlockWidth/2 + BlockRush.BlockWidth * CGFloat(column-3);
        let pY = BlockRush.BlockWidth * ((offsetRows-CGFloat(row))/2-0.25);
        
        return CGPoint(x: pX, y: pY);
    }
    
    func EvalChain(player: Player, numMatched: Int) -> Int
    {
        player.chainLevel += 1;
        let linkDamage = BlockRush.CalculateDamage(chainLevel: player.chainLevel, blocksCleared: numMatched)
        
        player.storedPower += linkDamage;
        //
        return linkDamage;
    }
    
    func DetectBottomPlayerLoss() -> Bool
    {
        /*
        for j in 0...columns()-1
        {
            for i in rows()/2...rows()-1
            {
                if(Field[i][j] == nil)
                {
                    continue columnLoop;
                }
                
                if(moveAmount <= lockCondition)
                {
                    
                }
            }
            player.hasLost = true;
            print("Bottom player loss detected");
        }
         */
        return false;
    }
    
    func DetectTopPlayerLoss() -> Bool
    {
        return false;
    }
    
    func StackMove(player: Player) -> Bool
    {
        if(movePower < 0)
        {
            if(player === playerBottom)
            {
                
                movePower += 1;
                moveAmount -= 1;
                
                let lockCondition = (6-rows())*4
                
                if(moveAmount <= lockCondition)
                {
                    moveAmount = lockCondition;
                    player.hasLost = true;
                    //print("BottomPlayer Loses!");
                }
                
                player.hasLost = DetectBottomPlayerLoss();
                
                fieldNode.position = CGPoint(x: 0, y: BlockRush.BlockWidth*CGFloat(moveAmount)/32);
                
                return true;
            }
            else
            {
                return false;
            }
        }
        else if(movePower > 0)
        {
            if(player === playerTop)
            {
                movePower -= 1;
                moveAmount += 1;
                
                let lockCondition = (rows()-6)*4
                
                if(moveAmount >= lockCondition)
                {
                    moveAmount = lockCondition;
                    player.hasLost = true;
                    //print("TopPlayer Loses!");
                }
                
                player.hasLost = DetectTopPlayerLoss();
                
                fieldNode.position = CGPoint(x: 0, y: BlockRush.BlockWidth*CGFloat(moveAmount)/32);
                
                return true;
            }
            else
            {
                return false;
            }
        }
        else
        {
            return false;
        }
    }
    
    func AdvanceFrame()
    {
        let DoFrame = GameFrame-20;
        EvalMatches(frame: DoFrame);
        //
        AnimMatches(frame: DoFrame);
        let Fell = Cascade(frame: DoFrame);
        if(!Fell)
        {
            if(TopMatches.isEmpty)
            {
                movePower -= playerTop.Unfreeze();
            }
            if(BtmMatches.isEmpty)
            {
                movePower += playerBottom.Unfreeze();
            }
        }
        AnimPower();
        
        //
        GameFrame += 1;
    }
    
    func ApplyMatch(blocks: [Block],frame: Int, creditTop: Bool?)
    {
        for block in blocks
        {
            block.nod.size.width*=1.2;
            block.nod.size.height*=1.2;
            block.nod.zPosition = 2;
        }
        if(creditTop == nil)
        {
            if(NilMatches[frame] == nil)
            {
                NilMatches[frame] = (Set<Block>()).union(blocks);
            }
            else
            {
                NilMatches[frame]!.formUnion(blocks);
            }
        }
        else if(creditTop! == true)
        {
            playerTop.Freeze();
            if(TopMatches[frame] == nil)
            {
                TopMatches[frame] = (Set<Block>()).union(blocks);
            }
            else
            {
                TopMatches[frame]!.formUnion(blocks);
            }
        }
        else
        {
            playerBottom.Freeze();
            if(BtmMatches[frame] == nil)
            {
                BtmMatches[frame] = (Set<Block>()).union(blocks);
            }
            else
            {
                BtmMatches[frame]!.formUnion(blocks);
            }
        }
    }
    
    func EvalMatches(frame: Int)
    {
        var TotalMatched: Set<Block> = [];
        //Detect Horizontal Matches
        
        let DetectVec = [(0,1),(1,0),(1,1),(1,-1)];
        for v in DetectVec
        {
            var DirMatched: Set<Block> = [];
            let x = v.0;
            let y = v.1;
            for i in 0...(columns()-1-3*x)
            {
                let s: [Int];
                if(y >= 0)
                {
                    s = (0...(rows()-1-3*y)).sorted();
                }
                else
                {
                    s = (-3*y...(rows()-1)).reversed();
                }
                for j in s
                {
                    if(Field[i][j] == nil)
                    {
                        continue;
                    }
                    if(Field[i][j]!.LockFrame > frame)
                    {
                        continue;
                    }
                    if(Field[i][j]!.col == nil)
                    {
                        continue;
                    }
                    let curBlk = Field[i][j]!;
                    if(DirMatched.contains(curBlk))
                    {
                        //If you've already matched in this direction on this block,
                        continue;
                    }
                    else
                    {
                        let MatchCol = curBlk.col;
                        var Matched = [curBlk];
                        var I = i+x;
                        var J = j+y;
                        while(I >= 0 && I < columns() && J >= 0 && J < rows() )
                        {
                            let NewBlk = Field[I][J];
                            if(NewBlk == nil || NewBlk!.col == nil || NewBlk!.col! != MatchCol)
                            {
                                break;
                            }
                            else if(NewBlk!.LockFrame > frame)
                            {
                                break;
                            }
                            else
                            {
                                Matched.append(NewBlk!);
                            }
                            I+=x;
                            J+=y;
                        }
                        if(Matched.count >= 4)
                        {
                            DirMatched.formUnion(Matched);
                            //credit match to proper player
                            var Mframe = -1;
                            var MplayerTop: Bool? = nil;
                            for b in Matched
                            {
                                if(b.LockFrame == Mframe)
                                {
                                    if(MplayerTop != b.CreditTop)
                                    {
                                        MplayerTop = nil;
                                    }
                                }
                                else if(b.LockFrame > Mframe)
                                {
                                    Mframe = b.LockFrame;
                                    MplayerTop = b.CreditTop;
                                }
                            }
                            ApplyMatch(blocks: Matched, frame: frame, creditTop: MplayerTop);
                        }
                    }
                }
            }
            TotalMatched.formUnion(DirMatched);
        }
        for block in TotalMatched
        {
            block.col = nil;
        }
    }
    
    func CreateChainEffect(blocks: Set<Block>,creditTop:Bool,chainLevel:Int)
    {
        let cN = CGFloat(blocks.count);
        var cX: CGFloat = 0;
        var cY: CGFloat = 0;
        for b in blocks
        {
            cX += b.nod.position.x / cN;
            cY += b.nod.position.y / cN;
        }
        
        cX += fieldNode.position.x;
        cY += fieldNode.position.y;
        
        let Bw = BlockRush.BlockWidth;
        let BaseNode = SKNode();
        
        let ChainNode = SKLabelNode(fontNamed:"Avenir-HeavyOblique");
        ChainNode.fontSize = Bw/2;
        ChainNode.position = CGPoint(x:0,y:-Bw/6);
        ChainNode.fontColor = UIColor.yellow;
        ChainNode.text = "CHAIN";
        ChainNode.verticalAlignmentMode = .center
        
        BaseNode.addChild(ChainNode);
        
        let NumNode = SKLabelNode(fontNamed:"Avenir-BlackOblique");
        NumNode.fontSize = Bw*2;
        NumNode.position = CGPoint(x: -Bw*5/4,y:0);
        NumNode.fontColor = UIColor.yellow;
        NumNode.text = String(chainLevel);
        NumNode.verticalAlignmentMode = .center
        
        NumNode.run(.scale(by: 1/2, duration: 0.25))
        
        BaseNode.addChild(NumNode);
        
        BaseNode.position = CGPoint(x: cX, y: cY)
        gameScene.addChild(BaseNode);
        BaseNode.run(.fadeOut(withDuration: 2)) {
            BaseNode.removeFromParent();
        };

        if(creditTop)
        {
            BaseNode.zRotation = .pi;
        }
    }
    
    private func AnimMatchesPartial(frame: Int, Matches: inout [Int:Set<Block>],CreditTop: Bool?)
    {
        let decayFactor: CGFloat = 0.92;
        let preFrames: Int = 30;
        let stayFrames: Int = 50;
        let endFrame: Int = 90;
        
        for (MatchFrame,S) in Matches
        {
            let AnimFrame = frame-MatchFrame;
            if(AnimFrame < preFrames)
            {
                continue;
            }
            if(AnimFrame == preFrames)
            {
                if(CreditTop != nil)
                {
                    let linkDamage: Int;
                    let p : Player;
                    if(CreditTop!)
                    {
                        print("TOP PLAYER-----");
                        p = playerTop;
                    }
                    else
                    {
                        print("BOTTOM PLAYER-----");
                        p = playerBottom;
                    }
                    linkDamage = EvalChain(player: p, numMatched: S.count);
                    print(String(p.chainLevel)+" CHAIN => "+String(linkDamage)+" DAMAGE!");
                    CreateChainEffect(blocks: S, creditTop: CreditTop!, chainLevel: p.chainLevel);
                }
            }
            for block in S
            {
                block.nod.color = .white;
                
                if(AnimFrame >= stayFrames)
                {
                    block.nod.alpha *= decayFactor;
                    block.nod.size.width *= decayFactor;
                    block.nod.size.height *= decayFactor;
                    if(AnimFrame == endFrame)
                    {
                        let I = block.iPos;
                        let J = block.jPos;
                        Field[I][J] = nil;
                        if(J <= rows()/2-1)
                        {
                            if(J-1 >= 0 && Field[I][J-1] != nil)
                            {
                                Field[I][J-1]?.CreditTop = CreditTop;
                            }
                        }
                        else
                        {
                            if(J+1 < rows() && Field[I][J+1] != nil)
                            {
                                Field[I][J+1]?.CreditTop = CreditTop;
                            }
                        }
                        block.nod.removeFromParent();
                    }
                }
            }
            if(AnimFrame == endFrame)
            {
                Matches[MatchFrame] = nil;
            }
        }
    }
    
    func AnimMatches(frame: Int)
    {
        AnimMatchesPartial(frame: frame, Matches: &TopMatches, CreditTop: true);
        AnimMatchesPartial(frame: frame, Matches: &BtmMatches, CreditTop: false);
        AnimMatchesPartial(frame: frame, Matches: &NilMatches, CreditTop: nil);
    }
    
    
    func Cascade(frame:Int) -> Bool
    {
        var ret = false;
        for i in 0...columns()-1
        {
            var jFrom = rows()/2-2;
            var Credit: Bool? = nil;
            var blockFell = false;
        columnBaseLoop:
            for jTo in (0...rows()/2-1).reversed()
            {
                if(Field[i][jTo] == nil)
                {
                    let block: Block;
                    while(Field[i][jFrom] == nil || jTo <= jFrom)
                    {
                        jFrom-=1;
                        if(jFrom == -1)
                        {
                            break columnBaseLoop;
                        }
                    }
                    block = Field[i][jFrom]!;
                    
                    if(block.col == nil)
                    {
                        continue;
                    }
                    if(!blockFell)
                    {
                        Credit = block.CreditTop;
                        blockFell = true
                        ret = true;
                    }
                    
                    block.CreditTop = Credit;
                    block.LockFrame = frame;
                    Field[i][jFrom] = nil;
                    
                    Field[i][jTo] = block;
                    block.nod.position = GetPosition(column:i,row:jTo);
                    block.iPos = i;
                    block.jPos = jTo;
                }
            }
            
            jFrom = rows()/2+1;
            blockFell = false;
            
        columnBaseLoop:
            for jTo in rows()/2...rows()-1
            {
                if(Field[i][jTo] == nil)
                {
                    let block: Block;
                    while(Field[i][jFrom] == nil || jTo >= jFrom)
                    {
                        jFrom+=1;
                        if(jFrom == rows())
                        {
                            break columnBaseLoop;
                        }
                    }
                    block = Field[i][jFrom]!;
                    
                    if(block.col == nil)
                    {
                        continue;
                    }
                    if(!blockFell)
                    {
                        Credit = block.CreditTop;
                        blockFell = true
                        ret = true;
                    }
                    
                    block.CreditTop = Credit;
                    block.LockFrame = frame;
                    
                    Field[i][jFrom] = nil;
                    
                    Field[i][jTo] = block;
                    block.nod.position = GetPosition(column:i,row:jTo);block.iPos = i;
                    block.jPos = jTo;
                }
            }
        }
        return ret;
    }
}
