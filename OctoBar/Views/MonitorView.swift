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
                    }
                    
                    HStack {
                        Text("State:")
                            .fontWeight(.bold)
                        Spacer()
                        Text("\(stats.state)")
                    }
                    
                    HStack {
                        Text("Print Time:")
                            .fontWeight(.bold)
                        Spacer()
                        Text("\(stats.printTimeDisplay)")
                    }
                    
                    HStack {
                        Text("Print Time Left:")
                            .fontWeight(.bold)
                        Spacer()
                        Text("\(stats.printTimeLeftDisplay)")
                    }
                    
                    HStack {
                        Text("Complete:")
                            .fontWeight(.bold)
                        
                        if #available(OSX 11.0, *) {
                            Spacer()
                            ProgressView(value: Float(stats.complete/100))
                            Text(String(format:"%.0f %%", floor(stats.complete)))
                        } else {
                            Spacer()
                            Text(String(format:"%.0f %%", stats.complete))
                        }
                    }.padding()
                }
            }.padding()
            
            HStack() {
                Button(action: {}) {
                    HStack {
                        Text("Pause")
                        if #available(OSX 11.0, *) {
                            Image(systemName: "pause.fill").renderingMode(.template)
                        }
                    }
                }.buttonStyle(OctoBarButtonStyle(color: .blue))
                
                Button(action: {}) {
                    HStack {
                        Text("Cancel")
                        if #available(OSX 11.0, *) {
                            Image(systemName: "xmark.circle").renderingMode(.template)
                        }
                    }
                }.buttonStyle(OctoBarButtonStyle(color: .red))
                
                
                Button(action: {
                    if let ip = UserDefaults.standard.string(forKey: Constants.SETTING_IPADDRESS) {
                        let url = URL(string: "http://\(ip)")!
                        NSWorkspace.shared.open(url)
                    }
                }) {
                    HStack {
                        Text("Open Web")
                        if #available(OSX 11.0, *) {
                            Image(systemName: "safari").renderingMode(.template)
                        }
                    }
                    
                }.buttonStyle(OctoBarButtonStyle(color: .gray))
            }.padding()
            }
    }
}

struct MonitorView_Previews: PreviewProvider {
    static var previews: some View {
        MonitorView()
    }
}
