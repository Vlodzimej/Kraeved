//
//  MainTableAdapter.swift
//  Kraeved
//
//  Created by Владимир Амелькин on 20.11.2022.
//

import UIKit

// MARK: - MainTableSectionItem
struct MainTableSectionItem {
    let title: String
    let type: EntityType
    var items: [MainTableCellItem] = []
    let hasOverlay: Bool

    static func makeCellItems(from entities: [MetaObject<Entity>], hasOverlay: Bool = false) -> [MainTableCellItem] {
        entities.map { MainTableCellItem(id: $0.id, title: $0.title, image: $0.image, text: $0.data?.text, hasOverlay: hasOverlay) }
    }
}

// MARK: - MainTableCellItem
struct MainTableCellItem {
    let id: UUID
    let title: String?
    let image: UIImage?
    let text: String?
    let hasOverlay: Bool
}

// MARK: - MainTableAdapterDelegate
protocol MainTableAdapterDelegate: AnyObject {
    func showEntityDetails(id: UUID)
}

final class MainTableAdapter: NSObject {

    var sections: [MainTableSectionItem] = [
        MainTableSectionItem(title: NSLocalizedString("mainScreen.historicalEvents", comment: ""), type: EntityType.historicalEvent, hasOverlay: true),
        MainTableSectionItem(title: NSLocalizedString("mainScreen.locations", comment: ""), type: EntityType.location, hasOverlay: true),
        MainTableSectionItem(title: NSLocalizedString("mainScreen.gallery", comment: ""), type: EntityType.photo, hasOverlay: false)
    ]

    var tableView: UITableView?

    weak var delegate: MainTableAdapterDelegate?

    func setup(for tableView: UITableView) {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView?.frame = CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNonzeroMagnitude)
        tableView.register(MainTableViewCell.self, forCellReuseIdentifier: "MainTableViewCell")
        self.tableView = tableView
    }

    func configurate(entities: [MetaObject<Entity>]) {
        sections.enumerated().forEach { (index, section) in
            guard let typeId = UUID(uuidString: section.type.rawValue) else { return }
            let items = entities.filter { $0.data?.typeId == typeId }
            sections[index].items = MainTableSectionItem.makeCellItems(from: items, hasOverlay: section.hasOverlay)
        }

        tableView?.reloadData()
    }
}

// MARK: - UITableViewDelegate
extension MainTableAdapter: UITableViewDelegate {

}

// MARK: - UITableViewDataSource
extension MainTableAdapter: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MainTableViewCell") as? MainTableViewCell else { return UITableViewCell() }
        let titleText: String? = indexPath.item == 0 ? section.title : nil
        cell.configurate(section: section, titleText: titleText)
        cell.delegate = self
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        indexPath.item == 0 ? MainTableViewCell.UIConstants.cellHeight + Constants.contentInset : MainTableViewCell.UIConstants.cellHeight
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        CGFloat.leastNonzeroMagnitude
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        UIView()
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        CGFloat.leastNormalMagnitude
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        UIView()
    }
}

// MARK: - MainTableCellDelegate
extension MainTableAdapter: MainTableCellDelegate {
    func showEntityDetails(id: UUID) {
        delegate?.showEntityDetails(id: id)
    }
}
