//
//  ContactListItemView.swift
//  Sendgrid
//
//  Created by Evan Anger on 11/11/21.
//

import SwiftUI

struct ContactListItemView: View {
    @EnvironmentObject var apiController: ApiController
    let contactList: AbbrevContact
    @State var contacts: [Contact] = []
    var body: some View {
        HStack {
            Text(self.contactList.name)
            ForEach(self.contacts, id: \.email) { contact in
                Text(contact.email)
            }
            Spacer()
            NavigationLink {
                ContactListDetailView(contactList: contactList)
                    .environmentObject(apiController)
            } label: {
                Image(systemName: "list.bullet")
                    .frame(width: 44, height: 44)
            }
            NavigationLink {
                EmailView(contact: contactList)
                    .environmentObject(apiController)
            } label: {
                Image(systemName: "paperplane")
                    .frame(width: 44, height: 44)
            }
        }
    }
}

struct ContactListItemView_Previews: PreviewProvider {
    static var previews: some View {
        ContactListItemView(contactList: AbbrevContact(name: "Evan's contact", id: "123232-1232-2132", count: 3))
    }
}
