//
//  ViewController.swift
//  Flash Chat
//
//  Created by Polina Fiksson.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import Firebase
import ChameleonFramework


class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    // Declare instance variables here
    var messageArray : [Message] = [Message]()
    
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
        retrieveMessages()
        
        messageTableView.separatorStyle = .none

        
    }

    ///////////////////////////////////////////
    
    //MARK: - TableView DataSource Methods
    
    //TODO: Declare cellForRowAtIndexPath here:
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //1.create a custom cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "customMessageCell", for: indexPath) as! CustomMessageCell
        
        //specify text to display in our cells
        cell.messageBody.text = messageArray[indexPath.row].messageBody
        cell.senderUsername.text = messageArray[indexPath.row].sender
        cell.avatarImageView.image = UIImage(named: "egg")
        
        if cell.senderUsername.text == Auth.auth().currentUser?.email {
            //our own message
            cell.avatarImageView.backgroundColor = UIColor.flatMint()
            cell.messageBackground.backgroundColor = UIColor.flatSkyBlue()
        }else {
            cell.avatarImageView.backgroundColor = UIColor.flatWatermelon()
            cell.messageBackground.backgroundColor = UIColor.flatGray()
        }
        
        return cell
    }
    
    
    
    //TODO: Declare numberOfRowsInSection here:
    //how many cells we want
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArray.count
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
        
        messageTextfield.endEditing(true)
        //TODO: Send the message to Firebase and save it in our database
        messageTextfield.isEnabled = false
        sendButton.isEnabled = false
        
        //create a messages database inside our Firebase Database, so that we have a dedicated DB just for the messages
        
        let messagesDB = Database.database().reference().child("Messages")//create a reference to a new DB inside our main DB
        
        //save user's message as a dictionary
        let messageDictionary = ["Sender" : Auth.auth().currentUser?.email,"MessageBody" : messageTextfield.text!]
        
        //messagesDB.childByAutoId() //creates a custom random key for our message, so that they can be saved under their own unique identifier
        //saving our message dictionary inside our messages DB under an automatically generated id
        messagesDB.childByAutoId().setValue(messageDictionary) {
            (error, reference) in
            
            if error != nil {
                print(error!)
            }else{
               print("Message saved successfully")
                
                self.messageTextfield.isEnabled = true
                self.sendButton.isEnabled = true
                self.messageTextfield.text = ""
            }
        }
        
        
    }
    
    //TODO: Create the retrieveMessages method here:
    func retrieveMessages() {
        let messagesDB = Database.database().reference().child("Messages")
        //ask firebase to keep an eye on any new data being added to the Messages DB(observe)
        messagesDB.observe(.childAdded) { (snapshot) in
            let snapshotValue = snapshot.value as! Dictionary<String, String>
            let text = snapshotValue["MessageBody"]!
            let sender = snapshotValue["Sender"]!
            //print(text,sender)
            
            //save this info into a Message object
            let newMessage = Message()
            newMessage.messageBody = text
            newMessage.sender = sender
            
            self.messageArray.append(newMessage)
            
            self.configureTableView()
            self.messageTableView.reloadData()
        }
    }
    
    

    
    
    
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
