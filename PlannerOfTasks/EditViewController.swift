//
//  EditViewController.swift
//  PlannerOfTasks
//
//  Created by Илья Викторов on 24.10.2020.
//

import UIKit

class EditViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate{

    @IBOutlet var timeLeft: UILabel!
    @IBOutlet var nameField: UITextField!
    @IBOutlet var categoryField: UITextField!
    @IBOutlet var targetView: UITextView!
    @IBOutlet var toolsField: UITextField!
    @IBOutlet var authorField: UITextField!
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var statusSwitch: UISwitch!
    @IBOutlet weak var buttonUnlock: UIButton!
    @IBOutlet weak var statusControl: UISegmentedControl!
    
    @IBAction func buttonLock(_ sender: UIButton) {
        nameField.isEnabled = true
        categoryField.isEnabled = true
        targetView.isSelectable = true
        targetView.isEditable = true
        toolsField.isEnabled = true
        authorField.isEnabled = true
        statusControl.isEnabled = true
        buttonUnlock.isHidden = false
        datePicker.isEnabled = true
        sender.isHidden = true
    }
    
    var name: String = ""
    var category: String = ""
    var target: String = ""
    var tools: String = ""
    var author: String = ""
    var date: Date = Date()
    var status: String = ""
//    var arrReason: [ReasonTask]{
//        get{
//            if let data = UserDefaults.standard.value(forKey: "ReasonDataKy") as? Data{
//                return try! PropertyListDecoder().decode([ReasonTask].self, from: data)
//            }else{
//                return [ReasonTask]()
//            }
//        }
//        set{
//            if let data = try? PropertyListEncoder().encode(newValue){
//                UserDefaults.standard.set(data, forKey: "ReasonDataKey")
//            }
//        }
//    }
    
    public var completion: ((String, String, String, String, String, Date, String) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameField.text = name
        categoryField.text = category
        targetView.text = target
        toolsField.text = tools
        authorField.text = author
        datePicker.date = date
        
        let dateCurrent = Date()
        let diffDate = (date.timeIntervalSince(dateCurrent)) / 60 / 60 / 24
        let roundDiffDate = Int(round(diffDate))
        if roundDiffDate < 0{
            status = "Просрочено"
        }
        if status == "В процессе"{
            timeLeft.text = "Осталось дней: \(roundDiffDate)"
        }
        else if status == "Просрочено"{
            timeLeft.text = "Задача просрочена на \(abs(roundDiffDate)) д."
        }
        else if status == "Выполнено"{
            timeLeft.text = "Задача выполнена!"
        }
        if status == "Выполнено"{
            statusControl.selectedSegmentIndex = 0
        }
        else if status == "В процессе"{
            statusControl.selectedSegmentIndex = 1
        }
        else if status == "Просрочено"{
            statusControl.selectedSegmentIndex = 2
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Сохранить",style: .done, target: self, action: #selector(saveTask))
    }
    
    @IBAction func didChangeSegment(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0{
            status = "Выполнено"
        }
        else if sender.selectedSegmentIndex == 1{
            status = "В процессе"
        }
        else if sender.selectedSegmentIndex == 2{
            status = "Просрочено"
        }
    }
    
    @objc func saveTask(){
    
        if let nameText = nameField.text, !nameText.isEmpty,
    
           let categoryText = categoryField.text, !categoryText.isEmpty,
           
           let targetText = targetView.text, !targetText.isEmpty,
           
           let toolsText = toolsField.text,
           
           let authorText = authorField.text, !authorText.isEmpty{
            
            let targetDate = datePicker.date

            completion?(nameText, categoryText, targetText, toolsText, authorText, targetDate, status)
        }
    }
    
    

}

//class ReasonTask: Codable{
//    var reason: String
//    var identifier: String
//
//    init(reason: String = "", identifier: String){
//        self.reason = reason
//        self.identifier = identifier
//    }
//}
