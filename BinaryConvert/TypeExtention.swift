//
//  TypeExtention.swift
//  BinaryConvert
//
//  Created by huayan on 16/12/6.
//  Copyright © 2016年 huayan. All rights reserved.
//

import Foundation

/*
 
 public extension Data{
 init<T:DataConvertible>(from value:T) {
 self.init(value.data)
 }
 
 init<T:DataConvertible>(fromArray values:[T]) {
 var selfValues = Data()
 for item in values {
 selfValues.append(item.data)
 }
 self.init(selfValues)
 }
 
 func to<T:DataConvertible>(type:T.Type)->T{
 return T(self)!
 }
 
 func toArray<T:DataConvertible>(type: T.Type) -> [T] {
 return self.withUnsafeBytes {
 [T](UnsafeBufferPointer(start: $0, count: self.count/MemoryLayout<T>.stride))
 }
 }
 }*/

public protocol DataConvertible {
    init()
    init?(_ data:Data)
    var data:Data {get}
    func toFitBytes(bytesSize:Int) -> [UInt8]
}

public extension DataConvertible {
    init(){ self.init() }
    
    init?(_ data:Data) {
        precondition(data.count <= MemoryLayout<Self>.stride,"Byte(s) set out of range")
        self = data.withUnsafeBytes { $0.pointee }
    }
    
    var data:Data {
        var value = self
        return Data(buffer: UnsafeBufferPointer(start: &value, count: 1))
    }
    
    var size:Int {
        return MemoryLayout<Self>.stride
    }
    
    func toFitBytes(bytesSize:Int) -> [UInt8] {
        
        let size = self.size
        var bytesArray = [UInt8](repeating: 0, count: size)
        (self.data as NSData).getBytes(&bytesArray, length: size)
        
        return bytesArray
    }
}

extension Int:DataConvertible{
    public func toFitBytes(bytesSize:Int) -> [UInt8] {
        let UmaxValue = 2^(bytesSize*8)-1
        let minValue = -(2^((bytesSize-1)*8))+1
        let value = self
        if value > 0 {
            precondition(value <= UmaxValue,"Int param is out of data range")
        }
        else {
            precondition(value >= minValue,"Int param is out of data range")
        }
        
        let size = self.size
        var bytesArray = [UInt8](repeating: 0, count: bytesSize)
        
        (self.data as NSData).getBytes(&bytesArray, length: ((bytesSize >= size) ? size : bytesSize))
        return bytesArray
    }
}

extension UInt:DataConvertible{
    public func toFitBytes(bytesSize:Int) -> [UInt8] {
        let UmaxValue = UInt(2^(bytesSize*8)-1)
        let value = self
        precondition(value <= UmaxValue,"UInt param is out of data range")
        
        let size = self.size
        var bytesArray = [UInt8](repeating: 0, count: bytesSize)
        
        (self.data as NSData).getBytes(&bytesArray, length: ((bytesSize >= size) ? size : bytesSize))
        return bytesArray
    }
}

extension UInt8:DataConvertible{}

extension UInt16:DataConvertible{
    public func toFitBytes(bytesSize:Int) -> [UInt8] {
        let UmaxValue = UInt16(2^(bytesSize*8)-1)
        let value = self
        precondition(value <= UmaxValue,"UInt16 param is out of data range")
        
        let size = self.size
        var bytesArray = [UInt8](repeating: 0, count: bytesSize)
        
        (self.data as NSData).getBytes(&bytesArray, length: ((bytesSize >= size) ? size : bytesSize))
        return bytesArray
    }
}

extension UInt32:DataConvertible{
    public func toFitBytes(bytesSize:Int) -> [UInt8] {
        let UmaxValue = UInt32(2^(bytesSize*8)-1)
        let value = self
        precondition(value <= UmaxValue,"UInt32 param is out of data range")
        
        let size = self.size
        var bytesArray = [UInt8](repeating: 0, count: bytesSize)
        
        (self.data as NSData).getBytes(&bytesArray, length: ((bytesSize >= size) ? size : bytesSize))
        return bytesArray
    }
}

extension UInt64:DataConvertible{
    public func toFitBytes(bytesSize:Int) -> [UInt8] {
        let UmaxValue:UInt64 = UInt64(2^(bytesSize*8)-1)
        let value = self
        precondition(value <= UmaxValue,"UInt64 param is out of data range")
        
        let size = self.size
        var bytesArray = [UInt8](repeating: 0, count: bytesSize)
        
        (self.data as NSData).getBytes(&bytesArray, length: ((bytesSize >= size) ? size : bytesSize))
        return bytesArray
    }
}

extension Float:DataConvertible{
    mutating public func toFitBytes(bytesSize:Int) -> [UInt8] {
        let UmaxValue:Float = Float(2^(bytesSize*8)-1)
        let minValue = -(2^((bytesSize-1)*8))+1
        let value = self
        if value > 0 {
            precondition(value <= UmaxValue,"Float param is out of data range")
        }
        else {
            precondition(Int(value) >= minValue,"Float param is out of data range")
        }
        
        let size = self.size
        var bytesArray = [UInt8](repeating: 0, count: bytesSize)
        
        (self.data as NSData).getBytes(&bytesArray, length: ((bytesSize >= size) ? size : bytesSize))
        return bytesArray
    }
}

extension Double:DataConvertible {}

extension Bool:DataConvertible {}

extension String:DataConvertible {
    public init?(_ data:Data) {
        self.init(data: data, encoding: .utf8)
    }
    
    public var data:Data {
        return self.data(using: .utf8)!
    }
    
    public var size:Int {
        return self.characters.count
    }
    
    public func toFitBytes(bytesSize:Int) -> [UInt8] {
        precondition(bytesSize <= self.size,"String out of range")
        let strUTF8 = self.utf8
        let bytesArray = [UInt8](strUTF8)
        return bytesArray
    }
}

/*
 public extension Array where Element:Mappable {
 
 public init?(_ dataVale:Data) {
 //        if let obj: [Element] = Mapper().toMapObjectArray(data: dataVale){
 //            self = obj
 //        }else {
 //            return nil
 //        }
 return nil
 }
 
 public func toData()->Data {
 return Mapper().toData(arrayObj: self)
 }
 
 }*/
