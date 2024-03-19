//
//  ViewController.swift
//  IconPainter
//
//  Created by ShomaKato on 2024/03/14.
//

import UIKit
import opencv2

class ViewController: UIViewController {
    private let iconPainterView = IconPainterView()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupHierarchy()
    }

    private func setupHierarchy() {
        iconPainterView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(iconPainterView)

        NSLayoutConstraint.activate([
            iconPainterView.topAnchor.constraint(equalTo: self.view.topAnchor),
            iconPainterView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            iconPainterView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            iconPainterView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
}
