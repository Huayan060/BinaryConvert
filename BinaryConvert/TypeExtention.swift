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

public let ByteSize = 8
public let nativeByteOrder:ByteOrder = nativeOrder()

public enum ByteOrder {
    case bigEndian
    case littleEndian
}

public func nativeOrder()-> ByteOrder{
    let intValue:Int = 1
    
    let byteArray = [UInt8](intValue.data)
    
    if byteArray[0] == 0 {
        return ByteOrder.bigEndian
    }
    return ByteOrder.littleEndian
}


public func mypower(_ radix:Int,_ powerValue:Int) -> Double{
    let myRadix = Decimal(radix)
    let myPowvalue = pow(myRadix, powerValue)
    let result = NSDecimalNumber(decimal: myPowvalue)
    return result.doubleValue
}

public func BytesToString(_ bytes: [UInt8])->String {
    return String(bytes: bytes, encoding: String.Encoding.utf8)!
}

public func BytesToValue<T>(_ bytes: [UInt8], _: T.Type) -> T {
    return bytes.withUnsafeBufferPointer {
        $0.baseAddress!.withMemoryRebound(to: T.self, capacity: 1) {
            $0.pointee
        }
    }
}

public func SetBitValue(byte:inout UInt8,nPos:Int,nValue:Int) -> Bool {
    if nValue == 1 {
        byte = UInt8(Int(byte) | 1 << nPos)
    }
    else if nValue == 0 {
        byte = UInt8(Int(byte) & ~(1<<nPos))
    }
    else {
        return false
    }
    return true
}

public func setBitForByte(bitLen:Int, toBytes:inout [UInt8], fromBytes:[UInt8], toBitStart:Int = 0, fromBitStart:Int = 0)->Bool{
/*    let byteStart = toBitStart/ByteSize
    var bitStart = toBitStart%ByteSize
    
    var fromBitStart = fromBitStart%ByteSize
    let fromByteStart = fromBitStart/ByteSize
    
    let byteCount = bitLen/ByteSize + (bitLen%ByteSize==0 ? 0 : 1)*/
   // precondition(fromBytes.count*ByteSize-fromBitStart>=bitLen,"setBitForByte:fromBytes byte(s) set out of range")
    
    for bitIndex in 0..<bitLen {
        if toBytes.count*ByteSize <= bitIndex+toBitStart {
            
            let tmp:UInt8 = 0
            toBytes.insert(tmp, at: toBytes.count)
        }
        
        let toByteIndex = (bitIndex+toBitStart)/ByteSize
        let toBitPosition = 7-(bitIndex+toBitStart)%ByteSize
        
        let fromByteIndex = (bitIndex+fromBitStart)/ByteSize
        let fromBitPosition = (bitIndex+fromBitStart)%ByteSize
        
        let value = fromBytes.count * ByteSize > bitIndex + fromBitStart ? fromBytes[fromByteIndex].subbit(fromBitPosition) : 0
        
        _ = SetBitValue(byte: &toBytes[toByteIndex], nPos: toBitPosition, nValue: value)
    }
    
 /*   for byteIndex in 0..<byteCount {
        
        if byteIndex+byteStart >= toBytes.count {
            let tmp:UInt8 = 0
            toBytes.insert(tmp, at: byteIndex+byteStart)
        }
        
        var bytevalue = toBytes[byteIndex+byteStart]
        print("start",bytevalue)
        
        
        for bitIndex in 0..<ByteSize {
            let bitPosition = 7-bitIndex % ByteSize+bitStart
            let fromBitPosition = (fromBitStart == 0 ? fromBitStart:(7-bitIndex % ByteSize))
            bytevalue = SetBitValue(byte: bytevalue, nPos: (7-bitPosition), nValue: fromBytes[fromByteStart+byteIndex].subbit(fromBitPosition))
        }
        bitStart = 0
        fromBitStart = 0
        toBytes[byteIndex+byteStart] = bytevalue
    }*/
    
    return true
}

public protocol DataConvertible {
    // init function
    init()
    init?(_ data:Data)
    
