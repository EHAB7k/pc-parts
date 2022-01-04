//
//  LanguageViewController.swift
//  BP
//
//  Created by Ehab Hakami on 01/06/1443 AH.
//

import UIKit

class LanguageViewController: UIViewController {

    @IBOutlet weak var selectLanguageEn: UILabel!
    @IBOutlet weak var selectLanguageAr: UILabel!
    @IBOutlet weak var btnChangeLanguage: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        selectLanguageAr.text = "اختر لغتك"
        selectLanguageEn.text = "Please, select your language"
        btnChangeLanguage.setTitle("ChangeLanguagh".localized, for: .normal)

        
    }
    
    @IBAction func arabicChanger(_ sender: Any) {
        let currantLang = Locale.current.languageCode
        let newLanguage = currantLang == "en" ? "ar" : "en"
        UserDefaults.standard.setValue([newLanguage], forKey: "AppleLanguages")
        exit(0)
    }

}




