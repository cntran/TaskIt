//
//  AddTaskViewController.swift
//  TaskIt
//
//  Created by Craig Tran on 1/15/15.
//  Copyright (c) 2015 SDBX Studio. All rights reserved.
//

import UIKit
import CoreData

protocol AddTaskViewControllerDelegate {
    func addTask(message: String)
    func addTaskCancelled(message: String)
}

class AddTaskViewController: UIViewController {

    
    @IBOutlet weak var taskTextField: UITextField!
    @IBOutlet weak var subtaskTextField: UITextField!
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    
    var delegate: AddTaskViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Background")!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelButtonTapped(sender: UIButton) {
        self.dismissViewControllerAnimated(true , completion: nil)
        delegate?.addTaskCancelled("Task was not added")
    }
    

    @IBAction func addTaskButtonTapped(sender: UIButton) {
        
        let appDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
       
        let entityDescription = NSEntityDescription.entityForName("TaskModel", inManagedObjectContext: ModelManager.instance.managedObjectContext!)
        let newTask = TaskModel(entity: entityDescription!, insertIntoManagedObjectContext: ModelManager.instance.managedObjectContext!)
        
        if NSUserDefaults.standardUserDefaults().boolForKey(kShouldCompleteNewTodoKey) == true {
            newTask.task = taskTextField.text.capitalizedString
        }
        else {
            newTask.task = taskTextField.text
        }
        newTask.subtask = subtaskTextField.text
        newTask.date = dueDatePicker.date
        
        if NSUserDefaults.standardUserDefaults().boolForKey(kShouldCompleteNewTodoKey) == true {
            newTask.completed = true
        }
        else {
            newTask.completed = false
        }
        
        ModelManager.instance.saveContext()
        
        var request = NSFetchRequest(entityName: "TaskModel")
        var error:NSError? = nil
        
        var results:NSArray = ModelManager.instance.managedObjectContext!.executeFetchRequest(request, error: &error)!
        
        
        for res in results {
            println(res)
        }
        
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        delegate?.addTask("Task Added")
    }
}
