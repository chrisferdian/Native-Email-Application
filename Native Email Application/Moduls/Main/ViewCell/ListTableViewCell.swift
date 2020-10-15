//
//  ListTableViewCell.swift
//  Native Email Application
//
//  Created by TMLI IT DEV on 14/10/20.
//

import UIKit

class ListTableViewCell: UITableViewCell {

    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelSubject: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelShortContent: UILabel!
    @IBOutlet weak var imageViewAvatar: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func bindCell(with content: EmailResponseElement) {
        labelName.text = content.name
        labelSubject.text = content.subject
        labelShortContent.text = content.content
        labelDate.text = content.createdAt.toDate().moment
        imageViewAvatar.makeRounded()
        imageViewAvatar.downloaded(from: content.avatar)
    }
}
extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
