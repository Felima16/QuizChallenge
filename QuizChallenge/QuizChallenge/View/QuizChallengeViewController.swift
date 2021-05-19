//
//  ViewController.swift
//  QuizChallenge
//
//  Created by Fernanda de Lima on 30/01/20.
//  Copyright © 2020 Felima. All rights reserved.
//

import UIKit

class QuizChallengeViewController: UIViewController {
    @IBOutlet weak var heightKeyboardConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleChallengeLabel: UILabel!
    @IBOutlet weak var countWordsLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var insertWordTextField: UITextField!
    @IBOutlet weak var answerTable: UITableView!
    @IBOutlet weak var startResetButton: UIButton!
    @IBAction func startResetButtonAction(_ sender: Any) {
        if !isPlaying {
            viewModel.startChallenge()
            startResetButton.setTitle("Reset", for: .normal)
            isPlaying = true
        }else{
            viewModel.stopChallenge()
            startResetButton.setTitle("Start", for: .normal)
            isPlaying = false
        }
    }
    
    var viewModel: QuizChallengeViewModel = QuizChallengeViewModel()
    var isPlaying: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getChallenge()
        setupUI()
        setupBindable()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    private func setupUI(){
        startResetButton.layer.cornerRadius = 8
        insertWordTextField.delegate = self
    }
    private func setupBindable(){
        viewModel.onChallengeLoad.bind { [weak self] (title) in
            if let strongSelf = self {
                DispatchQueue.main.async {
                    strongSelf.titleChallengeLabel.text = title
                }
            }
        }
        
        viewModel.onCountAnswer.bindAndFire { [weak self] (text) in
            if let strongSelf = self {
                DispatchQueue.main.async {
                    strongSelf.countWordsLabel.text = text
                    strongSelf.answerTable.reloadData()
                }
            }
        }
        
        viewModel.showLoadingHud.bind { [weak self] visible in
            if let strongSelf = self{
                visible ? strongSelf.view.startLoading() : strongSelf.view.stopLoading()
            }
        }
        
        viewModel.onShowAlert.bindAndFire { [weak self] (alert) in
            if let strongSelf = self {
                guard alert != nil else {return}
                DispatchQueue.main.async {
                    strongSelf.present(alert!, animated: true, completion: nil)
                }
            }
        }
        
        viewModel.onUpdateConstraint.bindAndFire { [unowned self] in
            self.heightKeyboardConstraint.constant = $0
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
        
        viewModel.updateTimer.bindAndFire { [weak self] (text) in
            if let strongSelf = self {
                DispatchQueue.main.async {
                    strongSelf.timerLabel.text = text
                }
            }
        }
        
        viewModel.enableStart.bindAndFire { [weak self] enable in
            if let strongSelf = self{
                DispatchQueue.main.async {
                    strongSelf.startResetButton.isEnabled = enable
                }
            }
        }
        
    }
}

extension QuizChallengeViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.playerAnswer.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "answerCell")!
        cell.textLabel?.text = viewModel.playerAnswer[indexPath.row]
        return cell
    }
}

extension QuizChallengeViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.viewModel.verifyAnswer(textField.text ?? "")
        self.insertWordTextField.text = ""
        return false;
    }
}
