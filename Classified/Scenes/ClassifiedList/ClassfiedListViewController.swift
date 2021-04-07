//
//  ViewController.swift
//  Classified
//
//  Created by Amir on 05/04/2021.
//

import UIKit
import HelpKit

class ClassfiedListViewController: UIViewController {
    @IBOutlet private var tableView: UITableView!

    // MARK: - Init
    init?(coder: NSCoder, viewModel: ClassfiedListViewModelType) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Properties
    var viewModel: ClassfiedListViewModelType

    lazy var loader: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        indicator.color = .gray
        return indicator
    }()

    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()

        addLoader()
        setupTableView()
        fetchData()

        viewModel.output = { [weak self] output in
            DispatchQueue.main.async {
                switch output {
                case .adsFetchSuccess(let ads):
                    debugPrint(ads)
                    self?.hideLoader()
                    self?.tableView.reloadData()
                case .adsFetchFailure(let error):
                    debugPrint(error)
                    self?.hideLoader()
                }
            }
        }

    }

    // MARK: - Private functions
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.registerCell(ClassifiedCell.self)
    }

    private func fetchData() {
        showLoader()
        viewModel.fetchClassifiedAds()
    }

    private func addLoader() {
        view.addSubview(loader)
        NSLayoutConstraint.activate([
            loader.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loader.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func showLoader() {
        loader.startAnimating()
    }

    private func hideLoader() {
        loader.stopAnimating()
    }
}

// MARK: - TableView Delegates
extension ClassfiedListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.numberOfItems
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        10
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        header.backgroundColor = .clear
        return header
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ClassifiedCell.cellIdentifier, for: indexPath) as? ClassifiedCell else { return UITableViewCell() }
        if let item = viewModel.item(at: indexPath.section) {
            cell.setupView(with: item)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? ClassifiedCell,
            let item = viewModel.item(at: indexPath.section),
            let url = URL(string: item.image_urls.first!) else { return }

        viewModel.downloadImage(with: url) { (data, _) in
            guard let data = data as Data? else { return }
            cell.setImage(with: data)
        }
    }

    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let item = viewModel.item(at: indexPath.section),
            let url = URL(string: item.image_urls.first!) else { return }
        viewModel.pauseImageDownload(with: url)
    }

}
