//
//  SearchViewController.swift
//  Etta
//
//  Created by Ben Murphy on 8/6/16.
//  Copyright © 2016 Constellation Software. All rights reserved.
//

import UIKit
import HTMLReader

class SearchViewController: UIViewController, SearchControllerDelegate {

    @IBOutlet weak var searchBox: UITextField!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var searchToResultsSpacingConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchBoxHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchBoxTopConstraint: NSLayoutConstraint!

    var containerVC: PageViewController!
    var resultsViewController: ResultsViewController!
    var historyViewController: HistoryViewController!

    var entries: [HTMLDictionaryEntry] = [] {
        didSet {
            resultsViewController.resultsTableView.reloadData()
        }
    }

    var coreDataController: CoreDataController!
    var searchController = SearchController()

    // MARK: - VC Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        containerVC = childViewControllers.first as! PageViewController
        resultsViewController = containerVC.resultsViewController
        historyViewController = containerVC.historyViewController
        resultsViewController.delegate = self
        historyViewController.delegate = self
        observeKeyboard()
        configureSearchBox()
        searchController.delegate = self
        positionSearchInCenter()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Methods

    func configureSearchBox() {
        searchBox.clearButtonMode = .always
    }

    func search(_ term: String) {
        searchBox.text = term
        searchChanged(searchBox)
    }

    // MARK: - Actions
    @IBAction func searchChanged(_ sender: UITextField) {
        guard let term = sender.text?.trim()  else {
            return
        }
        searchController.lookUp(term)
        containerVC.setViewControllers([resultsViewController], direction: .forward, animated: true, completion: nil)
    }
}



// MARK: - Animations
extension SearchViewController {

    func positionSearchInCenter() {
        searchBoxTopConstraint.constant = view.frame.midY - searchBoxHeightConstraint.constant

        UIView.animate(withDuration: 0.0) {
            self.view.layoutIfNeeded()
        }
    }

    func pushSearchToTop() {
        searchBoxTopConstraint.constant = 8.0

        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }

    func observeKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(SearchViewController.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(SearchViewController.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    func keyboardWillShow(notification: NSNotification) {
        pushSearchToTop()
    }

    func keyboardWillHide(notification: NSNotification) {
    }
}






