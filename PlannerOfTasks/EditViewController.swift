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
    @IBOutlet var reasonView: UITextView!
    @IBOutlet var labelReason: UILabel!
    @IBOutlet weak var buttonUnlock: UIButton!
    @IBOutlet weak var statusControl: UISegmentedControl!
    
    @IBAction func buttonLock(_ sender: UIButton) {
        nameField.isEnabled = true
        categoryField.isEnabled = true
        targetView.isSelectable = true
        targetView.isEditable = true
        reasonView.isEditable = true
        toolsField.isEnabled = true
        authorField.isEnabled = true
        statusControl.isEnabled = true
        buttonUnlock.isHidden = false
        datePicker.isEnabled = true
        sender.isHidden = true
    }
    
//    @IBAction func tap(_ sender: UIPanGestureRecognizer) {
//        if nameField.isSelected{
//            nameField.resignFirstResponder()}
//        if categoryField.isSelected{
//            categoryField.resignFirstResponder()}
//        if targetView.isSelectable{
//            targetView.resignFirstResponder()}
//        if toolsField.isSelected{
//            toolsField.resignFirstResponder()}
//        if authorField.isSelected{
//            authorField.resignFirstResponder()}
//        if reasonView.isSelectable{
//            reasonView.resignFirstResponder()}
//
//    }
    var name: String = ""
    var category: String = ""
    var target: String = ""
    var tools: String = ""
    var author: String = ""
    var date: Date = Date()
    var status: String = ""
    var reason: String = ""
    
    public var completion: ((String, String, String, String, String, Date, String) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameField.delegate = self
        categoryField.delegate = self
        toolsField.delegate = self
        authorField.delegate = self
        nameField.text = name
        categoryField.text = category
        targetView.text = target
        toolsField.text = tools
        authorField.text = author
        datePicker.date = date
        //view.addSubview()
        
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
//            removeReason()
        }
        else if status == "В процессе"{
            statusControl.selectedSegmentIndex = 1
//            removeReason()
        }
        else if status == "Просрочено"{
            statusControl.selectedSegmentIndex = 2
//            getReason()
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Сохранить",style: .done, target: self, action: #selector(saveTask))
    }
    
    @IBAction func didChangeSegment(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0{
            status = "Выполнено"
//            removeReason()
        }
        else if sender.selectedSegmentIndex == 1{
            status = "В процессе"
//            removeReason()
        }
        else if sender.selectedSegmentIndex == 2{
            status = "Просрочено"
//            getReason()
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
    
    //Убирает клавиаутуру после нажатия "Ввод"
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
//    //Скрывает поле для ввода причины (Статус "Выполнено" или "В процессе")
//    func removeReason(){
//        for constraint in self.reasonView.constraints{
//            if constraint.identifier == "myConstraints20" || constraint.identifier == "myConstraints40"  || constraint.identifier == "myConstraints115" {
//                constraint.constant = 0
////                constraint.priority = UILayoutPriority(rawValue: 750)
//            }
//        }
//        reasonView.isHidden = true
//        reasonView.isEditable = false
//        labelReason.updateConstraints()
//        labelReason.layoutIfNeeded()
//    for constraint in self.labelReason.constraints{
//        if constraint.identifier == "myConstraints20" || constraint.identifier == "myConstraints40" || constraint.identifier == "myConstraints24"  {
//                constraint.constant = 0
////                constraint.priority = UILayoutPriority(rawValue: 750)
//
//        }
//    }
//        labelReason.isHidden = true
//        labelReason.updateConstraints()
//        labelReason.layoutIfNeeded()
//
//        for constraint in self.statusControl.constraints{
//            if constraint.identifier == "myConstraints239"{
////                constraint.priority = UILayoutPriority(rawValue: 1250)
//                constraint.constant = 40
//            }
//        }
//        statusControl.updateConstraints()
//        statusControl.layoutIfNeeded()
//    }
//    //Показывает поле для ввода причины (Статус "Просрочено")
//    func getReason(){
//        for constraint in self.labelReason.constraints{
//            if constraint.identifier == "myConstraints20"{
//                constraint.constant = 20
////                constraint.priority = UILayoutPriority(rawValue: 1000)
//            }
//            if constraint.identifier == "myConstraints40"{
//                constraint.constant = 40
////                constraint.priority = UILayoutPriority(rawValue: 1000)
//
//            }
//            if constraint.identifier == "myConstraints24"{
//                constraint.constant = 24
////                constraint.priority = UILayoutPriority(rawValue: 1000)
//            }
//        }
//        labelReason.isHidden = false
//        labelReason.updateConstraints()
//        labelReason.layoutIfNeeded()
//
//        for constraint in self.reasonView.constraints{
//            if constraint.identifier == "myConstraints20"{
//                constraint.constant = 20
////                constraint.priority = UILayoutPriority(rawValue: 1000)
//
//            }
//            if constraint.identifier == "myConstraints40"{
//                constraint.constant = 40
////                constraint.priority = UILayoutPriority(rawValue: 1000)
//
//            }
//            if constraint.identifier == "myConstraints115"{
//                constraint.constant = 115
////                constraint.priority = UILayoutPriority(rawValue: 1000)
//
//            }
//        }
//        reasonView.isHidden = false
//        labelReason.updateConstraints()
//        labelReason.layoutIfNeeded()
////
////        for constraint in self.statusControl.constraints{
////            if constraint.identifier == "myConstraints239"{
////                constraint.constant = 239
////            }
////        }
////        statusControl.updateConstraints()
////        statusControl.layoutIfNeeded()
//
//    }

}



