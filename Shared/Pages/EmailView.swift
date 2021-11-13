//
//  EmailView.swift
//  Sendgrid
//
//  Created by Evan Anger on 11/12/21.
//

import SwiftUI

struct EmailView: View {
    let contact: AbbrevContact
    @State var text: String = "Text"

    var body: some View {
        
        VStack {
            Text("Contact List")
            TextEditor(text: $text)
                .frame(maxHeight: 200)
                .textFieldStyle(.roundedBorder)
                .padding(20)
            Spacer()
        }.navigationTitle(contact.name)
    }
}

struct EmailView_Previews: PreviewProvider {
    static var previews: some View {
        EmailView(contact: AbbrevContact(name: "Evan's contact list", id: "213423423", count: 2343))
    }
}
