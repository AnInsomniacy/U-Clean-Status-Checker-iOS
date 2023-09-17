//
//  ContentView.swift
//  U Clean Checker
//
//  Created by Sekiro on 16/9/2023.
//

import SwiftUI
import Foundation


struct ContentView: View {
    @State var greetingText = "Welcome to\nU Clean Status Checker"
    
    var buildingList = ["下滑选择","东十九", "西一"]
    var brandList = ["下滑选择","常工", "兆基"]
    
    @State private var selectedBuilding = UserDefaults.standard.string(forKey: "SelectedBuilding") ?? "未选择楼栋"
    @State private var selectedBrand = UserDefaults.standard.string(forKey: "SelectedBrand") ?? "未选择品牌"
    
    @State private var isChecking = false
    @State private var CheckButtonText = "开始查询"
    @State private var isCleared = false
    
    
    @State private var isBuildingPickerPresented = false // 用于控制宿舍楼选择器的显示
    @State private var isBrandPickerPresented = false // 用于控制品牌选择器的显示
    @State private var isBearerPresented = false // 用于控制Bearer输入框的显示
    
    
    @State var GlobalBearer = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhcHBVc2VySWQiOiJvZ3lSVDF1M0dlZU9OV2N5SGdHekZYM3RoLVVNIiwiZXhwIjoxNzAyMjgzNTg4LCJpYXQiOjE2OTQyNDgzODgsImlkIjozMDE5NDgzMiwibmFtZSI6IjE5ODc2NTc2NzY4In0.N83KdLj5-3DuyaY4-n9lsocUpq71QwnCvB4Ox7FL1D0"
    
    //查询结果
    @State private var GlobalResult = "等待查询指令..."
    
    
    //加载保存的持久化数据
    init() {
        if let savedBuilding = UserDefaults.standard.string(forKey: "SelectedBuilding") {
            _selectedBuilding = State(initialValue: savedBuilding)
        }
        if let savedBrand = UserDefaults.standard.string(forKey: "SelectedBrand") {
            _selectedBrand = State(initialValue: savedBrand)
        }
        if let savedBearer = UserDefaults.standard.string(forKey: "Bearer") {
            _GlobalBearer = State(initialValue: savedBearer)
        }
    }

    
    var body: some View {
        VStack {
            Text(greetingText)
                .font(.title)
                .foregroundColor(.purple)
                .padding()
                .multilineTextAlignment(.center)
            
            HStack{
                VStack{
                    Button("选择楼栋") {
                        isBuildingPickerPresented.toggle()
                    }
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.purple)
                    .cornerRadius(10)
                    .sheet(isPresented: $isBuildingPickerPresented) {
                        // 宿舍楼选择器弹出后的内容
                        VStack {
                            Text("选择宿舍楼")
                                .font(.title)
                                .padding()
                            
                            Picker("宿舍楼", selection: $selectedBuilding) {
                                ForEach(buildingList, id: \.self) { building in
                                    Text(building)
                                        .tag(building)
                                }
                            }
                            .pickerStyle(WheelPickerStyle()) // 选择器样式，可以根据需要修改
                            
                            Button("确定选择") {
                                // 用户点击确定按钮后的操作
                                UserDefaults.standard.set(selectedBuilding, forKey: "SelectedBuilding")
                                // 保存用户选择的宿舍楼
                                
                                isBuildingPickerPresented.toggle() // 关闭选择器
                            }
                            .padding().foregroundColor(.white).background(Color.purple).cornerRadius(10)
                        }
                    }
                    Text("楼栋:")
                    Text(selectedBuilding)
                }
                
                VStack{
                    Button("选择品牌") {
                        isBrandPickerPresented.toggle()
                    }
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.purple)
                    .cornerRadius(10)
                    .sheet(isPresented: $isBrandPickerPresented) {
                        // 宿舍楼选择器弹出后的内容
                        VStack {
                            Text("选择品牌")
                                .font(.title)
                                .padding()
                            
                            Picker("品牌", selection: $selectedBrand) {
                                ForEach(brandList, id: \.self) { brand in
                                    Text(brand)
                                        .tag(brand)
                                }
                            }
                            .pickerStyle(WheelPickerStyle()) // 选择器样式，可以根据需要修改
                            
                            Button("确定选择") {
                                // 用户点击确定按钮后的操作
                                UserDefaults.standard.set(selectedBrand, forKey: "SelectedBrand")
                                // 保存用户选择的宿舍楼
                                
                                isBrandPickerPresented.toggle() // 关闭选择器
                            }
                            .padding().foregroundColor(.white).background(Color.purple).cornerRadius(10)
                        }
                    }
                    Text("品牌:")
                    Text(selectedBrand)
                }
                VStack{
                    Button("清空配置"){
                        UserDefaults.standard.set("未选择楼栋", forKey: "SelectedBuilding")
                        UserDefaults.standard.set("未选择品牌", forKey: "SelectedBrand")
                        selectedBuilding = "未选择楼栋"
                        selectedBrand = "未选择品牌"
                        isCleared = true
                    }.padding().foregroundColor(.white).background(Color.purple).cornerRadius(10)
                    Text("状态:")
                    Text(isCleared ? "已清空" : "未清空")
                }
            }
            
