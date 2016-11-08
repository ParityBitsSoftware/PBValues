//
//  PercentageSpec.swift
//  PBValues
//
//  Created by Andrew Tillman on 8/12/15.
//  Copyright (c) 2015 Parity Bits. All rights reserved.
//

import PBValues
import Quick
import Nimble

class PercentageSpec : QuickSpec {
    override func spec() {
        
        var subject:Percentage!
        var numberValue:NSNumber!
        
        beforeEach {
            let randomValue = Float(((arc4random() % 100) + 1))
            numberValue = NSNumber(value: randomValue / 100)
            subject = Percentage(numberValue: numberValue)
        }
        
        describe("base functions") {
            it("captures the decimal value of the number") {
                //Using NSDecimalNumber to compare the NSDecimal structs
                expect(NSDecimalNumber(decimal: subject.percentValue)).to(equal(NSDecimalNumber(decimal: numberValue.decimalValue)))
            }
            
            it("converts to decimal number") {
                expect(subject.decimalNumber).to(equal(NSDecimalNumber(decimal: subject.percentValue)))
            }
        }
        
        describe("constant values") {
            it("has 0%") {
                expect(Percentage.Zero.decimalNumber).to(equal(Percentage(numberValue: NSNumber(value: 0)).decimalNumber))
            }
            
            it("has 100%") {
                expect(Percentage.OneHundred.decimalNumber).to(equal(Percentage(numberValue: NSNumber(value: 1)).decimalNumber))
            }
        }
        
        describe("Printable") {
            it("returns <value>%") {
                expect(subject.description).to(equal("\(subject.decimalNumber.multiplying(byPowerOf10: 2))%"))
            }
        }
        
        describe("Comparable") {
            var equalPercentage:Percentage!
            var lessThanPercentage:Percentage!
            var greaterThanPercentage:Percentage!
            
            beforeEach {
                equalPercentage = Percentage(numberValue: NSNumber(value: numberValue.floatValue))
                
                let lessNumber = NSNumber(value: numberValue.floatValue - 0.01)
                lessThanPercentage = Percentage(numberValue: lessNumber)
                
                let greaterNumber = NSNumber(value: numberValue.floatValue + 0.01)
                greaterThanPercentage = Percentage(numberValue: greaterNumber)
            }
            
            it("is equal if the percent values are equal") {
                expect(subject).to(equal(equalPercentage))
                expect(equalPercentage).to(equal(subject))
            }
            
            it("is not equal if the percent values are different") {
                expect(subject).notTo(equal(lessThanPercentage))
                expect(lessThanPercentage).notTo(equal(subject))
                expect(subject).notTo(equal(greaterThanPercentage))
                expect(greaterThanPercentage).notTo(equal(subject))
            }
            
            it("compares less then based in percentValue") {
                expect(subject).notTo(beLessThan(equalPercentage))
                expect(subject).notTo(beGreaterThan(equalPercentage))
                expect(subject).notTo(beLessThan(lessThanPercentage))
                expect(subject).to(beGreaterThan(lessThanPercentage))
                expect(subject).to(beLessThan(greaterThanPercentage))
                expect(subject).notTo(beGreaterThan(greaterThanPercentage))
            }
        }
    
        describe("arithmatic operations") {
            
            context("returning a percentage") {
                var otherPercentage:Percentage!
                var someNumber:NSNumber!
                var someNumberDecimal:NSDecimalNumber!
                
                beforeEach {
                    otherPercentage = Percentage(numberValue:  NSNumber(value: Float((arc4random() % 100)) / 100))
                    someNumber = Int((arc4random() % 10) + 2) as NSNumber!
                    someNumberDecimal = NSDecimalNumber(decimal: someNumber.decimalValue)
                }
                
                it("adds two percentages together") {
                    expect(subject + otherPercentage).to(equal(Percentage(numberValue: subject.decimalNumber.adding(otherPercentage.decimalNumber))))
                }
                
                it("subtract one percentage from another") {
                    expect(subject - otherPercentage).to(equal(Percentage(numberValue: subject.decimalNumber.subtracting(otherPercentage.decimalNumber))))
                }
                
                it("multiplies the percentage by the given amount")  {
                    expect(subject * someNumber).to(equal(Percentage(numberValue: subject.decimalNumber.multiplying(by: someNumberDecimal))))
                }
                
                it("divides the percentage by the given amount") {
                    expect(subject / someNumber).to(equal(Percentage(numberValue: subject.decimalNumber.dividing(by: someNumberDecimal))))
                }
                
            }
            
            context("returning decimal") {
                var someNumber:NSDecimalNumber!
                
                beforeEach {
                    someNumber = NSDecimalNumber(value: (arc4random() % 1000) + 2)
                }
                
                it("returns the percentage of a number for *") {
                    expect(NSDecimalNumber(decimal: someNumber * subject)).to(equal(someNumber.multiplying(by: subject.decimalNumber)))
                }
                
                it("returns the value that the number is the percentage of for /") {
                    expect(NSDecimalNumber(decimal: someNumber / subject)).to(equal(someNumber.dividing(by: subject.decimalNumber)))
                }
                
                it("adds the amount of the percentage of the number for +") {
                    expect(NSDecimalNumber(decimal: someNumber + subject)).to(equal(someNumber.adding(someNumber.multiplying(by: subject.decimalNumber))))
                }
                
                it("subtracts the amount of the percentage of the number for -") {
                    expect(NSDecimalNumber(decimal: someNumber - subject)).to(equal(someNumber.subtracting(someNumber.multiplying(by: subject.decimalNumber))))
                }
            }
        }
    }
}

