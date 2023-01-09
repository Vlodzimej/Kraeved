//
//  ProfileTableAdapter.swift
//  Kraeved
//
//  Created by Владимир Амелькин on 27.11.2022.
//

import UIKit

// MARK: - ProfileCellType
enum ProfileCellType {
    case textField
    case button
}

// MARK: - ProfileCellViewModel
struct ProfileCellViewModel {
    let title: String
    let value: String?
    let type: ProfileCellType
    let action: (() -> Void)?
}

// MARK: - ProfileTableAdapterDelegate
protocol ProfileTableAdapterDelegate: AnyObject {
    func logout()
}

// MARK: - ProfileTableAdapter
final class ProfileTableAdapter: NSObject {

    // MARK: Properties
    private var tableView: UITableView?
    weak var delegate: ProfileTableAdapterDelegate?

    private var profileCellViewModels: [ProfileCellViewModel] = []

    // MARK: Private Methods
    private func makeProfileCellViewModels(user: User) -> [ProfileCellViewModel] {
        var phoneNumber = ""
        if let phone = user.phone {
            phoneNumber = String(phone)
        }

        let result: [ProfileCellViewModel] = [
            .init(title: NSLocalizedString("profile.name", comment: ""), value: user.username ?? "", type: .textField, action: nil),
            .init(title: NSLocalizedString("profile.email", comment: ""), value: user.email ?? "", type: .textField, action: nil),
            .init(title: NSLocalizedString("profile.phone", comment: ""), value: phoneNumber, type: .textField, action: nil),
            .init(title: NSLocalizedString("profile.score", comment: ""), value: String(user.score ?? 0), type: .textField, action: nil),
            .init(title: NSLocalizedString("profile.logout", comment: ""), value: nil, type: .button, action: { [weak self] in
                guard let self else { return }
                self.delegate?.logout()
            })
        ]
        return result
    }

    // MARK: Public Methods
    func setup(tableView: UITableView) {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ProfileTableViewCell.self, forCellReuseIdentifier: "ProfileTableViewCell")
        self.tableView = tableView
    }

    func configurate(user: User) {
        self.profileCellViewModels = makeProfileCellViewModels(user: user)
        tableView?.reloadData()
    }
}

// MARK: - UITableViewDelegate
extension ProfileTableAdapter: UITableViewDelegate {

}

// MARK: - UITableViewDataSource
extension ProfileTableAdapter: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        profileCellViewModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableViewCell", for: indexPath) as? ProfileTableViewCell else { return UITableViewCell() }
        let cellViewModel = profileCellViewModels[indexPath.item]
        cell.configurate(viewModel: cellViewModel)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        ProfileTableViewCell.UIConstatns.cellHeight
    }
}
