//
//  LazyModel.swift
//  MacExtensionTool
//
//  Created by sharui on 2021/7/2.
//

import Foundation

class LazyModel: ObservableObject {
    @Published var typeModelList = LocationManger.find()
    func selected(model:ClassTypeModel) -> Void {
        for index in 0..<typeModelList.count {
            typeModelList[index].selected = false
        }
        model.selected = true
    }
}

class ClassTypeModel: Identifiable, ObservableObject{
    var id: String {
        self.classType
    }
    @Published var classType: String = ""
    @Published var propertyName: String = ""
    @Published var memberVarName: String = ""
    
    @Published var lazy: String = "请输入懒加载code"
    var placeholder: String = "请输入类名"
    var varNameplaceholder: String = "请输入属性名称"
    var memberVarNamePlaceholder: String = "请输入成员变量名"
    var index: String = ""
    var selected: Bool = false
    
    static func toDict(model: ClassTypeModel) -> Dictionary<String,String> {
        var dict = Dictionary<String,String>()
        dict["propertyName"] = model.propertyName
        dict["memberVarName"] = model.memberVarName
        dict["lazy"] = model.lazy
        dict["classType"] = model.classType
        dict["index"] = model.index
        return dict
    }
    
    static func toModel(dict: Dictionary<String,String>) -> ClassTypeModel {
        let model = ClassTypeModel();
        model.propertyName = dict["propertyName"] ?? "";
        model.memberVarName = dict["memberVarName"] ?? "";
        model.lazy = dict["lazy"] ?? "";
        model.classType = dict["classType"] ?? "";
        model.index = dict["index"] ?? ""
        return model
    }
}
