//
//  CustomTextField.swift
//  ReadersVault
//
//  Created by Jan-Nikolas Othersen on 23.08.24.
//

import SwiftUI

struct CustomTextField: View {
    let title: String
    @Binding var text: String
    @Environment(\.isEnabled) private var isEnabled: Bool

    var body: some View {
        HStack {
            Text(title + ":")
                .foregroundStyle(Color(.systemGray))
            TextField(title, text: $text)
                .foregroundColor(!isEnabled ? .gray : .primary)
        }
    }
}

#Preview {
    @State var title = "Langer Titel"
    @State var text = "Langer Titel"

    return Form { CustomTextField(title: title, text: $text) }
}
