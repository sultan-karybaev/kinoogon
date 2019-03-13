//
//  GreenVC.swift
//  Kinoogon
//
//  Created by Sultan Karybaev on 3/6/19.
//  Copyright © 2019 Sultan Karybaev. All rights reserved.
//

import UIKit

class GreenVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //addSub()
    }
    
    @IBAction func buttonWasPressed(_ sender: Any) {
        guard let redVC = storyboard?.instantiateViewController(withIdentifier: "RedVC") as? RedVC else { return }
        guard let nav = self.navigationController?.view else { return }
        self.navigationController?.addChild(redVC)
        self.navigationController?.view.addSubview(redVC.view)
        redVC.view.translatesAutoresizingMaskIntoConstraints = false
        redVC.view.topAnchor.constraint(equalTo: nav.topAnchor, constant: 100).isActive = true
        redVC.view.leadingAnchor.constraint(equalTo: nav.leadingAnchor, constant: 100).isActive = true
        redVC.view.widthAnchor.constraint(equalToConstant: 100).isActive = true
        redVC.view.heightAnchor.constraint(equalToConstant: 100).isActive = true
        //redVC.view.trailingAnchor.constraint(equalTo: nav.trailingAnchor, constant: 100).isActive = true
        //redVC.view.bottomAnchor.constraint(equalTo: nav.bottomAnchor, constant: 100).isActive = true
    }
    
    @IBAction func button222WasPressed(_ sender: Any) {
        print("addSub \(self.navigationController?.children)")
        print("addSub \(self.navigationController?.viewControllers)")
        
        guard let blueVC = storyboard?.instantiateViewController(withIdentifier: "BlueVC") as? BlueVC else { return }
        self.navigationController?.viewControllers = [self]
        self.navigationController?.pushViewController(blueVC, animated: true)
    }
    
    private func addSub() {
        guard let redVC = storyboard?.instantiateViewController(withIdentifier: "RedVC") as? RedVC else { return }
        guard let nav = self.navigationController?.view else { return }
        let view = UIView(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
        view.backgroundColor = #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1)
        //view.addSubview(redVC.view)
        //redVC.view.frame = CGRect(x: 0, y: 100, width: 100, height: 100)
        //self.navigationController?.addChild(redVC)
        self.navigationController?.addChild(redVC)
        
        
        //self.navigationController?.child
        //self.navigationController?.view.addSubview(view)
        //self.navigationController?.view.layoutIfNeeded()
        //self.navigationController?.children.append(redVC)
    }
    
}
