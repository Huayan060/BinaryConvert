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
        
        /*       let value:[Int] = [1,2,3,4]
         //var value1 :Double = 1.0
         //var data = value.data
         let data = value.data(using: String.Encoding.utf8)
         //let data = value.data(using: String.Encoding.utf8)
         let bytesLength = data.count
         var bytesArray  = [UInt8](repeating: 0, count: bytesLength)
         (data as NSData).getBytes(&bytesArray, length: bytesLength)
         for item in bytesArray {
         print(UInt8(item))
         }
         print(bytesArray)
         
         //        var bytesArray1:[UInt8]=[UInt8]()
         //        bytesArray1.append(bytesArray[4])
         //        bytesArray1.append(bytesArray[5])
         //        bytesArray1.append(bytesArray[6])
         //        bytesArray1.append(bytesArray[7])
         //        let test = Data(bytes:bytesArray1)
         //
         //        print(Int(test))*/
        
        
        let a = 1
        let b :Double = 2.0
        let c = "test"
        let d :Float = 1.0
        let e = 2
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
        data.append(f.data)
        
        print("dataT:", data)
        
        var bytesLength = data.count
        var bytesArray  = [UInt8](repeating: 0, count: bytesLength)
        (data as NSData).getBytes(&bytesArray, length: bytesLength)
        for item in bytesArray {
            print(UInt8(item))
        }
        
        print(a.size)
        print(b.size)
        print(c.size)
        print(d.size)
        
        let dataT = BinaryConvert<test>().toMapObject(data: data)
        print("dataT:", dataT?.parm1)
        print("dataT:", dataT?.parm2)
        print("dataT:", dataT?.parm3)
        print("dataT:", dataT?.parm4)
        dataT?.parm5?.printFunc()
        
        for item in (dataT?.parm6)! {
            print("dataT:", item)
        }
        
        for item in (dataT?.parm7)! {
            item.printFunc()
        }
        print("dataT:", dataT?.parm8)
        
        let dataAll = BinaryConvert<test>().toData(object: dataT!)
        print("dataAll:", dataAll)
        
        bytesLength = dataAll.count
        bytesArray  = [UInt8](repeating: 0, count: bytesLength)
        (data as NSData).getBytes(&bytesArray, length: bytesLength)
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
        parm1 <-> map[8]
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
        parm1 <-> map[8]
        parm2 <-> map[8]
        parm3 <-> map[4]
        parm4 <-> map[4]
        parm5 <-> map       // Convertable, not need to write total size or you can write as parm5 <-> map[0], set param to 0
        parm6 <-> map[8,16] // basic type array
        parm7 <-> map[0,16] // Convertable type array, fisrt param should set 0 or you can write as parm7 <-> map[16], not set first param
        parm8 <-> map[1]
        
    }
}

