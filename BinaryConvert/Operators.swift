//
//  Operators.swift
//  BinaryConvert
//
//  Created by huayan on 16/12/6.
//  Copyright © 2016年 huayan. All rights reserved.
//

import Foundation


infix operator <->

public func <-> <T:DataConvertible>(left: inout T?, right: Map) {
    switch right.mappingType {
    case .FromData:
        left = right.value() ?? T()
    case .ToData:
        if let field = left {
            right.toDataValue(value: field)
        }
    default:
        print("default")
    }
}

public func <-><T:DataConvertible>(left:inout [T]?, right: Map) {
    switch right.mappingType {
    case .FromData:
        left = right.valueArray()
    case .ToData:
        if left != nil {
            right.toArrayValue(arrayValue: left!)
        }
    default:
        print("default")
    }
}

public func <-> <T:Convertable>(left: inout T?, right: Map) {
    switch right.mappingType {
    case .FromData:
        left = right.valueMap()
    case .ToData:
        if let field = left {
            right.toDataMapValue(value: field)
        }
    case .CountConvertable:
        var tmp = T()
        right.setSubConvertableSizeToTotal(size: tmp.bitssize())
    default:
        print("default")
    }
    
}

public func <-><T:Convertable>(left:inout [T]?, right: Map) {
    switch right.mappingType {
    case .FromData:
        left = right.valueArrayMap()
    case .ToData:
        if let field = left {
            right.toDataMapArrayValue(mapArrayValue: field)
        }
    
    default:
        print("default")
    }
}


public func <-> <T:DataConvertible>(left: inout T!, right: Map) {
    switch right.mappingType {
    case .FromData:
        left = right.value() ?? T()
    case .ToData:
        right.toDataValue(value: left)
    default:
        print("default")
    }
}

public func <-><T:DataConvertible>(left:inout [T]!, right: Map) {
    switch right.mappingType {
    case .FromData:
        left = right.valueArray()
    case .ToData:
        right.toArrayValue(arrayValue: left)
    default:
        print("default")
    }
}


public func <-> <T:Convertable>(left: inout T!, right: Map) {
    switch right.mappingType {
    case .FromData:
        left = right.valueMap()
    case .ToData:
        right.toDataMapValue(value: left)
    case .CountConvertable:
        var tmp = T()
        right.setSubConvertableSizeToTotal(size: tmp.bitssize())
    default:
        print("default")
    }
    
}

public func <-><T:Convertable>(left:inout [T]!, right: Map) {
    switch right.mappingType {
    case .FromData:
        left = right.valueArrayMap()
    case .ToData:
        right.toDataMapArrayValue(mapArrayValue: left)
    default:
        print("default")
    }
}


public func <-> <T:DataConvertible>(left: inout T, right: Map) {
    switch right.mappingType {
    case .FromData:
        left = right.value() ?? T()
    case .ToData:
        right.toDataValue(value: left)
    default:
        print("default")
    }
}

public func <-><T:DataConvertible>(left:inout [T], right: Map) {
    switch right.mappingType {
    case .FromData:
        left = right.valueArray()
    case .ToData:
        right.toArrayValue(arrayValue: left)
    default:
        print("default")
    }
}

public func <-> <T:Convertable>(left: inout T, right: Map) {
    switch right.mappingType {
    case .FromData:
        left = right.valueMap()!
    case .ToData:
        right.toDataMapValue(value: left)
    case .CountConvertable:
        var tmp = T()
        right.setSubConvertableSizeToTotal(size: tmp.bitssize())
    default:
        print("default")
    }
    
}

public func <-><T:Convertable>(left:inout [T], right: Map) {
    switch right.mappingType {
    case .FromData:
        left = right.valueArrayMap()!
    case .ToData:
        right.toDataMapArrayValue(mapArrayValue: left)
    default:
        print("default")
    }
}

