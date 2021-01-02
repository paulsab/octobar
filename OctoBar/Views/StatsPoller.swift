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
                                                                        
                        let stateFull = responseJSON["state"] as? String ?? "Unknown"
                        let halves = stateFull.split(separator: " ",maxSplits: 1)
                        state = String(halves[0])
                        if (halves.count == 2) {
                            stateMessage = String(halves[1])
                        }
                                                
                        
                        if let progress = responseJSON["progress"] as? [String: Any]  {
                        
                            if let completionFloat = progress["completion"] as? Double {
                                completion = completionFloat
                            } else {
                                completion = 0
                            }
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
                        
                        
                        DispatchQueue.main.async {
                            self.complete = completion
                            self.state = state
                            self.stateMessage = stateMessage
                            self.file = filename
                        }
                        
                        NotificationCenter.default.post(name: .didReceiveCompletion, object: completion)
                        
                    }
            }            
        }
        task.resume()
    }
    
}
