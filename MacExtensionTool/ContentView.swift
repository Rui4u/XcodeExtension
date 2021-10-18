//
//  ContentView.swift
//  MacExtensionTool
//
//  Created by sharui on 2021/3/18.
//

import SwiftUI
import AppKit
import CoreData

struct ContentView: View {
    var body: some View {
        let a = findFirstAndSelected()
        MainView(model: a.0).environmentObject(a.1)
    }
    
    func findFirstAndSelected() -> (ClassTypeModel,LazyModel) {
        let lazyModel = LazyModel()
        var classTypeModel = ClassTypeModel()
        if let model = LazyModel().typeModelList.first  {
            classTypeModel = model
            classTypeModel.selected = true;
            lazyModel.typeModelList[0].selected = true;
        }
        return (classTypeModel, lazyModel)
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        }
    }
}



