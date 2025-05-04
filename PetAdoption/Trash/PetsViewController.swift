//
//  PetsViewController.swift
//  PetAdoption
//
//  Created by Adya Shreya Pattanaik on 3/30/25.
//
//



//import UIKit
//
//class PetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
//    @IBOutlet weak var tableView: UITableView!
//    @IBOutlet weak var averageAgeLabel: UILabel!
//    @IBOutlet weak var totalCountLabel: UILabel!
//
//    var allPets: [Pet] = []
//    var filteredPets: [Pet] = []
////    private let tableView = UITableView()
//    private var pets: [Pet] = []
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        title = "Available Pets"
//        view.backgroundColor = .white
//        setupTableView()
////        fetchPets()
//        loadPets()
//    }
//
//    private func setupTableView() {
//        view.addSubview(tableView)
//        tableView.translatesAutoresizingMaskIntoConstraints = false
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
//
//        NSLayoutConstraint.activate([
//            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
//        ])
//    }
//
//    private func fetchPets() {
//        pets = DatabaseManager.shared.getAllPets()
//        tableView.reloadData()
//    }
//    
//    func loadPets() {
//            allPets = PetManager.shared.getAllPets()
//        allPets = DatabaseManager.shared.getAllPets()
//            filteredPets = allPets
//            updateStatistics()
//            tableView.reloadData()
//        }
//
//        func applyFilters(species: String?, breed: String?, available: Int?) {
//            filteredPets = PetReportManager.shared.fetchFilteredPets(pets: allPets, species: species, breed: breed, available: available)
//            updateStatistics()
//            tableView.reloadData()
//        }
//
//        func updateStatistics() {
//            let stats = PetReportManager.shared.getPetStatistics(filteredPets: filteredPets)
//            averageAgeLabel.text = "Avg Age: \(stats.averageAge ?? 0.0)"
//            totalCountLabel.text = "Total Pets: \(stats.totalCount)"
//        }
//
//    // UITableView Methods
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return pets.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//        cell.textLabel?.text = pets[indexPath.row].name
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let pet = pets[indexPath.row]
//        let petDetailVC = PetDetailViewController(pet: pet)
//        navigationController?.pushViewController(petDetailVC, animated: true)
//    }
//}
