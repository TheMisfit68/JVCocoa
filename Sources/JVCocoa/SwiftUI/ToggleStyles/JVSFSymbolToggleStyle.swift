//
//  JVSFSymbolToggleStyle.swift
//  
//
//  Created by Jan Verrept on 24/11/2020.
//

import SwiftUI


public struct SFSymbolToggleStyle: ToggleStyle {
    
    let imageNameOn:String
    let colorOn:Color?
    let imageNameOff:String
    let colorOff:Color?

    public func makeBody(configuration: Self.Configuration) -> some View {
        
        HStack{
            Image(systemName: configuration.isOn ? imageNameOn: imageNameOff)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(configuration.isOn ? colorOn: colorOff ?? .secondary)
            Spacer()
            configuration.label
        }
    }
    
    public init(imageNameOn:String, colorOn:Color? = nil, imageNameOff:String, colorOff:Color? = nil){
        self.imageNameOn = imageNameOn
        self.colorOn = colorOn
        self.imageNameOff = imageNameOff
        self.colorOff = colorOff
    }
    
}
