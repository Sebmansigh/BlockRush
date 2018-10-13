//
//  CustomCollections.swift
//  Block Rush
//
//  Created by Sebastian Snyder on 3/25/18.
//

import Foundation

/**
 An implementation of a Queue data structure
 */
class Queue<T>: Collection
{
    func index(after i: Int) -> Int {
        return i+1;
    }
    
    subscript(position: Int) -> T {
        return data[position];
    }
    
    let startIndex: Int = 0;
    
    var endIndex: Int
    {
        return data.count;
    }
    
    typealias Element = T;
    
    typealias Index = Int;
    
    
    
    private var data: [T];
    /**
     Allocates an empty queue
     */
    init()
    {
        data = [];
    }
    
    /**
     Allocates a queue with the given elements
     Element 0 will be in the front of the queue.
     
     - Parameter elements: An array containing the desired elements.
     */
    init(_ elements: [T])
    {
        data = elements;
    }
    
    /**
     Adds an item to the back of the queue.
     - Parameter item: The element to add.
     */
    func enqueue(_ item: T)
    {
        data.append(item);
    }
    
    /**
     Returns whether or not the queue is empty.
     - Returns: `true` if empty, `false` otherwise.
     */
    func isEmpty() -> Bool
    {
        return data.count == 0;
    }
    
    /**
     Removes the first element in the queue.
     - Returns: The removed element.
     */
    func dequeue() -> T
    {
        return data.removeFirst();
    }
    
    /**
     Looks at the first element in the queue.
     - Returns: The first element in the queue.
     */
    func peek() -> T
    {
        return data[0];
    }
    
    /**
     Looks at the `n`th element in the queue.
     - Parameter n: How far back to look.
     - Returns: The `n`th element in the queue.
     */
    func peek(_ n: Int) -> T
    {
        return data[n];
    }
    /**
     Returns how many items are in the queue.
     - Returns: The size of the queue.
     */
    func count() -> Int
    {
        return data.count;
    }
}
