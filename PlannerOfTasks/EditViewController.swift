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
    @IBOutlet weak var buttonUnlock: UIButton!
    @IBOutlet weak var statusControl: UISegmentedControl!
    @IBOutlet weak var view1: UIView!
    
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
    
    @IBAction func tap(_ sender: UIPanGestureRecognizer) {
        if nameField.isSelected{
            nameField.resignFirstResponder()}
        if categoryField.isSelected{
            categoryField.resignFirstResponder()}
        if targetView.isSelectable{
            targetView.resignFirstResponder()}
        if toolsField.isSelected{
            toolsField.resignFirstResponder()}
        if authorField.isSelected{
            authorField.resignFirstResponder()}
        if reasonView.isSelectable{
            reasonView.resignFirstResponder()}

    }
    var name: String = ""
    var category: String = ""
    var target: String = ""
    var tools: String = ""
    var author: String = ""
    var date: Date = Date()
    var status: String = ""

    
    public var completion: ((String, String, String, String, String, Date, String) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
//            for constraint in self.view1.constraints{
//                if constraint.identifier == "myConstraints"{
//                    constraint.constant = 0
//                }
//            }
//            reasonView.isHidden = true
//             view1.updateConstraints()
//             view1.layoutIfNeeded()
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
//            reasonView.text
//            for constraint in self.view.constraints{
//                if constraint.identifier == "downConstraint"{
//                    constraint.constant = 0
//                }
//            }
            reasonView.isHidden = true
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