    // sub data
    var data:Data {get}
    var size:Int {get}
    //var bytes:[UInt8] {get}
    
    // function
    func bytes(byteOrder: ByteOrder)->[UInt8]
    func subbyte(_ position: Int) -> Int
    func subbytes(_ start: Int, _ length: Int) -> [UInt8]
    
    func subbit(_ position: Int) -> Int
    func subbits(_ start: Int, _ length: Int) -> [UInt8]
    
 //   func toFitBytes(bytesSize:Int) -> [UInt8]
    func toFitBytesByBitSize(bitSize:Int) -> [UInt8]
    func toFitBits(bitSize:Int) -> Int
}

public extension DataConvertible {

    init(){ self.init() }
    
    init?(_ data:Data) {
        precondition(data.count/ByteSize <= MemoryLayout<Self>.stride,"Byte(s) set out of range")
        self = data.withUnsafeBytes { $0.pointee }
    }
    
    var data:Data {
        var value = self
        return Data(buffer: UnsafeBufferPointer(start: &value, count: 1))
    }
    
    var size:Int {
        return MemoryLayout<Self>.stride
    }
    
/*    var bytes:[UInt8] {
        let valueByteArray = [UInt8](self.data)
        
       // let a = (ByteOrder.nativeByteOrder == .littleEndian) ? valueByteArray : valueByteArray.reversed()
        return valueByteArray
    }*/
    
    func bytes(byteOrder: ByteOrder = nativeByteOrder) -> [UInt8] {
        let valueByteArray = [UInt8](self.data)
        
        return (byteOrder == ByteOrder.littleEndian) ? valueByteArray : valueByteArray.reversed()
    }
    
    
    func subbyte(_ position: Int) -> Int {
        return Int(self.bytes()[position])
    }
    
    func subbytes(_ start: Int, _ length: Int) -> [UInt8] {
        return Array(self.bytes()[start..<start+length])
    }
    
    func subbit(_ position: Int) -> Int {
        
        var bytePosition    = 0
        
        bytePosition = position/ByteSize
        
        let bitPosition     = 7 - (position % ByteSize)
        let byte            = self.subbyte(bytePosition)
    
        return (byte >> bitPosition) & 0x01
    }
    
    func subbits(_ range: Range<Int>) -> Int {
        var positions = [Int]()
        
        for position in range.lowerBound..<range.upperBound {
            positions.append(position)
        }
        
        return positions.reversed().enumerated().reduce(0) {
            $0 + (self.subbit($1.element) << $1.offset)
        }
    }
    
    func subbits(_ start: Int, _ length: Int) -> [UInt8] {
        var retValue = [UInt8]()
        var subLen = ByteSize
        var remainLen = length
        var index = start
        
        while index < start+length {
            if subLen > remainLen {
                subLen = remainLen
            }
            let count = retValue.count
            retValue.insert(UInt8(self.subbits(index..<(index+subLen))), at: count)
            index += subLen
            remainLen -= subLen
        }
        
        return retValue
    }
    
    func toFitBytes(bytesSize:Int) -> [UInt8] {
        
        return [UInt8](self.data)
    }
    
    func toFitBits(bitSize:Int) -> Int {
        let condition = (self.bytes().count * ByteSize) >= bitSize
        precondition(condition,"Bit size param is out of data range")

        return self.subbits(0..<bitSize)
    }
    
    func toFitBytesByBitSize(bitSize:Int) -> [UInt8] {        
        return self.subbits(0, bitSize)
    }
}

extension Int:DataConvertible{
    public func toFitBytesByBitSize(bitSize:Int) -> [UInt8] {
        let bytesSize = bitSize/ByteSize + (bitSize%ByteSize==0 ? 0 : 1)
        let UmaxValue = mypower(2, bitSize)-1
        let minValue = -(mypower(2, (bitSize-1)))+1
        let value = Double(self)
        if value > 0 {
            precondition(value <= UmaxValue,"Int param is out of data range")
        }
        else {
            precondition(value >= minValue,"Int param is out of data range")
        }
        
        let size = self.size
        var bytesArray = [UInt8](repeating: 0, count: bytesSize)
        
        self.data.copyBytes(to: &bytesArray, count: ((bytesSize >= size) ? size : bytesSize))
        return bytesArray
    }
}

