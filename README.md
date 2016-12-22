# BinaryConvert

BinaryConvert project is used swift3, so you need to use this by XCode 8 and up version.

## Support:
It can convert Data to some other type, we support types as follow:
- 1.Int
- 2.UInt
- 3.UInt8
- 4.UInt16
- 5.UInt32
- 6.UInt64
- 7.Float
- 8.Double
- 9.Bool
- 10.Data
- 11.String
- 12.Mappable
- 13.Array(base type)
- 14.Array(Mappable)

Attention: Index 1-10 is base type

### Simple example:
```swift
import BinaryConvert
// define 
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

// Create Data
let a = 1 // Int
let b :Double = 2.0 // Double
let c = "test" // String
let d :Float = 1.0 //Float
let e = 2 // Int
let f = true // Bool
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

//Data convert to Object
let dataT = BinaryConvert<test>().toMapObject(data: data)

// Object convert to data
let dataAll = BinaryConvert<test>().toData(object: dataT!)
```

## Defects:
- 1.String type only support UTF8 decode and encode
- 2.String array type not support
- 3.Dictionay type not support
