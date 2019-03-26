//
//  HostsVC.swift
//  Kinoogon
//
//  Created by Sultan Karybaev on 2/21/19.
//  Copyright © 2019 Sultan Karybaev. All rights reserved.
//

import UIKit

class HostsVC: UIViewController {
    @IBOutlet weak var viewForTable: UIView!
    
    private var hostsArray: [InfoModel] = [InfoModel]()
    private var tableVC: StandartTVC!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTableView()
        setData()
        let textAttributes = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)]
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes
    }
    
    private func setData() {
        hostsArray = DataService.instance.HOSTS_ARRAY
        if hostsArray.isEmpty {
            DataService.instance.getAllHosts { (success) in
                if success {
                    self.hostsArray = DataService.instance.HOSTS_ARRAY
                    self.tableVC.infoModelArray = self.hostsArray
                    self.tableVC.tableView.reloadData()
                    print("hostsArray \(self.hostsArray.count)")
                }
            }
        } else {
            self.tableVC.infoModelArray = self.hostsArray
            self.tableVC.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBar()
    }
    
    private func setNavigationBar() {
        tabBarController?.navigationItem.title = "Ведущие"
//        self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
//        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
//        self.navigationController?.navigationBar.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
    }
    
    private func addTableView() {
        guard let standartTVC = storyboard?.instantiateViewController(withIdentifier: "StandartTVC") as? StandartTVC else { return }
        tableVC = standartTVC
        standartTVC.isSelectable = true
        standartTVC.selectCode = 1
        addChild(standartTVC)
        viewForTable.addSubview(standartTVC.view)
        standartTVC.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: standartTVC.view, attribute: .top, relatedBy: .equal, toItem: viewForTable, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: standartTVC.view, attribute: .leading, relatedBy: .equal, toItem: viewForTable, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: standartTVC.view, attribute: .trailing, relatedBy: .equal, toItem: viewForTable, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: standartTVC.view, attribute: .bottom, relatedBy: .equal, toItem: viewForTable, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
    }
}
