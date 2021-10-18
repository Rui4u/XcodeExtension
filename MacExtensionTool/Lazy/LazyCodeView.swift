//
//  LazyCodeView.swift
//  MacExtensionTool
//
//  Created by sharui on 2021/7/6.
//

import SwiftUI
import Combine
struct LazyEmptyView:View {
    var clickBlock: ()->(Void)
    var body: some View {
        HStack {
            VStack {
                Spacer()
                Text("""
                    添加你的第一个懒加载
                    """)
                    .font(.largeTitle)
                    .frame(alignment: .leading)
                    .padding()
                Text("""
                    LazyForXcode"现在可以在Xcode Source Editor 中使用。
                    另外，请确保在系统偏好设置的扩展>Xoode Souroe Editor遮项中启用 LazyForXcode。
                    可以点击"添加"按钮生成属于你自己的懒加载模板，点击保存即可。
                    只需要配置一次，既可以关闭此程序。
                    """)
                    .frame(alignment: .leading)
                    .padding()
                    .lineSpacing(15)
                Button(action: {
                    clickBlock()
                }, label: {
                    Image.init(systemName: "plus")
                        
                }).frame(width: 100, height: 100)
                Spacer()
            }
            Spacer()
        }
    }
}

struct LazyCodeViewForTextFiled: View {
    var title: String
    @Binding var name: String
    var placeholder: String
    var body: some View {
        HStack() {
            Text(title)
                .font(.system(size: 16, weight: .bold, design: .default))
                .frame(width: 100,alignment: .leading)
                .padding()
            TextField(placeholder, text: $name).padding(.trailing,10)
                .font(.system(size: 14))
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
        .background(RoundedCorners(color: Color("SystemGray"), tl: 10, tr: 10, bl: 10, br: 10))
        .padding(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5))
        .font(.title2)
    }
}



struct LazyCodeViewForTextEditor: View {
    var title: String
    @Binding var text: String
    var body: some View {
        VStack {
            HStack {
                Text(title)
                    .font(.system(size: 16, weight: .bold, design: .default))
                    .frame(alignment: .leading)
                    .padding()
                Spacer()
            }
            TextEditor(text: $text)
                .padding([.leading,.trailing,.bottom], 10)
        }.background(RoundedCorners(color: Color("SystemGray"), tl: 10, tr: 10, bl: 10, br: 10))
        .padding(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5))
        .font(.title2)
    }
}

struct LazyCodeViewForBottomBar: View {
    var removeBlock: ()->(Void)
    var saveBlock: ()->(Void)
    var body: some View {
        HStack {
            Spacer()
            Button("删除", action:removeBlock).padding()
            Button("保存", action:saveBlock).padding()
            Spacer()
        }
        .background(RoundedCorners(color: Color("SystemGray"), tl: 10, tr: 10, bl: 10, br: 10))
        .padding(EdgeInsets(top: 0, leading: 5, bottom: 10, trailing: 5))
    }
}

struct LazyCodeView: View  {
    @ObservedObject var item : ClassTypeModel
    var removeBlock: ((ClassTypeModel)->(Void))?
    var saveBlock: ((ClassTypeModel)->(Void))?
    
    var body: some View {
        VStack(spacing:0) {
            LazyCodeViewForTextFiled(title:"类名",name: $item.classType, placeholder: item.placeholder)
            LazyCodeViewForTextFiled(title:"属性名",name: $item.propertyName, placeholder: item.varNameplaceholder)
            LazyCodeViewForTextFiled(title:"成员变量名称",name: $item.memberVarName, placeholder: item.memberVarNamePlaceholder)
            LazyCodeViewForTextEditor(title: "懒加载代码", text: $item.lazy)
            Spacer()
            LazyCodeViewForBottomBar(removeBlock: {
                self.delete()
            }, saveBlock: {
                self.save()
            })
        }
    }
    func delete() {
        if let a = removeBlock {
            a(item)
        }
    }
    func save() {
        if let a = saveBlock {
            a(item)
        }
    }
}

//struct LazyCodeView_Previews: PreviewProvider {
//    static var previews: some View {
//        LazyCodeView(item: ClassTypeModel())
//    }
//}

struct LazyEmptyView_Previews: PreviewProvider {
    static var previews: some View {
        LazyEmptyView(clickBlock: {
            
        }).frame(width: 300, height: 300, alignment: .center)
    }
}



