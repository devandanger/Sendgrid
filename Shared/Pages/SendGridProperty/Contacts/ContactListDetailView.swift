//
//  ContactListDetailView.swift
//  Sendgrid
//
//  Created by Evan Anger on 3/31/23.
//

import SwiftUI

struct ContactListDetailView: View {
    @EnvironmentObject var apiController: ApiController
    let contactList: AbbrevContact
    @State var contacts: [Contact] = []
    @State var filterContacts: String = ""
    var body: some View {
        VStack {
            TextField("Search", text: $filterContacts)
                .defaultStyle()
            if contacts.count == 0 {
                Text("No Contacts")
            } else {
                ForEach(contacts, id: \.email) { contact in
                    if !filterContacts.isEmpty {
                        if contact.email.lowercased().contains(filterContacts.lowercased()) ||
                            contact.firstName.lowercased().contains(filterContacts.lowercased()) ||
                            contact.lastName.lowercased().contains(filterContacts.lowercased()) {
                            HStack {
                                Text(contact.email)
                                Spacer()
                                Text("\(contact.firstName) \(contact.lastName)")
                            }
                        } else {
                            EmptyView()
                        }
                    } else {
                        HStack {
                            Text(contact.email)
                            Spacer()
                            Text("\(contact.firstName) \(contact.lastName)")
                        }
                    }
                }
            }
            Spacer()
        }
        .padding()
        .onAppear {
            apiController.getContactList(for: contactList.id) { contacts, error in
                self.contacts = contacts
            }
        }
    }
}

struct ContactListDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ContactListDetailView(contactList: AbbrevContact(name: "Yo", id: "ID", count: 3))
    }
}
