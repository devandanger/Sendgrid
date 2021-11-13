//
//  ViewModifier+Loading.swift
//  Sendgrid
//
//  Created by Evan Anger on 11/13/21.
//

import SwiftUI

struct Loading: ViewModifier {
  func body(content: Content) -> some View {
    content
      .font(.caption)
      .padding([.leading,.trailing], 5)
      .background(Color(.secondarySystemBackground))
      .cornerRadius(5.0)
  }
}


