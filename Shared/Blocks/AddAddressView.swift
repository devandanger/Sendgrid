//
//  AddAddressView.swift
//  Sendgrid
//
//  Created by Evan Anger on 3/31/23.
//

import SwiftUI

struct AddAddressView: View {
    @Binding var emails: [String]
    @State var showAdd: Bool = false
    @State var newEmail: String = ""
    let headerName: String
    var body: some View {
        VStack {
            HStack {
                Text(headerName)
                Spacer()
                Button {
                    showAdd.toggle()
                } label: {
                    Image(systemName: "plus")
                }

            }
            .padding([.top, .bottom], 5)
            if emails.count > 0 {
                ForEach(Array(emails.enumerated()), id: \.offset) { index, element in
                    HStack {
                        Text(element)
                        Spacer()
                        Button {
                            self.emails.remove(at: index)
                        } label: {
                            Image(systemName: "minus.circle")
                        }
                    }
                }
            } else {
                Text("No emails")
            }
        }
        .sheet(isPresented: $showAdd, content: {
            NavigationStack {
                VStack {
                    TextField("Email", text: $newEmail)
                        .textInputAutocapitalization(.never)
                    Spacer()
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            self.showAdd.toggle()
                        } label: {
                            Text("Cancel")
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            self.showAdd.toggle()
                            self.emails.append(newEmail)
                            self.newEmail = ""
                        } label: {
                            Text("Add")
                        }
                    }
                }
                .padding()
            }
            .presentationDetents([.fraction(0.25)])
        })
        .padding()
    }
}

struct AddAddressView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            AddAddressView(emails: .constant(["hello@prog.com"]), headerName: "From")
            Spacer()
        }
        
    }
}
