//
//  ContactListView.swift
//  Sendgrid
//
//  Created by Evan Anger on 11/11/21.
//

import Combine
import SwiftUI

struct ContactListView: View {
    let property: SendGridProperty
//    let contactList: AbbrevContact
    @State var lists: [AbbrevContact] = []
    @State var contacts: [Contact] = []
    @State var filterContacts: String = ""
    var filteredList: [AbbrevContact] {
        if filterContacts.isEmpty {
            return lists
        } else {
            return lists.filter { $0.name.lowercased().contains(filterContacts.lowercased()) }
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                NavigationLink(destination: TestEmailView()) {
                    HStack {
                        Text("Test Email")
                        Image(systemName: "testtube.2")
                            .frame(width: 44, height: 44)
                    }
                }
                Spacer()
            }
            Header(name: "Contact Lists")
            TextField("Search", text: $filterContacts)
                .defaultStyle()
            ForEach(self.filteredList, id: \.id) { contact in
                ContactListItemView(contact: contact)
            }
            Spacer()
        }.onAppear {
//            self.controller.contactList(id: contactList.id) { data, response, error in
//                if let d = data {
//                    d.prettyPrint()
//                }
//                guard let d = data,
//                      let decoded = d.toDecodable(type: ResponseResult<Contact>.self)
//                else {
//                    return
//                }
//                
//                contacts = decoded.result
//            }
        }
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
        
        return ContactListView(property: SendGridProperty(name: "Fake", apiKey: "doesn'tmatter"))
    }
}
