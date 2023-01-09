//
//  Array+safeIndex.swift
//  Kraeved
//
//  Created by Владимир Амелькин on 25.11.2022.
//

import Foundation

extension Array {
    public subscript(safeIndex index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
