//
//  KeyboardOffsetModifier.swift
//  KW Install
//
//  Created by Luke Morse on 6/24/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//

import SwiftUI

@available(iOS 13, *)
public struct KeyboardOffsetModifier: ViewModifier {
    @State private var keyboardOffset: CGFloat = 0
    
    public func body(content: Content) -> some View {
        content
            .padding(.bottom, keyboardOffset)
            .onAppear {
                NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { notif in
                    guard let value = notif.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
                    let bottomSafeAreaInset: CGFloat = UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0
                    self.keyboardOffset = value.height - bottomSafeAreaInset
                }
                
                NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { notif in
                    self.keyboardOffset = 0
                }
        }
    }
}

@available(iOS 13, *)
extension View {
    /// Create some offset for the keyboard when visible
    /// - Returns: KeyboardOffsetModifier
    public func enableKeyboardOffset() -> ModifiedContent<Self, KeyboardOffsetModifier> {
        return modifier(KeyboardOffsetModifier())
    }
}
