//
//  PlayField.swift
//  Block Rush
//
//  Created by Sebastian Snyder on 3/26/18.
//

import Foundation
import SpriteKit

/**
 The playfield on which a round is played.
 */
class PlayField
{
    /// The 2-dimensional array containing the Blocks on the field.
    var Field: [[Block?]]
    /// The current frame number
    var GameFrame: Int;
    /// Whether the game has been initialized
    var GameReady: Bool;
    /// The frame on which the game has ended, if it has ended.
    var GameOverFrame: Int? = nil;
    
    /// The white bar indicating where the center of gravity is for the blocks.
    let CenterBar: SKSpriteNode;
    /// The gray bar indicating where the middle of the playfield is.
    let BackBar: SKSpriteNode;
    
    /// An array of rectangles going from the center bar to the edge of the top player's playfield.
    var TopColumns: [SKSpriteNode];
    /// The top player's Ghost Piece's front block
    var GhostTopFront: SKSpriteNode?;
    /// The top player's Ghost Piece's rear block
    var GhostTopRear: SKSpriteNode?;
    
    /// An array of rectangles going from the center bar to the edge of the bottom player's playfield.
    var BottomColumns: [SKSpriteNode];
    /// The bottom player's Ghost Piece's front block
    var GhostBottomFront: SKSpriteNode?;
    /// The bottom player's Ghost Piece's rear block
    var GhostBottomRear: SKSpriteNode?;
    
    ///If set to `true`, a cascade check will be performed next frame.
    var CheckCascade: Bool = false;
    ///A Set of frame numbers on which to check for matches.
    var CheckMatchFrames: Set<Int> = [];
    ///The frame on which the last cascade occurred on the top side of the field.
    var LastCascadeTop:    [Int] = [Int](repeating:0, count:6);
    ///The frame on which the last cascade occurred on the bottom side of the field.
    var LastCascadeBottom: [Int] = [Int](repeating:0, count:6);
    ///Which player, if any, should be credited with a match that occured from an adjusted cascade on the top side of the field.
    var CascadeCreditTop:  [Bool?] = [Bool?](repeating: nil, count: 6);
    ///Which player, if any, should be credited with a match that occured from an adjusted cascade on the bottom side of the field.
    var CascadeCreditBottom: [Bool?] = [Bool?](repeating: nil, count: 6);
    
    /// A map of frame numbers to matches made.
    /// These matches are credited to the top player.
    var TopMatches: [Int: Set<Block> ];
    /// A map of frame numbers to matches made.
    /// These matches are credited to the bottom player.
    var BtmMatches: [Int: Set<Block> ];
    /// A map of frame numbers to matches made.
    /// These matches have been fizzled.
    var NilMatches: [Int: Set<Block> ];
    
    /// The top player.
    unowned var playerTop: Player;
    /// The bottom player
    unowned var playerBottom: Player;
    /// The game scene
    unowned var gameScene: GameScene;
    
    /// A parent node containing all moving parts of the game field.
    /// When the field moves, the position of this node is changed.
    var fieldNode: SKNode;
    
    /// How many units of movement are stored up
    /// - Positive values move towards the top player
    /// - Negative values move towards the bottom player
    var movePower: Int;
    
    /// How many units of movement have been applied
    /// - Positive values are towards the top player
    /// - Negative values are towards the bottom player
    var moveAmount: Int;
    
    /// The stored movement indicators on the left side of the field.
    /// Each fully opaque indicator represents 8 units of movement, or half a row
    var LPowerNodes: [SKSpriteNode];
    
    /// The stored movement indicators on the right side of the field.
    /// Each fully opaque indicator represents 8 units of movement, or half a row
    var RPowerNodes: [SKSpriteNode];
    
    /// The stored large indicators on the left side of the field.
    /// Each one represents half the field, or 20 small indicators, or 10 rows, or 160 units of movement.
    var LBigNodes: [SKSpriteNode];
    /// The stored large indicators on the right side of the field.
    /// Each one represents half the field, or 20 small indicators, or 10 rows, or 160 units of movement.
    var RBigNodes: [SKSpriteNode];
    
    /// The current total amount of movement that the indicators represent. This only changes by 1 per frame so that the indicators can appear animated and is therefore not the actual amount of movement that is stored up.
    var curPowerVal: Int;
    
    /// An array containing the cached stack heights of the top side of the play field.
    var TopStackHeight:[Int];
    /// An array containing the cached stack heights of the bottom side of the play field.
    var BottomStackHeight:[Int];
    
    /// Contains the loser of the game. If it is `nil`, then the game was a draw.
    var Loser: Player? = nil;
    
    /// In a game of Survival, stores how many 64ths of a unit of applied movement. Is 0 in all other game modes.
    var PartialMove = 0;
    
    ///These are the "Flashing" effect when a block is over a potential match for the top player.
    public var TopHelperNodes: [SKSpriteNode];
    
    ///These are the "Flashing" effect when a block is over a potential match for the bottom player.
    public var BottomHelperNodes: [SKSpriteNode];
    
