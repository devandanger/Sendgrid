//
//  ButtonModifier.swift
//  Sendgrid
//
//  Created by Evan Anger on 11/13/21.
//

import Foundation
import SwiftUI

struct PrimaryButton: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .foregroundColor(.white)
            .clipShape(Capsule())
    }
}

extension View {
    func primaryButton() -> some View {
        modifier(PrimaryButton())
    }
}
