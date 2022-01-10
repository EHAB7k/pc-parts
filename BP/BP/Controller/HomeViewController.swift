//
//  HomeViewController.swift
//  BP
//
//  Created by Ehab Hakami on 20/05/1443 AH.
//

import UIKit
import Firebase
class HomeViewController: UIViewController,UISearchBarDelegate{
    var newPieceArr = [NewPeice]()
    var selectedNewPieceModel:NewPeice?
    var selectedNewPieceImage:UIImage?
    
    
    @IBOutlet weak var pieceTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    var filteredData:[NewPeice]!
        
    @IBOutlet weak var pieceTabBar: UINavigationItem!{
        didSet{
            pieceTabBar.title = "Piece".localized
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pieceTableView.delegate = self
        pieceTableView.dataSource = self
        
        searchBar.delegate = self
       
        
           
            self.searchBar.endEditing(true)
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.singleTap(sender:)))
        singleTapGestureRecognizer.numberOfTapsRequired = 1
        singleTapGestureRecognizer.isEnabled = true
        singleTapGestureRecognizer.cancelsTouchesInView = false
        self.view.addGestureRecognizer(singleTapGestureRecognizer)
        
        
        
        filteredData = newPieceArr
        getPiece()
        
        


       
    }
    
    func touch() {
        
        self.view.endEditing(true)
    }

    @objc func singleTap(sender: UITapGestureRecognizer) {
        self.searchBar.resignFirstResponder()
    }
    
    func getPiece() {
        let ref = Firestore.firestore()
        ref.collection("addPiece").order(by: "createdAt",descending: true).addSnapshotListener { snapshot, error in
            if let error = error {
                print("DB ERROR Posts",error.localizedDescription)
            }
            if let snapshot = snapshot {
                print("POST CANGES:",snapshot.documentChanges.count)
                snapshot.documentChanges.forEach { diff in
                    let postData = diff.document.data()
                    switch diff.type {
                    case .added :

                        if let userId = postData["userId"] as? String {
                            ref.collection("users").document(userId).getDocument { userSnapshot, error in
                                if let error = error {
                                    print("ERROR user Data",error.localizedDescription)

                                }
                                if let userSnapshot = userSnapshot,
                                   let userData = userSnapshot.data(){
                                    let user = User(dict:userData)
                                    let post = NewPeice(dict:postData,id:diff.document.documentID,user:user)
                                    self.pieceTableView.beginUpdates()
                                    if snapshot.documentChanges.count != 1 {
                                        self.newPieceArr.append(post)

                                        self.pieceTableView.insertRows(at: [IndexPath(row:self.newPieceArr.count - 1,section: 0)],with: .automatic)
                                    }else {
                                        self.newPieceArr.insert(post,at:0)

                                        self.pieceTableView.insertRows(at: [IndexPath(row: 0,section: 0)],with: .automatic)
                                    }

                                    self.pieceTableView.endUpdates()


                                }
                            }
                        }
                    case .modified:
                        let postId = diff.document.documentID
                        if let currentPost = self.newPieceArr.first(where: {$0.id == postId}),
                           let updateIndex = self.newPieceArr.firstIndex(where: {$0.id == postId}){
                            let newPost = NewPeice(dict:postData, id: postId, user: currentPost.user)
                            self.newPieceArr[updateIndex] = newPost

                                self.pieceTableView.beginUpdates()
                                self.pieceTableView.deleteRows(at: [IndexPath(row: updateIndex,section: 0)], with: .left)
                                self.pieceTableView.insertRows(at: [IndexPath(row: updateIndex,section: 0)],with: .left)
                                self.pieceTableView.endUpdates()

                        }
                    case .removed:
                        let postId = diff.document.documentID
                        if let deleteIndex = self.newPieceArr.firstIndex(where: {$0.id == postId}){
                            self.newPieceArr.remove(at: deleteIndex)

                                self.pieceTableView.beginUpdates()
                                self.pieceTableView.deleteRows(at: [IndexPath(row: deleteIndex,section: 0)], with: .automatic)
                                self.pieceTableView.endUpdates()

                        }
                    }
                }
            }
        }
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "toPostVC" {
                let vc = segue.destination as! AddNewPieceViewController
                vc.selectedNewPiece = selectedNewPieceModel
                vc.selectedNewPieceImage = selectedNewPieceImage
            }else {
                
               let vc = segue.destination as! DetailsViewController
                vc.selectedNewPiece = selectedNewPieceModel
                vc.selectedNewPieceImage = selectedNewPieceImage
            }
        }
     
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredData = []
        if searchText == "" {
            filteredData = newPieceArr
        }else{
            for fruit in newPieceArr {
                if fruit.title.lowercased().contains(searchText.lowercased()){
                    filteredData.append(fruit)
                }
            }
        }
        self.pieceTableView.reloadData()
    }
    
    
}


extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filteredData.count > 0 {
            return filteredData.count
        } else {
            return newPieceArr.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! NewPieceCell
        
        
        if filteredData.count > 0 {
        return cell.configure(with: filteredData[indexPath.row])
        } else {
            return cell.configure(with: newPieceArr[indexPath.row])
        }
    }
    
    
}
extension HomeViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.height/6
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! NewPieceCell
        selectedNewPieceImage = cell.newPieceImageView.image
        selectedNewPieceModel = newPieceArr[indexPath.row]
        if let currentUser = Auth.auth().currentUser,
           currentUser.uid == newPieceArr[indexPath.row].user.id{
          performSegue(withIdentifier: "toPostVC", sender: self)
        }else {
            performSegue(withIdentifier: "toDetailsVC", sender: self)
            
        }
    }
    

}




