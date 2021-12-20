//
//  ViewController.swift
//  splokhmatikovPW2
//
//  Created by Сергей Лохматиков on 22.09.2021.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    private let settingsView = UIView()
    private let locationTextView = UITextView()
    private let locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestWhenInUseAuthorization()
        setupSettingsButton()
        setupLocationxtView()
        setupSettingsView()
        setupLocationToggle()
        // Do any additional setup after loading the view.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    private func setupSettingsButton(){
        let settingsButton = UIButton(type: .system)
        self.view.addSubview(settingsButton)
        settingsButton.setImage(UIImage(named: "settings-2")?.withRenderingMode(.alwaysOriginal), for: .normal)
        settingsButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        settingsButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        settingsButton.pinTop(to: view.safeAreaLayoutGuide.topAnchor, 15)
        settingsButton.pinRight(to: view.safeAreaLayoutGuide.trailingAnchor, 15)
        settingsButton.addTarget(self, action: #selector(settingsButtonPressed), for: .touchUpInside)
        settingsView.alpha = 0
    }
    
    @objc
    func settingsButtonPressed(){
        UIView.animate(withDuration: 0.1, animations: {self.settingsView.alpha = 1 - self.settingsView.alpha})
    }
    
    private func setupSettingsView(){
        self.view.addSubview(self.settingsView)
        self.settingsView.backgroundColor = .darkGray
        self.settingsView.pinTop(to: view.safeAreaLayoutGuide.topAnchor, 10)
        self.settingsView.pinRight(to: view.safeAreaLayoutGuide.trailingAnchor, 60)
        self.settingsView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        self.settingsView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        self.settingsView.layer.cornerRadius = 10
    }
    private func setupLocationxtView(){
        view.addSubview(locationTextView)
        locationTextView.backgroundColor = .white
        locationTextView.layer.cornerRadius = 20
        locationTextView.pinTop(to: view.safeAreaLayoutGuide.topAnchor, 60)
        locationTextView.pinCenter(to: view)
        locationTextView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        locationTextView.pinLeft(to: view.safeAreaLayoutGuide.leadingAnchor, 15)
        locationTextView.isUserInteractionEnabled = false
    }
    
    private func setupLocationToggle() {
        let locationToggle = UISwitch()
        settingsView.addSubview(locationToggle)
        locationToggle.translatesAutoresizingMaskIntoConstraints = false
        locationToggle.topAnchor.constraint(
            equalTo: settingsView.topAnchor,
            constant: 50
        ).isActive = true
        locationToggle.trailingAnchor.constraint(
            equalTo: settingsView.trailingAnchor,
            constant: -10 ).isActive = true
        locationToggle.addTarget(
            self,
            action: #selector(locationToggleSwitched),
            for: .valueChanged
        )
        let locationLabel = UILabel()
        settingsView.addSubview(locationLabel)
        locationLabel.text = "Location"
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.topAnchor.constraint(
            equalTo: settingsView.topAnchor,
            constant: 55
        ).isActive = true
        locationLabel.leadingAnchor.constraint(
            equalTo: settingsView.leadingAnchor,
            constant: 10
        ).isActive = true
        locationLabel.trailingAnchor.constraint(
            equalTo: locationToggle.leadingAnchor,
            constant: -10 ).isActive = true
    }
    
    @objc
    func locationToggleSwitched(_ sender: UISwitch) {
        if sender.isOn {
            if CLLocationManager.locationServicesEnabled() {
                locationManager.delegate = self
                locationManager.desiredAccuracy =
                    kCLLocationAccuracyNearestTenMeters
                locationManager.startUpdatingLocation()
            } else {
                sender.setOn(false, animated: true)
            }
        } else {
            locationTextView.text = ""
            locationManager.stopUpdatingLocation()
        }
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        guard let coord: CLLocationCoordinate2D =
                manager.location?.coordinate else { return }
        locationTextView.text = "Coordinates = \(coord.latitude) \(coord.longitude)"
    }
}

