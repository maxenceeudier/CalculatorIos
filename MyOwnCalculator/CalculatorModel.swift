//
//  CalculatorModel.swift
//  MyOwnCalculator
//
//  Created by eudier maxence on 09/03/2023.
//

import Foundation


struct CalculatorModel<ContentType> {
    private(set) var screen : Screen = Screen()
    private(set) var buttons : Array<Button> = []
    private var num1 : Float = 0
    private var num2 : Float = 0
    private var rslt : Float? = nil
    private var operation : ((Float, Float) -> Float)? = nil
    
    init(_ buttonsArray : Array<ContentType>) {
        for index in 0..<buttonsArray.count {
            buttons.append(Button(content: buttonsArray[index], isTap: false, id: index))
        }
        
    }
    
    struct Screen {
        var result : String = "0"
        var history : String = ""
    }
    
    struct Button : Identifiable {
        var content : ContentType
        var isTap : Bool
        var id : Int
    }
    
    mutating func tap (_ button : Button) {
        let indexToChange = buttons.firstIndex(where: {aButton in aButton.id == button.id})
        for i in 0..<buttons.count {
                buttons[i].isTap = false
        }
        buttons[indexToChange!].isTap = true
        writeResult(buttons[indexToChange!])
        
    }
    
    mutating func writeResult (_ button : Button) -> Void
    {
        let content = "\(button.content)"
        
        switch content
        {
        case "AC" :
            reInit()
        case "+/-" :
            inverse()
        case "+" :
            action(add, "+")
        case "-" :
            action(sub, "-")
        case "X" :
            action(product, "X")
        case "/" :
            action(divide, "/")
        case "=" :
            equal()
        case "%" :
            percent()
        default :
            defaultAction(content: content)
        }
        
        if (operation == nil)
        {
            num1 = Float(screen.result) ?? 0
        }
        else
        {
            var indexOperation : String.Index?
            for index in screen.history.indices
            {
                if index != screen.history.startIndex && screen.history[index] != "." && !screen.history[index].isNumber
                {
                    indexOperation = index
                    break
                }
            }
            if ( indexOperation != nil && indexOperation != screen.history.endIndex)
            {
                let numString2 = String(screen.history[screen.history.index(after: indexOperation!)..<screen.history.endIndex])
                num2 = Float(numString2) ?? 0
            }
        }
    }
    
    
    func add (_ num1 : Float, _ num2 : Float) -> Float
    {
        num1 + num2
    }
    
    func sub (_ num1 : Float, _ num2 : Float) -> Float
    {
        num1 - num2
    }
    
    func product(_ num1 : Float, _ num2 : Float) -> Float
    {
       num1 * num2
    }
    
    func divide(_ num1 : Float, _ num2 : Float) -> Float
    {
       num1 / num2
    }
    
    mutating func percent()
    {
        equal()
        num1 /= 100
        screen.result = String(num1)
        tcheckRslt()
        screen.history = screen.result
    }
    
    mutating func tcheckRslt(){
        var i = 0
        for char in screen.result
        {
            if char == "."
            {
                break
            }
            i += 1
        }
        if i == screen.result.count - 2 && screen.result[screen.result.index(before: screen.result.endIndex)] == "0"
        {
            let index = screen.result.firstIndex(where: {char in char == "."})
            screen.result = String(screen.result[screen.result.startIndex..<index!])
        }
        
        if i == 0
        {
            screen.result = "0" + screen.result
        }
    }
    
    mutating func equal() {
        calculate()
        if (rslt != nil)
        {
            num1 = rslt!
            screen.result = String(rslt!)
        }
        else
        {
            screen.result =  screen.result
        }
        tcheckRslt()
        operation = nil
        num2 = 0
        rslt = nil
        screen.history = screen.result
        
    }
    
    
    mutating func action(_ action : @escaping (Float, Float) -> Float, _ symbol: String){
        calculate()
        if (rslt != nil)
        {
            num1 = rslt!
            screen.result = String(rslt!)
        }
        else
        {
            screen.result =  screen.result
        }
        tcheckRslt()
        operation = action
        screen.history = screen.result + symbol
    }
    
    mutating func defaultAction(content : String) {
        if (screen.result == "0")
        {
            screen.result = content
            
        }
        else if (screen.history.count > 0)
        {
            let indexLast = screen.history.index(before: screen.history.endIndex)
            if (screen.history[indexLast].isNumber || screen.history[indexLast] == ".")
            {
                if screen.result.firstIndex(where: {char in char == "."}) != nil && content == "."
                {
                    return 
                }
                
                screen.result = screen.result + content
            }
            else
            {
                screen.result = content
            }
        }
        else
        {
            screen.result = screen.result + content
        }
        if screen.history == "-"
        {
            screen.history = content
        }
        else
        {
            screen.history = screen.history + content
        }
    }
    
    mutating func calculate() {
        if operation != nil
        {
            rslt = operation!(num1, num2)
        }
    }
    
    mutating func reInit() {
        screen.history = ""
        screen.result = "0"
        num1 = 0
        num2 = 0
        operation = nil
        rslt = nil
    }
    
    
    
    mutating func inverse() {
        let isNeg =  screen.result.first == "-"
        let start = screen.result.startIndex
        var indexOperation : String.Index?
        for index in screen.history.indices
        {
            if index != screen.history.startIndex && screen.history[index] != "." && !screen.history[index].isNumber
            {
                indexOperation = index
                break
            }
        }

        
        screen.result = isNeg ?  String(screen.result[screen.result.index(after: start)..<screen.result.endIndex]) : "-" + screen.result

        
        if operation != nil && indexOperation != nil  && indexOperation != screen.history.endIndex && num2 != 0
        {
            if screen.history[screen.history.index(after: indexOperation!)] == "-"
            {
                indexOperation = screen.history.index(after: indexOperation!)
                screen.history = String(screen.history[screen.history.startIndex..<indexOperation!]) + String(screen.history[screen.history.index(after: indexOperation!)..<screen.history.endIndex])
                
            }
            else
            {
                screen.history = String(screen.history[screen.history.startIndex..<screen.history.index(after: indexOperation!)]) + "-" + String(screen.history[screen.history.index(after: indexOperation!)..<screen.history.endIndex])
            }
            num2 *= -1
           
        }
        else
        {
            screen.history = isNeg ?  String(screen.history[screen.history.index(after: start)..<screen.history.endIndex]) : "-" + screen.history
            num1 *= -1
        }
    }
    
}

extension String {
    var isNumber: Bool {
        let characters = CharacterSet.decimalDigits

        return CharacterSet(charactersIn: self).isSubset(of: characters)
    }
}
