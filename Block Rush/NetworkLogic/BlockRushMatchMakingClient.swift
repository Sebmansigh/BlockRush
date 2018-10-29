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
    static let WRITE_GENERIC_STRING = 0;
    static let READ_GENERIC_STRING = 1;
    static let READ_HELLO = 100;
}

final class BlockRushMatchMakingClient
{
    private static var HeartbeatTimer: Timer?
    
    private class SocketDelegate: NSObject, GCDAsyncSocketDelegate
    {
        static let Instance = SocketDelegate();
        
        private override init(){};
        
        //On Data Read
        func socket(_ sock: GCDAsyncSocket, didRead data: Data, withTag tag: Int)
        {
            let str = String(data: data, encoding: .ascii)!.trimmingCharacters(in: .newlines);
            switch(tag)
            {
            case Tag.READ_GENERIC_STRING:
                print("read: \(str)");
            case Tag.READ_HELLO:
                if(str == "hello")
                {
                    if let menu = GameMenu.focusMenu as? OnlineMenu
                    {
                        menu.notifyHello();
                    }
                    else
                    {
                        BlockRushMatchMakingClient.Client.disconnect();
                    }
                }
                else
                {
                    print("Got initial string '\(str)' instead of 'hello'.");
                    connectionError(sock);
                }
            default:
                print("Unknown read tag: \(tag)");
                connectionError(sock);
            }
        }
        
        //On Time Out
        func socket(_ sock: GCDAsyncSocket, shouldTimeoutReadWithTag tag: Int, elapsed: TimeInterval, bytesDone length: UInt) -> TimeInterval
        {
            print("read timed out.");
            return 0;
        }
        
        //On Data Write
        func socket(_ sock: GCDAsyncSocket, didWriteDataWithTag tag: Int)
        {
            //works
            //print("Wrote data.");
        }
        
        func socketDidDisconnect(_ sock: GCDAsyncSocket, withError err: Error?)
        {
            BlockRushMatchMakingClient.HeartbeatTimer?.invalidate();
            if let error = err
            {
                print("Socket connection error: \(error)");
            }
            if let menu = GameMenu.focusMenu as? OnlineMenu
            {
                menu.notifyDisconnect();
            }
        }
        
        func connectionError(_ sock: GCDAsyncSocket)
        {
            sock.disconnect();
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
        
        if #available(iOS 10.0, *)
        {
            BlockRushMatchMakingClient.HeartbeatTimer = Timer.scheduledTimer(withTimeInterval: 20, repeats: true, block:heartbeat)
        }
        else
        {
            BlockRushMatchMakingClient.HeartbeatTimer = Timer.scheduledTimer(timeInterval: 20, target: self, selector: #selector(self.heartbeat), userInfo: nil, repeats: true)
        }
    }
    
    @objc func heartbeat(t: Timer)
    {
        self.writeLine("!");
    }
    
    func disconnect()
    {
        Socket?.disconnectAfterReadingAndWriting();
        BlockRushMatchMakingClient.HeartbeatTimer?.invalidate();
    }
    
    func writeLine(_ str:String)
    {
        //print("Queueing write: '\(str)'");
        write(str+"\n");
    }
    
    func write(_ str:String)
    {
        if let strData = str.data(using: .ascii)
        {
            Socket?.write(strData, withTimeout: 3, tag: 0);
        }
        else
        {
            fatalError("Can only write ascii strings to server.");
        }
    }
    
    func readLine()
    {
        print("Queueing read.");
        if let s = Socket
        {
            print("Socket.");
            s.readData(to: "\n".data(using: .ascii)!, withTimeout: -1, tag: Tag.READ_GENERIC_STRING);
        }
        else
        {
            print("No socket?");
        }
    }
    
    func getHello()
    {
        print("Queueing read.");
        if let s = Socket
        {
            print("Hello Socket.");
            s.readData(to: "\n".data(using: .ascii)!, withTimeout: 3, tag: Tag.READ_HELLO);
        }
        else
        {
            print("No socket?");
        }
    }
}
