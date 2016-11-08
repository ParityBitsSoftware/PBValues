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
    
    public let percentValue:Decimal
    public var decimalNumber:NSDecimalNumber {
        get {
            return NSDecimalNumber(decimal: percentValue)
        }
    }
    
    init(percentValue:Decimal) {
        self.percentValue = percentValue
    }
    
    public init(numberValue:NSNumber) {
        self.percentValue = numberValue.decimalValue
    }
    
    
}

extension Percentage : CustomStringConvertible {
    
    public var description: String {
        get {
            let formatter = NumberFormatter()
            formatter.numberStyle = .percent
            return formatter.string(from: decimalNumber)!
        }
    }
    
}

extension Percentage : Comparable {}

//Equatable
public func ==(lhs:Percentage, rhs:Percentage) -> Bool {
    return compare(lhs, rhs: rhs) == .orderedSame
}

//Comparable
public func <(lhs:Percentage, rhs:Percentage) -> Bool {
    return compare(lhs, rhs: rhs) == .orderedAscending
}

private func compare(_ lhs:Percentage, rhs:Percentage) -> ComparisonResult {
    var lhsd = lhs.percentValue
    var rhsd = rhs.percentValue
    return NSDecimalCompare(&lhsd, &rhsd)
}

//Arithmatic operations

private typealias PBDecimalOperation = ( _ result: UnsafeMutablePointer<Decimal>, _ lhs: UnsafePointer<Decimal>, _ rhs: UnsafePointer<Decimal>, _ roundingMode: NSDecimalNumber.RoundingMode) -> NSDecimalNumber.CalculationError

private func PBAddPercent( _ result: UnsafeMutablePointer<Decimal>, lhs: UnsafePointer<Decimal>, rhs: UnsafePointer<Decimal>, roundingMode: NSDecimalNumber.RoundingMode) -> NSDecimalNumber.CalculationError {
    var tempResult = Decimal()
    
    let error = NSDecimalMultiply(&tempResult, lhs, rhs, roundingMode)
    if error == NSDecimalNumber.CalculationError.noError {
        return NSDecimalAdd(result, lhs, &tempResult, roundingMode)
    } else {
        return error
    }
}

private func PBSubtractPercent( _ result: UnsafeMutablePointer<Decimal>, lhs: UnsafePointer<Decimal>, rhs: UnsafePointer<Decimal>, roundingMode: NSDecimalNumber.RoundingMode) -> NSDecimalNumber.CalculationError {
    var tempResult = Decimal()
    
    let error = NSDecimalMultiply(&tempResult, lhs, rhs, roundingMode)
    if error == NSDecimalNumber.CalculationError.noError {
        return NSDecimalSubtract(result, lhs, &tempResult, roundingMode)
    } else {
        return error
    }
}



//Percentage operations
public func +(lhs:Percentage, rhs:Percentage) -> Percentage {
    return operationToPercentage(lhs.percentValue, rhs: rhs.percentValue, operation: NSDecimalAdd)
}

public func -(lhs:Percentage, rhs:Percentage) -> Percentage {
    return operationToPercentage(lhs.percentValue, rhs: rhs.percentValue, operation: NSDecimalSubtract)
}

public func *(lhs:Percentage, rhs:NSNumber) -> Percentage {
    return operationToPercentage(lhs.percentValue, rhs: rhs.decimalValue, operation: NSDecimalMultiply)
}

public func /(lhs:Percentage, rhs:NSNumber) -> Percentage {
    return operationToPercentage(lhs.percentValue, rhs: rhs.decimalValue, operation: NSDecimalDivide)
}

//NSDecimal and NSNumber
public func *(lhs:NSNumber, rhs:Percentage) -> Decimal {
    return lhs.decimalValue * rhs
}

public func *(lhs:Decimal, rhs:Percentage) -> Decimal {
    return operationToDecimal(lhs, rhs: rhs.percentValue, operation: NSDecimalMultiply)
}

public func /(lhs:NSNumber, rhs:Percentage) -> Decimal {
    return lhs.decimalValue / rhs
}

public func /(lhs:Decimal, rhs:Percentage) -> Decimal {
    return operationToDecimal(lhs, rhs: rhs.percentValue, operation: NSDecimalDivide)
}

public func +(lhs:NSNumber, rhs:Percentage) -> Decimal {
    return lhs.decimalValue + rhs
}

public func +(lhs:Decimal, rhs:Percentage) -> Decimal {
    return operationToDecimal(lhs, rhs: rhs.percentValue, operation: PBAddPercent)
}

public func -(lhs:NSNumber, rhs:Percentage) -> Decimal {
    return lhs.decimalValue - rhs
}

public func -(lhs:Decimal, rhs:Percentage) -> Decimal {
    return operationToDecimal(lhs, rhs: rhs.percentValue, operation: PBSubtractPercent)
}


//Operator function
private func operationToPercentage(_ lhs:Decimal, rhs:Decimal, operation:PBDecimalOperation) -> Percentage {
    return Percentage(percentValue: operationToDecimal(lhs, rhs: rhs, operation: operation))
}

private func operationToDecimal(_ lhs:Decimal, rhs:Decimal, operation:PBDecimalOperation) -> Decimal {
    var lhsd = lhs
    var rhsd = rhs
    var result:Decimal = Decimal()
    
    _ = operation(&result, &lhsd, &rhsd, NSDecimalNumber.RoundingMode.bankers)
    return result
}

