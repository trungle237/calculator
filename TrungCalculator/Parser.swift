//
//  Calculator.swift
//  prog5.1
//
//  Created by Lech Szymanski on 24/05/15.
//  Copyright (c) 2015 Lech Szymanski. All rights reserved.
//

import Foundation

/**
 Protocol for an object that represents
 a number with a function that can convert
 string to that number and has the
 +, -, * and / operations defined
 between two numer objects
 */
protocol StringConvertibleNum {
    static func readFromString(_: String) -> Self?
    func +(_: Self, _: Self) -> Self
    func -(_: Self,_: Self) -> Self
    func *(_: Self,_: Self) -> Self
    func /(_: Self,_: Self) -> Self
}

/**
 Parser for string expressions with fraction calculations
 
 Supports +, -, *, and / operations
 
 */
class Parser<T: StringConvertibleNum> {
    
    // Type alias for operation and string tuple
    typealias TokenStr = (op: Character, token: String)
    // Type alias for operation and fraction tuple
    typealias TokenVal = (op: Character, token: T)
    
    /**
     Check whether a character corresponds to mathematical
     operation symbol
     
     :param: ch Character to check
     - returns: Bool True if character is +,-,/, or *, false
     otherwise
     */
    fileprivate static func isAnOperation(_ ch: Character) -> Bool {
        if ch == "+" || ch == "-" ||
            ch == "/" || ch == "*" {
            return true;
        }
        return false
    }
    
    /**
     Check whether a string contains a mathematical operation
     symbol anywhere aside from the first character
     
     :param: token String token to check
     - returns: Bool True if string token contains a mathematical
     operation symbol, false otherwise
     */
    fileprivate static func containsOperation(_ token: String) -> Bool {
        var firstCh: Bool = true;
        for ch in token.characters {
            if firstCh {
                // Do not check the first character of
                // the string
                firstCh = false
            } else if isAnOperation(ch) {
                return true;
            }
        }
        return false
    }
    
    /**
     Tokenises string expression into a set of tupples with
     mathematical operation and corresponding number string
     
     :param: exprStr Expression string to tokenize
     - returns: [TokenStr]? An optional array of TokenStr tuples, nil
     if parsing returns syntax error at any point
     */
    fileprivate static func tokenise(_ exprStr: String) -> [TokenStr]? {
        // Next token and operation
        var newToken: String = ""
        var newOperation: Character = " "
        
        // Array of token string tuples to return
        var tokens: [TokenStr] = []
        
        var firstParseChar: Bool = true;
        
        // Flag indicating whether operation symbol
        // must follow the last token
        var opMustFollow = false;
        // Flag indicating whether operation symbol
        // cannot follow the last token
        var opCannotFollow = true;
        
        // Count checking for bracket closure
        var bracketCount: Int = 0;
        
        // Walk through each character in the expression string
        for exprChar in exprStr.characters {
            // Skip whitespace
            if(exprChar == " ") {
                continue;
            }
            
            // If the first character in the expression string
            // is a "+" or "-", just treat it as
            // multiplication by positive or negative 1
            if firstParseChar && (exprChar=="+" || exprChar=="-") {
                if exprChar == "-" {
                    tokens += [(op: " ", token: String(exprChar) + "1")]
                    newOperation = "*"
                }
                firstParseChar = false;
                continue;
            }
            firstParseChar = false
            
            // If the next parse character does not have to be
            // an operation, check for brackets
            if !opMustFollow {
                
                // If character is the open bracket,
                // increase bracket count
                if exprChar == "(" {
                    // If it's the first opening bracket, it must
                    // be at the beginning of the new token string
                    if bracketCount == 0 && !newToken.isEmpty {
                        return nil
                    }
                    bracketCount += 1
                    // The first open bracket
                    // does not get added to the new token
                    if(bracketCount == 1) {
                        continue;
                    }
                    
                    // Else if parse character is the close bracket,
                    // decrease bracket count
                } else if exprChar == ")" {
                    // If bracket count is already at zero
                    // there is a syntax error - closing a
                    // bracket that hasn't been open
                    if(bracketCount == 0) {
                        return nil;
                    }
                    bracketCount -= 1
                    
                    // Last closing bracket
                    // does not get added to the new token string
                    // and operation must follow
                    if(bracketCount == 0) {
                        opMustFollow = true;
                        continue
                    }
                }
            }
            
            // If bracket count is at zero, check if the expression character
            // is an operation
            if bracketCount == 0 && isAnOperation(exprChar) {
                
                // Next character is an operation
                
                if opCannotFollow || newToken.isEmpty {
                    // If the flag for operation cannot follow is set or the
                    // token string is empty (operation follows right after
                    // an operation), then we have a parse error
                    return nil
                } else {
                    // Add a new tuple to the return token array
                    tokens += [(op: newOperation, token: newToken)]
                    // Reset the string token
                    newToken = ""
                    // Save the operation for next tuple
                    newOperation = exprChar;
                    // Reset operation must/cannot follow flags
                    opMustFollow = false
                    opCannotFollow = true
                }
            } else {
                // Next character is not an operation
                
                if opMustFollow {
                    // If operation must follow, we got a
                    // syntax error
                    return nil
                }
                // Just add expression character to the
                // token string
                newToken.append(exprChar);
                // Operation can follow after a non-operation
                //character
                opCannotFollow = false
            }
        }
        
        // Add the remaining operation and the token string
        tokens += [(op: newOperation, token: newToken)]
        
        // Finished parsing the expression string, if bracket count
        // is not zero, we have a syntax error
        if bracketCount > 0 {
            return nil
        } else {
            return tokens
        }
    }
    
