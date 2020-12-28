//
//  JVTwoViewsToggleStyle.swift
//  
//
//  Created by Jan Verrept on 24/11/2020.
//

import SwiftUI


public struct TwoViewsToggleStyle: ToggleStyle {
    
    let viewOn:AnyView
    let colorOn:Color?
    let viewOff:AnyView
    let colorOff:Color?
    
    public func makeBody(configuration: Self.Configuration) -> some View {
        
        return HStack{
            configuration.isOn ? viewOn.foregroundColor(colorOn) : viewOff.foregroundColor(colorOff)
            Spacer()
            configuration.label
        }
    }
    
    //FIXME: - AnyView can not except Views created on the callers side
    
    public init(viewOn:AnyView, colorOn:Color? = nil, viewOff:AnyView, colorOff:Color? = nil){
        self.viewOn = viewOn
        self.colorOn = colorOn
        self.viewOff = viewOff
        self.colorOff = colorOff
    }
    
}
