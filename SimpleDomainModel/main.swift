//
//  main.swift
//  SimpleDomainModel
//
//  Created by Ted Neward on 4/6/16.
//  Copyright © 2016 Ted Neward. All rights reserved.
//

import Foundation

var myMoney : Money = Money(currency: "USD", amount: 1000)
print(myMoney)
var myMoney4 : Money = Money(currency: "USD", amount: 666)
var myMoney5 : Money = Money(currency: "USD", amount: 333)
myMoney = myMoney.convertTo("GBP")
//print(myMoney)

var myMoney2 = myMoney.convertTo("CAN")
print(myMoney2)


var myMoney3 = myMoney.convertTo("EUR")
print(myMoney3)

myMoney = myMoney.add(myMoney4)
print(myMoney)
myMoney = myMoney.subtract(myMoney5)
myMoney = myMoney.convertTo("USD")
print(myMoney)

print("")
var myJob = Job(title: "Student", salary: 30, salaryType: .perHour)
myJob.salary = myJob.raise(30)
print(myJob.title, myJob.salary, myJob.salaryType)
let income = myJob.calculateIncome(400)
print("My total income is $\(income)")

print("")
var Jack = Person(firstName: "Jack", lastName: "Johns", age: 23, spouse: nil, job: myJob)
print(Jack.toString())


var Mary = Person(firstName: "Mary", lastName: "Johns", age: 21, spouse: Jack, job: myJob)
print(Mary.toString())

print("")
var newFamily = Family(members: [Jack,Mary])


print("there are \(newFamily.members.count) people in this family now")
newFamily.haveChild()

print("there are \(newFamily.members.count) people in this family now")

print("")
print("list of family members: ")
for (var i = 0; i < newFamily.members.count; i++) {
    var name = newFamily.members[i].firstName + " " + newFamily.members[i].lastName
    print("\(i+1). \(name)")
    
}





// Extension Double: convert a double value into a Money using self as the amount
extension Double {
    var USD: Money {return Money(currency: "USD", amount: self)}
    var EUR: Money {return Money(currency: "EUR", amount: self)}
    var GBP: Money {return Money(currency: "GBP", amount: self)}
    var CAN: Money {return Money(currency: "CAN", amount: self)}
}
print("")
print("Extension: Double Tests:")
print("\"1200.USD\" returns \(1200.USD)")
print("\"2000.EUR.add(300.USD)\" returns \(2000.EUR.add(300.USD))")


// New protocol added: returns human readable version of contents
protocol CustomStringConvertible {
    var description : String { get }
}
print("")
print("CustomStringConvertible Tests:")
print("\"1200.USD.description\" returns: \(1200.USD.description)")
print("\"myJob.description\" returns: \(myJob.description)")
print("\"Jack.description\" returns: \(Jack.description)")
print("\"newFamily.description\" returns: \(newFamily.description)")


// New protocol added: Mathematics (+,-)
print(myMoney.addMoney(myMoney2))
print(myMoney.addMoney(myMoney2).description)
print(myMoney.subMoney(myMoney2))
print(myMoney.subMoney(myMoney2).description)

////////////////////////////////////
// Money
//
protocol Mathematics {
    func addMoney(incoming: Money) -> Money
    func subMoney(incoming: Money) -> Money
}

struct Money: CustomStringConvertible, Mathematics{
    var currency : String
    var amount : Double
    
    
    // coverts current currency to the given currency type
    func convertTo(targetCurrency: String) -> Money{
        var result = Money(currency: targetCurrency, amount: self.amount)
        switch self.currency {
        case "USD":
            if (targetCurrency == "GBP") {
                result.amount = self.amount * 0.5
                
            }else if (targetCurrency == "EUR"){
                result.amount = self.amount * 1.5
            }else if (targetCurrency == "CAN") {
                result.amount = self.amount * 1.25
            }else {
                print("Cannot convert to this currency.")
            }
            
        case "GBP":
            if (targetCurrency == "USD") {
                result.amount = self.amount * 2
            }else if (targetCurrency == "EUR"){
                result.amount = self.amount * 3
            }else if (targetCurrency == "CAN") {
                result.amount = self.amount * 2.5
            }else {
                print("Cannot convert to this currency.")
            }
            
        case "EUR":
            if (targetCurrency == "GBP") {
                result.amount = self.amount * (1/3)
            }else if (targetCurrency == "USD"){
                result.amount = self.amount * (2/3)
            }else if (targetCurrency == "CAN") {
                result.amount = self.amount * (5/6)
            }else {
                print("Cannot convert to this currency.")
            }
            
        case "CAN":
            if (targetCurrency == "GBP") {
                result.amount = self.amount * (2/5)
            }else if (targetCurrency == "EUR"){
                result.amount = self.amount * (6/5)
            }else if (targetCurrency == "USD") {
                result.amount = self.amount * (4/5)
            }else {
                print("Cannot convert to this currency.")
            }
        default:
            result.amount = self.amount
            result.currency = self.currency
        }
        
        return result
    }
    
