//
//  main.swift
//  SimpleDomainModel
//
//  Created by Ted Neward on 4/6/16.
//  Copyright © 2016 Ted Neward. All rights reserved.
//

import Foundation

print("Hello, World!")

public func testMe() -> String {
    return "I have been tested"
}

public class TestMe {
    public func Please() -> String {
        return "I have been tested"
    }
}

////////////////////////////////////
// Money
//
public struct Money {
    public var amount : Int
    public var currency : String
    let eRates = ["USD" : 1, "GBP" : 0.5, "EUR" : 1.5, "CAN" : 1.25]
    
    // convert the money object to the given currency
    public func convert(to: String) -> Money {
        let rate = eRates[to]! / eRates[self.currency]!
        return Money(amount: Int(rate * Double(self.amount)), currency: to)
        
    }
    
    
    public func add(to: Money) -> Money {
        if to.currency == self.currency {
            return Money(amount: to.amount + self.amount, currency: self.currency)
        } else {
            let m = self.convert(to.currency)
            return Money(amount: m.amount + to.amount, currency: to.currency)
        }
    }
    
    public func subtract(from: Money) -> Money {
        if from.currency == self.currency {
            return Money(amount: from.amount - self.amount, currency: self.currency)
        } else {
            let m = from.convert(self.currency)
            return Money(amount: m.amount - self.amount, currency: self.currency)
        }
    }
    
}

////////////////////////////////////
// Job
//
public class Job {
    public var title : String
    public var type: JobType
    
    public enum JobType {
        case Hourly(Double)
        case Salary(Int)
    }
    
    public init(title : String, type : JobType) {
        self.title = title
        self.type = type
    }
    
    // caculate total income if the income is hourly, return the salary if it's annual
    public func calculateIncome(hours: Int) -> Int {
        switch type {
        case let .Hourly(rate):
            return Int(Double(hours) * rate)
        case let .Salary(amt):
            return amt
        }
    }
    
    // apply a raise of a given amount to the current salary
    public func raise(amt : Double) {
        switch type {
        case let .Hourly(rate): self.type = .Hourly(amt + rate)
        case let .Salary(total): self.type = .Salary(Int(amt) + total)
        }
    }
}


////////////////////////////////////
// Person
//
public class Person {
    public var firstName : String = ""
    public var lastName : String = ""
    public var age : Int = 0
    
    // a person can have a job if he/she is over 16
    private var _job : Job?
    public var job : Job? {
        get { return _job}
        set(value) {
            if age >= 16 {
                _job = value!
            }
        }
    }
    
    // a person can have a spouse if he/she is over 21
    private var _spouse : Person?
    public var spouse : Person? {
        
        get { return _spouse}
        set(value) {
            if age >= 18 {
                _spouse = value!
            }
        }
    }
    
    public init(firstName : String, lastName: String, age : Int) {
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
        _job = nil
        _spouse = nil
    }
    
    public func toString() -> String {
        return "[Person: firstName:\(self.firstName) lastName:\(self.lastName) age:\(self.age) job:\(self.job) spouse:\(self.spouse)]"
    }
}



////////////////////////////////////
// Family
//

public class Family {
    private var members : [Person] = []
    public init(spouse1: Person, spouse2: Person) {
        if spouse1.spouse == nil && spouse2.spouse == nil {
            spouse1.spouse = spouse2
            spouse2.spouse = spouse1
            members.append(spouse1)
            members.append(spouse2)
        }
    }
    
    // add a child to the family if at least one of the family members is over 21
    public func haveChild(child: Person) -> Bool {
        var over21 = false
        for person in members {
            if person.age >= 21 {
                over21 = true
            }
        }
        if over21 {
            self.members.append(child)
        }
        return over21
    }
    
    // calculate the total family income
    public func householdIncome() -> Int {
        var incomes = 0
        for person in members {
            if person.job != nil {
                
                // for hourly, 40 hours/week, 50 weeks/year 40
                incomes += (person.job?.calculateIncome(40 * 50))!
            }
        }
        return incomes
    }
}







