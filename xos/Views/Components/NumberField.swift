//
//  NumberField.swift
//  xos
//
//  Created by nick on 03/08/2023.
//

import SwiftUI

// cf. https://fatbobman.medium.com/advanced-swiftui-textfield-formatting-and-validation-7a783250f2b9
struct NumberField: View {
    @Binding var number: Int

    var body: some View {
        TextField("inputNumber", value: $number, format: .number)
        .keyboardType(.numberPad)
    }
}

struct NumberField_Previews: PreviewProvider {
    static var previews: some View {
        @State var value: Int = 1

        Form {
            NumberField(number: $value)
        }
    }
}
