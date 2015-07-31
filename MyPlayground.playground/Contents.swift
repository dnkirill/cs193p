//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

var ints = [Int]()
ints.append(4)

ints.append(6)
var someVals = [Int](count: 3, repeatedValue: 0)

ints + someVals

var list = ["Eggs", "Test"]

for (i,v) in enumerate(list) {
    println("Item N\(i), value \(v)")
}


enum CompassPoint: Int {
    case North = 0
    case South
    case West
    case East
}

var direction = CompassPoint.North

direction = .South


enum Barcode {
    case UPCA(Int, Int, Int, Int)
    case QRCode(String)
    case MathCode
}

var productCode = Barcode.UPCA(10, 20, 30, 40)
var mathCode = Barcode.MathCode



let point = CompassPoint(rawValue: 2)
point

final class Location {
    var latitude: Double
    var longitude: Double {
        willSet(newLongitude) {
            println("New Longitude = \(newLongitude)")
            latitude += 10
        }
        didSet {
            longitude = oldValue
        }
    }
    
    init() {
        (latitude, longitude) = (0.0, 0.0)
    }
}

var loc = Location()
loc.latitude = 5.0
loc.longitude = 110



struct Resolution {
    var width = 0
    var height = 0
    static var ppi = 300
}

var res = Resolution()

res.width = 500

Resolution.ppi = 600

var cinema = res

res.width = 100

res
cinema

var testArray = [Int]()

testArray.append(5)
testArray

var copiedArray = testArray
testArray.append(10)
copiedArray




