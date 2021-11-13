//
//  LoadingVStack.swift
//  Sendgrid
//
//  Created by Evan Anger on 11/13/21.
//

import SwiftUI

struct LoadingVStack<Content: View>: View {
    var content: () -> Content
    @State var isLoading: Bool = true
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    var body: some View {
        if self.isLoading {
            ProgressView()
                .scaleEffect(x: 2, y: 2, anchor: .center)
        } else {
            VStack(content: content)
        }
    }
}

extension LoadingVStack {
    func loading(_ isLoading: Bool) -> some View  {
        self.isLoading = isLoading
        return self
    }
}

struct LoadingVStack_Previews: PreviewProvider {
    static var previews: some View {
        let loading: Bool = false
        LoadingVStack {
            Text("Hi")
        }
        .loading(loading)
    }
}
