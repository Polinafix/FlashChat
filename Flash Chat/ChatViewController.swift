//
//  ViewController.swift
//  Flash Chat
//
//  Created by Polina Fiksson.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import Firebase


class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    
    
    // Declare instance variables here

    
    // We've pre-linked the IBOutlets
    @IBOutlet var heightConstraint: NSLayoutConstraint!
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var messageTextfield: UITextField!
    @IBOutlet var messageTableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TODO: Set yourself as the delegate and datasource here:
        messageTableView.delegate = self
        messageTableView.dataSource = self
        
        //TODO: Set yourself as the delegate of the text field here:
        messageTextfield.delegate = self

        //TODO: Set the tapGesture here:
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
        messageTableView.addGestureRecognizer(tapGesture)
        
        

        //TODO: Register your MessageCell.xib file here:
        messageTableView.register(UINib(nibName:"MessageCell",bundle: nil), forCellReuseIdentifier: "customMessageCell")
        
        configureTableView()

        
    }

    ///////////////////////////////////////////
    
    //MARK: - TableView DataSource Methods
    
    //TODO: Declare cellForRowAtIndexPath here:
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //1.create a custom cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "customMessageCell", for: indexPath) as! CustomMessageCell
        
        //specify text to display in our cells
        let messageArray = ["first message", "second message", "third message"]
        cell.messageBody.text = messageArray[indexPath.row]
        
        return cell
    }
    
    
    
    //TODO: Declare numberOfRowsInSection here:
    //how many cells we want
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    
    
    //TODO: Declare tableViewTapped here:
    @objc func tableViewTapped() {
        //will call textFieldEndEditing
        messageTextfield.endEditing(true)
    }
    
    
    
    //TODO: Declare configureTableView here:
    
    func configureTableView() {
        //create a cell based on the content dimensions
        //use a default value for a given dimension
        messageTableView.rowHeight = UITableViewAutomaticDimension
        //specify the estimated height
        messageTableView.estimatedRowHeight = 120.0
    }
    
    
    
    ///////////////////////////////////////////
    
    //MARK:- TextField Delegate Methods
    
    

    
    //TODO: Declare textFieldDidBeginEditing here:
    //when some activity is detected inside the textField(user is beginning to type inside the field)
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        UIView.animate(withDuration: 0.5) {
            //increase the height constraint for the text field to go up
            //258(keyboard height) + 50(text field height)
            self.heightConstraint.constant = 308
            //BUT we have to call on auto layout to update all the views to redraw everything on screen before this code comes into action
            self.view.layoutIfNeeded()//if the cinstraint has changed > redraw
        }
    }
    
    
    
    
    //TODO: Declare textFieldDidEndEditing here:
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5) {
            self.heightConstraint.constant = 50
            self.view.layoutIfNeeded()
        }
    }
    

    
    ///////////////////////////////////////////
    
    
    //MARK: - Send & Recieve from Firebase
    
    
    @IBAction func sendPressed(_ sender: AnyObject) {
        
        
        //TODO: Send the message to Firebase and save it in our database
        
        
    }
    
    //TODO: Create the retrieveMessages method here:
    
    

    
    
    
    @IBAction func logOutPressed(_ sender: AnyObject) {
        
        //TODO: Log out the user and send them back to WelcomeViewController
        
        do {
            //method that can throw an error
           try Auth.auth().signOut()
            //back to Welcome VC
           navigationController?.popToRootViewController(animated: true)
        }
        //if error occurs(it fails)
        catch {
            print("Error. There was a problem signing out.")
        }
        
        
        
    }
    


}
