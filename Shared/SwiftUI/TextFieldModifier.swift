//
//  TextFieldModifier.swift
//  Sendgrid
//
//  Created by Evan Anger on 11/13/21.
//

import Foundation
import SwiftUI

struct DefaultTextField: ViewModifier {
    func body(content: Content) -> some View {
        content
            .textFieldStyle(.roundedBorder)
            .padding(10)
    }
}

extension View {
    func defaultStyle() -> some View {
        modifier(DefaultTextField())
    }
}
