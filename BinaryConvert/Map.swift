//
//  Map.swift
//  BinaryConvert
//
//  Created by huayan on 16/11/3.
//  Copyright © 2016年 huayan. All rights reserved.
//

import Foundation

public final class Map {
    
    public var nIndex = 0   // data array size index
    public var nCurrentSizeCount = 0 // bits size index
    public var nTotalMapSize = 0 // total map size
    
    public var dataValue:Data = Data() // all data value
    public var mappingType:MappingType = .DefaultVlue // convert type
    public var currentValue:Data = Data() // sub data of one parament

    public var nSingleSize = 0 // array single bits size
    
    public init(){
        self.mappingType = .ToData
    }
    
    public init(_ value:Data){
        self.mappingType = .FromData
        self.dataValue = value
    }
    
    public init(blCountConvertable:Bool){
        self.mappingType = .CountConvertable
    }
    
    public subscript(nBitCount:Int)->Map{
        let nCount = nBitCount
        // Convertable type
        if nBitCount > 0 {
            // to set array type is no
            nSingleSize = 0
            if self.mappingType == .CountConvertable {
                nTotalMapSize += nCount
            }
            else {
                nCurrentSizeCount = nCount
                nSingleSize = nCount
                if nIndex+nCount <= dataValue.count*ByteSize && self.mappingType == .FromData{
                    currentValue = Data(bytes: dataValue.subbits(nIndex, nCount))
                }
                nIndex += nCount
            }
        }
        
        return self
    }
    
    public subscript(single:Int, total:Int)->Map{
        // Convertable array type
        let nSingle = single
        let nTotal = total
        
        if self.mappingType == .CountConvertable {
            nTotalMapSize += nTotal
        }
        else {
            nCurrentSizeCount = nTotal
            nSingleSize = nSingle
            if self.mappingType == .FromData {
                precondition(nIndex+nTotal <= dataValue.count*ByteSize,"From data index is out range")
                currentValue = Data(bytes: dataValue.subbits(nIndex, nTotal))
            }
            nIndex += nTotal
        }
        
        return self
    }
    
    public func setSubConvertableSizeToTotal(size:Int) {
        nSingleSize = size
        nTotalMapSize += size
        nIndex += nSingleSize
    }
    
    public func getConvertableSize()->Int{
        return nTotalMapSize
    }
    
    // convert 1:basic type
    // data convert to basic type
    public func value<T:DataConvertible>()->T? {
        return T(self.currentValue)
    }
    // basic type convert to data
    public func toDataValue<T:DataConvertible>(value:T) {
/*        let byteArray = value.toFitBytesByBitSize(bitSize: nCurrentSizeCount)
        dataValue.append(byteArray, count:byteArray.count)*/
        var arrayBytes = dataValue.bytes()
        _ = setBitForByte(bitLen: nCurrentSizeCount, toBytes: &arrayBytes, fromBytes: value.bytes(), toBitStart: nIndex-nSingleSize, fromBitStart: 0)
        dataValue.removeAll()
        dataValue.append(arrayBytes, count: arrayBytes.count)
    }

    // convert 2: Map type
    // data convert to Map type
    public func valueMap<T:Convertable>()->T? {
        var temp = T()
        let size = temp.bitssize()
        precondition(nIndex+size <= dataValue.count*ByteSize,"Convertable Byte(s) set out of range")
        
        nCurrentSizeCount = size
        currentValue = Data(bytes: dataValue.subbits(nIndex, size))
        nIndex += size
        
        return BinaryConvert().toMapObject(data: currentValue)
    }
    // Map type convert to data
    public func toDataMapValue<T:Convertable>(value:T) {
        let fromArray = BinaryConvert().toData(object: value).bytes()
        var arrayBytes = dataValue.bytes()
        var temp = T()
        let size = temp.bitssize()
        nCurrentSizeCount = size
        _ = setBitForByte(bitLen: nCurrentSizeCount, toBytes: &arrayBytes, fromBytes: fromArray, toBitStart: nIndex, fromBitStart: 0)
        nIndex += size
        
        dataValue.removeAll()
        dataValue.append(arrayBytes, count: arrayBytes.count)
       // dataValue.append(BinaryConvert().toData(object: value))
    }
    
    // convert 3: Map array type
    // data convert to map array type
    public func valueArrayMap<T:Convertable>()-> [T]? {
        var temp = T()
        let size = temp.bitssize()
        precondition((currentValue.count*ByteSize)%size == 0,"Convertable Byte(s) set out of range")
        
        return BinaryConvert().toMapObjectArray(data: currentValue)
    }
    // map array type convert to data
    public func toDataMapArrayValue<T:Convertable>(mapArrayValue:[T]) {
        var temp = T()
        let size = temp.bitssize()
        
        let remainder = nCurrentSizeCount%size
        precondition(remainder == 0 ,"Convertable array total size and single size is not match")
        
        let mapData = BinaryConvert().toData(arrayObj:mapArrayValue)
       /* for (index,item) in mapArrayValue.enumerated() {
            let fromArray = BinaryConvert().toData(object: item).bytes()
            
            _ = setBitForByte(bitLen: nSingleSize, toBytes: &arrayBytes, fromBytes: fromArray, toBitStart: nIndex+index*size, fromBitStart: 0)
          //  dataValue.append(BinaryConvert().toData(object: item))
        }*/
        dataValue.append(mapData)
    }
    
    // convert 4: basic array type
    // data convert to basic array type
    public func valueArray<T:DataConvertible>()->[T] {
        precondition(nSingleSize > 0 ,"Array have to two arguments, single and toal")
        let remainder = nCurrentSizeCount%nSingleSize
        precondition(remainder == 0 ,"Array total size and single size is not match")
        let nCount = nCurrentSizeCount/nSingleSize
        var ret = [T]()
        for index in 0..<nCount {
            ret.append(T(Data(currentValue.subbits(index*nSingleSize, nSingleSize)))!)
        }
        return ret
    }
    // basic array type convert to data
    public func toArrayValue<T:DataConvertible>(arrayValue:[T]) {
        precondition(nSingleSize > 0 ,"Array have to two arguments, single and toal")
        let remainder = nCurrentSizeCount%nSingleSize
        precondition(remainder == 0 ,"Array total size and single size is not match")
        var arrayBytes = dataValue.bytes()

        for (index,item) in arrayValue.enumerated() {
            let byteArray = item.toFitBytesByBitSize(bitSize: nSingleSize)
            _ = setBitForByte(bitLen: nSingleSize, toBytes: &arrayBytes, fromBytes: byteArray, toBitStart: nIndex+index*item.size*ByteSize-nCurrentSizeCount, fromBitStart: 0)
            //dataValue.append(byteArray, count:byteArray.count)
        }
        dataValue.removeAll()
        dataValue.append(arrayBytes, count: arrayBytes.count)
    }

}
