//
//  BlockRushMatchMakingClient.swift
//  Block Rush
//
//  Created by Sebastian Snyder on 10/28/18.
//

import Foundation

fileprivate struct Tag
{
    private init(){};
    static let STRING_WRITE = 0;
    static let STRING_READ = 1;
}

final class BlockRushMatchMakingClient
{
    private static let OnReads = Queue<(String) -> Void>();
    
    private class SocketDelegate: NSObject, GCDAsyncSocketDelegate
    {
        static let Instance = SocketDelegate();
        
        private override init(){};
        
        func socket(_ sock: GCDAsyncSocket, didRead data: Data, withTag tag: Int)
        {
            print("readlistener reached.");
            let str = String(data: data, encoding: .ascii)!;
            print("read: \(str)");
            BlockRushMatchMakingClient.OnReads.dequeue()(str);
        }
        
        func socket(_ sock: GCDAsyncSocket, shouldTimeoutReadWithTag tag: Int, elapsed: TimeInterval, bytesDone length: UInt) -> TimeInterval
        {
            return 0;
        }
        
        func socket(_ sock: GCDAsyncSocket, didWriteDataWithTag tag: Int)
        {
            //works
            //print("Wrote data.");
        }
        
        func socketDidDisconnect(_ sock: GCDAsyncSocket, withError err: Error?)
        {
            if let error = err
            {
                print("Socket connection error: \(error)");
            }
        }
    }
    
    public static let Client = BlockRushMatchMakingClient();
    
    private var Socket: GCDAsyncSocket? = nil;
    
    private init() {};
    
    func connect()
    {
        Socket = GCDAsyncSocket(delegate: SocketDelegate.Instance, delegateQueue: DispatchQueue.main);
        do
        {
            try Socket!.connect(toHost: "192.168.0.7", onPort: 22196);
        }
        catch
        {
            BlockRush.PopUp("\(error)");
            print("\(error)")
        }
    }
    
    func disconnect()
    {
        Socket?.disconnectAfterReadingAndWriting();
    }
    
    func writeLine(_ str:String)
    {
        write(str+"\n");
    }
    
    func write(_ str:String)
    {
        if let strData = str.data(using: .ascii)
        {
            Socket?.write(strData, withTimeout: 3, tag: 0);
            print("Queueing write: '\(str)'");
        }
        else
        {
            fatalError("Can only write ascii strings to server.");
        }
    }
    
    func readLine(onComplete: @escaping (String) -> Void)
    {
        print("Queueing read.");
        if let s = Socket
        {
            print("Socket.");
            BlockRushMatchMakingClient.OnReads.enqueue(onComplete);
            s.readData(to: "\n".data(using: .ascii)!, withTimeout: -1, tag: Tag.STRING_READ);
        }
        else
        {
            print("No socket?");
        }
    }
    
}
