//
//  SourceEditorCommand.swift
//  XcodeExtension
//
//  Created by sharui on 2021/3/18.
//

import Foundation
import XcodeKit

class SourceEditorCommand: NSObject, XCSourceEditorCommand {
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void ) -> Void {
        LazyCommand.lazy(invocation)
        completionHandler(nil)
    }
    
}
