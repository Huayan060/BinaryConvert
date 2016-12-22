//
//  BinaryConvert.swift
//  BinaryConvert
//
//  Created by huayan on 16/12/6.
//  Copyright © 2016年 huayan. All rights reserved.
//

import Foundation

public enum MappingType {
    case FromData
    case ToData
    case CountConvertable
    case DefaultVlue
}

public final class BinaryConvert<T:Convertable> {
    
    public init(){
    }
    
    public func toData(object:T)->Data {
        var objectValue = object
        let map = Map()
        objectValue.mapping(map)
        return map.dataValue
    }
    
    public func toData(arrayObj:[T])->Data {
        var retData = Data()
        let arrayData = arrayObj.map {
            self.toData(object: $0)
        }
        
        for item in arrayData {
            retData.append(item)
        }
        
        return retData
    }
    
    public func toMapObject(data:Data)->T? {
        let map = Map(data)
        
        if var object = T.self.objectForMapping(map) as? T {
            object.mapping(map)
            return object
        }
        
        if var object = T(map) {
            object.mapping(map)
            return object
        }
        
        return nil
    }
    
    public func toMapObjectArray(data:Data)->[T] {
        var object = T()
        let nMapSize = object.bitssize()
        var retArray=[T]()
        
        if (data.count*ByteSize)%nMapSize == 0 {
            let nCount = (data.count*ByteSize)/nMapSize
            
            for index in 0..<nCount {
                
                let subData = Data(data.subbits(index*nMapSize, nMapSize))
                if let mapObj = BinaryConvert().toMapObject(data: subData) {
                    retArray.append(mapObj)
                }
                
            }
        }
        
        return retArray
    }
}
