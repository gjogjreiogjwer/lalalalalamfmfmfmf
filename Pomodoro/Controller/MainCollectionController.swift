//
//  MainCollectionController.swift
//  Pomodoro
//
//  Created by 金一成 on 2020/10/18.
//

import UIKit
import Alamofire
import SwiftyJSON


/*
 Main menu interface
 */
class MainCollectionController: UICollectionViewController {
    
    // Used to link cell
    private let reuseIdentifier = "cell"
    
    // Style array
    private let styles = ["Normal", "Flip", "Microphone"]
    
    // Message for each card
    private let dict:[String:String] = [
        "List": "Each task can be added, deleted, edited, and queried. Moreover, each task takes different time to complete.",
        "Setting": "Account message.",
        "Ranking": "Ranking of scores.",
        "Style": "Current style: "]
    
    // UIView for each card
    private var cardViewArr: [UIView] = []
    
    // The number of cells
    private let cellsNum = 4
    
    //Description for style card
    private var styleDescribe: UILabel!
    
    // Frame of card 
    private var cardFrame: CGRect!
    
    
    // MARK: - System methods

    /*
     init
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        TimerController.timerStyle = UserDefaults.standard.integer(forKey: "style")
    }
    
    
    /*
     Request ranking from server and hide navigation bar
     @parameter animated: perform animation or not
     */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    
    /*
     Show navigation bar in next page
     @parameter animated: perform animation or not
     */
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    
    // MARK: - Navigation
    
