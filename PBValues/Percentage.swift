//
//  Percentage.swift
//  PBValues
//
//  Created by Andrew Tillman on 8/12/15.
//  Copyright (c) 2015 Parity Bits. All rights reserved.
//

import Foundation

public struct Percentage {
    
    public static let Zero = Percentage(numberValue: 0)
    public static let OneHundred = Percentage(numberValue: 1)
    
    public let percentValue:NSDecimal
    public var decimalNumber:NSDecimalNumber {
        get {
            return NSDecimalNumber(decimal: percentValue)
        }
    }
    
    init(percentValue:NSDecimal) {
        self.percentValue = percentValue
    }
    
    public init(numberValue:NSNumber) {
        self.percentValue = numberValue.decimalValue
    }
    
    
}

extension Percentage : Printable {
    
    public var description: String {
        get {
            let formatter = NSNumberFormatter()
            formatter.numberStyle = .PercentStyle
            return formatter.stringFromNumber(decimalNumber)!
        }
    }
    
}

extension Percentage : Comparable {}

//Equatable
public func ==(lhs:Percentage, rhs:Percentage) -> Bool {
    return compare(lhs, rhs) == .OrderedSame
}

//Comparable
public func <(lhs:Percentage, rhs:Percentage) -> Bool {
    return compare(lhs, rhs) == .OrderedAscending
}

private func compare(lhs:Percentage, rhs:Percentage) -> NSComparisonResult {
    var lhsd = lhs.percentValue
    var rhsd = rhs.percentValue
    return NSDecimalCompare(&lhsd, &rhsd)
}

//Arithmatic operations

private typealias PBDecimalOperation = ( result: UnsafeMutablePointer<NSDecimal>, lhs: UnsafePointer<NSDecimal>, rhs: UnsafePointer<NSDecimal>, roundingMode: NSRoundingMode) -> NSCalculationError

private func PBAddPercent( result: UnsafeMutablePointer<NSDecimal>, lhs: UnsafePointer<NSDecimal>, rhs: UnsafePointer<NSDecimal>, roundingMode: NSRoundingMode) -> NSCalculationError {
    var tempResult = NSDecimal()
    
    var error = NSDecimalMultiply(&tempResult, lhs, rhs, roundingMode)
    if error == NSCalculationError.NoError {
        return NSDecimalAdd(result, lhs, &tempResult, roundingMode)
    } else {
        return error
    }
}

private func PBSubtractPercent( result: UnsafeMutablePointer<NSDecimal>, lhs: UnsafePointer<NSDecimal>, rhs: UnsafePointer<NSDecimal>, roundingMode: NSRoundingMode) -> NSCalculationError {
    var tempResult = NSDecimal()
    
    var error = NSDecimalMultiply(&tempResult, lhs, rhs, roundingMode)
    if error == NSCalculationError.NoError {
        return NSDecimalSubtract(result, lhs, &tempResult, roundingMode)
    } else {
        return error
    }
}



//Percentage operations
public func +(lhs:Percentage, rhs:Percentage) -> Percentage {
    return operationToPercentage(lhs.percentValue, rhs.percentValue, NSDecimalAdd)
}

public func -(lhs:Percentage, rhs:Percentage) -> Percentage {
    return operationToPercentage(lhs.percentValue, rhs.percentValue, NSDecimalSubtract)
}

public func *(lhs:Percentage, rhs:NSNumber) -> Percentage {
    return operationToPercentage(lhs.percentValue, rhs.decimalValue, NSDecimalMultiply)
}

public func /(lhs:Percentage, rhs:NSNumber) -> Percentage {
    return operationToPercentage(lhs.percentValue, rhs.decimalValue, NSDecimalDivide)
}

//NSDecimal and NSNumber
public func *(lhs:NSNumber, rhs:Percentage) -> NSDecimal {
    return lhs.decimalValue * rhs
}

public func *(lhs:NSDecimal, rhs:Percentage) -> NSDecimal {
    return operationToDecimal(lhs, rhs.percentValue, NSDecimalMultiply)
}

public func /(lhs:NSNumber, rhs:Percentage) -> NSDecimal {
    return lhs.decimalValue / rhs
}

public func /(lhs:NSDecimal, rhs:Percentage) -> NSDecimal {
    return operationToDecimal(lhs, rhs.percentValue, NSDecimalDivide)
}

public func +(lhs:NSNumber, rhs:Percentage) -> NSDecimal {
    return lhs.decimalValue + rhs
}

public func +(lhs:NSDecimal, rhs:Percentage) -> NSDecimal {
    return operationToDecimal(lhs, rhs.percentValue, PBAddPercent)
}

public func -(lhs:NSNumber, rhs:Percentage) -> NSDecimal {
    return lhs.decimalValue - rhs
}

public func -(lhs:NSDecimal, rhs:Percentage) -> NSDecimal {
    return operationToDecimal(lhs, rhs.percentValue, PBSubtractPercent)
}


//Operator function
private func operationToPercentage(lhs:NSDecimal, rhs:NSDecimal, operation:PBDecimalOperation) -> Percentage {
    return Percentage(percentValue: operationToDecimal(lhs, rhs, operation))
}

private func operationToDecimal(lhs:NSDecimal, rhs:NSDecimal, operation:PBDecimalOperation) -> NSDecimal {
    var lhsd = lhs
    var rhsd = rhs
    var result:NSDecimal = NSDecimal()
    
    var error = operation(result:&result, lhs:&lhsd, rhs:&rhsd, roundingMode:NSRoundingMode.RoundBankers)
    return result
}

