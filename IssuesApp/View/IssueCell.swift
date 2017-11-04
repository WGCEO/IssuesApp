//
//  IssueCell.swift
//  IssuesApp
//
//  Created by changi kim on 2017. 11. 4..
//  Copyright © 2017년 Piano. All rights reserved.
//

import UIKit

class IssueCell: UICollectionViewCell {
    @IBOutlet weak var stateButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentsLabel: UILabel!
    @IBOutlet weak var commentCountButton: UIButton!
}

extension IssueCell {
    static var cellFromNib: IssueCell {
        return Bundle.main.loadNibNamed("IssueCell", owner: nil, options: nil)?.first as? IssueCell ?? IssueCell()
    }
    func update(date issue: Model.Issue) {
        titleLabel.text = issue.title
        let createAt = issue.createdAt?.string(dateFormat: "dd MMM") ?? "-"
        contentsLabel.text = "#\(issue.number) \(issue.state.rawValue) on \(createAt) by \(issue.user.login)"
        stateButton.isSelected = issue.state == .closed
        commentCountButton.setTitle("\(issue.comments)", for: .normal)
        let commentCountHidden = issue.comments == 0 ? true : false
        commentCountButton.isHidden = commentCountHidden
    }
}

extension Date {
    func string(dateFormat: String, locale: String = "en-US") -> String {
        let format = DateFormatter()
        format.dateFormat = dateFormat
        format.locale = Locale(identifier: locale)
        return format.string(from: self)
    }
}
