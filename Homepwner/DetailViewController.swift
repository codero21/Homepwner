//
//  DetailViewController.swift
//  Homepwner
//
//  Created by Rollin Francois on 4/15/17.
//  Copyright © 2017 Francois Technology. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    // MARK: Properties
    
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var serialNumberTextField: UITextField!
    @IBOutlet var valueTextField: UITextField!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    
    
    // Property Observer will update the title of the navigationItem
    var item: Item! {
        didSet {
            navigationItem.title = item.name
        }
    }
    
    var imageStore: ImageStore!
    
    
    let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
        
    }()
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter

    }()
    
    
    // MARK: Methods
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        nameTextField.text = item.name
        serialNumberTextField.text = item.serialNumber
        valueTextField.text = numberFormatter.string(from: NSNumber(value: item.valueInDollars))
        dateLabel.text = dateFormatter.string(from: item.dateCreated)
        
        // Get the item key
        let key = item.itemKey
        
        // If there is an associated image with the item
        // display it on the image view
        let imageToDisplay = imageStore.image(forKey: key)
        imageView.image = imageToDisplay
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Save changes to item
        item.name = nameTextField.text ?? ""
        item.serialNumber = serialNumberTextField.text!
        
        if let valueText = valueTextField.text, let value = numberFormatter.number(from: valueText) {
            
            item.valueInDollars = value.intValue
        } else {
            item.valueInDollars = 0
        }
        
        // Clear First Responder
        //view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    
    // Tap Gesture Recognizer
    
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        
        view.endEditing(true)
    }
    
    @IBAction func takePicture(_ sender: UIBarButtonItem) {
        
        // create image picker & Set source type
        let imagePicker = UIImagePickerController()
        
        // If the device has a camera, take the picture; otherwise
        // just pick from the photo library
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
        } else {
            imagePicker.sourceType = .photoLibrary
        }
        
        // Set the instance of DetailViewCOntroller to be theimage picker's delegate
        imagePicker.delegate = self
        
        // Place image picker on the screen modally
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // Get picked image from info dictionaru
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        // Store the image in the ImageStore for the item's key
        imageStore.setImage(image, forKey: item.itemKey)
        
        // Put that image on the screen in the image view
        imageView.image = image
        
        // Take image picker off the screen - 
        // you must call this dismiss method
        dismiss(animated: true, completion: nil)
        
    }
    
    
    
}
