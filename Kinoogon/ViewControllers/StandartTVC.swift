//
//  StandartTVC.swift
//  Kinoogon
//
//  Created by Sultan Karybaev on 2/14/19.
//  Copyright © 2019 Sultan Karybaev. All rights reserved.
//

import UIKit

class StandartTVC: UITableViewController {
    
    private var dataDictionary: [String: Data] = [:]
    public var infoModelArray: [InfoModel] = [InfoModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return infoModelArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "StandartCell") as? StandartCell else {
            return StandartCell()
        }
        let infoModel = infoModelArray[indexPath.row]
        if let data = dataDictionary[infoModel.image] {
            cell.mainImage.image = UIImage(data: data)
        } else {
            cell.mainImage.image = nil
            DownloadService.getImage(indexPath: indexPath, path: infoModel.image) { (success, ind, data) in
                if success {
                    guard let cell = tableView.cellForRow(at: ind) as? StandartCell else { return }
                    cell.mainImage.image = UIImage(data: data)
                    self.dataDictionary[infoModel.image] = data
                }
            }
        }
        cell.titleLabel.text = infoModel.title
        cell.descriptionLabel.text = infoModel.description
        if indexPath.row == 0 {
            cell.separatorView.isHidden = true
        } else {
            cell.separatorView.isHidden = false
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

}
