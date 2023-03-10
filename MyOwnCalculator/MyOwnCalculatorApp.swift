//
//  MyOwnCalculatorApp.swift
//  MyOwnCalculator
//
//  Created by eudier maxence on 08/03/2023.
//

import SwiftUI

@main
struct MyOwnCalculatorApp: App {
    let Calculator = CalculatorViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView(Calculator: Calculator)
        }
    }
}
