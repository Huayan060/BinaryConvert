//
//  BinaryConvertTests.swift
//  BinaryConvertTests
//
//  Created by huayan on 16/12/6.
//  Copyright © 2016年 huayan. All rights reserved.
//

import XCTest
@testable import BinaryConvert

class BinaryConvertTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.       
        
        let a:Int = 1
        let b :Double = 1//Double(bigEndian:2.0)
        let c = "1234"
        let d :Float = 1.0//Float(bigEndian:2.0)
        let e:Int = 2
        let f = true
        
        var data = Data()
        data.append(a.data)
        data.append(b.data)
        data.append(c.data)
        data.append(d.data)
        data.append(a.data)
        data.append(a.data)
        data.append(a.data)
        data.append(e.data)
        data.append(e.data)
        data.append(e.data)
        data.append(f.data)
        
        print("data:", data)
        for item in f.bytes() {
            for x in 0..<8{
                print(item.subbit(x))
            }
        }
        
        var bytesLength = data.count
        var bytesArray  = [UInt8](repeating: 0, count: bytesLength)
        data.copyBytes(to: &bytesArray, count: bytesLength)
        for item in bytesArray {
            print(UInt8(item))
        }
        
        print("aa:",a.subbit(0))
        var tmp = a.bytes()
        _=setBitForByte(bitLen: 64, toBytes: &tmp, fromBytes: e.bytes(), toBitStart: 0, fromBitStart: 0)
        print(Int(Data(bytes:tmp)))
        
        let dataT = BinaryConvert<test>().toMapObject(data: data)
        print("parm1:", dataT?.parm1)
        print("parm2:", dataT?.parm2)
        print("parm3:", dataT?.parm3)
        print("parm4:", dataT?.parm4)
        dataT?.parm5?.printFunc()
        
        for item in (dataT?.parm6)! {
            print("parm6:", item)
        }
        
        for item in (dataT?.parm7)! {
            item.printFunc()
        }
        print("parm8:", dataT?.parm8)
        print("dataAll:", dataT)
        let dataAll = BinaryConvert<test>().toData(object: dataT!)
        print("dataAll size:", dataAll)
        
        bytesLength = dataAll.count
        bytesArray  = [UInt8](repeating: 0, count: bytesLength)
        data.copyBytes(to: &bytesArray, count: bytesLength)
      //  (data as NSData).getBytes(&bytesArray, length: bytesLength)
        for item in bytesArray {
            print(UInt8(item))
        }

        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}

class subTest : Convertable {
    var parm1 : Int?
    
    required init?(_ map: Map) {
        
    }
    
    required init(){}
    
    func mapping(_ map: Map) {
        parm1 <-> map[8*8]
    }
    
    public func printFunc() {
        print("data:",parm1)
    }
}

class test : Convertable {
    var parm1 : Int?
    var parm2 : Double?
    var parm3 : String?
    var parm4 : Float?
    var parm5 : subTest?
    var parm6 : [Int]?
    var parm7 : [subTest]?
    var parm8 : Bool?
    
    required init?(_ map: Map) {
        
    }
    
    required init(){}
    
    func mapping(_ map: Map) {
        parm1 <-> map[8*8]
        parm2 <-> map[8*8]
        parm3 <-> map[4*8]
        parm4 <-> map[4*8]
        parm5 <-> map           // Convertable, not need to write total size or you can write as parm5 <-> map[0], set param to 0
        parm6 <-> map[8*8,16*8] // basic type array
        parm7 <-> map[0,24*8]   // Convertable type array, fisrt param should set 0
        parm8 <-> map[4]
        
    }
}

