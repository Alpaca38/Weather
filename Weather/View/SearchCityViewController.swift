//
//  SearchCityViewController.swift
//  Weather
//
//  Created by 조규연 on 7/11/24.
//

import UIKit
import SnapKit

final class SearchCityViewController: BaseViewController {
    private let viewModel = SearchCityViewModel()
    private let searchController = UISearchController(searchResultsController: nil)
    private lazy var tableView = {
        let view = UITableView()
        view.backgroundColor = .black
        view.register(SearchCityTableViewCell.self, forCellReuseIdentifier: SearchCityTableViewCell.identifier)
        view.dataSource = self
        view.delegate = self
        self.view.addSubview(view)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.inputViewDidLoadTrigger.value = ()
        setNavi()
        setSearchController()
    }
    
    override func configureLayout() {
        tableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
}

private extension SearchCityViewController {
    func setNavi() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "City"
    }
    
    func setSearchController() {
        searchController.searchBar.tintColor = .white
        searchController.searchBar.placeholder = "도시를 검색할 수 있습니다."
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchResultsUpdater = self
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    func bindData() {
        viewModel.outputCityData.bind { [weak self] _ in
            guard let self else { return }
            tableView.reloadData()
        }
    }
}

extension SearchCityViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        print(searchController.searchBar.text!)
    }
}

extension SearchCityViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.outputCityData.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchCityTableViewCell.identifier, for: indexPath) as! SearchCityTableViewCell
        let data = viewModel.outputCityData.value[indexPath.row]
        cell.configure(data: data)
        return cell
    }
}
