//
//  PickerComponent.swift
//  SwiftyHelper
//
//  Created by Alphonso Sensley II on 5/23/23.
//

import Foundation
import SwiftUI

struct PickerComponent<T: CaseIterable & Hashable & RawRepresentable>: View where T.RawValue == String {
    let title: String
    @Binding var selection: T

    var body: some View {
        Picker(title, selection: $selection) {
            ForEach(T.allCases.map {$0}, id: \.self) { type in
                Text(type.rawValue.capitalized).tag(type)
            }
        }
        .frame(width: 200)
        .pickerStyle(MenuPickerStyle())
        .padding(.top)
    }
}
