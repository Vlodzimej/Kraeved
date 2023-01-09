//
//  MainTableCellFactory.swift
//  Kraeved
//
//  Created by Владимир Амелькин on 23.11.2022.
//

import UIKit

// MARK: - MainTableCellViewFactory
final class MainTableCellViewFactory {

    func makeHistoricalEventCellView(items: [MainTableCellItem], delegate: EntityCellDelegate?) -> UIView {
        let cellView = EntityCellView(items: items, type: EntityType.historicalEvent)
        cellView.delegate = delegate
        return cellView
    }

    func makeLocationsCellView(items: [MainTableCellItem], delegate: EntityCellDelegate?) -> UIView {
        let cellView = EntityCellView(items: items, type: EntityType.location)
        cellView.delegate = delegate
        return cellView
    }

    func makeGalleryCellView(items: [MainTableCellItem], delegate: EntityCellDelegate?) -> UIView {
        let cellView = EntityCellView(items: items, type: EntityType.photo)
        cellView.delegate = delegate
        return cellView
    }
}