            HStack{
                Button("配置令牌"){
                    //设置令牌代码
                    //弹出输入窗口
                    isBearerPresented.toggle()
                    
                }.padding().foregroundColor(.white).background(Color.purple).cornerRadius(10).sheet(isPresented: $isBearerPresented){
                    // 输入窗口内容
                    VStack {
                        Text("配置U净访问令牌")
                            .font(.largeTitle)
                            .bold()
                            .padding(.bottom, 20)
                        
                        TextField("请输入令牌", text: $GlobalBearer)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal, 20)
                            .padding(.bottom, 30)
                        
                        Button("清空输入框") {
                            GlobalBearer = ""
                        }.padding()
                            .background(Color.purple)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        
                        Button("保存访问令牌") {
                            // 在这里添加保存令牌的代码
                            // 你可以使用 $token 来获取用户输入的令牌
                            // 例如：保存到UserDefaults或其他地方
                            UserDefaults.standard.set(GlobalBearer, forKey: "Bearer")
                            isBearerPresented.toggle() // 关闭输入窗口
                        }
                        .padding()
                        .background(Color.purple)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        
                        Button("使用默认令牌(可能过期)"){
                            GlobalBearer="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhcHBVc2VySWQiOiJvZ3lSVDF1M0dlZU9OV2N5SGdHekZYM3RoLVVNIiwiZXhwIjoxNzAyMjgzNTg4LCJpYXQiOjE2OTQyNDgzODgsImlkIjozMDE5NDgzMiwibmFtZSI6IjE5ODc2NTc2NzY4In0.N83KdLj5-3DuyaY4-n9lsocUpq71QwnCvB4Ox7FL1D0"
                            UserDefaults.standard.set(GlobalBearer, forKey: "Bearer")
                        }.padding().foregroundColor(.white).background(Color.purple).cornerRadius(10)
                    }
                    .padding()
                }
                
                //开始查询
                Button(action: {
                    // 在按钮点击时禁用按钮和更改文本
                    isChecking = true
                    CheckButtonText = "正在查询"
                    
                    GlobalResult=""
                    var MachineListForCheck: [String] = [] //用于存储要查询的机器列表
                    
                    //判断要查询的机器组
                    switch selectedBuilding {
                    case "东十九":
                        switch selectedBrand {
                        case "常工":
                            MachineListForCheck = D19_ChangGong
                        case "兆基":
                            MachineListForCheck = D19_ZhaoJi
                        default:
                            GlobalResult="暂不支持该查询组合"
                        }
                    case "西一":
                        GlobalResult="暂不支持该查询组合"
                    default:
                        GlobalResult="暂不支持该查询组合"
                    }
                    
                    Task {
                        do {
                            let MultipleMachinesResult = try await MultipleMachinesChecker(machineUrlList: MachineListForCheck, Global_Bearer: GlobalBearer)
                            if MultipleMachinesResult != "" {
                                GlobalResult = MultipleMachinesResult
                            }
                        
                        } catch {
                            print("发生错误：\(error)")
                        }
                        
                        // 在异步任务完成后恢复按钮和文本
                        isChecking = false
                        CheckButtonText = "开始查询"
                    }
                }) {
                    Text(CheckButtonText)
                        .padding()
                        .foregroundColor(.white)
                        .background(isChecking ? Color.gray : Color.purple)
                        .cornerRadius(10)
                }
                
                //关于作者
                Button("使用教程"){
                    //关于作者代码
                    var tempResult = ""
                    tempResult += "项目GitHub地址： \n"
                    tempResult += "https://github.com/lriley26/U-Clean-Status-Checker-iOS \n\n"
                    tempResult += "当程序提示令牌失效时，请点击左侧按钮重新配置令牌。 \n\n"
                    tempResult += "请通过抓包软件截取并分析Bearer令牌，然后填入程序并保存。 \n\n"
                    tempResult += "如果不会抓包分析，当令牌失效时，作者会在GitHub更新Bearer,请多加留意 \n\n"
                    tempResult += "本程序为华南师范大学石牌校区宿舍洗衣机查询程序 \n"
                    tempResult += "目前仅支持部分宿舍楼查询 \n"
                    tempResult += "如有问题请联系作者 \n\n"
                    tempResult += "本程序仅供交流学习使用，严禁用于非法用途 \n"
                    
                    GlobalResult = tempResult
                    
                }.padding().foregroundColor(.white).background(Color.purple).cornerRadius(10)
            
            }
            Text("查询结果").font(.title).padding().foregroundColor(.purple)
            //显示查询结果
            HStack{
                ScrollView {
                    Text(GlobalResult)
                }
            }
        }
        .padding()
    }
}



    
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