    // coverts the given Money to current currency and returns the sum
    func add(incoming: Money) -> Money{
        
        
        var total = Money(currency: self.currency, amount: self.amount)
        let coveredIncoming = incoming.convertTo(self.currency)
        total.amount = self.amount + coveredIncoming.amount
        
        return total
    }
    
    // coverts the given Money to current currency and returns the subtract result
    func subtract(incoming: Money) -> Money{
        var total = Money(currency: self.currency, amount: self.amount)
        let coveredIncoming = incoming.convertTo(self.currency)
        total.amount = self.amount - coveredIncoming.amount
        
        return total
    }
    
    var description : String {
        return ("\(self.currency) $\(self.amount)")
    }
    
    
    // protool methods
    func addMoney(incoming: Money) -> Money {
        if(self.currency != incoming.currency) {
            incoming.convertTo(self.currency)
        }
        return Money(currency: self.currency, amount: self.amount + incoming.amount)
    }
    
    func subMoney(incoming: Money) -> Money {
        if(self.currency != incoming.currency) {
            incoming.convertTo(self.currency)
        }
        return Money(currency: self.currency, amount: self.amount - incoming.amount)
    }
    
    
}

////////////////////////////////////
// Job
//
class Job : CustomStringConvertible {
    
    enum SalaryType {
        case perHour
        case perYear
    }
    
    let title: String
    var salary: Double
    let salaryType: SalaryType
    
    
    
    init(title: String, salary: Double, salaryType: SalaryType) {
        self.title = title
        self.salary = salary
        self.salaryType = salaryType
        
    }
    
    // accepts a number of hours worked this year and returns total salary, returns year salary if type is perYear
    func calculateIncome(hoursWorked: Double) -> Double {
        if (self.salaryType == SalaryType.perHour) {
            return salary * hoursWorked
        }else {
            return salary
        }
    }
    
    // raise salary with given percentage
    func raise(percent: Double) -> Double {
        let newSalary = salary * (percent/100) + salary
        return newSalary
    }
    
    var description : String {
        return ("\(self.title) $\(self.salary) \(self.salaryType)" )
    }
    
}

////////////////////////////////////
// Person
//
class Person : CustomStringConvertible {
    let firstName : String
    let lastName : String
    let age : Int
    var spouse : Person?
    var job : Job?
    
    init(firstName: String, lastName: String, age: Int, spouse: Person?, job: Job?) {
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
        if (age >= 16) {
            self.job = job
        }else {
            self.job = nil
        }
        if (age >= 18) {
            self.spouse = spouse
        }else {
            self.spouse = nil
        }
    }
    
    func toString () -> String{
        if(self.job != nil && self.spouse != nil){
            return "FirstName: \(firstName), LastName:\(lastName), age:\(age), Spouse:\(spouse!.firstName), Job:\(job!.title)"
        }else if (self.job == nil && self.spouse != nil){
            return "FirstName: \(firstName), LastName:\(lastName), age:\(age), Spouse:\(spouse!.firstName), Job: None"
        }else if (self.job != nil && self.spouse == nil) {
            return "FirstName: \(firstName), LastName:\(lastName), age:\(age), Spouse: None, Job:\(job!.title)"
        }else {
            return "FirstName: \(firstName), LastName:\(lastName), age:\(age), Spouse: None, Job: None"
        }
        
    }
    
    var description : String {
        if(self.job != nil && self.spouse != nil){
            return ("\(self.firstName) \(self.lastName) \(self.age) \(self.spouse!) \(self.job!.description)" )
        }else if (self.job == nil && self.spouse != nil){
            return ("\(self.firstName) \(self.lastName) \(self.age) \(self.spouse!) NoJob" )
        }else if (self.job != nil && self.spouse == nil) {
            return ("\(self.firstName) \(self.lastName) \(self.age) NoSpouse \(self.job!.description)" )
        }else {
            return ("\(self.firstName) \(self.lastName) \(self.age) NoSpouse NoJob" )
        }
        
        
    }
}

////////////////////////////////////
// Family
//
class Family : CustomStringConvertible{
    var members : [Person]
    
    init (members: [Person]) {
        self.members = members
    }
    
    
    
    func householdIncome() -> Double{
        var total : Double = 0
        for member in members {
            if (member.job != nil) {
                let income = member.job!.calculateIncome(2087)
                total += income
            }
            
        }
        return total
    }
    
    func haveChild(){
        for member in members {
            if (member.age > 21) {
                members.append(Person(firstName: "newBaby", lastName: member.lastName, age: 0, spouse: nil, job: nil))
                print("A new baby has joined this family.")
                break
            }else {
                print("This family is illegal to have child.")
            }
        }
        
    }
    
    var description : String {
        var list : String = ""
        for (var i = 0; i < newFamily.members.count; i += 1) {
            let name = newFamily.members[i].firstName + " " + newFamily.members[i].lastName
            list += ("\(i+1). \(name) ")
            
        }
        return list
    }
}





