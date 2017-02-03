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
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 80.0
        
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
        
        tableView.rx.contentOffset
            .asObservable()
            .subscribe{[weak self] next in
                guard let ss = self, let e = next.element else { return }
                let marker = ss.tableView.contentSize.height / 2.0
                if e.y + ss.tableView.bounds.size.height > marker {
                    let pageNum = ss.tableView.numberOfRows(inSection: 0) / ss.viewModel.pageSize
                    ss.viewModel.page.value = pageNum + 1
                }
            }
            .addDisposableTo(disposeBag)
    }
}

extension ChatController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
