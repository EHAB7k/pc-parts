//
//  NewPieceViewController.swift
//  BP
//
//  Created by Ehab Hakami on 20/05/1443 AH.
//

import UIKit
import Firebase
import SwiftUI
class AddNewPieceViewController: UIViewController{
//    let scrollView = UIScrollView()
//        let contentView = UIView()
    @IBOutlet weak var ScrolInstack: UIStackView!
    
   
    
    
    
    @IBOutlet weak var thePartNameLabel: UILabel!{
        didSet{
            thePartNameLabel.text = "The piece name".localized
        }
    }
    
    @IBOutlet weak var thePriceOfThePieceLabel: UILabel!{
        didSet{
            thePriceOfThePieceLabel.text = "The price of the piece".localized
        }
    }
    
    @IBOutlet weak var PhoneNumberLabel: UILabel!{
        didSet{
            PhoneNumberLabel.text = "Phone number".localized
        }
    }
    
    @IBOutlet weak var ProductInformationLabel: UILabel!{
        didSet{
            ProductInformationLabel.text = "Product information".localized
        }
    }
    
    
    var selectedNewPiece:NewPeice?
    var selectedNewPieceImage:UIImage?
    
    @IBOutlet weak var productInformation: UITextView!
    
    
    @IBOutlet weak var actionButton: UIButton!
        
    
    
    @IBOutlet weak var addNewPieceImageView: UIImageView!{
        didSet {
            addNewPieceImageView.isUserInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
            addNewPieceImageView.addGestureRecognizer(tapGesture)
        }
        
    }
    


    
    
    @IBOutlet weak var phoneNumber: UITextField!
    
    @IBOutlet weak var addTitleTextField: UITextField!
    
    @IBOutlet weak var addDescriptionTextField: UITextField!
    
    let activityIndicator = UIActivityIndicatorView()
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        if let selectedNewPiece = selectedNewPiece,
        let selectedImage = selectedNewPieceImage{
            addTitleTextField.text = selectedNewPiece.title
            addDescriptionTextField.text = selectedNewPiece.description
            productInformation.text = selectedNewPiece.productInformation
            phoneNumber.text = selectedNewPiece.phoneNumber
            addNewPieceImageView.image = selectedImage
            actionButton.setTitle("Update".localized, for: .normal)
            let deleteBarButton = UIBarButtonItem(image: UIImage(systemName: "trash.fill"), style: .plain, target: self, action: #selector(handleDelete))
            self.navigationItem.rightBarButtonItem = deleteBarButton
        }else {
            actionButton.setTitle("Add".localized, for: .normal)
//            DeleteButton.isHidden = true
            self.navigationItem.rightBarButtonItem = nil
            
        }
        
        addTitleTextField.delegate = self
        addDescriptionTextField.delegate = self
        phoneNumber.delegate = self
        

        
            
        productInformation.layer.borderColor = UIColor.systemGray.cgColor
        productInformation.layer.borderWidth = 1.0
        productInformation.layer.masksToBounds = true
        productInformation.layer.cornerRadius = 7
        
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.singleTap(sender:)))
        singleTapGestureRecognizer.numberOfTapsRequired = 1
        singleTapGestureRecognizer.isEnabled = true
        singleTapGestureRecognizer.cancelsTouchesInView = false
        self.view.addGestureRecognizer(singleTapGestureRecognizer)
        



  
//        setupScrollView()
//        setupViews()
//        scrollView.contentSize = CGSize(width: view.frame.size.width, height: 900)
//
//        scrollView.showsVerticalScrollIndicator = false
//        scrollView.showsHorizontalScrollIndicator = false

    }
    
    @objc func singleTap(sender: UITapGestureRecognizer) {
        self.productInformation.resignFirstResponder()
        self.addTitleTextField.resignFirstResponder()
        self.phoneNumber.resignFirstResponder()
        self.addDescriptionTextField.resignFirstResponder()
    }
    
    func deleteText() {
        productInformation.text = ""
        addTitleTextField.text = ""
        phoneNumber.text = ""
        addDescriptionTextField.text = ""
        addNewPieceImageView.image = UIImage(systemName: "photo.artframe")
}

    
    

       

 



