//
//  UserDefaultsManager.swift
//  MacExtensionTool
//
//  Created by sharui on 2021/7/5.
//

import Foundation
import AppKit

struct UserDefaultsManger {
    static func manager() -> UserDefaults {
        UserDefaults(suiteName: "com.rui4u.MacExtensionTool.group")!
    }
    
}

struct LocationManger {
    
    static func output(list: [ClassTypeModel]) {
        
        var dictList = Array<[String: String]>()
        var jsonNSData: NSData!
        for item in list {
            let dict = ClassTypeModel.toDict(model: item)
            dictList.append(dict)
        }
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dictList, options: JSONSerialization.WritingOptions.prettyPrinted)
            jsonNSData = NSData(data: jsonData)
        } catch let error as NSError {
            print(error)
        }
        
        
        let panel = NSSavePanel()
        panel.title = "保存文件"
        panel.message = "请选择文件保存地址"
        panel.directoryURL = URL(string: "\(NSHomeDirectory())/Desktop")
        panel.nameFieldStringValue = "extensionConfig.text"
        panel.allowsOtherFileTypes = true
        panel.isExtensionHidden = false
        panel.canCreateDirectories = true
        panel.begin { (response) in
            if response == .OK {
                if let path = panel.url?.path {
                    jsonNSData.write(toFile: path, atomically: true)
                }
            }
        }
        
    }
    
    static func input() {
        openFile { data in
            if let data = data {
                do {
                    if let decoded = try JSONSerialization.jsonObject(with: data as Data, options: []) as? [[String:String]] {
                        var list = [ClassTypeModel]()
                        for dict in decoded {
                            list.append(ClassTypeModel.toModel(dict: dict))
                        }
                        saveAll(list: list)
                    }
                } catch let error as NSError {
                    print(error)
                }
            }
        }
    }
    
    static func openFile(dataBlock:(_ data:NSData?)->()) -> Void{
        
        let openPanel = NSOpenPanel()
        // 是否可以选择文件夹
        openPanel.canChooseDirectories = true
        // 是否可以选择文件
        openPanel.canChooseFiles = true
        // 是否可以多选
        openPanel.allowsMultipleSelection = false
        // 设置可选文件后缀名
        openPanel.allowedFileTypes=["text"]
        // 滑出式窗口
        let okPressed = openPanel.runModal() == .OK
        if okPressed {
            for url in openPanel.urls {
                let path = url.path
                dataBlock(NSData(contentsOfFile: path))
            }
        }
    }
    
    static func remove(model:ClassTypeModel, list: inout [ClassTypeModel]) {
        let index =  list.lastIndex {$0.classType == model.classType}
        if let index = index {
            list.remove(at: index)
        }
        
        saveAll(list: list)
    }
    
    static func saveAll(list: [ClassTypeModel]) {
        var arr = [String]()
        for item in list {
            arr.append(item.classType)
            UserDefaultsManger.manager().setValue(ClassTypeModel.toDict(model:item), forKey: item.classType)
        }
        UserDefaultsManger.manager().setValue(arr, forKey: "allKey")
        print(arr)
    }
    
    
    
    static func find() -> [ClassTypeModel]{
        var modelList = [ClassTypeModel]()
        let keys = UserDefaultsManger.manager().array(forKey: "allKey") as? Array<String> ?? [String]()
        for key in keys {
            let lazyCoder = UserDefaultsManger.manager().object(forKey: key) as? Dictionary<String, String>
            if let lazyCoder = lazyCoder {
                let model = ClassTypeModel.toModel(dict: lazyCoder)
                modelList.append(model)
            }
        }
        return modelList
    }
    
    static func exchange(){
        let keys = UserDefaultsManger.manager().array(forKey: "allKey") as? Array<String> ?? [String]()
        for key in keys {
            if let model = locationLazyCoder(key: key) {
                let str = transformLazyCoderToKeyString(model: model)
                print(str)
            }
        }
    }
    
    static func locationHave(className: String) -> Bool {
        let keys = UserDefaultsManger.manager().array(forKey: "allKey") as? Array<String> ?? [String]()
        if keys.contains(className) {
            return true
        }
        return false
    }
    
    static func locationLazyCoder(key: String) -> ClassTypeModel?{
        let lazyCoder = UserDefaultsManger.manager().object(forKey: key) as? Dictionary<String, String>
        if let lazyCoder = lazyCoder {
            let model = ClassTypeModel.toModel(dict: lazyCoder)
            return model
        }
        return nil
    }
    
    static func transformLazyCoderToKeyString(model: ClassTypeModel) -> String{
        var coder = model.lazy
        coder = coder.replacingOccurrences(of: model.memberVarName, with: "成员变量名",options: String.CompareOptions.literal)
        coder = coder.replacingOccurrences(of: model.propertyName, with: "属性名",options: String.CompareOptions.literal)
        coder = coder.replacingOccurrences(of: model.classType, with: "类名",options: String.CompareOptions.literal)
        return coder
    }
}

