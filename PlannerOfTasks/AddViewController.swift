//
//  AddViewController.swift
//  PlannerOfTasks
//
//  Created by Илья Викторов on 21.10.2020.
//

import UIKit

class AddViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var nameField: UITextField!
    @IBOutlet var categoryField: UITextField!
    @IBOutlet var targetView: UITextView!
    @IBOutlet var toolsField: UITextField!
    @IBOutlet var authorField: UITextField!
    @IBOutlet var datePicker: UIDatePicker!
   

    public var completion: ((String, String, String, String, String, Date, String) -> Void)?
    var status = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameField.delegate = self
        categoryField.delegate = self
        toolsField.delegate = self
        authorField.delegate = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Сохранить",style: .done, target: self, action: #selector(saveTask))
    }
    @objc func saveTask(){
    
        if let nameText = nameField.text, !nameText.isEmpty,
    
           let categoryText = categoryField.text, !categoryText.isEmpty,
           
           let targetText = targetView.text, !targetText.isEmpty,
           
           let toolsText = toolsField.text,
           
           let authorText = authorField.text, !authorText.isEmpty{
            
            let targetDate = datePicker.date
            
            if datePicker.date < Date(){
                status = "Просрочено"
            }
            else{
                status = "В процессе"
            }
            
            completion?(nameText, categoryText, targetText, toolsText, authorText, targetDate, status)
        }
    }
 
    //Убирает клавиаутуру после нажатия "Ввод"
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        scrollView.setContentOffset(CGPoint(x: 0,y: 150), animated: true)
//    }
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        scrollView.setContentOffset(CGPoint(x: 0,y: 150), animated: true)
//    }
//    func textViewDidBeginEditing(_ textView: UITextView) {
//        scrollView.setContentOffset(CGPoint(x: 0,y: 150), animated: true)
//    }
//    func textViewDidEndEditing(_ textView: UITextView) {
//        scrollView.setContentOffset(CGPoint(x: 0,y: 150), animated: true)
//    }
        
        
}
