//
//  ContactListView.swift
//  Sendgrid
//
//  Created by Evan Anger on 11/11/21.
//

import Combine
import SwiftUI

struct ContactListView: View {
    @EnvironmentObject var keyStorage: ApiKeyStorage
    let contactList: AbbrevContact
    @State var contacts: [Contact] = []
    var controller: ApiController {
        return ApiController(storage: keyStorage)
    }
    var body: some View {
        ScrollView {
            VStack {
                ForEach(self.contacts, id: \.email) {
                    Text($0.email)
                }
            }
        }.onAppear {
            self.controller.contactList(id: contactList.id) { data, response, error in
                if let d = data {
                    d.prettyPrint()
                }
                guard let d = data,
                      let decoded = d.toDecodable(type: ResponseResult<Contact>.self)
                else {
                    return
                }
                
                contacts = decoded.result
            }
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
        
        return ContactListView(contactList: AbbrevContact(name: "Evan's list", id: "234234", count: 3))
    }
}
