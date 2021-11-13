//
//  Header.swift
//  Sendgrid
//
//  Created by Evan Anger on 11/13/21.
//

import SwiftUI

struct Header: View {
    let name: String
    var body: some View {
        Text(name)
            .font(.title)
    }
}

struct Header_Previews: PreviewProvider {
    static var previews: some View {
        Header(name: "Contact List")
    }
}
