//
//  StartView.swift
//  KW Install
//
//  Created by Luke Morse on 4/10/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//

import SwiftUI

struct StartView: View {
    @State var isLoggedIn: Bool
    var body: some View {
        Group {
            isLoggedIn ? AnyView(MainView().environmentObject(MainViewModel())) : AnyView(PasscodeField { (str, callBack: (Bool) -> Void) in
                self.setLoggedIn(newVal: str == "1234")
            })
        }
    }
    
    func setLoggedIn(newVal: Bool) {
        self.isLoggedIn = newVal
    }
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView(isLoggedIn: false)
    }
}
