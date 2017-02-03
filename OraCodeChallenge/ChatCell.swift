//
//  ChatCell.swift
//  OraCodeChallenge
//
//  Created by Kevin Gannon on 2/3/17.
//  Copyright © 2017 Kevin Gannon. All rights reserved.
//

import UIKit

class ChatCell: UITableViewCell {
    @IBOutlet weak var chatTitle: UILabel!
    @IBOutlet weak var lastUser: UILabel!
    @IBOutlet weak var lastMessage: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setChat(chat: Chat) {
        chatTitle.text = chat.name
        lastUser.text = chat.lastMessage.user.name
        lastMessage.text = chat.lastMessage.message
    }
}
