//
//  ViewController.swift
//  Demon
//
//  Created by immortal on 2021/3/26.
//

import UIKit
import IMViewBlur

func updateBlur(for view: UIView, animated: Bool = true) {
    if IMViewBlur.isBlurred(for: view) {
        IMViewBlur.unBlur(from: view, duration: animated ? 0.5 : 0.0)
    } else {
        IMViewBlur.blur(in: view, radius: 6.0, duration: animated ? 0.5 : 0.0)
    }
}

class ViewController: UIViewController {
    
    private let tableView: UITableView = {
        UITableView.appearance().separatorStyle = .none
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = #colorLiteral(red: 0.09411764706, green: 0.1019607843, blue: 0.1254901961, alpha: 1)
        tableView.rowHeight = 120.0
        tableView.separatorColor = .clear
        tableView.separatorStyle = .none
        tableView.separatorEffect = nil
        tableView.showsVerticalScrollIndicator = false
        tableView.register(Cell.self, forCellReuseIdentifier: String(describing: Cell.self))
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.view.backgroundColor = .white
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.delegate = self
        
        navigationItem.rightBarButtonItem = .init(title: "Blur overall", style: .done, target: self, action: #selector(didChangeViewBlur))
        navigationItem.leftBarButtonItem = .init(title: "Blur cells", style: .done, target: self, action: #selector(didChangeCellsBlur))
        title = "IMViewBlur"
    }
    
    var blurCells = true
    
    
    @objc func didChangeViewBlur() {
        updateBlur(for: view)
    }
    
    @objc func didChangeCellsBlur() {
        blurCells = !blurCells
        tableView.reloadData()
    }
}


extension ViewController: UITableViewDataSource {
     
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        100
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        120.0
    }
     
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: Cell.self), for: indexPath) as! Cell
        cell.updateContent(blurCells)
        return cell
    }
}

extension ViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        updateBlur(for: cell.contentView)
    }
}


class Cell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        loadSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var container: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.1529411765, green: 0.1647058824, blue: 0.2, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10.0
        return view
    }()
     
    let avatarView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 30.0
        imageView.layer.masksToBounds = true
        return imageView
    }()
     
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14.0, weight: .medium)
        label.textColor = .white
        label.numberOfLines = 2
        return label
    }()
    
    func loadSubviews() {
        contentView.addSubview(container)
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10.0),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10.0),
            container.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10.0),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -10.0)
        ])
        
        container.addSubview(avatarView)
        NSLayoutConstraint.activate([
            avatarView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 20.0),
            avatarView.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            avatarView.topAnchor.constraint(equalTo: container.topAnchor, constant: 20.0),
            avatarView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -20.0),
            avatarView.widthAnchor.constraint(equalToConstant: 60.0),
            avatarView.heightAnchor.constraint(equalTo: avatarView.widthAnchor),
        ])
        
        container.addSubview(messageLabel)
        NSLayoutConstraint.activate([
            messageLabel.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 10.0),
            messageLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -20.0),
            messageLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor),
        ])
        
        layoutIfNeeded()
        separatorInset = .zero
        selectionStyle = .none
    }
    
    let messages: [String] = [
        "A name is a term used for identification by an external observer. They can identify a class or category of things, or a single thing, either uniquely, or within a given",
        "A name is a term used for identification by an external observer. ",
        "A name is a term used for identification",
        "A name is a term used for",
        "A name is a term",
        "A name"
    ]
    
    func updateContent(_ isBlurred: Bool) {
        let imageName = String(describing: Int.random(in: 0...4))
        let message = messages[Int.random(in: 0..<messages.count)]
        avatarView.image = UIImage(named: imageName)
        messageLabel.text = message
        if isBlurred {
//            IMViewBlur.blur(in: contentView, radius: 6.0, duration: 0.2)
            IMViewBlur.blur(in: contentView, radius: 6.0)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
//        IMViewBlur.unBlur(from: contentView, duration: 0.2)
        IMViewBlur.unBlur(from: contentView)
    }
}
