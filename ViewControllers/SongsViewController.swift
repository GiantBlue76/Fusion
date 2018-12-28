//
//  SongsViewController.swift
//  Fusion
//
//  Created by Charles Imperato on 12/26/18.
//  Copyright © 2018 Wind Valley Software. All rights reserved.
//

import UIKit
import wvslib

class SongsViewController: UIViewController {

    // - Song table
    fileprivate lazy var tableView: UITableView = {
        let table = UITableView.init(frame: .zero, style: UITableView.Style.plain)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.separatorStyle = .none
        table.backgroundColor = UIColor.clear
        table.delegate = self
        table.dataSource = self
        return table
    }()
    
    // - Genres
    fileprivate var sections = [String]()
    
    // - Songs
    fileprivate var songs = [String: [SongInfo]]()
    
    // - Presenter
    fileprivate let presenter: SongsPresenter
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Fusion Song List"
        self.view.backgroundColor = UIColor.white
        
        self.tableView.register(SongHeaderView.self, forHeaderFooterViewReuseIdentifier: "sectionHeader")
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "songCell")
        self.tableView.alpha = 0.0
        
        // Do any additional setup after loading the view.
        self.layout()
        
        // - Load the song list
        self.presenter.loadSongs()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    init(withPresenter presenter: SongsPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        self.presenter.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: - UITableView

extension SongsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard section < self.sections.count && section >= 0 else { return 0}

        let section = self.sections[section]
        if let songs = self.songs[section] {
            return songs.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "songCell", for: indexPath)
        let genre = self.sections[indexPath.section]
       
        guard let song = self.songs[genre]?[indexPath.row] else {
            log.warning("The songs could not be found at the given index \(indexPath.row) for the genre \(genre).")
            return cell
        }

        var songView = SongView()
        songView.translatesAutoresizingMaskIntoConstraints = false
        songView.tag = 100
        
        if let content = cell.contentView.viewWithTag(100) as? SongView {
            songView = content
        }
        else {
            cell.contentView.addSubview(songView)
            songView.topAnchor.constraint(equalTo: cell.contentView.topAnchor).isActive = true
            songView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor).isActive = true
            songView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor).isActive = true
            songView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor).isActive = true
        }
        
        songView.titleLabel.text = song.name
        songView.artistLabel.text = song.artist
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "sectionHeader") as? SongHeaderView else { return nil }

        view.headerLabel.text = self.sections[section]
        view.contentView.backgroundColor = UIColor.sharedBlue
        view.contentView.layer.borderColor = UIColor.darkGray.cgColor
        view.contentView.layer.borderWidth = 1.0
        view.tapHandler = { [weak self] in
            self?.presenter.toggleExpand(section)
        }
        
        return view
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let songHeader = view as? SongHeaderView else { return }
        
        let image = CommonImages.expand.image?.maskedImage(with: UIColor.white)
        if tableView.numberOfRows(inSection: section) == 0 {
            songHeader.expandImageView.image = image?.imageRotatedByDegrees(deg: 180)
        }
        else {
            songHeader.expandImageView.image = image
        }
    }
}

// MARK: - SongsDelegate

extension SongsViewController: SongsDelegate {
    func songsLoaded(_ sortedSections: [String]) {
        self.sections = sortedSections
        self.tableView.alpha = 1.0
        self.tableView.reloadData()
    }
    
    func sectionLoaded(_ index: Int, _ songs: [SongInfo]) {
        guard index < self.sections.count && index >= 0 else { return }
        
        self.songs[self.sections[index]] = songs
        self.tableView.reloadSections(IndexSet.init(integer: index), with: .fade)
    }
}

// MARK: - Private

fileprivate extension SongsViewController {
    func layout() {
        self.view.addSubview(self.tableView)
        self.tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
}

