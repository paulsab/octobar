//
//  MonitorView.swift
//  OctoBar
//
//  Created by Paul Sabatino on 1/1/21.
//

import SwiftUI

struct MonitorView: View {
    @ObservedObject var stats = StatsPoller()

    init() {
        if let ip = UserDefaults.standard.string(forKey: Constants.SETTING_IPADDRESS),
           let api = UserDefaults.standard.string(forKey: Constants.SETTIMG_API_KEY)  {
            stats.start(ip: ip, api: api)
        }
    }

    var body: some View {
        VStack {
            HStack(alignment: VerticalAlignment.center) {
                VStack(alignment: .leading) {
                    
//                    HStack {
//                        Image("Icon")
//                    }.padding()
                    
                    HStack {
                        Text("File:")
                            .fontWeight(.bold)
                        Spacer()
                        Text("\(stats.file)")
                    }.padding()
                    
                    HStack {
                        Text("State:")
                            .fontWeight(.bold)
                        Spacer()
                        Text("\(stats.state)")
                    }.padding()
                    
                    HStack {
                        Text("Complete:")
                            .fontWeight(.bold)
                        
                        if #available(OSX 11.0, *) {
                            Spacer()
                            ProgressView(value: Float(stats.complete/100))
                            Text(String(format:"%.0f %%", stats.complete))
                        } else {
                            Spacer()
                            Text(String(format:"%.0f %%", stats.complete))
                        }
                    }.padding()
                }
            }
            HStack() {
                Button("Pause") {
                    
                }
                Button("Cancel") {
                    
                }
            }.padding()
        }
    }
}

struct MonitorView_Previews: PreviewProvider {
    static var previews: some View {
        MonitorView()
    }
}
