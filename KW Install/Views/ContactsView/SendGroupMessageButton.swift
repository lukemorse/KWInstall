//
//  SendGroupMessageButton.swift
//  KW Install
//
//  Created by Luke Morse on 5/13/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//

import SwiftUI
import MessageUI

struct SendGroupMessageButton: View {
    var emails: [String]
    @State private var mailResult: Result<MFMailComposeResult, Error>? = nil
    @State private var isShowingMailView = false
    
    var body: some View {
        Button(action: {
            self.isShowingMailView.toggle()
        })
        {
            Image(systemName: "envelope.fill").imageScale(.large)
        }
        .disabled(!MFMailComposeViewController.canSendMail())
        .sheet(isPresented: $isShowingMailView) {
            MailView(emails: self.emails, result: self.$mailResult)
        }
    }
}

struct SendGroupMessageButton_Previews: PreviewProvider {
    static var previews: some View {
        SendGroupMessageButton(emails: ["test@test.com"])
    }
}
