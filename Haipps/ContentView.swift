//
//  ContentView.swift
//  Haipps
//
//  Created by Omid Shojaeian Zanjani on 10/05/23.
//

import SwiftUI

struct ContentView: View {
    @State var yOffset:CGFloat = 40
    let range:ClosedRange<CGFloat> = -120...140
    var percentage : Double {
        var percentage = (yOffset + abs(range.lowerBound)) / (range.upperBound + abs(range.lowerBound))
        percentage = percentage * 2 - 1
        print(percentage)
        return percentage
    }
    var body: some View {
        ZStack{
            
            // now we have to add colors depends on the mood we have ...
            Color.yellow.ignoresSafeArea()
            Color.green.opacity(percentage).ignoresSafeArea()
            Color.red.opacity(-percentage).ignoresSafeArea()
            VStack {
                Text("How is your Day?")
                    .font(.system(size: 15, weight: .bold))
                
                Smile(yOffset: yOffset)
                    .stroke( Color.black, lineWidth: 5)
                    .frame(height: 500)
                
                Slider(value: $yOffset, in: range )
            }
            .padding()
        }
        
    }
}

struct Smile:Shape{
    let yOffset:CGFloat
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let spacing: CGFloat = 180.0
        
        
        // THis is the left eye
        path.addPath(getEye(path, rect: rect))
        path = path.applying(.init(scaleX: -1, y: 1))
        path = path.applying(.init(translationX: rect.maxX - spacing, y: 0))
        
        // this is the right eye
        // THis is the left eye
        path.addPath(getEye(path, rect: rect))
        path = path.applying(.init(translationX: spacing / 2 , y: 0))
         
        // moving eyes up
        // this adds more movement to the eyes
        path = path.applying(.init(translationX: 0, y: -150 + yOffset / 4))
        
        // mounth
        path.addPath(getMonth(path, rect: rect))
        return path
    }
    
    func getMonth(_ path:Path, rect:CGRect)->Path{
        var path = Path()
        
        let startPoint = CGPoint(x: rect.minX, y: rect.midY)
        let endPoint = CGPoint(x: rect.maxX, y: rect.midY)
        
        let controlPtn1 = CGPoint(x: startPoint.x ,
                                  y: rect.midY + yOffset)
        let controlPtn2 = CGPoint(x: endPoint.x ,
                                  y: rect.midY + yOffset)
        
        path.move(to: startPoint)
        //path.addLine(to: endPoint)
        path.addCurve(to: endPoint , control1: controlPtn1, control2: controlPtn2)
        
        return path
    }
    func getEye(_ path:Path, rect:CGRect)-> Path {
        var path = path
        // eye
        //-------------------------------------------------------
        let startPoint = CGPoint(x: rect.midX - 50,
                                 y: rect.midY)
        //-------------------------------------------------------
        let bottomPoint = CGPoint(x: startPoint.x + 50 ,
                                  y: startPoint.y + 50 )
        //-------------------------------------------------------
        let controlPtn1 = CGPoint(x: startPoint.x,
                                  y: bottomPoint.y )
        //-------------------------------------------------------
        let rightPtn = CGPoint(x: startPoint.x + 100,
                               y: startPoint.y - 30)
        //-------------------------------------------------------
        let controlPtn2 = CGPoint(x: rightPtn.x,
                                  y: bottomPoint.y)
        //-------------------------------------------------------
        let offset:CGFloat = yOffset / 5
        //-------------------------------------------------------
        let controlPtn3 = CGPoint(x: rightPtn.x - 5 ,
                                  y: rightPtn.y - offset )
        //-------------------------------------------------------
        let controlPtn4 = CGPoint(x: startPoint.x + 5 ,
                                  y: rightPtn.y - offset )
        /// Drawing part here 👇
        path.move(to: startPoint)
        path.addQuadCurve(to: bottomPoint, control: controlPtn1)
        path.addQuadCurve(to: rightPtn, control: controlPtn2)
        path.addCurve(to: startPoint, control1: controlPtn3, control2: controlPtn4)
        //-------------------------------------------------------
        // this is just to visualize the control points
//         let size = CGSize(width: 5, height: 5)
//        path.addEllipse(in: CGRect(origin: controlPtn1, size: size))
//        path.addEllipse(in: CGRect(origin: controlPtn2, size: size))
//
//        path.addEllipse(in: CGRect(origin: controlPtn3, size: size))
//        path.addEllipse(in: CGRect(origin: controlPtn4, size: size))
        return path
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
