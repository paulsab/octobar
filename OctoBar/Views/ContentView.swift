//
//  ContentView.swift
//  OctoBar
//
//  Created by Paul Sabatino on 1/1/21.
//

import SwiftUI



struct ContentView: View {
    
    @State var selection = 1;
    
    init() {
        let ip = UserDefaults.standard.string(forKey: Constants.SETTING_IPADDRESS) ?? ""
        let api = UserDefaults.standard.string(forKey: Constants.SETTIMG_API_KEY) ?? ""
        
        if (ip == "" || api == "") {
            _selection = State<Int>.init(initialValue:2)
        }
    }
    
    
    var body: some View {
    
        TabView(selection: $selection) {
            MonitorView()
                .tabItem {
                    Text("Monitor")
                }
                .tag(1)
            
            SettingsView()
                .tabItem() {
                    Text("Settings")
                }
                .tag(2)
        }.padding()
    
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
