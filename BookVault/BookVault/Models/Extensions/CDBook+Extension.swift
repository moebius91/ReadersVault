//
//  CDBook+Extension.swift
//  ReadersVault
//
//  Created by Jan-Nikolas Othersen on 21.08.24.
//

import Foundation

extension CDBook {
    func removeFromCategory(_ category: CDCategory) {
        self.removeFromCategories(category)

        for list in self.lists as? Set<CDList> ?? [] where list.category == category {
            list.removeFromBooks(self)
        }
    }
}
