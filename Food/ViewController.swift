//
//  ViewController.swift
//  Food
//
//  Created by Apurva Patel on 4/18/18.
//  Copyright © 2018 Apurva Patel. All rights reserved.
//

import UIKit
import CoreML
import Vision


class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

   
    @IBOutlet weak var imageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let userPickedimage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = userPickedimage
            guard let ciimage = CIImage(image: userPickedimage) else {fatalError("Coudnt convert UIImage to CIImage.")}

            detect(image: ciimage)
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func detect (image : CIImage){
        
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else { fatalError("Loading coreML model fail") }
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let result = request.results as? [VNClassificationObservation] else {fatalError("Model fail to process image")}
            
            if let firstResult = result.first {
                if firstResult.identifier.contains("hotdog") {
                    self.navigationItem.title = "HOTDOG!"
                }
                else {
                    self.navigationItem.title = "NOT HOTDOG!"
                }
            }
            
            
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        
        do {
            try handler.perform([request])
            }
        catch {
            print ("Error processing request \(error)")
        }
    }
    
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    
    
}

