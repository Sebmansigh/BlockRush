//
//  BlockRushClient.swift
//  Block Rush
//
//  Created by Sebastian Snyder on 10/28/18.
//

import Foundation

final class BlockRushGameClient: NSObject, StreamDelegate
{
    public static let Client = BlockRushGameClient();
    
    var inputStream: InputStream!;
    var outputStream: OutputStream!;
    
    let maxReadLength = 4096;
    
    override private init() {};
    
    func connect(host:String,port:UInt32)
    {
        // 1
        var readStream: Unmanaged<CFReadStream>?
        var writeStream: Unmanaged<CFWriteStream>?
        
        // 2
        CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault,
                                           host as CFString,
                                           port,
                                           &readStream,
                                           &writeStream);
        
        inputStream = readStream!.takeRetainedValue();
        outputStream = writeStream!.takeRetainedValue();

        inputStream.delegate = self;
        
        inputStream.schedule(in: .current, forMode: RunLoop.Mode.common);
        outputStream.schedule(in: .current, forMode: RunLoop.Mode.common);
        
        inputStream.open();
        outputStream.open();
    }
    
    func disconnect()
    {
        inputStream.close();
        outputStream.close();
    }
    
    func sendPlayerInputFrame(_ input:Input)
    {
        let data = Data(bytes: [input.rawValue]);
        
        let _ = data.withUnsafeBytes
        {
            outputStream.write($0, maxLength: 1);
        }
    }
    
    //inputStream has some frames for us.
    func stream(_ iStream: Stream, handle eventCode: Stream.Event)
    {
        switch eventCode
        {
        case Stream.Event.hasBytesAvailable:
            readAvailableBytes(stream: iStream as! InputStream)
        case Stream.Event.endEncountered:
            print("new message received")
        case Stream.Event.errorOccurred:
            print("error occurred")
        case Stream.Event.hasSpaceAvailable:
            print("has space available")
        default:
            print("some other event...")
            break
        }
    }
    
    //reads as many foe input frames as possible.
    private func readAvailableBytes(stream: InputStream)
    {
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: maxReadLength);
        
        while stream.hasBytesAvailable
        {
            let numberOfBytesRead = inputStream.read(buffer, maxLength: maxReadLength)
            
            if numberOfBytesRead < 0
            {
                if let _ = stream.streamError
                {
                    break;
                }
            }
            
        }
    }
    
}
