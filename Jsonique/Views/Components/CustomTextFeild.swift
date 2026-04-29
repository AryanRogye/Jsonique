//
//  CustomTextFeild.swift
//  Jsonique
//
//  Created by Aryan Rogye on 4/28/26.
//

import SwiftUI

struct CustomTextFeild: View {
    
    var label: String = ""
    @Binding var text: String
    
    public init(_ label: String = "", text: Binding<String>) {
        self.label = label
        self._text = text
    }
    
    var body: some View {
        TextField(label, text: $text)
            .textFieldStyle(.plain)
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(
                        .black,
                        style: .init(lineWidth: 1)
                    )
            }
    }
}
