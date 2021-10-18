//
//  LazyContentView.swift
//  MacExtensionTool
//
//  Created by sharui on 2021/7/6.
//

import Foundation
import SwiftUI

struct LefeTitle : View{
    var selected : Bool
    var title: String
    var click: ()->Void
    var body: some View {
        HStack {
            Text(title).padding()
            Spacer()
        }
        .background(RoundedCorners(color: selected ? Color("SystemGray") : Color("white") , tl: 10, tr: 10, bl: 10, br: 10))
        .font(.title2)
        .onTapGesture {
            self.click()
        }
    }
}

struct CustomNavigationView: View {
    @EnvironmentObject var lazyModel : LazyModel
//    @Binding var refresh: Bool;
    @ObservedObject var typeModel: ClassTypeModel
    
    var body: some View {
        HStack {
          
                List(lazyModel.typeModelList, id:(\.self.id)) { item in
                    let hasClassType = item.classType.count > 0
                    LefeTitle(selected: item.selected, title:hasClassType ? item.classType : item.placeholder) {
                        selected(model: item)
                    }.frame(width: 300)
                }.frame(width: 300)
                
            if (lazyModel.typeModelList.count > 0) {
                LazyCodeView(item: typeModel,removeBlock: { model in
                    LocationManger.remove(model: model, list: &lazyModel.typeModelList)
                    if let lastModel = lazyModel.typeModelList.last {
                        selected(model: lastModel)
                    }
                },saveBlock: { model in
                    save(model: model)
    //                refresh.toggle()
                }).background(Color("white"))
            }else {
                LazyEmptyView(clickBlock: {
                    self.addItem()
                }).frame(minWidth: 600)
            }
            
        }
        .toolbar {
            Button(action: addItem) {
                Text("添加")
             }
            Button(action: input) {
                Text("导入")
             }
            Button(action: output) {
                Text("导出")
             }
        }
    }
    
    private func selected(model:ClassTypeModel) {
        lazyModel.selected(model: model)
        showEditModel(leftModel: model, editModel: typeModel)
    }
    
    private func showEditModel(leftModel:ClassTypeModel, editModel:ClassTypeModel) {
        editModel.classType = leftModel.classType
        editModel.propertyName = leftModel.propertyName
        editModel.memberVarName = leftModel.memberVarName
        editModel.lazy = leftModel.lazy
        editModel.index = leftModel.index
        editModel.selected = leftModel.selected
        print(editModel.classType)
    }
    
    private func addItem() {
        if self.lazyModel.typeModelList.last?.classType.count == 0 {
            return
        }
        let model = ClassTypeModel()
        model.index = "\(self.lazyModel.typeModelList.count)"
        self.lazyModel.typeModelList.append(model)
        LocationManger.saveAll(list: self.lazyModel.typeModelList)
        selected(model: model)
    }
    
    private func input() {
        LocationManger.input()
        self.lazyModel.typeModelList = LocationManger.find()
        if let model = self.lazyModel.typeModelList.first {
            selected(model: model)
        }
    }
    
    private func output() {
        LocationManger.output(list: self.lazyModel.typeModelList)
    }
    
    private func save(model:ClassTypeModel) {
        guard let index = Int(model.index) else {
            return
        }
        
        let model1 = ClassTypeModel()
        model1.classType = model.classType
        model1.propertyName = model.propertyName
        model1.memberVarName = model.memberVarName
        model1.lazy = model.lazy
        model1.index = model.index
        model1.selected = model.selected
        
        self.lazyModel.typeModelList[index] = model1
        
        LocationManger.saveAll(list: self.lazyModel.typeModelList)
        selected(model: model1)
    }
}

struct MainView: View {
    @EnvironmentObject var lazyModel : LazyModel
    var model : ClassTypeModel
    @State var refresh = false
    var body: some View {
        CustomNavigationView(typeModel: model)
    }
}


struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CustomNavigationView(typeModel: ClassTypeModel()).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        }
    }
}
