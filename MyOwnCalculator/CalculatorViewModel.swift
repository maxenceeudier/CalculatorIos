//
//  CalculatorViewModel.swift
//  MyOwnCalculator
//
//  Created by eudier maxence on 09/03/2023.
//

import SwiftUI

class CalculatorViewModel : ObservableObject {
    static let keyboard = ["AC", "+/-", "%", "/", "7", "8", "9", "X", "4", "5", "6", "-", "1", "2", "3", "+", "0", ".", "="]
    
    
    @Published private var model : CalculatorModel<String> = CalculatorModel<String>(keyboard)
    
    var screen : CalculatorModel<String>.Screen {
        return model.screen
    }
    
    var buttons : Array<CalculatorModel<String>.Button> {
        return model.buttons
    }
    
    func Tap (_ button: CalculatorModel<String>.Button) {
        return model.tap(button)
    }
    
   
}
