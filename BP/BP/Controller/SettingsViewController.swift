//
//  SettingsViewController.swift
//  BP
//
//  Created by Ehab Hakami on 01/06/1443 AH.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var settingTableView: UITableView!
    
    
    var settingArr:[Settings] = []
    
    
    var settingAppp = Settings(name: "Language", image: "globe")
    override func viewDidLoad() {
        super.viewDidLoad()
        settingTableView.delegate = self
        settingTableView.dataSource = self
        settingArr = [settingAppp]

        // Do any additional setup after loading the view.
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SettingsViewController:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        settingArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        
        
        var content = cell.defaultContentConfiguration()
        
        content.text = settingArr[indexPath.row].name
        let image = UIImage(systemName: settingArr[indexPath.row].image)?.withTintColor(UIColor.systemGray, renderingMode:.alwaysOriginal)
        content.image = image
        content.image = image
        content.imageProperties.maximumSize = CGSize(width: 60, height: 60)
    
        cell.contentConfiguration = content
        cell.accessoryType = .disclosureIndicator
        cell.contentConfiguration = content
        return cell
    }
   
    private func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath)
    {
        if indexPath.row == 0
        {
            print("Segue1")
            performSegue(withIdentifier: "language", sender: self)
        }
//        else if indexPath.row == 1
//        {
//            println("Segue2")
//            self.performSegueWithIdentifier("Segue2", sender: self)
//        }
//        else if indexPath.row == 2
//        {
//            println("Segue3")
//            self.performSegueWithIdentifier("Segue3", sender: self)
//        }

    }
    
    
}