extension UInt:DataConvertible{
    public func toFitBytesByBitSize(bitSize:Int) -> [UInt8] {
        let bytesSize = bitSize/ByteSize + (bitSize%ByteSize==0 ? 0 : 1)
        let UmaxValue = mypower(2, bitSize)-1
        let value = Double(self)
        
        precondition(value <= UmaxValue,"UInt param is out of data range")
        
        let size = self.size
        var bytesArray = [UInt8](repeating: 0, count: bytesSize)
        
        self.data.copyBytes(to: &bytesArray, count: ((bytesSize >= size) ? size : bytesSize))
        return bytesArray
    }
}

extension UInt8:DataConvertible{}

extension UInt16:DataConvertible{
    public func toFitBytesByBitSize(bitSize:Int) -> [UInt8] {
        let bytesSize = bitSize/ByteSize + (bitSize%ByteSize==0 ? 0 : 1)
        let UmaxValue = mypower(2, bitSize)-1
        let value = Double(self)
        precondition(value <= UmaxValue,"UInt16 param is out of data range")
        
        let size = self.size
        var bytesArray = [UInt8](repeating: 0, count: bytesSize)
        
        self.data.copyBytes(to: &bytesArray, count: ((bytesSize >= size) ? size : bytesSize))
        return bytesArray
    }
}

extension UInt32:DataConvertible{
    public func toFitBytesByBitSize(bitSize:Int) -> [UInt8] {
        let bytesSize = bitSize/ByteSize + (bitSize%ByteSize==0 ? 0 : 1)
        let UmaxValue = mypower(2, bitSize)-1
        let value = Double(self)
        precondition(value <= UmaxValue,"UInt32 param is out of data range")
        
        let size = self.size
        var bytesArray = [UInt8](repeating: 0, count: bytesSize)
        
        self.data.copyBytes(to: &bytesArray, count: ((bytesSize >= size) ? size : bytesSize))
        return bytesArray
    }
}

extension UInt64:DataConvertible{
    public func toFitBytesByBitSize(bitSize:Int) -> [UInt8] {
        let bytesSize = bitSize/ByteSize + (bitSize%ByteSize==0 ? 0 : 1)
        let UmaxValue = mypower(2, bitSize)-1
        let value = Double(self)
        precondition(value <= UmaxValue,"UInt64 param is out of data range")
        
        let size = self.size
        var bytesArray = [UInt8](repeating: 0, count: bytesSize)
        
        self.data.copyBytes(to: &bytesArray, count: ((bytesSize >= size) ? size : bytesSize))
        return bytesArray
    }
}

extension Float:DataConvertible {}

extension Double:DataConvertible {}

extension Bool:DataConvertible {}

extension Data:DataConvertible {
    public init?(_ data:Data) {
        self = data
    }
    
    public var data:Data {
        return self
    }
    
    public var size:Int {
        return self.count
    }
    
    public func toFitBytesByBitSize(bitSize:Int) -> [UInt8] {
        let bytesSize = bitSize/ByteSize + (bitSize%ByteSize==0 ? 0 : 1)
        precondition(self.count <= bytesSize,"Float param is out of data range")
        
        let size = self.count
        var bytesArray = [UInt8](repeating: 0, count: bytesSize)
        
        self.data.copyBytes(to: &bytesArray, count:size)
        
        return bytesArray
    }
}

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
    
    public func toFitBytesByBitSize(bitSize:Int) -> [UInt8] {
        let bytesSize = bitSize/ByteSize
        
        precondition(bytesSize >= self.size && bitSize%ByteSize==0,"String out of range")
        var bytesArray = [UInt8](repeating: 0, count: bytesSize)
        
        self.data.copyBytes(to: &bytesArray, count: self.size)
        return bytesArray
    }
}
