//
//  JVDigitalDisplay.swift
//  
//
//  Created by Jan Verrept on 29/12/2019.
//

import Foundation
import SwiftUI
import Combine

@available(OSX 10.15, *)
public struct DigitalDisplayView:View{
    @ObservedObject public var model:DigitalDisplayModel
    @State private var linesToDisplay:[String] = []
    
    public init(model:DigitalDisplayModel){
        self.model = model
    }
    
    let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    
    public var body: some View {
        ZStack{
            BackgroundLight(backLightOn: $model.backLightOn)
            LCD(lines:linesToDisplay)
            Glass()
            Bezel()
        }.onReceive(timer) { _ in
            self.linesToDisplay = self.model.textLines
        }
    }
    
}

//@available(OSX 10.15, *)
//struct DigitalDisplayView_Previews: PreviewProvider {
//    static var previews: some View {
//        DigitalDisplayView()
//    }
//}

@available(OSX 10.15, *)
public struct Bezel:View{
    public var body: some View {
        RoundedRectangle(cornerRadius: 20,style: .continuous).strokeBorder(Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)), lineWidth: 10)
    }
}

@available(OSX 10.15, *)
public struct Glass:View{
    
    public var body: some View {
        Path { path in
            path.move(to: CGPoint(x: 300, y: 110))
            path.addArc(center: .init(x: 300, y: 110), radius: 120, startAngle: Angle(degrees: 180.0), endAngle: Angle(degrees: 360.0), clockwise: false)
        }.brightness(0.2).opacity(0.1).clipped()
    }
}

@available(OSX 10.15, *)
public struct LCD:View{
    var lines: [String]
    public var body: some View {
        VStack{
            ForEach(lines, id: \.self) { line in
                HStack{
                    Text(line).font(.custom("Technology", size: 24)).italic().foregroundColor(Color(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1))).padding(5)
                    Spacer()
                }
            }
            }.padding(10).multilineTextAlignment(.leading).shadow(radius: 10)
    }
}


@available(OSX 10.15, *)
public struct BackgroundLight:View{
    @Binding var backLightOn:Bool
    public var body: some View {
        let backLightColors:Gradient
        if backLightOn{
            backLightColors = Gradient(colors: [Color(#colorLiteral(red: 0.4793787132, green: 0.6737758619, blue: 0.1756879404, alpha: 1)),Color(#colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)),Color(#colorLiteral(red: 0.2997378409, green: 0.5897147059, blue: 0.1139934883, alpha: 1)),Color(#colorLiteral(red: 0.2531218827, green: 0.5225499868, blue: 0.07702929527, alpha: 1))])
        }else{
            backLightColors = Gradient(colors: [Color(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)),Color(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)),Color(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)),Color(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1))])
        }
        let backGroundLight = LinearGradient(gradient: backLightColors, startPoint: .top, endPoint: .bottom)
        return RoundedRectangle(cornerRadius: 20,style: .continuous).fill(backGroundLight).frame(width: nil, height: 120, alignment: .center)
    }
    
}

@available(OSX 10.15, *)
open class DigitalDisplayModel: ObservableObject {
    @Published open var textLines:[String] = []
    @Published open var backLightOn:Bool = true
    
    public init(){}
}