//    override func viewDidLayoutSubviews() {
//
//        let scrollView = UIScrollView(frame: CGRect(x:10, y:10 , width: view.frame.size.width, height: view.frame.size.height - 20))
//
////
//
//
//
//
////        let centerOffsetX = (scrollView.contentSize.width - scrollView.frame.size.width) / 2
////        let centerOffsetY = (scrollView.contentSize.height - scrollView.frame.size.height) / 2
////        let centerPoint = CGPoint(x: centerOffsetX, y: centerOffsetY)
////        scrollView.setContentOffset(centerPoint, animated: true)
//
//
////        NSLayoutConstraint.activate([
////           scrollView.topAnchor.constraint(equalTo: view.topAnchor),
////           scrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
////           scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
////           scrollView.leftAnchor.constraint(equalTo: view.leftAnchor)
////         ])
//
//        view.addSubview(scrollView)
//
//        scrollView.addSubview(ScrolInstack)
//
//
//
//        scrollView.contentSize = CGSize(width: view.frame.size.width, height: 1200)
//        scrollView.showsVerticalScrollIndicator = false
//        scrollView.showsHorizontalScrollIndicator = false
//
//    }
    
    @objc func tapDone(sender: Any) {
          self.view.endEditing(true)
      }
    

    

        
    
    @objc func handleDelete (_ sender: UIBarButtonItem) {
        let ref = Firestore.firestore().collection("addPiece")
        if let selectedNewPiece = selectedNewPiece {
            //Activity.showIndicator(parentView: self.view, childView: activityIndicator)
            let alert = UIAlertController(title: "The deletion was successful".localized, message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Done".localized, style: .default, handler: {(action: UIAlertAction) in
                self.navigationController?.popViewController(animated: true)
               
                
            }))
            
            self.present(alert, animated: true, completion: nil)
            ref.document(selectedNewPiece.id).delete { error in
                if let error = error {
                    print("Error in db delete",error)
                }else {
                    // Create a reference to the file to delete
                    let storageRef = Storage.storage().reference(withPath: "addPiece/\(selectedNewPiece.user.id)/\(selectedNewPiece.id)")
                    // Delete the file
                    storageRef.delete { error in
                        if let error = error {
                            print("Error in storage delete",error)
                        } else {
                            self.activityIndicator.stopAnimating()
                            self.navigationController?.popViewController(animated: true)
                            
                        }
                    }
                    
                }
            }
        }
    }
    
    
    @IBAction func handleAddNewPiece(_ sender: Any) {
        if let image = addNewPieceImageView.image,
           let imageData = image.jpegData(compressionQuality: 0.75),
           let title = addTitleTextField.text,
           let description = addDescriptionTextField.text,
           let productInformation = productInformation.text,
           let phoneNumber = phoneNumber.text,
           let currentUser = Auth.auth().currentUser {
            Activity.showIndicator(parentView: self.view, childView: activityIndicator)
//            ref.addDocument(data:)
            var pieceId = ""
            if let selectedNewPiece = selectedNewPiece {
                pieceId = selectedNewPiece.id
            }else {
                pieceId = "\(Firebase.UUID())"
            }
            let storageRef = Storage.storage().reference(withPath: "piecess/\(currentUser.uid)/\(pieceId)")
            let updloadMeta = StorageMetadata.init()
            updloadMeta.contentType = "image/jpeg"
            storageRef.putData(imageData, metadata: updloadMeta) { storageMeta, error in
                if let error = error {
                    print("Upload error",error.localizedDescription)
                }
                storageRef.downloadURL { url, error in
                    var pieceData = [String:Any]()
                    if let url = url {
                        let db = Firestore.firestore()
                        let ref = db.collection("addPiece")
                        if let selectedNewPiece = self.selectedNewPiece {
                            pieceData = [
                                "userId":selectedNewPiece.user.id,
                                "title":title,
                                "description":description,
                                "productInformation":productInformation,
                                "phoneNumber":phoneNumber,
                                "imageUrl":url.absoluteString,
                                "createdAt":selectedNewPiece.createdAt ?? FieldValue.serverTimestamp(),
                                "updatedAt": FieldValue.serverTimestamp()
                            ]
                        }else {
                            pieceData = [
                                "userId":currentUser.uid,
                                "title":title,
                                "description":description,
                                "productInformation":productInformation,
                                "phoneNumber":phoneNumber,
                                "imageUrl":url.absoluteString,
                                "createdAt":FieldValue.serverTimestamp(),
                                "updatedAt": FieldValue.serverTimestamp()
                            ]
                        }
                        ref.document(pieceId).setData(pieceData) { error in
                            if let error = error {
                                print("FireStore Error",error.localizedDescription)
                            }
                            Activity.removeIndicator(parentView: self.view, childView: self.activityIndicator)
                            self.navigationController?.popViewController(animated: true)
                            let alert = UIAlertController(title: "Added succeesfully".localized, message: "", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Done".localized, style: .default, handler: {(action: UIAlertAction) in
                               
                                
                            }))
                            self.deleteText()
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                }
            }
        }
        
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


extension AddNewPieceViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @objc func chooseImage() {
        self.showAlert()
    }
    private func showAlert() {
        
        let alert = UIAlertController(title: "Choose Profile Picture", message: "From where you want to pick this image?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action: UIAlertAction) in
            self.getImage(fromSourceType: .camera)
        }))
        alert.addAction(UIAlertAction(title: "Photo Album", style: .default, handler: {(action: UIAlertAction) in
            self.getImage(fromSourceType: .photoLibrary)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    //get image from source type
    private func getImage(fromSourceType sourceType: UIImagePickerController.SourceType) {
        
        //Check is source type available
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = sourceType
            self.present(imagePickerController, animated: true, completion: nil)
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let chosenImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        addNewPieceImageView.image = chosenImage
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}
extension AddNewPieceViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        addTitleTextField.resignFirstResponder()
        phoneNumber.resignFirstResponder()
        addDescriptionTextField.resignFirstResponder()

           self.view.endEditing(true)
        print("retern button preessd ")
        return true
    }

}

