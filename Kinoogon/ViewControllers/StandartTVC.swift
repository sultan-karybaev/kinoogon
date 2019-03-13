//
//  StandartTVC.swift
//  Kinoogon
//
//  Created by Sultan Karybaev on 2/14/19.
//  Copyright © 2019 Sultan Karybaev. All rights reserved.
//

import UIKit

class StandartTVC: UITableViewController {
    
    public var hostID: String?
    private var dataDictionary: [String: Data] = [:]
    public var infoModelArray: [InfoModel] = [InfoModel]()
    public var isSelectable: Bool = false
    public var selectCode: Int = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        setData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear \(hostID)")
    }
    
    private func setData() {
        print("setData setData setData \(hostID)")
        guard let hostID = hostID else { return }
        print("HOSTS_IMAGES_DICTIONARY \(DataStorage.instance.HOSTS_IMAGES_DICTIONARY[hostID])")
        guard let data = DataStorage.instance.HOSTS_IMAGES_DICTIONARY[hostID] else { return }
        dataDictionary = data
        print("data \(dataDictionary)")
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
            print("dataDictionary")
            cell.mainImage.image = UIImage(data: data)
        } else {
            print("DownloadService")
            cell.mainImage.image = nil
            DownloadService.getImage(indexPath: indexPath, path: infoModel.image) { (success, ind, data) in
                if success {
                    guard let cell = tableView.cellForRow(at: ind) as? StandartCell else { return }
                    cell.mainImage.image = UIImage(data: data)
                    self.dataDictionary[infoModel.image] = data
                    if let hostID = self.hostID {
                        DataStorage.instance.HOSTS_IMAGES_DICTIONARY[hostID] = self.dataDictionary
                    }
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print("didSelectRowAt didSelectRowAt \(self.parent?.navigationController?.children)")
        tableView.deselectRow(at: indexPath, animated: false)
        if isSelectable {
            if selectCode == 1 {
                guard let profileVC = storyboard?.instantiateViewController(withIdentifier: "ProfileVC") as? ProfileVC else { return }
                guard let tabBC = self.parent?.tabBarController else { return }
                let infoModel = infoModelArray[indexPath.row]
                guard let name = infoModel.title else { return }
                guard let id = infoModel.id else { return }
                profileVC.hostName = name
                profileVC.hostID = id
                //self.navigationController.navigationBar.tintColor=[UIColor readcolor]
                self.parent?.navigationController?.navigationBar.tintColor = #colorLiteral(red: 1, green: 0.5764705882, blue: 0, alpha: 1)
                self.parent?.navigationController?.viewControllers = [tabBC]
                //print("self.parent?.tabBarController \(self.parent?.tabBarController)")
                self.parent?.navigationController?.pushViewController(profileVC, animated: true)
            }
        }
    }

}
