//
//  PasscodeField.swift
//  KW Install
//
//  Created by Luke Morse on 4/8/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//

import SwiftUI
import Introspect

public struct PasscodeField: View {
    
    var maxDigits: Int = 4
    var label = "Enter Passcode"
    
    @State var pin: String = ""
    @State var showPin = false
    @State var isDisabled = false
    
    
    var handler: (String, (Bool) -> Void) -> Void
    
    public var body: some View {
        VStack(spacing: 50) {
            Text(label).font(.title)
            ZStack {
                pinDots
                backgroundField
            }
            showPinStack
        }
    }
    
    private var pinDots: some View {
        HStack {
            Spacer()
            ForEach(0..<maxDigits) { index in
                Image(systemName: self.getImageName(at: index))
                    .font(.system(size: 20, weight: .thin, design: .default))
                Spacer()
            }
        }
    }
    
    private var backgroundField: some View {
        let boundPin = Binding<String>(get: { self.pin }, set: { newValue in
            self.pin = newValue
            self.submitPin()
        })
        
        return TextField("", text: boundPin, onCommit: submitPin)
            .introspectTextField { textField in
                textField.tintColor = .clear
                textField.textColor = .clear
                textField.keyboardType = .numberPad
                textField.becomeFirstResponder()
                textField.isEnabled = !self.isDisabled
        }
    }
    
    private var showPinStack: some View {
        HStack {
            Spacer()
            if !pin.isEmpty {
                showPinButton
            }
        }
        .frame(height: 200)
        .padding([.trailing])
    }
    
    private var showPinButton: some View {
        Button(action: {
            self.showPin.toggle()
        }, label: {
            self.showPin ?
                Image(systemName: "eye.slash.fill").foregroundColor(.primary) :
                Image(systemName: "eye.fill").foregroundColor(.primary)
        })
    }
    
    private func submitPin() {
        guard !pin.isEmpty else {
            showPin = false
            return
        }
        
        if pin.count == maxDigits {
            isDisabled = true
            
            handler(pin) { isSuccess in
                if isSuccess {
                    print("pin matched, go to next page, no action to perfrom here")
                    
                } else {
                    pin = ""
                    isDisabled = false
                    print("this has to called after showing toast why is the failure")
                }
            }
        }
        
        // this code is never reached under  normal circumstances. If the user pastes a text with count higher than the
        // max digits, we remove the additional characters and make a recursive call.
        if pin.count > maxDigits {
            pin = String(pin.prefix(maxDigits))
            submitPin()
        }
    }
    
    private func getImageName(at index: Int) -> String {
        if index >= self.pin.count {
            return "circle"
        }
        
        if self.showPin {
            return self.pin.digits[index].numberString + ".circle"
        }
        
        return "circle.fill"
    }
}

extension String {
    
    var digits: [Int] {
        var result = [Int]()
        
        for char in self {
            if let number = Int(String(char)) {
                result.append(number)
            }
        }
        
        return result
    }
    
}

extension Int {
    
    var numberString: String {
        
        guard self < 10 else { return "0" }
        
        return String(self)
    }
}

struct PasscodeField_Previews: PreviewProvider {
    static var previews: some View {
        PasscodeField { (str, _: (Bool) -> Void) in
            return
        }
    }
}
