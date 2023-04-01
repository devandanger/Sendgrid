//
//  ContactListView.swift
//  Sendgrid
//
//  Created by Evan Anger on 11/11/21.
//

import Combine
import Moya
import SwiftUI

struct ContactListView: View {
    @EnvironmentObject var apiController: ApiController
    let property: SendGridProperty
    @State var contacts: [Contact] = []
    @State var filterContacts: String = ""

    
    var body: some View {
        VStack {
            TextField("Search", text: $filterContacts)
                .defaultStyle()
            ForEach(apiController.contactList, id: \.id) { contactList in
                if !filterContacts.isEmpty {
                    if contactList.name.lowercased().contains(filterContacts.lowercased()) {
                        ContactListItemView(contactList: contactList)
                    } else {
                        EmptyView()
                    }
                } else {
                    ContactListItemView(contactList: contactList)
                }
                
            }
            Spacer()
        }
        .navigationTitle("Contact List")
    }
}

struct ContactListView_Previews: PreviewProvider {
    static let contact: AbbrevContact = """
    {
        name: "Evan's",
        id: "12312-123123-123132",
        contact_count: 2
    }
    """.toDecodable(type: AbbrevContact.self)
    static var previews: some View {
        
        NavigationStack {
            ContactListView(property: SendGridProperty(name: "Fake", apiKey: "doesn'tmatter"))
        }
    }
}
