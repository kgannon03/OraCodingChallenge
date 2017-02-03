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
    
    func lastMessageText() -> String {
        return chat.lastMessage.message
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
        lastMessage.text = viewModel.lastMessageText()
        
        lastMessage.sizeToFit()
    }
}
