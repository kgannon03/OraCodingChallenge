//
//  ChatController.swift
//  OraCodeChallenge
//
//  Created by Kevin Gannon on 2/2/17.
//  Copyright © 2017 Kevin Gannon. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class ChatController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingCover: UIView!
    
    let viewModel = ChatViewModel(service: ChatService())
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.rowHeight = 90.0
        
        addBindings()
    }
    
    func addBindings() {
        viewModel.chatList
            .asObservable()
            .bindTo(tableView.rx.items(
                cellIdentifier: "ChatCell",
                cellType: ChatCell.self)) { index, chat, cell in
                    let viewmodel = ChatCellViewModel(chat: chat)
                    cell.setChat(viewModel: viewmodel)
            }
            .addDisposableTo(disposeBag)
        
        viewModel.loadingState
            .asObservable()
            .map{ $0 == .Loading ? false : true }
            .bindTo(loadingCover.rx.isHidden)
            .addDisposableTo(disposeBag)
    }
}

extension ChatController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
