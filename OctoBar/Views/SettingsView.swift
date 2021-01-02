//
//  SettingsView.swift
//  OctoBar
//
//  Created by Paul Sabatino on 1/1/21.
//

import SwiftUI

struct SettingsView: View {
    
    @State var ipAddress  = ""
    @State var apiKey  = ""
    @State var message  = " "
    
    init() {
        let ip = UserDefaults.standard.string(forKey: Constants.SETTING_IPADDRESS) ?? ""
        _ipAddress = State<String>.init(initialValue:ip)
        
        let api = UserDefaults.standard.string(forKey: Constants.SETTIMG_API_KEY) ?? ""
        _apiKey = State<String>.init(initialValue: api)
        
    }
    
    var body: some View {
        
        VStack() {
            Form {
                Section(header: Text("OctoPrint Connection").font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)) {
                    TextField("IP Address", text: $ipAddress)
                    TextField("API Key", text: $apiKey)
                }

                Text("\(message)").foregroundColor(.red)

            }.padding()
            
            Button("Save") {
                saveSettings()
            }
            
            
            Spacer()
            
            Button("Quit") {
                exit(0)
            }.padding()
        }
    }
    
    func validateSettings() -> Bool {
        guard self.ipAddress != "" else {
            self.message = "IP Address is required"
            return false
        }
        
        guard self.apiKey != "" else {
            self.message = "API Key is required"
            return false
        }
        
        self.message = ""
        return true
        
    }
    
    
    
    func saveSettings() {
        
        guard validateSettings() else {
            return
        }
        
        UserDefaults.standard.setValue(self.ipAddress, forKey: Constants.SETTING_IPADDRESS)
        UserDefaults.standard.setValue(self.apiKey, forKey: Constants.SETTIMG_API_KEY)
        
    }
    
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
