//
//  ContactListItemView.swift
//  Sendgrid
//
//  Created by Evan Anger on 11/11/21.
//

import SwiftUI

struct ContactListItemView: View {

    let contact: AbbrevContact
    var body: some View {
        HStack {
            Text(self.contact.name)
            Spacer()
            NavigationLink {
                NotImplementedView()
//                ContactListView(contactList: contact)
            } label: {
                Image(systemName: "list.bullet")
                    .frame(width: 44, height: 44)
            }
            NavigationLink {
                EmailView(contact: contact)
            } label: {
                Image(systemName: "paperplane")
                    .frame(width: 44, height: 44)
            }

        }
    }
}

struct ContactListItemView_Previews: PreviewProvider {
    static var previews: some View {
        ContactListItemView(contact: AbbrevContact(name: "Evan's contact", id: "123232-1232-2132", count: 3))
    }
}
