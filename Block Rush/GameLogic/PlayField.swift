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
    var GameOver: Bool;
    
    let CenterBar: SKSpriteNode;
    let BackBar: SKSpriteNode;
    var TopColumns: [SKSpriteNode];
    var GhostTopFront: SKSpriteNode?;
    var GhostTopRear: SKSpriteNode?;
    var BottomColumns: [SKSpriteNode];
    var GhostBottomFront: SKSpriteNode?;
    var GhostBottomRear: SKSpriteNode?;
    
    
    var TopMatches: [Int: Set<Block> ];
    var BtmMatches: [Int: Set<Block> ]
    var NilMatches: [Int: Set<Block> ];
    var playerTop: Player;
    var playerBottom: Player;
    var gameScene: GameScene;
    var fieldNode: SKNode;
    var movePower: Int;
    var moveAmount: Int;
    var LPowerNodes: [SKSpriteNode];
    var RPowerNodes: [SKSpriteNode];
    var LBigNodes: [SKSpriteNode];
    var RBigNodes: [SKSpriteNode];
    var curPowerVal: Int;
    
    
    var TopStackHeight:[Int];
    var BottomStackHeight:[Int];
    
    var Loser: Player? = nil;
    
    init(cols:Int, rows:Int, playerTop t:Player, playerBottom b: Player, scene:SKScene)
    {
        fieldNode = SKNode();
        GameFrame = 0;
        GameReady = false;
        GameOver = false;
        
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
        gameScene = scene as! GameScene;
        CenterBar.zPosition = 2;
        BackBar.zPosition = -1;
        
        LPowerNodes = [];
        RPowerNodes = [];
        LBigNodes = [];
        RBigNodes = [];
        curPowerVal = 0;
        
        TopColumns = [];
        GhostTopFront = nil;
        GhostTopRear = nil;
        BottomColumns = [];
        GhostBottomFront = nil;
        GhostBottomRear = nil;
        
        TopStackHeight = [Int](repeating: 0, count: rows);
        BottomStackHeight = [Int](repeating: 0, count: rows);
        
        
        for i in 0...columns()-1
        {
            let Tc = SKSpriteNode(color: .white, size: CGSize(width: BlockRush.BlockWidth, height: BlockRush.BlockWidth*5));
            Tc.alpha = 0;
            Tc.position.x = GetPosition(column: i);
            Tc.position.y = BlockRush.BlockWidth*2.5;
            scene.addChild(Tc);
            TopColumns.append(Tc);
            let Bc = SKSpriteNode(color: .white, size: CGSize(width: BlockRush.BlockWidth, height: BlockRush.BlockWidth*5));
            Bc.alpha = 0;
            Bc.position.x = GetPosition(column: i);
            Bc.position.y = -BlockRush.BlockWidth*2.5;
            scene.addChild(Bc);
            BottomColumns.append(Bc);
        }
        scene.addChild(fieldNode);
        scene.addChild(BackBar);
        
    }
    
    func columns() -> Int
    {
        return Field.count;
    }
    
    func rows() -> Int
    {
        return Field[0].count;
    }
    
    
    //returns an array of stack heights for the given player. Indecies are column numbers.
    func getSurfaceData(_ player: Player) -> [Int]
    {
        var ret: [Int] = Array<Int>(repeating: 0, count: columns());
        for i in 0...columns()-1
        {
            ret[i] = getStackHeight(column: i, player: player);
        }
        return ret;
    }
    
    
    func getStackHeight(column: Int, player: Player) -> Int
    {
        if(player === playerTop)
        {
            return TopStackHeight[column];
        }
        else if(player === playerBottom)
        {
            return BottomStackHeight[column];
            
        }
        else
        {
            fatalError("Recieved neither top nor bottom player for getStackHeight");
        }
    }
    
    func RecalculateStackHeights()
    {
        for column in 0...columns()-1
        {
            //Top
            do
            {
                let max = rows()/2-1;
                TopStackHeight[column] = max+1;
                for i in (0...max).reversed()
                {
                    if(Field[column][i] == nil)
                    {
                        TopStackHeight[column] = max-i;
                        break;
                    }
                }
            }
            
            //Bottom
            do
            {
                let max = rows()-1;
                let min = rows()/2;

                BottomStackHeight[column] = max-min+1;
                for i in min...max
                {
                    if(Field[column][i] == nil)
                    {
                        BottomStackHeight[column] = i-min;
                        break;
                    }
                }
            }
        }
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
        
        let pX = GetPosition(column: column);
        let pY = GetPosition(row: row);
        
        return CGPoint(x: pX, y: pY);
    }
    func GetPosition(column:Int) -> CGFloat
    {
        return BlockRush.BlockWidth/2 + BlockRush.BlockWidth * CGFloat(column-3);
    }
    func GetPosition(row:Int) -> CGFloat
    {
        let offsetRows = CGFloat(rows())/2;
        return BlockRush.BlockWidth * ((offsetRows-CGFloat(row))/2-0.25);
    }
    
    func GetPositionTopNext(column:Int,add:Int) -> CGPoint
    {
        for i in 0...rows()/2-1
        {
            if(Field[column][i] != nil)
            {
                return GetPosition(column:column, row:i-add);
            }
        }
        return GetPosition(column:column, row:rows()/2-add);
    }
    
    func GetPositionBottomNext(column:Int,add:Int) -> CGPoint
    {
        for i in (rows()/2...rows()-1).reversed()
        {
            if(Field[column][i] != nil)
            {
                return GetPosition(column:column, row:i+add);
            }
        }
        
        return GetPosition(column:column, row:rows()/2+add-1);
    }
    
    func TopBlockAtColumn(column: Int, player: Player) -> Block?
    {
        if(player === playerTop)
        {
            var prevBlock:Block? = nil;
            for j in (0...rows()/2-1).reversed()
            {
                let thisBlock = Field[column][j]
                if(thisBlock == nil)
                {
                    return prevBlock;
                }
                else
                {
                    prevBlock = thisBlock;
                }
            }
            return prevBlock;
        }
        else// if(player === playerBottom)
        {
            var prevBlock:Block? = nil;
            for j in (rows()/2...rows()-1)
            {
                let thisBlock = Field[column][j]
                if(thisBlock == nil)
                {
                    return prevBlock;
                }
                else
                {
                    prevBlock = thisBlock;
                }
            }
            return prevBlock;
        }
    }
    
    func EvalChain(player: Player, numMatched: Int) -> Int
    {
        player.chainLevel += 1;
        let linkDamage = BlockRush.CalculateDamage(chainLevel: player.chainLevel, blocksCleared: numMatched)
        
        player.storedPower += linkDamage;
        player.GainTime(300*player.chainLevel-150);
        //
        return linkDamage;
    }
    
    func DetectPlayerLoss(player: Player) -> Bool
    {
        if(player === playerTop)
        {
            return DetectTopPlayerLoss();
        }
        else if(player === playerBottom)
        {
            return DetectBottomPlayerLoss();
        }
        else
        {
            fatalError("Tried to detect the loss of neither the top nor bottom players.");
        }
    }
    
    func DetectBottomPlayerLoss() -> Bool
    {
        let Sdata = getSurfaceData(playerBottom);
        //
        let Smax = 10.0+Double(moveAmount)/16;
        
        let ALLOWZONE = 1.0;
        
        for i in 0...columns()-1
        {
            let Datai:Double = Double(Sdata[i]);
            if(Datai >= Smax+ALLOWZONE)
            {
                return true;
            }
        }
        return false;
    }
    
    func DetectTopPlayerLoss() -> Bool
    {
        let Sdata = getSurfaceData(playerTop);
        //
        let Smax = 10.0-Double(moveAmount)/16;
        
        let ALLOWZONE = 1.0;
        
        for i in 0...columns()-1
        {
            let Datai:Double = Double(Sdata[i]);
            if(Datai >= Smax+ALLOWZONE)
            {
                return true;
            }
        }
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
                
                let lockCondition = (6-rows())*4;
                
                if(moveAmount <= lockCondition)
                {
                    moveAmount = lockCondition;
                    //print("BottomPlayer Loses!");
                }
                
                
                let yPos = BlockRush.BlockWidth*CGFloat(moveAmount)/32;
                fieldNode.position = CGPoint(x: 0, y: yPos);
                
                for i in 0...columns()-1
                {
                    let Tc = TopColumns[i];
                    Tc.position.y  =  BlockRush.BlockWidth*2.5+yPos/2;
                    Tc.size.height =  BlockRush.BlockWidth*5-yPos;
                    
                    let Bc = BottomColumns[i];
                    Bc.position.y  = -BlockRush.BlockWidth*2.5+yPos/2;
                    Bc.size.height =  BlockRush.BlockWidth*5+yPos;
                }
                
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
                }
                
                let yPos = BlockRush.BlockWidth*CGFloat(moveAmount)/32;
                fieldNode.position = CGPoint(x: 0, y: yPos);
                
                for i in 0...columns()-1
                {
                    let Tc = TopColumns[i];
                    Tc.position.y  =  BlockRush.BlockWidth*2.5+yPos/2;
                    Tc.size.height =  BlockRush.BlockWidth*5-yPos;
                    
                    let Bc = BottomColumns[i];
                    Bc.position.y  = -BlockRush.BlockWidth*2.5+yPos/2;
                    Bc.size.height =  BlockRush.BlockWidth*5+yPos;
                }
                
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
        
        //DebugTools.TimeExecution("Stack Height Recalculation.")
        RecalculateStackHeights();
        
        
        let Tr = (playerTop.readyPiece != nil)
        let Br = (playerBottom.readyPiece != nil)
        
        for i in 0...columns()-1
        {
            let Tc = TopColumns[i];
            let Bc = BottomColumns[i];
            if(Tr && i == playerTop.columnOver)
            {
                Tc.alpha = 0.2;
            }
            else
            {
                Tc.alpha = 0;
            }
            
            if(Br && i == playerBottom.columnOver)
            {
                Bc.alpha = 0.2;
            }
            else
            {
                Bc.alpha = 0;
            }
            
        }
        let Tdata = getSurfaceData(playerTop);
        let Bdata = getSurfaceData(playerBottom);
        //
        let Tmax = 10.0-Double(moveAmount)/16;
        let Bmax = 10.0+Double(moveAmount)/16;
        
        let DANGERZONE = 2.5;
        
        for i in 0...columns()-1
        {
            let redFactor = CGFloat((sin(Double(DoFrame) * Double.pi / 2 / 30 )+1)/2)
            var Datai:Double = Double(Tdata[i]);
            var c = TopColumns[i];
            if(Datai > Tmax-DANGERZONE)
            {
                c.color = UIColor(red:redFactor,green:0,blue:0,alpha:1);
                c.alpha = 1;
            }
            else
            {
                c.color = .white;
            }
            c = BottomColumns[i];
            Datai = Double(Bdata[i]);
            if(Datai > Bmax-DANGERZONE)
            {
                c.color = UIColor(red:redFactor,green:0,blue:0,alpha:1);
                c.alpha = 1;
            }
            else
            {
                c.color = .white;
            }
        }
        
        
        
        if(Tr)
        {
            let P = playerTop.readyPiece!;
            GhostTopFront?.removeFromParent();
            GhostTopRear?.removeFromParent();
            GhostTopFront = SKSpriteNode(color: BlockRush.BlockColors[P.FrontBlock.col!], size: CGSize(width: BlockRush.BlockWidth, height: BlockRush.BlockWidth/2));
            GhostTopRear = SKSpriteNode(color: BlockRush.BlockColors[P.RearBlock.col!], size: CGSize(width: BlockRush.BlockWidth, height: BlockRush.BlockWidth/2));
            
            GhostTopFront!.position = GetPositionTopNext(column: playerTop.columnOver,add: 1);
            GhostTopRear! .position = GetPositionTopNext(column: playerTop.columnOver,add: 2);
            
            GhostTopFront!.position.y += fieldNode.position.y;
            GhostTopRear! .position.y += fieldNode.position.y;
            
            GhostTopFront!.alpha = 0.5;
            GhostTopRear!.alpha = 0.5;
            
            GhostTopFront!.zPosition = 9;
            GhostTopRear!.zPosition = 9;
            
            gameScene.addChild(GhostTopFront!);
            gameScene.addChild(GhostTopRear!);
        }
        else
        {
            GhostTopFront?.removeFromParent();
            GhostTopRear?.removeFromParent();
            GhostTopFront = nil;
            GhostTopRear = nil;
        }
        
        if(Br)
        {
            let P = playerBottom.readyPiece!
            GhostBottomFront?.removeFromParent();
            GhostBottomRear?.removeFromParent();
            GhostBottomFront = SKSpriteNode(color: BlockRush.BlockColors[P.FrontBlock.col!], size: CGSize(width: BlockRush.BlockWidth, height: BlockRush.BlockWidth/2));
            GhostBottomRear = SKSpriteNode(color: BlockRush.BlockColors[P.RearBlock.col!], size: CGSize(width: BlockRush.BlockWidth, height: BlockRush.BlockWidth/2));
            
            GhostBottomFront!.position = GetPositionBottomNext(column: playerBottom.columnOver,add: 1);
            GhostBottomRear! .position = GetPositionBottomNext(column: playerBottom.columnOver,add: 2);
            
            GhostBottomFront!.position.y += fieldNode.position.y;
            GhostBottomRear! .position.y += fieldNode.position.y;
            
            GhostBottomFront!.alpha = 0.5;
            GhostBottomRear!.alpha = 0.5;
            
            GhostBottomFront!.zPosition = 9;
            GhostBottomRear!.zPosition = 9;
            
            gameScene.addChild(GhostBottomFront!);
            gameScene.addChild(GhostBottomRear!);
        }
        else
        {
            GhostBottomFront?.removeFromParent();
            GhostBottomRear?.removeFromParent();
            GhostBottomFront = nil;
            GhostBottomRear = nil;
        }
        //
        GameFrame += 1;
    }
    
    func ApplyMatch(blocks: [Block],frame: Int, creditTop: Bool?)
    {
        BlockRush.PlaySound(name: "Chain1");
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
                    
                    switch p.chainLevel
                    {
                    case 1:
                        BlockRush.PlaySound(name: "Chain1");
                    case 2:
                        BlockRush.PlaySound(name: "Chain2");
                    case 3:
                        BlockRush.PlaySound(name: "Chain3");
                    case 4:
                        BlockRush.PlaySound(name: "Chain4");
                    case 5:
                        BlockRush.PlaySound(name: "Chain5");
                    case 6:
                        BlockRush.PlaySound(name: "Chain6");
                    default:
                        BlockRush.PlaySound(name: "Chain7");
                    }
                    
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
                        if(block.nod.parent != nil)
                        {
                            block.nod.removeFromParent();
                        }
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
                    block.nod.position = GetPosition(column:i,row:jTo);
                    block.iPos = i;
                    block.jPos = jTo;
                }
            }
        }
        return ret;
    }
    
    func acceptDefeat(player: Player)
    {
        //print(player);
        if(Loser != nil && Loser! !== player)
        {
            Loser = nil;
        }
        else
        {
            GameOver = true;
            Loser = player;
            gameScene.ReadyEndOfGame();
        }
    }
}
