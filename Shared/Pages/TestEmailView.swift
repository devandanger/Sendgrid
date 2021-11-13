//
//  TestEmailView.swift
//  Sendgrid
//
//  Created by Evan Anger on 11/13/21.
//

import SwiftUI

struct TestEmailView: View {
    @EnvironmentObject var keyStorage: ApiKeyStorage
    var controller: ApiController {
        return ApiController(storage: keyStorage)
    }

    @State var templates: [Template] = []
    @State var isReadyToSend: Bool = true
    @State var selectedTemplate: String? {
        didSet {
            setIsReadyToSend()
        }
    }
    @State var isLoading: Bool = false
    @State var fromAddress: String = "rsmith@neosportsplant" {
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
    var toAddresses: [String] = []
    
    var body: some View {
        VStack {
            if isLoading {
                ProgressView()
                    .scaleEffect(x: 2, y: 2, anchor: .center)
            } else {
                VStack {
                    TextField("From Address", text: $fromAddress)
                        .textFieldStyle(.roundedBorder)
                        .frame(height: 60)
                    Header(name: "Choose Template")
                    Picker(selection: $selectedTemplate, label: Text("Choose template")
                            .foregroundColor(Color.white)) {
                        ForEach(self.templates, id: \.id) {
                            Text($0.name)
                        }
                    }
                    .onSubmit {
                                
                    }
                    .frame(height: 50)
                    .pickerStyle(.wheel)
                    Header(name: "Addresses")
                        .padding(EdgeInsets(top: 20, leading: 0, bottom: 0, trailing: 0))
                    TextEditor(text: $addresses)
                        .frame(maxHeight: 200)
                        .textFieldStyle(.roundedBorder)
                        .padding(20)
                    Spacer()
                }
            }
        }
        .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    controller.sendTestEmail(template: "d-1993c321eb084cc89de555f0510b3834", emails: toAddresses, from: fromAddress, result: { data, response, error in
                        print("Send test email")
                    })
                } label: {
                    Image(systemName: "paperplane")
                }
                .disabled(!isReadyToSend)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            controller.getTemplates(result: { data, response, error in
                guard
                    let data = data,
                    let ts = data.toDecodable(type: ResponseResult<Template>.self)
                else {
                    return
                }
                self.templates = ts.result
                isLoading = false
            })
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
                TestEmailView()
                    .environmentObject(ApiKeyStorage())
            }
        }
    }
}
