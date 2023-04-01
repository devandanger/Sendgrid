//
//  TemplateListView.swift
//  Sendgrid
//
//  Created by Evan Anger on 3/31/23.
//

import SwiftUI

struct TemplateListView: View {
    @EnvironmentObject var apiController: ApiController
    var body: some View {
        VStack {
            if apiController.templateList.count == 0 {
                Text("No templates")
            } else {
                ForEach(apiController.templateList, id: \.name) { template in
                    HStack {
                        Text(template.name)
                        Spacer()
                        NavigationLink {
                            TestEmailView(template: template)
                                .environmentObject(apiController)
                        } label: {
                            Image(systemName: "testtube.2")
                        }
                    }
                    .padding()
                }
            }
            Spacer()
        }
        .navigationTitle("Templates")
    }
}

struct TemplateListView_Previews: PreviewProvider {
    static func templateData() -> [Template] {
        return [
            Template(id: "", name: "Template 1"),
            Template(id: "", name: "Template 3"),
            Template(id: "", name: "ssdf 3"),
            Template(id: "", name: "Template 2"),
            Template(id: "", name: "Template 2"),
        ]
    }
    static var previews: some View {
        NavigationStack {
            VStack {
                ForEach(templateData(), id: \.name) { template in
                    HStack {
                        Text(template.name)
                        Spacer()
                        NavigationLink {
                            TestEmailView(template: template)
                        } label: {
                            Image(systemName: "testtube.2")
                        }
                    }
                    .padding()
                }
                Spacer()
            }
        }
        .padding()
    }
}
