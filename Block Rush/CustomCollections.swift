//
//  CustomCollections.swift
//  Block Rush
//
//  Created by Sebastian Snyder on 3/25/18.
//

import Foundation

class Queue<T>
{
    private var data: [T];
    init()
    {
        data = [];
    }
    
    init(_ elements: [T])
    {
        data = elements;
    }
    
    func enqueue(_ item: T)
    {
        data.append(item);
    }
    
    func isEmpty() -> Bool
    {
        return data.count == 0;
    }
    
    func dequeue() -> T
    {
        return data.removeFirst();
    }
    
    func peek() -> T
    {
        return data[0];
    }
    
    func peek(_ n: Int) -> T
    {
        return data[n];
    }
    
    func count() -> Int
    {
        return data.count;
    }
}
