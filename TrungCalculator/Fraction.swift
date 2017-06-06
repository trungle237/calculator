//
//  Fraction.swift
//  prog2.1
//
//  Created by Christopher Lynch on 7/20/16.
//  Copyright © 2016 Christopher Lynch. All rights reserved.
//

import Foundation

final class Fraction: CustomStringConvertible, StringConvertibleNum {
    
    // STORED PROPERTIES
    
    fileprivate let num: Int;
    fileprivate let den: Int;
    
    // COMPUTED PRORPERTIES
    
    var decimal: Float {
        get {
            return Float(self.num)/Float(self.den)
        }
    }
    
    var description: String {
        if self.num > self.den {
            let q: Int = self.num/self.den
            let r: Int = self.num - (self.den * q)
            if r == 0 {
                return "\(q)"
            } else {
                return "\(q) \(r)/\(self.den)"
            }
        } else {
            if self.num <= 1 {
                return "\(self.num)"
            } else {
                return "\(self.num)/\(self.den)"
            }
        }
    }
    
    // INITIALISERS
    
    // def. initialiser
    convenience init() {
        self.init(num: 0, den: 1)
    }
    
    // designated initialiser
    init(num: Int, den: Int) {
        assert(den != 0, "Denominator cannot be zero")
        
        // func args are constants -> conv. to vars
        var num = num
        var den = den
        
        if den < 0 {
            num = -num
            den = -den
        }
        
        for gcd in (1...den).reversed() {
            if (num % gcd == 0 && den % gcd == 0) {
                // common denominator found
                num /= gcd
                den /= gcd
                break
            }
        }
        
        self.num = num
        self.den = den
    }
    
    // convenience initialiser
    convenience init(num: Int) {
        self.init(num: num, den: 1)
    }
    
    // METHODS
    
    func add(_ f: Fraction) -> Fraction {
        return Fraction(num: self.num*f.den + self.den*f.num, den: self.den*f.den)
    }
    
    func subtract(_ f: Fraction) -> Fraction {
        return Fraction(num: self.num*f.den - self.den*f.num, den: self.den*f.den)

    }
    
    func multiply(_ f: Fraction) -> Fraction {
        return Fraction(num: self.num * f.num, den: self.den * f.den)
    }
    
    func divide(_ f: Fraction) -> Fraction {
        return Fraction(num: self.num * f.den, den: self.den * f.num)
    }
    
    func add(_ x: Int) -> Fraction {
        return Fraction(num: self.num + self.den*x, den: self.den)
    }
    
    func subtract(_ x: Int) -> Fraction {
        return Fraction(num: self.num - self.den*x, den: self.den)
    }
    
    func multiply(_ x: Int) -> Fraction {
        return Fraction(num: self.num*x, den: self.den)
    }
    
    func divide(_ x: Int) -> Fraction {
        return Fraction(num: self.num, den: self.den*x)
    }
    
    static func add(_ f1: Fraction, to f2: Fraction) -> Fraction {
        return f1.add(f2)
    }
    
    static func subtract(_ f1: Fraction, from f2: Fraction) -> Fraction {
        return f2.subtract(f1)
    }
    
    static func multiply(_ f1: Fraction, by f2: Fraction) -> Fraction {
        return f1.multiply(f2)
    }
    
    static func divide(_ f1: Fraction, by f2: Fraction) -> Fraction {
        return f1.divide(f2)
    }
    
    static func readFromString(_ string: String) -> Fraction? {
        var num: Int = 0
        var den: Int = 1
        var tokens = string.components(separatedBy: "/")
        
        if tokens.count > 0 {
            if let n = Int(tokens[0]) {
                num = n
            } else {
                return nil
            }
        }
        
        if tokens.count > 1 {
            if let d = Int(tokens[1]) {
                den = d
            } else {
                return nil
            }
        }
        
        return Fraction(num: num, den: den)
    }
}

func +(f1: Fraction, f2: Fraction) -> Fraction {
    return f1.add(f2)
}

func +(f: Fraction, x: Int) -> Fraction {
    return f.add(x)
}

func -(f1: Fraction, f2: Fraction) -> Fraction {
    return f1.subtract(f2)
}

func -(f: Fraction, x: Int) -> Fraction {
    return f.subtract(x)
}

func *(f1: Fraction, f2: Fraction) -> Fraction {
    return f1.multiply(f2)
}

func *(f: Fraction, x: Int) -> Fraction {
    return f.multiply(x)
}

func /(f1: Fraction, f2: Fraction) -> Fraction {
    return f1.divide(f2)
}

func /(f: Fraction,x: Int) -> Fraction {
    return f.divide(x)
}
