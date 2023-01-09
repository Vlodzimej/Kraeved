//
//  SearchTableAdapter.swift
//  Kraeved
//
//  Created by Владимир Амелькин on 26.11.2022.
//

import UIKit

// MARK: - SearchTableAdapterDelegate
protocol SearchTableAdapterDelegate: AnyObject {
    func showHistoricalEventDetail(id: UUID)
}

// MARK: - SearchTableAdapter
final class SearchTableAdapter: NSObject {

    // MARK: Properties
    private var items: [SearchItem] = []
    private var tableView: UITableView?
    weak var delegate: SearchTableAdapterDelegate?

    // MARK: Public Methods
    func setup(for tableView: UITableView) {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView?.frame = CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNonzeroMagnitude)
        tableView.register(SearchTableViewCell.self, forCellReuseIdentifier: "SearchTableViewCell")
        self.tableView = tableView
    }

    func configurate(items: [SearchItem]) {
        self.items = items
        tableView?.reloadData()
    }
}

// MARK: - UITableViewDelegate
extension SearchTableAdapter: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.item]
        delegate?.showHistoricalEventDetail(id: item.id)
    }
}

// MARK: - UITableViewDataSource
extension SearchTableAdapter: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell") as? SearchTableViewCell else { return UITableViewCell() }
        let item = items[indexPath.item]
        cell.configurate(title: item.title, type: item.type)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        SearchTableViewCell.UIConstatns.cellHeight
    }
}
