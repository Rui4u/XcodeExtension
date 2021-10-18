//
//  SourceEditorExtension.swift
//  XcodeExtension
//
//  Created by sharui on 2021/3/18.
//

import Foundation
import XcodeKit

class SourceEditorExtension: NSObject, XCSourceEditorExtension {
    
    /*
    func extensionDidFinishLaunching() {
        // If your extension needs to do any work at launch, implement this optional method.
    }
    */
    
    let kSourceEditorClassName = "XcodeExtension.SourceEditorCommand"
    var commandDefinitions: [[XCSourceEditorCommandDefinitionKey: Any]] {
        
        let menu1: [XCSourceEditorCommandDefinitionKey: Any] = [
            XCSourceEditorCommandDefinitionKey.nameKey : "lazy",
            XCSourceEditorCommandDefinitionKey.classNameKey : kSourceEditorClassName,
            XCSourceEditorCommandDefinitionKey.identifierKey : "lazyID"
        ]
        return [menu1]
    }
}
