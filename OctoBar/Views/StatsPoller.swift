//
//  PolledStats.swift
//  OctoBar
//
//  Created by Paul Sabatino on 1/1/21.
//

import Foundation

class StatsPoller: ObservableObject {
    
    @Published var complete: Double = 0
    @Published var bed: Float = 0.0
    @Published var nozzle: Float = 0.0
    @Published var state = ""
    @Published var stateMessage = ""
    @Published var file = ""
    @Published var printTime = 0
    @Published var printTimeLeft = 0
    @Published var printTimeDisplay = ""
    @Published var printTimeLeftDisplay = ""
    
    
    
    var ip : String?
    var api : String?
    
    var url : URL?
    
    var timer = Timer()
    
    
    func start (ip: String, api: String) {
        self.ip = ip
        self.api = api
        
        
        if let url = URL(string:"http://\(ip)/api/job") {
            var request = URLRequest(url: url)
            request.setValue("Bearer \(self.api!)", forHTTPHeaderField: "Authorization")
            request.httpMethod = "GET"
                
            self.pollStatus(withRequest: request)
            self.timer = Timer.scheduledTimer(withTimeInterval: Constants.POLLING_INTERVAL, repeats: true) {_ in
                self.pollStatus(withRequest: request)
            }
        }
        
    }
    
    func stop() {
        timer.invalidate()
    }
 
    
    func pollStatus(withRequest request: URLRequest ) {
                
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                print("ERROR: \(error)")
                return
            }
                    
            
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
//                print("Response data string:\n \(dataString)")
                let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                    if let responseJSON = responseJSON as? [String: Any] {
                        print(responseJSON)
                        print("State: \(responseJSON["state"]!)")
                        
                        var state = "unknown"
                        var stateMessage = ""
                        var completion = 0.0
                        var filename = ""
                        var printTime = 0
                        var printTimeLeft = 0
                                                                        
                        let stateFull = responseJSON["state"] as? String ?? "Unknown"
                        let halves = stateFull.split(separator: " ",maxSplits: 1)
                        state = String(halves[0])
                        if (halves.count == 2) {
                            stateMessage = String(halves[1])
                        }
                                                
                        
                        if let progress = responseJSON["progress"] as? [String: Any]  {
                            completion = progress["completion"] as? Double ?? 0.0
                            printTime =  progress["printTime"] as? Int ?? 0
                            printTimeLeft =  progress["printTimeLeft"] as? Int ?? 0
                        }
                        
                        if let job = responseJSON["job"] as? [String: Any]  {
                            if let file = job["file"] as? [String: Any]  {
                                filename = file["display"] as? String ?? "None"
                            } else {
                                filename = "None"
                            }
                        } else {
                            filename = "None"
                        }
                        
                        let printTimeDuration: TimeInterval  = Double(printTime)
                        let printTimeLeftDuration: TimeInterval = Double(printTimeLeft)
                        
                        let formatter = DateComponentsFormatter()
                        formatter.unitsStyle = .brief
                        formatter.allowedUnits = [.hour, .minute]
                        formatter.zeroFormattingBehavior = [.dropLeading]
                        
                        DispatchQueue.main.async {
                            self.complete = completion
                            self.state = state
                            self.stateMessage = stateMessage
                            self.file = filename
                            self.printTime = printTime
                            self.printTimeLeft = printTimeLeft
                            self.printTimeDisplay = formatter.string(from: printTimeDuration) ?? "NA"
                            self.printTimeLeftDisplay = formatter.string(from: printTimeLeftDuration) ?? "NA"
                        }
                        
                        let printerState = PrinterState()
                        printerState.complete = completion
                        printerState.state = state
                        
                        NotificationCenter.default.post(name: .didReceiveCompletion, object: printerState)
                        
                    }
            }            
        }
        task.resume()
    }
    
}