    /*
     Transfer message to next pages
     @parameter segue: segue to which pages
     @parameter sender: message when segue button(empty in default)
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Style"{
            let vc = segue.destination as! StyleTableController
            vc.describe = styleDescribe
        }
    }
    

    // MARK: - UICollectionViewDataSource

    /*
     @parameter collectionView: current collection view
     @returns: the number of sections
     */
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    /*
     @parameter collectionView: current collection view
     @parameter numberOfItemsInSection: row in which section
     @returns: the number of row
     */
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return cellsNum
    }

    
    /*
     Init cells
     @parameter collectionView: current collection view
     @parameter cellForItemAt: current cell
     @parameter indexPath: cell position
     @returns cell: main collection cell
     */
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MainCollectionCell
        cardFrame = cell.cardView.frame

        if indexPath.row == 0{
            createCard(text: "List")
        }
        else if indexPath.row == 1{
            createCard(text: "Ranking")
        }
        else if indexPath.row == 2{
            createCard(text: "Style")
        }
        else if indexPath.row == 3{
            createCard(text: "Setting")
        }
        
        cell.cardView.addSubview(cardViewArr[indexPath.row])
        return cell
    }
    
    
    // MARK: - Create UI
    
    
    /*
     Create card
     @parameter text: which card will be created
     */
    private func createCard(text:String){
        let shadowView = createShadowView()
        let subView = createSubView(shadowView: shadowView)
        let background = createBackground(subView: subView)
        let subViewTitle = createTitleLabel(text: text, subView: subView)
        let describe = createDescribeLabel(text: text, subView: subView)
        
        subView.addSubview(background)
        subView.insertSubview(subViewTitle, aboveSubview: background)
        subView.insertSubview(describe, aboveSubview: background)
        shadowView.addSubview(subView)
        cardViewArr.append(shadowView)
                
        if text == "List"{
            let tap = UITapGestureRecognizer(target: self, action:#selector(MainCollectionController.handleTapToList(sender:)))
            shadowView.addGestureRecognizer(tap)
        }
        else if text == "Setting"{
            let tap = UITapGestureRecognizer(target: self, action:#selector(MainCollectionController.handleTapToSetting(sender:)))
            shadowView.addGestureRecognizer(tap)
        }
        else if text == "Ranking"{
            let tap = UITapGestureRecognizer(target: self, action:#selector(MainCollectionController.handleTapToRanking(sender:)))
            shadowView.addGestureRecognizer(tap)
        }
        else if text == "Style"{
            let tap = UITapGestureRecognizer(target: self, action: #selector(MainCollectionController.handleTapToStyle(sender:)))
            shadowView.addGestureRecognizer(tap)
        }
    }
    
    
    /*
     Create shadow of card
     @returns shadowView: shadow UIView
     */
    private func createShadowView() -> UIView{
        let shadowView = UIView(frame: cardFrame)

        shadowView.layer.shadowColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        shadowView.layer.shadowOffset = CGSize(width: 10, height: 10)
        shadowView.layer.shadowOpacity = 0.6
        shadowView.layer.shadowRadius = 5.0
        shadowView.clipsToBounds = false
        return shadowView
    }
    
    
    /*
     Create subView of card
     @parameter shadowView: shadow UIView
     @returns subView: subView UIView
     */
    private func createSubView(shadowView: UIView) -> UIView{
        let subView = UIView(frame: shadowView.frame)
        subView.contentMode = .scaleToFill
        subView.layer.cornerRadius = 20.0
        subView.isUserInteractionEnabled = true
        return subView
    }
    
    
    /*
     Create background of card
     @parameter subView: subView UIView
     @returns background: background image
     */
    private func createBackground(subView: UIView) -> UIImageView{
        let background = UIImageView(frame: subView.frame)
        background.contentMode = .scaleToFill
        background.image = UIImage(named: "Pinky")
        background.layer.cornerRadius = 20.0
        background.layer.masksToBounds = true
        return background
    }
    
    
    /*
     Create title of card
     @parameter text: card title
     @parameter subView: subView UIView
     @returns subViewTitle: card title UILabel
     */
    private func createTitleLabel(text:String, subView: UIView) -> UILabel{
        let subViewTitle = UILabel()
        subViewTitle.font = UIFont.boldSystemFont(ofSize: 40)
        subViewTitle.text = text
        subViewTitle.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        subViewTitle.frame.size.width = 200
        subViewTitle.frame.size.height = 50
        subViewTitle.center.x = subView.frame.width / 2 - 60
        subViewTitle.center.y = subView.frame.height / 2 - 50
        return subViewTitle
    }
    
    
    /*
     Create description of card
     @parameter text: card title
     @parameter subView: subView UIView
     @returns subViewTitle: card description UILabel
     */
    func createDescribeLabel(text:String, subView: UIView) -> UILabel{
        let describe = UILabel()
        describe.font = UIFont.systemFont(ofSize: 20)
        describe.numberOfLines = 0
        describe.text = dict[text]
        describe.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        describe.frame.size.width = 300
        describe.frame.size.height = 150
        describe.center.x = subView.frame.width / 2
        if text == "List"{
            describe.center.y = subView.frame.height / 2 + 20
        }
        else if text == "Setting"{
            describe.center.y = subView.frame.height / 2
        }
        else if text == "Style"{
            describe.text! += "\(styles[TimerController.timerStyle])"
            styleDescribe = describe
            
        }
        return describe
    }

    
    // MARK: - Gesture methods
    
    /*
     Click card to link listing page
     @parameter sender: tap gesture recognizer
     */
    @objc func handleTapToList(sender:UITapGestureRecognizer) {
        if sender.state == .ended{
            performSegue(withIdentifier: "List", sender: nil)
        }
    }
    
    
    /*
     Click card to link setting page
     @parameter sender: tap gesture recognizer
     */
    @objc func handleTapToSetting(sender:UITapGestureRecognizer) {
        if sender.state == .ended{
            performSegue(withIdentifier: "Setting", sender: nil)
        }
    }
    
    
    /*
     Click card to link ranking page
     @parameter sender: tap gesture recognizer
     */
    @objc func handleTapToRanking(sender:UITapGestureRecognizer) {
        if sender.state == .ended{
            performSegue(withIdentifier: "Ranking", sender: nil)
        }
    }
    
    
    /*
     Click card to link style page
     @parameter sender: tap gesture recognizer
     */
    @objc func handleTapToStyle(sender:UITapGestureRecognizer) {
        if sender.state == .ended{
            performSegue(withIdentifier: "Style", sender: nil)
        }
    }
    
    
    // MARK: - Helper

    /*
     static method for creating backgound
     @parameter currentView: current view
     */
    class func setBackground(currentView: UIView){
        let background = UIImageView(frame: currentView.frame)
        background.contentMode = .scaleAspectFill
        background.image = UIImage(named: "Yeta")
        background.alpha = 0.3
        currentView.addSubview(background)
    }
    
}


// MARK: - Extension: implement collection flow layout

extension MainCollectionController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 40, left: 10, bottom: 10, right: 10)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 380, height: 180)
    }
    
}


