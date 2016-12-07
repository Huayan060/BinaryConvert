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
    public var nCurrentSizeCount = 0 // byte size index
    public var nTotalMapSize = 0 // total map size
    
    public var dataValue:Data = Data() // all data value
    public var mappingType:MappingType = .DefaultVlue // convert type
    public var currentValue:Data = Data() // sub data of one parament

    public var nSingleSize = 0 // array single size
    
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
    
    public subscript(nByteCount:Int)->Map{
        let nCount = nByteCount
        // Convertable type
        if nByteCount > 0 {
            // to set array type is no
            nSingleSize = 0
            if self.mappingType == .CountConvertable {
                nTotalMapSize += nCount
            }
            else {
                nCurrentSizeCount = nCount
                
                if nIndex+nCount <= dataValue.count {
                    currentValue = dataValue.subdata(in: Range(nIndex..<nIndex+nCount))
                    nIndex += nCount
                }
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
            if nIndex+nTotal <= dataValue.count {
                currentValue = dataValue.subdata(in: Range(nIndex..<nIndex+nTotal))
                nIndex += nTotal
            }
        }
        
        return self
    }
    
    public func setSubConvertableSizeToTotal(size:Int) {
        nTotalMapSize += size
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
        let byteArray = value.toFitBytes(bytesSize: nCurrentSizeCount)
        dataValue.append(byteArray, count:byteArray.count)
    }

    // convert 2: Map type
    // data convert to Map type
    public func valueMap<T:Convertable>()->T? {
        var temp = T()
        let size = temp.size()
        precondition(nIndex+size <= dataValue.count,"Convertable Byte(s) set out of range")
        
        nCurrentSizeCount = size
        currentValue = dataValue.subdata(in: Range(nIndex..<nIndex+size))
        nIndex += size
        
        return BinaryConvert().toMapObject(data: currentValue)
    }
    // Map type convert to data
    public func toDataMapValue<T:Convertable>(value:T) {
        
        dataValue.append(BinaryConvert().toData(object: value))
    }
    
    // convert 3: Map array type
    // data convert to map array type
    public func valueArrayMap<T:Convertable>()-> [T]? {
        var temp = T()
        let size = temp.size()
        precondition(currentValue.count%size == 0,"Convertable Byte(s) set out of range")
        
        return BinaryConvert().toMapObjectArray(data: currentValue)
    }
    // map array type convert to data
    public func toDataMapArrayValue<T:Convertable>(mapArrayValue:[T]) {
            
        for item in mapArrayValue {
            dataValue.append(BinaryConvert().toData(object: item))
        }
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
            ret.append(T(currentValue.subdata(in: Range(index*nSingleSize..<(index+1)*nSingleSize)))!)
        }
        return ret
    }
    // basic array type convert to data
    public func toArrayValue<T:DataConvertible>(arrayValue:[T]) {
        precondition(nSingleSize > 0 ,"Array have to two arguments, single and toal")
        let remainder = nCurrentSizeCount%nSingleSize
        precondition(remainder == 0 ,"Array total size and single size is not match")

        for item in arrayValue {
            let byteArray = item.toFitBytes(bytesSize: nSingleSize)
            dataValue.append(byteArray, count:byteArray.count)
        }
        
    }

}
