import Foundation

// 使用 async 标记函数为异步函数，并返回结果数组的异步任务
func MachineStatusChecker(machineURL: String, Global_Bearer: String) async throws -> [Any] {
    let url = URL(string: "https://phoenix.ujing.online/api/v1/wechat/devices/scanWasherCode")!

    var request = URLRequest(url: url)
    request.httpMethod = "POST"

    let headers = [
        "Accept": "application/json, text/plain, */*",
        "Authorization": "Bearer " + Global_Bearer, // Global_Bearer需要在此之前定义
        "Accept-Language": "zh-CN,zh-Hans;q=0.9",
        "Accept-Encoding": "gzip, deflate, br",
        "Content-Type": "application/json; charset=utf-8",
        "x-app-code": "BCI",
        "Origin": "https://wx.zhinengxiyifang.cn",
        "User-Agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 15_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.33(0x18002121) NetType/WIFI Language/zh_CN",
        "Referer": "https://wx.zhinengxiyifang.cn/",
        "x-app-version": "0.1.40",
        "Connection": "keep-alive"
    ]

    for (key, value) in headers {
        request.setValue(value, forHTTPHeaderField: key)
    }

    let parameters = ["qrCode": machineURL]
    request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)

    // 使用 async/await 进行网络请求，并等待结果
    let (data, _) = try await URLSession.shared.data(for: request)

    
    // 解析 JSON 数据
    do {
        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
            
            if let code = json["code"] as? Int {
                if code == 401 {
                    print("token过期，无法获取状态，请等待作者更新")
                    return [false, "token过期，无法获取状态，请等待作者更新"]
                }
            }

            if let dataDict = json["data"] as? [String: Any] {
                if let result = dataDict["result"] as? [String: Any] {
                    if let canCreate = result["createOrderEnabled"] as? Bool,
                       let reason = result["reason"] as? String {
                        let resultArray: [Any] = [canCreate, reason]
                        print(resultArray)
                        return resultArray
                    }
                }
            }
        }
    } catch {
        print("Error parsing JSON: \(error.localizedDescription)")
    }

    return [false,"发生未知错误"] // 在出现错误时返回适当的值
}

func MultipleMachinesChecker(machineUrlList:[String],Global_Bearer:String) async throws -> String{
    var resultString = ""
    var floorCount = 1.5
    for machineURL in machineUrlList {
        let resultArray = try await MachineStatusChecker(machineURL: machineURL, Global_Bearer: Global_Bearer)
        if resultArray[0] as! Bool == false {
            resultString += "第\(floorCount)层洗衣机不可用，原因:\n" + (resultArray[1] as! String) + "\n\n"
        } else {
            resultString += "第\(floorCount)层洗衣机可用\n\n"
        }
        floorCount += 1
    }
    return resultString

}
