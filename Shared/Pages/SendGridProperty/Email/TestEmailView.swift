//
//  TestEmailView.swift
//  Sendgrid
//
//  Created by Evan Anger on 11/13/21.
//

import SwiftUI

struct TestEmailView: View {
    @EnvironmentObject var apiController: ApiController
    let template: Template
    @State var templates: [Template] = []
    @State var isReadyToSend: Bool = true
    @State var selectedTemplate: String? {
        didSet {
            setIsReadyToSend()
        }
    }
    @State var isLoading: Bool = false
    @State var fromAddress: String = "" {
        didSet {
            setIsReadyToSend()
        }
    }
    @State var addresses: String = "" {
        mutating didSet {
            self.toAddresses = addresses
                .components(separatedBy: ",")
                .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            setIsReadyToSend()
        }
    }
    @State var showTemplates: Bool = false
    @State var toAddresses: [String] = []
    
    var body: some View {
        VStack {
            if isLoading {
                ProgressView()
                    .scaleEffect(x: 2, y: 2, anchor: .center)
            } else {
                VStack {
                    TextField("From Address", text: $fromAddress)
                        .textInputAutocapitalization(.never)
                        .textFieldStyle(.roundedBorder)
                        .frame(height: 60)
                    AddAddressView(emails: $toAddresses, headerName: "To Addressses")
                    Spacer()
                }
            }
        }
        .navigationTitle("Using Template: \(template.name)")
        .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    apiController.sendTestEmail(template: self.template.id, emails: self.toAddresses, from: self.fromAddress) { error in
                        print("Error: \(error?.localizedDescription ?? "no error")")
                    }
                } label: {
                    Image(systemName: "paperplane")
                }
                .disabled(!isReadyToSend)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
//            controller.getTemplates(result: { data, response, error in
//                guard
//                    let data = data,
//                    let ts = data.toDecodable(type: ResponseResult<Template>.self)
//                else {
//                    return
//                }
//                self.templates = ts.result
//                isLoading = false
//            })
        }
    }
    
    func setIsReadyToSend() {
        self.isReadyToSend = self.toAddresses.count > 0
        && !(selectedTemplate ?? "").isEmpty
        && !self.fromAddress.isEmpty
    }
}

struct TestEmailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            VStack {
                TestEmailView(template: Template(id: "", name: "Random"))
            }
        }
    }
}
