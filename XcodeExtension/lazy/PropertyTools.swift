//
//  PropertyTools.swift
//  XcodeExtensionTools
//
//  Created by sharui on 2021/3/18.
//

import Foundation

let kInterfaceKey = "@interface"
let kEndKey = "@end"
let kImplementationKey = "@implementation"

struct ClassPairStatus {
    var line : Int = -1
    var key : String = ""
    var className : String = ""
}

struct LazyInsetLineInfo {
    var start: Int = -1
    var end: Int = -1
    var list: Array<Any> = []
    var isFind : Bool {
        start != -1 && end != -1
    }
}

struct PropertyTools {
    
    static func findPropertyDueTo(lineIndex: Int, lines: NSMutableArray) -> LazyInsetLineInfo {
        
        var lazy = LazyInsetLineInfo()
        var classPair = Array<ClassPairStatus>()
        
        
        for index in 0..<lines.count {
            let string = lines[index] as? String ?? ""
            var key = ""
            if string.contains(kInterfaceKey) {
                key = kInterfaceKey
            } else if string.contains(kEndKey) {
                key = kEndKey
            } else if string.contains(kImplementationKey) {
                key = kImplementationKey
            }
            
            if key.count > 0 {
                let className = findPropertyDueToClassName(string: string,key: key)
                classPair.append(ClassPairStatus(line: index, key: key, className:className))
            }
        }
        // 没有成对
        guard classPair.count % 2 == 0 && classPair.count >= 2 else {
            return lazy
        }
        
        var className = ""
        for item in classPair {
            let index = item.line
            if index > lineIndex {
                break;
            }
            className = item.className
        }
        
        var index = 0
        var IMPIndex = 0
        var findIndex = false
        
        for item in classPair {
            if item.key == kImplementationKey && item.className == className && item.className != "" {
                IMPIndex = index;
                findIndex = true;
            }
            index = index + 1;
        }
        
        if !findIndex {
            return lazy
        }
        
        let next = IMPIndex + 1
        if next < classPair.count {
            let tempList = Array(lines)
            
            let startIndex = tempList.index(tempList.startIndex, offsetBy:classPair[IMPIndex].line)
            let endIndex = tempList.index(tempList.startIndex, offsetBy:classPair[next].line)
            lazy.list = Array(tempList[startIndex...endIndex])
            lazy.start = startIndex
            lazy.end = endIndex
            return lazy
        }
        
        return lazy
    }

    static func findPropertyDueToClassName(string: String, key:String) -> String {
        let subString = string.replacingOccurrences(of: key, with: "")
        var resultString = ""
        
        for item in subString {
            
            if !VerityEnum.className(String(item)).isRight && resultString.count > 0{
                break
            }
            if VerityEnum.className(String(item)).isRight {
                resultString.append(item)
            }
        }
        return resultString
    }

    
    static func referenceKeyWord(className: String) ->String{
        if className == "NSString" {
            return "copy"
        }
        return "strong"
    }
    
    static func findClassName(string: String) -> String{
        if string .contains("*") {
            return findStringBetween(firstChar1: ")", lastChar2:"*", string: string)
        }
        return ""
    }
    
    static func findVariableName(string: String) -> String{
        if string.contains("*") {
            return findStringBetween(lastChar1: "*", lastChar2:";", string: string)
        }
        return ""
    }
    
    static func findStringBetween(lastChar1 char1: Character, lastChar2 char2: Character, string:String) -> String {
        let firstIndex = string.lastIndex(of: char1)!
        let endIndex = string.lastIndex(of: char2)!
        
        if firstIndex < endIndex {
            let temp = string[string.index(after: firstIndex)...string.index(before: endIndex)]
            let b = replacingSideSpace(string: String(temp))
            return b
        }
        return ""
    }
    
    static func findStringBetween(firstChar1 char1: Character, lastChar2 char2: Character, string:String) -> String {
        let firstIndex = string.firstIndex(of: char1)!
        let endIndex = string.lastIndex(of: char2)!
        
        if firstIndex < endIndex {
            let temp = string[string.index(after: firstIndex)...string.index(before: endIndex)]
            let b = replacingSideSpace(string: String(temp))
            return b
        }
        return ""
    }
    
    private static func replacingSideSpace(string:String) -> String {
        var index = 0
        var begin:String.Index = string.startIndex
        for char in string {
            if String(char) != " " {
                begin = string.index(string.startIndex, offsetBy: index)
                break
            }
            index = index + 1
        }
        
        var end: String.Index = string.endIndex
        var index2 = 0
        for char in string.reversed() {
            if String(char) != " " {
                end = string.index(string.endIndex, offsetBy: index2)
                break
            }
            index2 = index2 - 1
        }
        let temp = string[begin..<end]
        return String(temp)
    }
    
    
}


enum VerityEnum {
    case className(_:String)
    case funcName(className:String, varName:String, sourceString:String)
    var isRight : Bool {
        var currentString: String!
        var predicateString: String!
        switch self {
        case let .className(str):
            predicateString = "^[\\u4E00-\\u9FA5A-Za-z0-9_]+$"
            currentString = str
        case let.funcName(className, varName, sourceString):
            predicateString = "(.*)\\s*\\-\\s*\\(\\s*\(className)\\s*\\*\\s*\\)\\s*\(varName)\\s*\\{*\\s*(.*)"
            currentString = sourceString
        }
        
        
        let predicate = NSPredicate(format: "SELF MATCHES %@", predicateString)
        let isRight = predicate.evaluate(with: currentString)
        return isRight
    }
    
    
//    - (LGMsgNoDataView *)noDatatView
}
