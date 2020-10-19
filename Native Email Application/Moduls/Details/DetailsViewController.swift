//
//  DetailsViewController.swift
//  Native Email Application
//
//  Created by TMLI IT DEV on 18/10/20.
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var imageViewAvatar: UIImageView!
    @IBOutlet weak var labelSubject:UILabel!
    @IBOutlet weak var labelEmail:UILabel!
    @IBOutlet weak var textViewContent: UITextView!
    
    var content: EmailResponseElement?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageViewAvatar.makeRounded()
        labelEmail.text = content?.email
        labelSubject.text = content?.subject
        textViewContent.attributedText = content?.content.html2AttributedString
        if let url = content?.avatar {
            imageViewAvatar.downloaded(from: url)
        }
    }
    
}
