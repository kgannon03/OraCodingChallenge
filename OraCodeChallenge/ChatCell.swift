//
//  ChatCell.swift
//  OraCodeChallenge
//
//  Created by Kevin Gannon on 2/3/17.
//  Copyright © 2017 Kevin Gannon. All rights reserved.
//

import UIKit

struct ChatCellViewModel {
    private let chat: Chat
    
    let dateFormatter = ISO8601DateFormatter()
    
    init(chat: Chat) {
        self.chat = chat
    }
    
    func lastMessageUserAndDate() -> String {
        guard
            let date = dateFormatter.date(from: chat.lastMessage.createdDate) else {
            return ""
        }
        
        if Calendar.current.isDateInToday(date) {
            let minutes = Calendar.current.dateComponents([.minute], from: date, to: Date()).minute!
            return "\(minutes) mins ago"
        }
        
        let days = Calendar.current.dateComponents([.day], from: date, to: Date()).day!
        return "\(days) days ago"
    }
    
    func lastMessageText() -> NSAttributedString {
        let message = NSMutableAttributedString(string: chat.lastMessage.message)
        message.addAttribute(
            NSForegroundColorAttributeName,
            value: UIColor.lightGray,
            range: NSMakeRange(0, message.length))
        
        guard let name = chat.lastMessage.user.name else {
            return message
        }
        
        let author = NSMutableAttributedString(string: "\(name): ")
        author.addAttribute(
            NSForegroundColorAttributeName,
            value: Constants.Colors.oraOrange,
            range: NSMakeRange(0, author.length))
        
        author.append(message)
        
        return author
    }
    
    func chatTitle() -> String {
        guard let name = chat.name else { return "" }
        return "\(name)"
    }
}

class ChatCell: UITableViewCell {
    @IBOutlet weak var chatTitle: UILabel!
    @IBOutlet weak var lastUser: UILabel!
    @IBOutlet weak var lastMessage: UILabel!
    
    func setChat(viewModel: ChatCellViewModel) {
        chatTitle.text = viewModel.chatTitle()
        lastUser.text = viewModel.lastMessageUserAndDate()
        lastMessage.attributedText = viewModel.lastMessageText()
        
        lastMessage.sizeToFit()
    }
}