    /**
     Evaluates a string as a mathematical expression.
     
     :param: string String to evaluate
     :param: debug Flag indicating whether to print debug info
     :param: rcount Recursion count - used for indentation printing of debug info
     :return: Fraction? Result of evaluation the string, nil if syntax error
     */
    fileprivate static func evaluate(_ string: String, debug: Bool, rcount: Int) -> T? {
        
        // Debug display
        if debug {
            print("dbg:", terminator: "")
            for _ in 0..<rcount {
                print("| ", terminator: "")
            }
        }
        
        // Check for base case
        if !containsOperation(string) {
            // There are no more mathematical operators within the string -
            // just evaluate the string to Fraction
            let result =  T.readFromString(string)
            
            // Debug info
            if debug {
                if let f = result {
                    print("evaluating number \(f)")
                } else {
                    print("syntax error!")
                }
            }
            
            return result
        } else {
            // There are mathematical expressions within the string -
            // will parse the string and break it into substrings
            // and recursively evaluate each part
            
            // Break the string into string tokens separated
            // by mathematical symbols
            let tokensToParse: [TokenStr]? = Parser<T>.tokenise(string);
            
            // Check if parsing retunred non-nil result
            if let tokens = tokensToParse {
                
                // Debug info about tokens found
                if debug {
                    print("evaluating '\(string)'")
                    for token in tokens {
                        print("dbg:", terminator: "")
                        for _ in 0..<rcount {
                            print("| ", terminator: "")
                        }
                        print("found op:\(token.op), expr:\(token.token)")
                    }
                }
                
                // Start converting strings to values
                var valuesToProcess: [TokenVal] = [];
                
                // Evaluate all tokens to numbers
                for token in tokens {
                    // Recursive call to evaluate next token to a value
                    if let val = self.evaluate(token.token, debug: debug, rcount: rcount+1) {
                        // Debug info showing obtained value
                        if debug {
                            print("dbg:", terminator: "")
                            for _ in 0..<rcount+1 {
                                print("| ", terminator: "")
                            }
                            print("value: \(val)")
                        }
                        // Add the operator with the new value
                        // to the parsed values array
                        valuesToProcess += [(op: token.op,token: val)]
                    } else {
                        return nil
                    }
                }
                
                // If no values were found, return nil
                if valuesToProcess.isEmpty {
                    return nil
                }
                
                // The first value in the array should
                // came with no preceeding operation
                let firstToken = valuesToProcess[0]
                if firstToken.op != " " {
                    return nil
                }
                
                
                // The * and / have precendence over + and
                // -, so first evaluate all the * and /
                // operators in the valuesToProcess array
                var i: Int = 1;
                while i < valuesToProcess.count {
                    // Get the operation, the left operand
                    // value and the right operand value
                    let op = valuesToProcess[i].op
                    let leftNum: T = valuesToProcess[i-1].token
                    let rightNum: T = valuesToProcess[i].token
                    
                    // If the operations is a * or a /, then
                    // perform multiplication or division, replacing
                    // the left operand in the valuesToProcess with
                    // the result, removing the right operand
                    if op == "*" {
                        valuesToProcess[i-1].token=leftNum * rightNum
                        valuesToProcess.remove(at: i);
                    } else if op == "/" {
                        valuesToProcess[i-1].token=leftNum / rightNum
                        valuesToProcess.remove(at: i);
                    } else {
                        i += 1;
                    }
                }
                
                // Once multiplication and division is done,
                // it's time to do addition and subtraction.
                // The result is stored as a single result
                // value
                var result: T = valuesToProcess[0].token               
                for i in 1..<valuesToProcess.count {
                    let token = valuesToProcess[i]
                    let num: T = token.token
                    
                    // Check if the operation on the next
                    // token is + or - and perform
                    // addition or subtraction on
                    // the final result and the next token
                    if token.op == "+" {
                        result = result + num;
                    } else if(token.op == "-") {
                        result = result - num;
                    } else {
                        // Do not expect any other operations
                        // at this point, aside from + and -,
                        // so if something else is found,
                        // return nil
                        return nil
                    }
                    
                    // Debug display of the final result
                    if debug {
                        print("dbg:", terminator: "")
                        for _ in 0..<rcount {
                            print("| ", terminator: "")
                        }
                        print("total: \(result)")
                    }
                }
                // Return the evaluated result
                return result;
            } else {
                // This else catches the nil return
                // of the parse result, meaning
                // parsing didn't work because of
                // a syntax error
                return nil
            }
        }
    }
    
    /**
     Evaluates a string as a mathematical expression.
     
     :param: string String to evaluate
     :param: debug Flag indicating whether to print debug info (false by default)
     :return: Fraction? Result of evaluation the string, nil if syntax error
     */
    static func evaluate(_ string: String, withDebugOption: Bool = false) -> T? {
        return Parser<T>.evaluate(string, debug: withDebugOption, rcount: 0);
    }
}
