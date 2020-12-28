//
//  JVDigitalDisplay.swift
//  
//
//  Created by Jan Verrept on 29/12/2019.
//

import Foundation
import SwiftUI
import Combine

public struct DigitalDisplayView:View{
    let linesToDisplay:[String]
    let backLightOn:Bool
    let color:Color
    
    // Memberwise initialiser would be Internal by default,
    // provide a pulic one for use outside of this module
    public init(linesToDisplay:[String], backLightOn:Bool, color:Color){
        self.linesToDisplay = linesToDisplay
        self.backLightOn = backLightOn
        self.color = color
    }
    
    public var body: some View {
        ZStack{
            BackgroundLight(color: color, backLightOn: backLightOn)
            LCD(lines:linesToDisplay)
            Glass()
            Bezel()
        }.padding()
    }
}


// MARK: - Subviews/Components
extension DigitalDisplayView{
    
    struct Bezel:View{
        public var body: some View {
            RoundedRectangle(cornerRadius: 20,style: .continuous).strokeBorder(Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)), lineWidth: 10)
        }
    }
    
    struct Glass:View{
        
        public var body: some View {
            GeometryReader { geometry in
                Path { path in
                    path.addArc(center: .init(x: geometry.size.width, y: geometry.size.height), radius: geometry.size.height*1.2, startAngle: Angle(degrees: 180.0), endAngle: Angle(degrees:90.0), clockwise: false)
                }.brightness(0.2)
                .opacity(0.1)
                .clipped()
            }
        }
    }
    
    struct LCD:View{
        var lines: [String]
        public var body: some View {
            GeometryReader { geometry in
                VStack{
                    ForEach(lines, id: \.self) { line in
                        HStack{
                            
                            Text(line)
                                .font(.custom("Technology", size:(geometry.size.height-20)/CGFloat(max( 1,lines.count))))
                                .italic()
                                .foregroundColor(Color(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)))
                                .shadow(radius: 10)
                            
                            Spacer()
                        }
                    }
                }.padding(10)
            }
        }
    }
    
    
    struct BackgroundLight:View{
        var color:Color
        var backLightOn:Bool
        
        public var body: some View {
            
            let darkColor:Color = color //Color(NSColor(color).darker(amount: 0.5))
            var gradientBaseColor:Color
            var gradientColors: [Color] = []
            
            if !backLightOn{
                gradientBaseColor = darkColor
            }else{
                gradientBaseColor = color
            }
            
            gradientColors.append(gradientBaseColor)
            gradientColors.append(Color(NSColor(gradientBaseColor).lighter(amount: 0.25)))
            gradientColors.append(gradientBaseColor)
            gradientColors.append(Color(NSColor(gradientBaseColor).darker(amount: 0.25)))
            
            let gradient = Gradient(colors: gradientColors)
            let backGroundLight = LinearGradient(gradient: gradient, startPoint: .top, endPoint: .bottom)
            return RoundedRectangle(cornerRadius: 20,style: .continuous).fill(backGroundLight)
        }
        
    }
}

// MARK: - Previews
struct JVDigitalDisplay_Previews: PreviewProvider {
    static var previews: some View {
        
        Group {
            DigitalDisplayView(linesToDisplay: ["0123456789", "LightScheme"], backLightOn: true, color: Color(#colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)))
                .frame(width: 400, height: 200, alignment: .center)
                .environment(\.colorScheme, .light)
            
            DigitalDisplayView(linesToDisplay: ["0123456789", "DarkScheme"], backLightOn: true, color: Color(#colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)))
                .frame(width: 400, height: 200, alignment: .center)
                .environment(\.colorScheme, .dark)
            
        }
    }
    
}


// MARK: - Add this view to the XCode-library for reuse
struct LibraryContent: LibraryContentProvider {
    @LibraryContentBuilder
    var views: [LibraryItem] {
        LibraryItem(
            DigitalDisplayView(linesToDisplay: ["0123456789", "ABCDEFGHIJ"], backLightOn: true, color: Color(#colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1))),
            category: .control
        )
    }
}

