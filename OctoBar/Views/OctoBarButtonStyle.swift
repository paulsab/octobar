//
//  OctoBarButtonStyle.swift
//  OctoBar
//
//  Created by Paul Sabatino on 1/2/21.
//

import SwiftUI

struct OctoBarButtonStyle: ButtonStyle {
    var color: Color = .green
    
    public func makeBody(configuration: OctoBarButtonStyle.Configuration) -> some View {
        
        configuration.label
            .foregroundColor(.white)
            .padding(10)
            .background(RoundedRectangle(cornerRadius: 8).fill(color))
            .compositingGroup()
//            .shadow(color: .black, radius: 3)
            .opacity(configuration.isPressed ? 0.5 : 1.0)
            .scaleEffect(configuration.isPressed ? 0.8 : 1.0)
            .fixedSize()
            
    }
}
