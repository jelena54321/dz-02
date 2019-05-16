//
//  QuizzesViewController.swift
//  dz-02
//
//  Created by Jelena Šarić on 15/05/2019.
//  Copyright © 2019 Jelena Šarić. All rights reserved.
//

import UIKit
import PureLayout

/// Class which presents view controller for quizzes table view.
class QuizzesViewController: UIViewController {

    /// Cell reuse identifier.
    private static let cellReuseIdentifier = "cellReuseIdentifier"
    
    /// Table view containing quizzes.
    @IBOutlet weak var quizzesTableView: UITableView!
    
    /// Refresh control.
    var refreshControl: UIRefreshControl!
    /// View model.
    var viewModel: QuizzesViewModel!
    
    /**
     Initializes view controller with provided **QuizzesViewModel** object.
     View model object presents communication of view controller with model.
     
     - Parameters:
        - viewModel: **QuizzesViewModel** object reference
     - Returns: initialized **QuizzesViewController** object
    */
    convenience init(viewModel: QuizzesViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpTableView()
        bindViewModel()
    }
    
    /// Defines action which will be executed once refresh has been executed.
    @objc func refresh() {
        DispatchQueue.main.async {
            self.quizzesTableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    
    /// Sets up quizzes table view.
    private func setUpTableView() {
        quizzesTableView.backgroundColor = UIColor.darkGray
        quizzesTableView.delegate = self
        quizzesTableView.dataSource = self
        quizzesTableView.separatorStyle = .singleLine
        quizzesTableView.autoPinEdgesToSuperviewEdges()
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(
            self,
            action: #selector (QuizzesViewController.refresh),
            for: UIControl.Event.valueChanged
        )
        quizzesTableView.refreshControl = refreshControl
        
        quizzesTableView.register(
            UINib(nibName: "QuizzesTableViewCell", bundle: nil),
            forCellReuseIdentifier: QuizzesViewController.cellReuseIdentifier
        )
    }
    
    /// Acquiring data through *viewModel* reference and updating GUI with fetched data.
    private func bindViewModel() {
        viewModel.fetchQuizzes {
            self.refresh()
        }
    }
}

extension QuizzesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension QuizzesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = quizzesTableView.dequeueReusableCell(
            withIdentifier: QuizzesViewController.cellReuseIdentifier,
            for: indexPath
        ) as! QuizzesTableViewCell
        
        if let quiz = viewModel.quiz(atIndex: indexPath.row) {
            cell.setUp(withQuiz: quiz)
        }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfQuizzes()
    }
}
