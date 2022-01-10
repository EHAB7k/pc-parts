//
//  SettingsViewController.swift
//  BP
//
//  Created by Ehab Hakami on 01/06/1443 AH.
//

import UIKit
import Firebase
class SettingsViewController: UIViewController {
    
    @IBOutlet weak var settingTableView: UITableView!
    
    
    var settingArr:[Settings] = []
    
    
    var language = Settings(name: "Language", image: "globe")
    var logOut = Settings(name: "Logout", image: "person.crop.circle.badge.xmark")
    override func viewDidLoad() {
        super.viewDidLoad()
        settingTableView.delegate = self
        settingTableView.dataSource = self
        
        language.name = "Language".localized
        logOut.name = "Logout".localized
        
        settingArr = [language,logOut]
        
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
    
//    private func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath){
//        if indexPath.row == 0 {
//            print("Segue1")
//            performSegue(withIdentifier: "language", sender: self)
//        }
//    }
//    //        }else if indexPath.row == 1 {
//    //            print("LogOut")
//    //            do {
//    //                try Auth.auth().signOut()
//    //                if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LandingNavigationController") as? UINavigationController {
//    //                    vc.modalPresentationStyle = .fullScreen
//    //                    self.present(vc, animated: true, completion: nil)
//    //                }
//    //            } catch  {
//    //                print("ERROR in signout",error.localizedDescription)
//    //            }
//    //
//    //
//    //        }
//    //        else if indexPath.row == 2
//    //        {
//    //            println("Segue3")
//    //            self.performSegueWithIdentifier("Segue3", sender: self)
//    //        }
//
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 1 {
            print("LogOut")
            do {
                try Auth.auth().signOut()
                if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LandingNavigationController") as? UINavigationController {
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true, completion: nil)
                }
            } catch  {
                print("ERROR in signout",error.localizedDescription)
            }
            
            
        } else {
            print("Segue1")
            performSegue(withIdentifier: "language", sender: self)
            
            
        }
    }
} // end extantion
