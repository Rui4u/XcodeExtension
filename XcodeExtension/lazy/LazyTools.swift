//
//  LazyTools.swift
//  XcodeExtensionTools
//
//  Created by sharui on 2021/3/18.
//

import Foundation
struct LazyTools {
    
    static func lazyString(className:String , variableName:String) -> String{
        if let str = locationString(className: className, propertyName: variableName, variableName: "_\(variableName)"){
            return str
        } else {
            return defaultLazyString(className: className, variableName: variableName)
        }
    }
    
    private static func locationString(className: String, propertyName: String, variableName: String) -> String? {
        let locationHas = LocationManger.locationHave(className: className)
        guard locationHas == true else {
            return nil
        }
        guard let model = LocationManger.locationLazyCoder(key: className) else {
            return nil
        }
        
        var templte = LocationManger.transformLazyCoderToKeyString(model: model);
        
        templte = templte.replacingOccurrences(of: "成员变量名", with: variableName,options: String.CompareOptions.literal)
        templte = templte.replacingOccurrences(of: "属性名", with: propertyName,options: String.CompareOptions.literal)
        templte = templte.replacingOccurrences(of: "类名", with: className,options: String.CompareOptions.literal)
        return templte
    }
    
    private static func defaultLazyString(className: String, variableName: String) ->String{
"""

- (\(className) *)\(variableName) {
    if (_\(variableName) == nil) {
        _\(variableName) = [[\(className) alloc] init];
    }
    return _\(variableName);
}
"""
    }
}

