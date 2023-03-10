//
//  ContentView.swift
//  MyOwnCalculator
//
//  Created by eudier maxence on 08/03/2023.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.verticalSizeClass) var vericalSizeClass
    var isLandscape: Bool { vericalSizeClass == .compact}

    @ObservedObject var Calculator : CalculatorViewModel
    
    var body: some View {
        ZStack {
            Rectangle().foregroundColor(Color("Background")).ignoresSafeArea()
            if (isLandscape)
            {
                HStack {
                    Screen(Screen: Calculator.screen , _width: 400, _height: UIScreen.main.bounds.height - 100)
                    LazyVGrid(columns: [GridItem(), GridItem(), GridItem(), GridItem()]) {
                        ForEach(Calculator.buttons) { button in
                        CalculatorButton(button: button,  _fontSize: 30, _width: 60, _height: 60)
                                .onTapGesture {
                                    Calculator.Tap(button)
                                }
                        }
                    }
                    .padding(.horizontal, 80.0)
                }
            }
            else
            {
                VStack {
                    Spacer().frame(width: nil, height: 20, alignment: .center)
                    Screen(Screen: Calculator.screen)
                    Spacer().frame(width: nil, height: 50, alignment: .center)
                    LazyVGrid(columns: [ GridItem(.adaptive(minimum: 80))]) {
                        ForEach(Calculator.buttons) { button in
                            CalculatorButton(button: button)
                                .onTapGesture {
                                    Calculator.Tap(button)
                                }
                        }
                    }
                    .padding(.all, 10.0)
                }
            }
            
        }.edgesIgnoringSafeArea(.all)
    }
}

struct Screen : View {
    var Screen : CalculatorModel<String>.Screen
    var _content: String = "test"
    var _width : CGFloat = UIScreen.main.bounds.width - 80
    var _height : CGFloat = 200
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .frame(width: _width, height: _height, alignment: .center)
                .foregroundColor(Color("Background"))
                .modifier(ShadowIntern())
            HStack{
            Spacer().frame(width:  30, height: 20, alignment: .center)
                VStack {
                    Text(Screen.result)
                        .bold()
                        .font(.custom("Menlo-regular", size: 60))
                        .minimumScaleFactor(0.5)
                        .foregroundColor(Color("Background"))
                        .modifier(ShadowExtern(_radius: 1, _shadow: 2, _colorShadow: "TopShadow"))
                    Spacer().frame(width: nil, height: 60, alignment: .center)
                    Text(Screen.history)
                        .bold()
                        .font(.custom("Menlo-regular", size: 30))
                        .foregroundColor(Color("Background"))
                        .minimumScaleFactor(0.5)
                        .modifier(ShadowExtern(_radius: 1, _shadow: 2, _colorShadow: "TopShadow"))
                    
                }
                .frame(width: _width - 10, height: _height - 10, alignment: .center)
                
            Spacer().frame(width:  30, height: 20, alignment: .center)
            }
        }
    }
}


struct CalculatorButton : View {
    var button : CalculatorModel<String>.Button

    var _shadowRadius: CGFloat = 5
    var _contentColor : Color = .black
    var _fontSize: CGFloat = 40
    var _width: CGFloat = 80
    var _height: CGFloat = 80
    
    
    var body: some View {
        ZStack {
            
            let rec = RoundedRectangle(cornerRadius: 10)
                .fill(LinearGradient(gradient: Gradient(colors: [Color("Background"), Color("Light")]), startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: _width, height: _height, alignment: .center)
                .padding(2)
                
            if (!button.isTap)
            {
                rec.modifier(ShadowExtern())
            }
            else
            {
                rec.modifier(ShadowIntern())
            }
            
            Text(button.content)
                .foregroundColor(/*@START_MENU_TOKEN@*/Color("Background")/*@END_MENU_TOKEN@*/)
                .font(.custom("Menlo-regular", size: _fontSize))
                .modifier(ShadowExtern(_radius: 1, _shadow: 2, _colorShadow: "TopShadow"))
            
        }
        .padding(.all, 4.0)
        .foregroundColor(/*@START_MENU_TOKEN@*/Color("Background")/*@END_MENU_TOKEN@*/)
    }
}

struct ShadowExtern: ViewModifier {
    var _radius: CGFloat = 10
    var _shadow: CGFloat = 5
    var _colorShadow: String = "TopShadow"

    
    func body(content: Content) -> some View {
        return content
    .shadow(color: .white.opacity(0.5),radius: _radius , x: -_shadow, y: -_shadow)
            .shadow(color: Color(_colorShadow), radius: _radius, x: _shadow, y: _shadow)
    }
}

struct ShadowIntern: ViewModifier {
    var _radius: CGFloat = 10
    var _shadow: CGFloat = 5
    var _mainColor: String = "Background"
    var _secondColor: String = "TopShadow"

    
    func body(content: Content) -> some View {
        return content
            .foregroundColor(Color(_mainColor))
            .overlay(
                RoundedRectangle(cornerRadius: _radius)
                    .stroke(Color(_mainColor),
                            lineWidth: 5)
                    .shadow(color: Color(_secondColor),
                            radius: _shadow, x: _shadow, y: _shadow)
                    .clipShape(
                        RoundedRectangle(cornerRadius: _radius)
                    )
                    .shadow(color: .white, radius: _shadow, x: -_shadow, y: -_shadow)
                    .clipShape(
                        RoundedRectangle(cornerRadius: _radius)
                    )
            )
            .background(Color(_mainColor))
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let Calculator = CalculatorViewModel()
        ContentView(Calculator: Calculator)
.previewInterfaceOrientation(.portrait)
    }
}
