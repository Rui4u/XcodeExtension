//
//  LazyCommand.swift
//  XcodeExtension
//
//  Created by sharui on 2021/7/6.
//

import Foundation
import XcodeKit

struct LazyCommand {
    static func lazy(_ invocation: XCSourceEditorCommandInvocation) {
        let firstRange : XCSourceTextRange = invocation.buffer.selections.lastObject as! XCSourceTextRange
        let lastRange : XCSourceTextRange = invocation.buffer.selections.firstObject as! XCSourceTextRange
        
        
        for index in firstRange.start.line...lastRange.end.line {
            
            let lazyInsetInfo = PropertyTools.findPropertyDueTo(lineIndex: index, lines: invocation.buffer.lines)
            let str = invocation.buffer.lines[index] as? String ?? "";
            let className = PropertyTools.findClassName(string: str)
            let variableName = PropertyTools.findVariableName(string: str)
            
            
            if className.count > 0 && variableName.count > 0 {
                let lazyString = LazyTools.lazyString(className: className, variableName: variableName)
                if !lazyInsetInfo.isFind {
                    continue
                }
                
                let listStr = (lazyInsetInfo.list as! Array<String>).joined(separator: "")
                
                if VerityEnum.funcName(className: className, varName: variableName,sourceString:listStr).isRight {
                    continue
                }
                invocation.buffer.lines.insert(lazyString, at: lazyInsetInfo.end)
            }
        }
    }
}