    init(cols:Int, rows:Int, playerTop t:Player, playerBottom b: Player, scene:SKScene)
    {
        fieldNode = SKNode();
        fieldNode.zPosition = -1;
        GameFrame = 0;
        GameReady = false;
        
        TopMatches = [:];
        BtmMatches = [:];
        NilMatches = [:];
        
        playerTop = t;
        playerBottom = b;
        movePower = 0;
        moveAmount = 0;
        TopHelperNodes = [];
        BottomHelperNodes = [];
        
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
        CenterBar.zPosition = 1;
        BackBar.zPosition = -3;
        
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
            Tc.zPosition = -2;
            Tc.position.x = GetPosition(column: i);
            Tc.position.y = BlockRush.BlockWidth*2.5;
            scene.addChild(Tc);
            TopColumns.append(Tc);
            let Bc = SKSpriteNode(color: .white, size: CGSize(width: BlockRush.BlockWidth, height: BlockRush.BlockWidth*5));
            Bc.alpha = 0;
            Bc.zPosition = -2;
            Bc.position.x = GetPosition(column: i);
            Bc.position.y = -BlockRush.BlockWidth*2.5;
            scene.addChild(Bc);
            BottomColumns.append(Bc);
        }
        scene.addChild(fieldNode);
        scene.addChild(BackBar);
        
    }
    
    /// Gets the number of columns in this playfield
    func columns() -> Int
    {
        return Field.count;
    }
    
    /// Gets the number of rows in this playfield
    func rows() -> Int
    {
        return Field[0].count;
    }
    
    
    /**
     Gets the surface data for the given player.
     
     Because there are two sides of the field, the player must be specified.
     
     - Parameter player: the player for whom to get surface data for.
     - Returns: an array of stack heights for the given player. Indecies are column numbers.
     */
    func getSurfaceData(_ player: Player) -> [Int]
    {
        var ret: [Int] = Array<Int>(repeating: 0, count: columns());
        for i in 0...columns()-1
        {
            ret[i] = getStackHeight(column: i, player: player);
        }
        return ret;
    }
    
    /**
     Gets the column data for the given player.
     
     Because there are two sides of the field, the player must be specified.
     
     - Parameter column: the column for which to get data for.
     - Parameter player: the player for whom to get data for.
     - Returns: an array of stack heights for the given player. Indecies are column numbers.
     */
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
    
    func surfaceTopBlock(column: Int) -> Block?
    {
        for i in 0...rows()/2-1
        {
            if let b = Field[column][i]
            {
                return b;
            }
        }
        return nil;
    }
    
    func surfaceBottomBlock(column: Int) -> Block?
    {
        for i in (rows()/2...rows()-1).reversed()
        {
            if let b = Field[column][i]
            {
                return b;
            }
        }
        return nil;
    }
    
    /**
     Update the values of `TopStackHeight` and `BottomStackHeight`.
     */
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
    
    /**
     Causes one frame of animation for the movement indicators on either side of the field.
     */
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
                        
                        NewNodeL.zPosition = 3;
                        NewNodeR.zPosition = 3;
                        
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
                    
                    NewNodeL.zPosition = 3;
                    NewNodeR.zPosition = 3;
                    
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
                        
                        NewNodeL.zPosition = 3;
                        NewNodeR.zPosition = 3;
                        
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
                        
                        NewNodeL.zPosition = 3;
                        NewNodeR.zPosition = 3;
                        
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
                        
                        NewNodeL.zPosition = 3;
                        NewNodeR.zPosition = 3;
                        
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
    
    /**
     Pushes a new piece onto the bottom side of stack.
     
     - Parameters:
        - column: The column to push the piece onto.
        - piece: The piece to push onto the stack.
        - frame: Which frame this occurred on (in case an input device is behind the current game frame.)
     */
    func PushBottom(column: Int, piece: Piece, frame: Int)
    {
        PushBottom(column:column, block:piece.FrontBlock, frame:frame);
        PushBottom(column:column, block:piece.RearBlock, frame:frame);
    }
    
    /**
     Pushes a single block onto the bottom side of stack.
     
     - Parameters:
        - column: The column to push the piece onto.
        - block: The block to push onto the stack.
        - frame: Which frame this occurred on (in case an input device is behind the current game frame.)
     */
    func PushBottom(column: Int, block: Block,frame: Int)
    {
        for i in rows()/2...rows()-1
        {
            if(Field[column][i] == nil)
            {
                block.nod.isHidden = false;
                block.nod.position = GetPosition(column:column,row:i);
                if(frame >= LastCascadeBottom[column])
                {
                    block.CreditTop = false;
                    block.LockFrame = frame;
                }
                else
                {
                    block.CreditTop = CascadeCreditBottom[column];
                    block.LockFrame = LastCascadeBottom[column];
                }
                Field[column][i] = block;
                block.iPos = column;
                block.jPos = i;
                block.nod.removeFromParent();
                fieldNode.addChild(block.nod);
                
                block.debugLabel?.text = "\(frame)\u{21e9}"
                
                CheckMatchFrames.insert(frame);
                return;
            }
        }
    }
    
    /**
     Pushes a new piece onto the top side of stack.
     
     - Parameters:
         - column: The column to push the piece onto.
         - piece: The piece to push onto the stack.
         - frame: Which frame this occurred on (in case an input device is behind the current game frame.)
     */
    func PushTop(column: Int, piece: Piece, frame: Int)
    {
        PushTop(column:column, block:piece.FrontBlock, frame:frame);
        PushTop(column:column, block:piece.RearBlock, frame:frame);
    }
    
    /**
     Pushes a single block onto the top side of stack.
     
     - Parameters:
         - column: The column to push the piece onto.
         - block: The block to push onto the stack.
         - frame: Which frame this occurred on (in case an input device is behind the current game frame.)
     */
    func PushTop(column: Int, block: Block,frame: Int)
    {
        for i in (0...rows()/2-1).reversed()
        {
            if(Field[column][i] == nil)
            {
                block.nod.isHidden = false;
                block.nod.position = GetPosition(column:column,row:i);
                if(frame >= LastCascadeTop[column])
                {
                    block.CreditTop = true;
                    block.LockFrame = frame;
                }
                else
                {
                    block.CreditTop = CascadeCreditTop[column];
                    block.LockFrame = LastCascadeTop[column];
                }
                Field[column][i] = block;
                block.iPos = column;
                block.jPos = i;
                block.nod.removeFromParent();
                fieldNode.addChild(block.nod);
                
                block.debugLabel?.text = "\(frame)\u{21e7}"
                
                CheckMatchFrames.insert(frame);
                return;
            }
        }
    }
    
    
    /**
     Calculate the position of the specified row/column indecies.
     - Parameter column: The column number to use.
     - Parameter row: The row number to use.
     - Returns: The calculated point.
     */
    func GetPosition(column:Int,row:Int) -> CGPoint
    {
        
        let pX = GetPosition(column: column);
        let pY = GetPosition(row: row);
        
        return CGPoint(x: pX, y: pY);
    }
    
    /**
     Calculate the x-position of the specified column.
     - Parameter column: The column number to use.
     - Returns: The calculated value.
     */
    func GetPosition(column:Int) -> CGFloat
    {
        return BlockRush.BlockWidth/2 + BlockRush.BlockWidth * CGFloat(column-3);
    }
    /**
     Calculate the y-position of the specified row.
     - Parameter row: The row number to use.
     - Returns: The calculated value.
     */
    func GetPosition(row:Int) -> CGFloat
    {
        let offsetRows = CGFloat(rows())/2;
        return BlockRush.BlockWidth * ((offsetRows-CGFloat(row))/2-0.25);
    }
    
    /**
     Get the y-position of the top row of a given column plus a specified number of rows.
     - Parameter column: The column to calculate the y-position of.
     - Parameter add: The number of rows above the top row to add.
     - Returns: The final y-position.
     */
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
    
    /**
     Get the y-position of the bottom row of a given column plus a specified number of rows.
     - Parameter column: The column to calculate the y-position of.
     - Parameter add: The number of rows below the bottom row to add.
     - Returns: The final y-position.
     */
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
    
    /**
     Gets the surface-level block for a given column and player
     - Parameter column: The column number to check.
     - Parameter player: The player whose side to check.
     - Returns: `nil` if the surface level is the center bar, or the surface-level block otherwise.
     */
    func SurfaceBlockAtColumn(column: Int, player: Player) -> Block?
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
    
    /**
     Evaluates the effects of a chain link.
     - Parameter player: The player who caused the match.
     - Parameter numMatched: The total number of blocks matched in this chain link.
     */
    func EvalChain(player: Player, numMatched: Int) -> Int
    {
        player.chainLevel += 1;
        let linkDamage = BlockRush.CalculateDamage(chainLevel: player.chainLevel, blocksCleared: numMatched);
        switch(gameScene.GameMode)
        {
        case .Survival:
            player.storedPower += linkDamage;
            fallthrough;
        case .TimeAttack:
            player.linkScore = gameScene.Level * BlockRush.CalculateScore(chainLevel: player.chainLevel, blocksCleared: numMatched);
        default:
            player.storedPower += linkDamage;
        }
        player.GainTime(300*player.chainLevel-150);
        //
        return linkDamage;
    }
    
    /**
     Checks the loss condition for the given player.
     - Parameter player: The player to check for.
     - Returns: Whether the given player's loss condition has been met.
     */
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
    
    /**
     Checks the loss condition for the bottom player.
     - Returns: Whether the bottom player's loss condition has been met.
     */
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
    /**
     Checks the loss condition for the top player.
     - Returns: Whether the top player's loss condition has been met.
     */
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
    
    /**
     Moves the stack to the specified value of `moveAmount`.
     */
    func StackMove(moveAmount ma: Int)
    {
        moveAmount = ma;
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
    }
    
    /**
     Moves the stack 1 unit towards the given player if the value of `movePower` indicates that such movement should take place. If successful, the value of `movePower` will become 1 closer to 0.
     
     - Returns: Whether or not movement occurred.
     */
    func StackMove(player: Player) -> Bool
    {
        if(movePower == 0)
        {
            return false;
        }
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
        else// if(movePower > 0)
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
        /*
        else
        {
            fatalError("wut?");
        }
         */
    }
    
    
    /**
     Causes the playfield and any pending matches or cascades to advance one frame.
     Causes the playfield to inch forward in Survival mode if the bottom player isn't frozen.
     */
    func AdvanceFrame()
    {
        GameEvent.Fire(.OnGameFrameUpdate);
        if GameFrame > 200,
           case .Survival = gameScene.GameMode
        {
            if(StackMove(player: playerTop))
            {
                if(moveAmount == 160)
                {
                    PartialMove = 0;
                    gameScene.OverpowerBonus += 1;
                    gameScene.UpdateOverpowerBonusEffect();
                }
            }
            else if(!playerBottom.isFrozen())
            {
                if(gameScene.OverpowerBonus > 0)
                {
                    gameScene.Score += BlockRush.CalculateOverpowerBonus(units: gameScene.OverpowerBonus);
                    gameScene.OverpowerBonus = 0;
                }
                PartialMove += gameScene.Level*2-1;
                if(PartialMove > 64)
                {
                    StackMove(moveAmount: moveAmount-PartialMove/64);
                    PartialMove = PartialMove % 64;
                }
            }
        }
        let DoFrame = GameFrame;
        if(CheckMatchFrames.contains(DoFrame-16))
        {
            EvalMatches(frame: DoFrame-15);
            CheckMatchFrames.remove(DoFrame-16);
            //print("CHECKING:\(DoFrame-1)");
        }
        else
        {
            //print(DoFrame,CheckMatchFrames);
        }
        //
        AnimMatches(frame: DoFrame);
        let Fell = Cascade(frame: DoFrame);
        if(Fell)
        {
            CheckMatchFrames.insert(DoFrame);
        }
        AnimPower();
        
        //DebugTools.TimeExecution("Stack Height Recalculation.")
        RecalculateStackHeights();
        
        
        let Tr = (playerTop.readyPiece != nil && !playerTop.IsHidden())
        let Br = (playerBottom.readyPiece != nil && !playerBottom.IsHidden())
        
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
            
            var Datai = Double(Tdata[i]);
            var c = TopColumns[i];
            
            if case .Survival = gameScene.GameMode
            {
                c.color = UIColor.purple;
                c.alpha = 1;
            }
            else
            {
                if(Datai > Tmax-DANGERZONE)
                {
                    c.color = UIColor(red:redFactor,green:0,blue:0,alpha:1);
                    c.alpha = 1;
                }
                else
                {
                    c.color = .white;
                }
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
        
        let helperPulseAlpha = sin(Double(GameFrame)/5) / 8 + 0.125;
        
        for node in TopHelperNodes
        {
            node.removeFromParent();
        }
        TopHelperNodes = [];
        
        if(Tr)
        {
            let P = playerTop.readyPiece!;
            GhostTopFront?.removeFromParent();
            GhostTopRear?.removeFromParent();
            GhostTopFront = SKSpriteNode(texture: P.FrontBlock.blockTexture(), color: P.FrontBlock.blockColor(), size: CGSize(width: BlockRush.BlockWidth, height: BlockRush.BlockWidth/2));
            GhostTopRear = SKSpriteNode(texture: P.RearBlock.blockTexture(), color: P.RearBlock.blockColor(), size: CGSize(width: BlockRush.BlockWidth, height: BlockRush.BlockWidth/2));
            
            GhostTopFront?.colorBlendFactor = 1;
            GhostTopRear?.colorBlendFactor = 1;
            
            GhostTopFront!.position = GetPositionTopNext(column: playerTop.columnOver,add: 1);
            GhostTopRear! .position = GetPositionTopNext(column: playerTop.columnOver,add: 2);
            
            GhostTopFront!.position.y += fieldNode.position.y;
            GhostTopRear! .position.y += fieldNode.position.y;
            
            GhostTopFront!.alpha = 0.5;
            GhostTopRear!.alpha = 0.5;
            
            GhostTopFront!.zPosition = -1;
            GhostTopRear!.zPosition = -1;
            
            gameScene.addChild(GhostTopFront!);
            gameScene.addChild(GhostTopRear!);
            
            let MatchData = PieceMatchesTop(column: playerTop.columnOver, colorFront: P.FrontBlock.col!, colorRear: P.RearBlock.col!).0;
            for block in MatchData
            {
                let newNode = SKSpriteNode(color: .white, size:CGSize(width:BlockRush.BlockWidth,height:BlockRush.BlockWidth/2));
                block.nod.addChild(newNode);
                newNode.alpha = CGFloat(helperPulseAlpha);
                newNode.zPosition = 100;
                TopHelperNodes.append(newNode);
            }
        }
        else
        {
            GhostTopFront?.removeFromParent();
            GhostTopRear?.removeFromParent();
            GhostTopFront = nil;
            GhostTopRear = nil;
        }
        
        
        for node in BottomHelperNodes
        {
            node.removeFromParent();
        }
        BottomHelperNodes = [];
        
        if(Br)
        {
            let P = playerBottom.readyPiece!
            GhostBottomFront?.removeFromParent();
            GhostBottomRear?.removeFromParent();
            GhostBottomFront = SKSpriteNode(texture: P.FrontBlock.blockTexture(), color: P.FrontBlock.blockColor(), size: CGSize(width: BlockRush.BlockWidth, height: BlockRush.BlockWidth/2));
            GhostBottomRear = SKSpriteNode(texture: P.RearBlock.blockTexture(), color: P.RearBlock.blockColor(), size: CGSize(width: BlockRush.BlockWidth, height: BlockRush.BlockWidth/2));
            
            
            GhostBottomFront?.colorBlendFactor = 1;
            GhostBottomRear?.colorBlendFactor = 1;
            
            GhostBottomFront!.position = GetPositionBottomNext(column: playerBottom.columnOver,add: 1);
            GhostBottomRear! .position = GetPositionBottomNext(column: playerBottom.columnOver,add: 2);
            
            GhostBottomFront!.position.y += fieldNode.position.y;
            GhostBottomRear! .position.y += fieldNode.position.y;
            
            GhostBottomFront!.alpha = 0.5;
            GhostBottomRear!.alpha = 0.5;
            
            GhostBottomFront!.zPosition = -1;
            GhostBottomRear!.zPosition = -1;
            
            gameScene.addChild(GhostBottomFront!);
            gameScene.addChild(GhostBottomRear!);
            let MatchData = PieceMatchesBottom(column: playerBottom.columnOver, colorFront: P.FrontBlock.col!, colorRear: P.RearBlock.col!).0;
            for block in MatchData
            {
                let newNode = SKSpriteNode(color: .white, size:CGSize(width:BlockRush.BlockWidth,height:BlockRush.BlockWidth/2));
                block.nod.addChild(newNode);
                newNode.alpha = CGFloat(helperPulseAlpha);
                newNode.zPosition = 100;
                BottomHelperNodes.append(newNode);
            }
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
        ///*
        if(BlockRush.DEBUG_MODE)
        {
            for i in 0...5
            {
                var t: String;
                if let c = CascadeCreditTop[i]
                {
                    if(c)
                    {
                        t = "\u{21e7}";
                    }
                    else
                    {
                        t = "\u{21e9}";
                    }
                }
                else
                {
                    t = "=";
                }
                
                gameScene.DebugNodeTopColumn[i]!.text = "\(LastCascadeTop[i])"+t;
                //
                if let c = CascadeCreditBottom[i]
                {
                    if(c)
                    {
                        t = "\u{21e7}";
                    }
                    else
                    {
                        t = "\u{21e9}";
                    }
                }
                else
                {
                    t = "=";
                }
                
                gameScene.DebugNodeBottomColumn[i]!.text = "\(LastCascadeBottom[i])"+t;
            }
        }
         //*/
    }
    
    /**
     Register a set of matched blocks and color them white in-game.
     - Parameters:
        - blocks: An array containing the matched blocks
        - frame: The frame at which the match occurred
        - creditTop: `true` if it's the top player's match, `false` if it's the bottom player's, or `nil` if it's been fizzled.
     */
    func ApplyMatch(blocks: [Block],frame: Int, creditTop: Bool?)
    {
        for block in blocks
        {
            //block.nod.size.width*=1.2;
            //block.nod.size.height*=1.2;
            block.nod.color = .white;
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
            /*
             TO DO: Add a frame argument to freeze and unfreeze.
             */
            playerTop.Freeze(untilFrame: frame+120);
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
            playerBottom.Freeze(untilFrame: frame+120);
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
    
    /**
     Detect and call `ApplyMatch` all matches on the field.
     - Parameter frame: The frame number on which the match occurred
     */
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
        if(!TotalMatched.isEmpty)
        {
            BlockRush.PlaySound(name: "Chain1");
        }
    }
    
    /**
     Creates a visual chain effect centered on a set of blocks.
     - Parameters:
        - blocks: A set containing the blocks to center the chain effect on.
        - creditTop: Whether the effect should face the top player.
        - chainLevel: The chain level this effect represents.
     */
    func CreateChainEffect(blocks: Set<Block>,creditTop:Bool,chainLevel:Int)
    {
        let cN = CGFloat(blocks.count);
        var cX: CGFloat = 0;
        var cY: CGFloat = 0;
        for b in blocks
        {
            cX += b.nod.position.x;
            cY += b.nod.position.y;
        }
        
        cX /= cN;
        cY /= cN;
        
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
    
    /**
     Creates a visual score effect centered on a set of blocks.
     - Parameters:
     - blocks: A set containing the blocks to center the chain effect on.
     - score: The number of points earned.
     */
    func CreateScoreEffect(blocks: Set<Block>,score: Int)
    {
        let cN = CGFloat(blocks.count);
        var cX: CGFloat = 0;
        var cY: CGFloat = 0;
        for b in blocks
        {
            cX += b.nod.position.x;
            cY += b.nod.position.y;
        }
        
        cX /= cN;
        cY /= cN;
        
        cX += fieldNode.position.x;
        cY += fieldNode.position.y;
        
        let Bw = BlockRush.BlockWidth;
        let BaseNode = SKNode();
        
        let ScoreNode = SKLabelNode(fontNamed:"Avenir-HeavyOblique");
        ScoreNode.fontSize = Bw*2/3;
        ScoreNode.position = CGPoint(x:0,y:-Bw);
        ScoreNode.fontColor = UIColor.cyan;
        ScoreNode.text = String(score);
        ScoreNode.verticalAlignmentMode = .center
        
        
        BaseNode.addChild(ScoreNode);
        
        BaseNode.position = CGPoint(x: cX, y: cY)
        gameScene.addChild(BaseNode);
        BaseNode.run(.fadeOut(withDuration: 3)) {
            BaseNode.removeFromParent();
        };
    }
    
    /**
     Creates the visual level up effect.
     */
    func CreateLevelUpEffect()
    {
        let Bw = BlockRush.BlockWidth;
        let BaseNode = SKNode();
        
        let cX: CGFloat = 0;
        let cY = BlockRush.GameHeight/2 - BlockRush.BlockWidth;
        
        let TextNode = SKLabelNode(fontNamed:"Avenir-Heavy");
        TextNode.fontSize = Bw;
        TextNode.position = CGPoint(x:0,y:-Bw/3);
        TextNode.fontColor = UIColor.orange;
        TextNode.text = "LEVEL UP";
        TextNode.verticalAlignmentMode = .center
        
        
        BaseNode.addChild(TextNode);
        
        BaseNode.position = CGPoint(x: cX, y: cY)
        gameScene.addChild(BaseNode);
        BaseNode.run(.sequence([.wait(forDuration: 2),
                                .fadeOut(withDuration: 3)] ))
        {
            BaseNode.removeFromParent();
        };
    }
    
    /**
     Cause the animation and disappearing of sets of matched blocks.
     - Parameters:
        - frame: The current game frame.
        - Matches: A dictionary of frame-match pairs. The frame is the number on which the match was made.
        - CreditTop: `true` if `Matches` contains the top player's matches, `false` if it contains the bottom player's, or `nil` if it contains fizzled matches.
     */
    private func AnimMatchesPartial(frame: Int, Matches: inout [Int:Set<Block>],CreditTop: Bool?)
    {
        let decayFactor: CGFloat = 0.92;
        let preFrames: Int = 45;
        let stayFrames: Int = 60;
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
                for block in S
                {
                    block.nod.texture = nil;
                }
                if(CreditTop != nil)
                {
                    //let linkDamage: Int;
                    let p : Player;
                    if(CreditTop!)
                    {
                        //print("TOP PLAYER-----");
                        p = playerTop;
                    }
                    else
                    {
                        //print("BOTTOM PLAYER-----");
                        p = playerBottom;
                    }
                    //linkDamage =
                    let _ = EvalChain(player: p, numMatched: S.count);
                    
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
                    
                    //print(String(p.chainLevel)+" CHAIN => "+String(linkDamage)+" DAMAGE!");
                    CreateChainEffect(blocks: S, creditTop: CreditTop!, chainLevel: p.chainLevel);
                    if(p.linkScore > 0)
                    {
                        CreateScoreEffect(blocks: S, score: p.linkScore);
                        gameScene.Score += p.linkScore * p.chainLevel;
                        gameScene.NextLevel -= S.count;
                        if(gameScene.NextLevel <= 0)
                        {
                            CreateLevelUpEffect();
                            repeat
                            {
                                gameScene.Level += 1;
                                gameScene.NextLevel += 40;
                            }
                            while(gameScene.NextLevel < 0);
                        }
                        p.linkScore = 0;
                    }
                }
            }
            for block in S
            {
                if(AnimFrame >= stayFrames)
                {
                    block.nod.alpha *= decayFactor;
                    block.nod.size.width *= decayFactor;
                    block.nod.size.height *= decayFactor;
                    if(AnimFrame == endFrame)
                    {
                        let I = block.iPos;
                        let J = block.jPos;
                        if(surfaceTopBlock(column:I) == block)
                        {
                            CascadeCreditTop[I] = CreditTop;
                            LastCascadeTop[I] = frame;
                        }
                        else if(surfaceBottomBlock(column:I) == block)
                        {
                            CascadeCreditBottom[I] = CreditTop;
                            LastCascadeBottom[I] = frame;
                        }
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
                            CheckCascade = true;
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

    /**
     Cause the animation and disappearing of all sets of matched blocks.
     - Parameter frame: The current game frame.
    */
    func AnimMatches(frame: Int)
    {
        AnimMatchesPartial(frame: frame, Matches: &TopMatches, CreditTop: true);
        AnimMatchesPartial(frame: frame, Matches: &BtmMatches, CreditTop: false);
        AnimMatchesPartial(frame: frame, Matches: &NilMatches, CreditTop: nil);
    }
    
    /**
     Cause blocks to move towards the center bar, filling empty spaces as they go.
     Blocks will not move through matches in progress.
     - Parameter frame: The current game frame.
     */
    func Cascade(frame:Int) -> Bool
    {
        if(!CheckCascade)
        {
            return false;
        }
        
        CheckCascade = false;

        var ret = false;
        for i in 0...columns()-1
        {
            var jFrom = rows()/2-2;
            var Credit: Bool? = nil;
            var blockFell = false;
            
            
            //Top side of the field:
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
                    
                    CascadeCreditTop[i] = Credit;
                    LastCascadeTop[i] = frame;
                    
                    if(BlockRush.DEBUG_MODE)
                    {
                        if let l = block.debugLabel
                        {
                            let t: String;
                            if let c = Credit
                            {
                                if(c)
                                {
                                    t = "\u{21e7}";
                                }
                                else
                                {
                                    t = "\u{21e9}";
                                }
                            }
                            else
                            {
                                t = "=";
                            }
                            
                            l.text = "\(frame)"+t;
                        }
                    }
                    Field[i][jFrom] = nil;
                    
                    Field[i][jTo] = block;
                    block.nod.position = GetPosition(column:i,row:jTo);
                    block.iPos = i;
                    block.jPos = jTo;
                }
            }
            
            jFrom = rows()/2+1;
            blockFell = false;
            
            //Bottom side of the field.
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
                    
                    CascadeCreditBottom[i] = Credit;
                    LastCascadeBottom[i] = frame;
                    
                    if(BlockRush.DEBUG_MODE)
                    {
                        if let l = block.debugLabel
                        {
                            let t: String;
                            if let c = Credit
                            {
                                if(c)
                                {
                                    t = "\u{21e7}";
                                }
                                else
                                {
                                    t = "\u{21e9}";
                                }
                            }
                            else
                            {
                                t = "=";
                            }
                            
                            l.text = "\(frame)"+t;
                        }
                    }
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
    
    /**
     Called when a player's loss condition is met and cannot be recovered from.
     If called for both players in the same frame before the game over check, the game results in a draw.
     - Parameter player: The player who lost the game.
     - Parameter frame: The frame on which the player lost.
     */
    func acceptDefeat(player: Player,frame: Int)
    {
        if(GameOverFrame != nil)
        {
            //The calling player accepted defeat on a frame after the other player, so they don't lose.
            if(GameOverFrame! < frame)
            {
                return;
            }
            //The other player accepted defeat, but the this player was frames behind and lost first.
            if(GameOverFrame! > frame)
            {
                Loser = player;
                GameOverFrame = frame;
            }
        }
        if(Loser != nil && Loser! !== player)
        {
            //Both players have accepted defeat on the same frame
            Loser = nil;
            gameScene.ReadyEndOfGame();
        }
        else
        {
            GameOverFrame = frame;
            Loser = player;
        }
    }
    
    ///Returns an array of blocks that would be matched by a hypothetical piece played by the top player in the given column
    ///If a block is included twice, it exists in two matches.
    ///Also returns the length of the longest match or partial match formed by the addition of this piece.
    public func PieceMatchesTop(column:Int,colorFront:Int,colorRear:Int) -> ([Block],Int)
    {
        let twinpiece = (colorFront == colorRear);
        
        var TotalMatched = [Block]();
        //Detect Horizontal Matches
        
        let DetectVec = [(0,1),(1,0),(1,1),(-1,1)];
        var BiggestMatchPart = 1;
        for v in DetectVec
        {
            var DirMatched = [Block]();
            let iDir = v.0;
            let jDir = v.1;
            
            for CheckingRearPiece in [true,false]
            {
                var matchMin = 0, matchMax = 0;
                var MaxDir = false;
                //If matching vertically
                if(v == (0,1))
                {
                    //Don't ever check the rear piece's vertical matches.
                    if(CheckingRearPiece)
                    {
                        continue;
                    }
                    else if(twinpiece)
                    {
                        //Include the rear of the hypothetical piece in this match as the only block in the min direction.
                        matchMin = -1;
                    }
                    //Don't bother checking in the rear piece's direction.
                    MaxDir = true;
                }
                
                
                let startIPos = column;
                let startJPos:Int;
                if let surfacePiece = SurfaceBlockAtColumn(column: column, player: playerTop)
                {
                    startJPos = surfacePiece.jPos - 1 - (CheckingRearPiece ? 1 : 0);
                }
                else
                {
                    startJPos = rows()/2 - 1 - (CheckingRearPiece ? 1 : 0);
                }
                
                let matchColor = CheckingRearPiece ? colorRear : colorFront;
                while(true)
                {
                    let testIPos:Int;
                    let testJPos:Int;
                    if(MaxDir)
                    {
                        testIPos = startIPos+iDir*(matchMax+1);
                        testJPos = startJPos+jDir*(matchMax+1);
                    }
                    else
                    {
                        testIPos = startIPos+iDir*(matchMin-1);
                        testJPos = startJPos+jDir*(matchMin-1);
                    }
                    //
                    if testIPos >= 0 && testIPos < 6,
                        testJPos >= 0 && testJPos < rows(),
                        let b = Field[testIPos][testJPos]
                    {
                        if let c = b.col,
                            c == matchColor
                        {
                            //Include this piece.
                            if(MaxDir)
                            {
                                matchMax+=1;
                            }
                            else
                            {
                                matchMin-=1;
                            }
                        }
                            //Otherwise, stop testing in this direction
                        else if(MaxDir)
                        {
                            break;
                        }
                        else
                        {
                            MaxDir = true;
                        }
                    }
                        //Otherwise, stop testing in this direction
                    else if(MaxDir)
                    {
                        break;
                    }
                    else
                    {
                        MaxDir = true;
                    }
                }
                let matchPartLength = matchMax - matchMin + 1
                if matchPartLength >= 4
                {
                    for x in matchMin...matchMax
                    {
                        let iPos = startIPos+x*iDir;
                        let jPos = startJPos+x*jDir;
                        if let b = Field[iPos][jPos]
                        {
                            DirMatched.append(b);
                        }
                    }
                    /*
                     print("Match detected at start position (\(startIPos),\(startJPos)) along direction \(v) in range \(matchMin)...\(matchMax) RearPiece:\(CheckingRearPiece)");
                     */
                }
                if(matchPartLength > BiggestMatchPart)
                {
                    BiggestMatchPart = matchPartLength;
                }
            }
            TotalMatched.append(contentsOf: DirMatched);
        }
        return (TotalMatched,BiggestMatchPart);
    }

    
    ///Returns an array of blocks that would be matched by a hypothetical piece played by the bottom player in the given column
    ///If a block is included twice, it exists in two matches.
    ///Also returns the length of the longest match or partial match formed by the addition of this piece.
    public func PieceMatchesBottom(column:Int,colorFront:Int,colorRear:Int) -> ([Block],Int)
    {
        let twinpiece = (colorFront == colorRear);
        
        var TotalMatched = [Block]();
        //Detect Horizontal Matches
        
        let DetectVec = [(0,-1),(1,0),(1,-1),(-1,-1)];
        var BiggestMatchPart = 1;
        for v in DetectVec
        {
            var DirMatched = [Block]();
            let iDir = v.0;
            let jDir = v.1;
            
            for CheckingRearPiece in [true,false]
            {
                var matchMin = 0, matchMax = 0;
                var MaxDir = false;
                //If matching vertically
                if(v == (0,-1))
                {
                    //Don't ever check the rear piece's vertical matches.
                    if(CheckingRearPiece)
                    {
                        continue;
                    }
                    else if(twinpiece)
                    {
                        //Include the rear of the hypothetical piece in this match as the only block in the min direction.
                        matchMin = -1;
                    }
                    //Don't bother checking in the rear piece's direction.
                    MaxDir = true;
                }
                
                
                let startIPos = column;
                let startJPos:Int;
                if let surfacePiece = SurfaceBlockAtColumn(column: column, player: playerBottom)
                {
                    startJPos = surfacePiece.jPos + 1 + (CheckingRearPiece ? 1 : 0);
                }
                else
                {
                    startJPos = rows()/2 + (CheckingRearPiece ? 1 : 0);
                }
                
                let matchColor = CheckingRearPiece ? colorRear : colorFront;
                while(true)
                {
                    let testIPos:Int;
                    let testJPos:Int;
                    if(MaxDir)
                    {
                        testIPos = startIPos+iDir*(matchMax+1);
                        testJPos = startJPos+jDir*(matchMax+1);
                    }
                    else
                    {
                        testIPos = startIPos+iDir*(matchMin-1);
                        testJPos = startJPos+jDir*(matchMin-1);
                    }
                    //
                    if testIPos >= 0 && testIPos < 6,
                        testJPos >= 0 && testJPos < rows(),
                        let b = Field[testIPos][testJPos]
                    {
                        if let c = b.col,
                            c == matchColor
                        {
                            //Include this piece.
                            if(MaxDir)
                            {
                                matchMax+=1;
                            }
                            else
                            {
                                matchMin-=1;
                            }
                        }
                            //Otherwise, stop testing in this direction
                        else if(MaxDir)
                        {
                            break;
                        }
                        else
                        {
                            MaxDir = true;
                        }
                    }
                        //Otherwise, stop testing in this direction
                    else if(MaxDir)
                    {
                        break;
                    }
                    else
                    {
                        MaxDir = true;
                    }
                }
                let matchPartLength = matchMax - matchMin + 1
                if matchPartLength >= 4
                {
                    for x in matchMin...matchMax
                    {
                        let iPos = startIPos+x*iDir;
                        let jPos = startJPos+x*jDir;
                        if let b = Field[iPos][jPos]
                        {
                            DirMatched.append(b);
                        }
                    }
                    /*
                    print("Match detected at start position (\(startIPos),\(startJPos)) along direction \(v) in range \(matchMin)...\(matchMax) RearPiece:\(CheckingRearPiece)");
                    */
                }
                if(matchPartLength > BiggestMatchPart)
                {
                    BiggestMatchPart = matchPartLength;
                }
            }
            TotalMatched.append(contentsOf: DirMatched);
        }
        return (TotalMatched,BiggestMatchPart);
    }
}
