//
//  SegueOption.swift
//  ArchitectureBootcamp
//
//  Created by Desmond Fitch on 4/7/25.
//

import SwiftUI

enum SegueOption {
    case push, sheet, fullScreenCover
    
    var shouldAddNewNavigationView: Bool {
        switch self {
        case .push:
            return false
        case .sheet, .fullScreenCover:
            return true
        }
    }
}
