//
//  Convertable.swift
//  BinaryConvert
//
//  Created by huayan on 16/12/6.
//  Copyright © 2016年 huayan. All rights reserved.
//

import Foundation

public protocol Convertable {
    init()
    
    init?(_ map:Map)
    
    mutating func mapping(_ map:Map)
    
    static func objectForMapping(_ map:Map)->Convertable?
    
    mutating func bitssize() -> Int
}

public extension Convertable {
    
    public static func objectForMapping(_ map:Map)->Convertable? {
        return nil
    }
    
    // Initializes object from a Data param
    //    public init?(_ dataVale:Data) {
    //        if let obj: Self = Convertable().toMapObject(data: dataVale){
    //            self = obj
    //        }else {
    //            return nil
    //        }
    //    }
    
    public func toData()->Data {
        return BinaryConvert().toData(object: self)
    }
    
    public mutating func bitssize()->Int {
        var nSize = 0
        
        let map = Map(blCountConvertable:true)
        self.mapping(map)
        nSize = map.getConvertableSize()
        
        return nSize
    }
}




