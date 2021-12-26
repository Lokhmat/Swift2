//
//  SettingsViewController.swift
//  splokhmatikovPW2
//
//  Created by Сергей Лохматиков on 20.12.2021.
//

import UIKit
import CoreLocation

final class SettingsViewController: UIViewController {
    private let settingsView = UIStackView()
    private var locationTextView: UITextView
    private var locationManager: CLLocationManager
    private var masterToggle: UISwitch
    private var masterSliders: [UISlider]
    private var changeMasterColor: (_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat) -> Void
    private let sliders = [UISlider(), UISlider(), UISlider()]
    private let colors = ["Red", "Green", "Blue"]
    
    init(locationTextView: UITextView, locationManager: CLLocationManager, masterToggle: UISwitch, sliders: [UISlider], function: @escaping (_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat) -> Void) {
        self.locationTextView = locationTextView
        self.masterToggle = masterToggle
        self.locationManager = locationManager
        self.masterSliders = sliders
        self.changeMasterColor = function
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    private func placeholder(red: CGFloat, green: CGFloat, blue: CGFloat){
        return
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCloseButton()
        setupSettingsView()
        setupLocationToggle()
        setupSliders()
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
    
    private func setupLocationToggle() {
        let locationToggle = UISwitch()
        locationToggle.isOn = masterToggle.isOn
        settingsView.addArrangedSubview(locationToggle)
        locationToggle.pinTop(to: settingsView, 50)
        locationToggle.pinRight(to: settingsView, 10)
        locationToggle.pinLeft(to: settingsView, 100)
        locationToggle.addTarget(
            self,
            action: #selector(locationToggleSwitched),
            for: .valueChanged
        )
        let locationLabel = UILabel()
        settingsView.addArrangedSubview(locationLabel)
        locationLabel.text = "Location"
        locationLabel.pinTop(to: settingsView, -175)
        locationLabel.pinLeft(to: settingsView, 10)
        locationLabel.pinRight(to: settingsView, 10)
    }
    
    @objc
    func locationToggleSwitched(_ sender: UISwitch) {
        masterToggle.isOn = !masterToggle.isOn
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
    
    private func setupCloseButton() {
        let button = UIButton(type: .close)
        view.addSubview(button)
        button.pinTop(to: view, 10)
        button.pinRight(to: view, 10)
        button.addTarget(self, action: #selector(closeScreen),
                         for: .touchUpInside)
    }
    
    private func setupSliders() {
        var top = 80
        for i in 0..<sliders.count {
            let view = UIView()
            settingsView.addArrangedSubview(view)
            view.pinLeft(to: settingsView, 10)
            view.pinRight(to: settingsView, 10)
            view.pinTop(to: settingsView, Double(top))
            view.setHeight(to: 30)
            top += 40
            let label = UILabel()
            view.addSubview(label)
            label.text = colors[i]
            label.pinTop(to: view, 5)
            label.pinLeft(to: view, 5)
            label.setWidth(to: 50)
            let slider = sliders[i]
            slider.addTarget(self, action:
                                #selector(sliderChangedValue), for: .valueChanged)
            for i in 0..<3{
                sliders[i].value = masterSliders[i].value
            }
            slider.minimumValue = 0
            slider.maximumValue = 1
            view.addSubview(slider)
            slider.pinTop(to: view, 5)
            slider.setHeight(to: 20)
            slider.pinLeft(to: view, 50)
            slider.pinRight(to: view)
        }
    }
    
    @objc private func sliderChangedValue() {
        for i in 0..<3{
            masterSliders[i].value = sliders[i].value
        }
        changeMasterColor(CGFloat(sliders[0].value), CGFloat(sliders[0].value), CGFloat(sliders[0].value))
    }
    
    @objc
    private func closeScreen() {
        dismiss(animated: true, completion: nil)
    }
}

extension SettingsViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        guard let coord: CLLocationCoordinate2D =
                manager.location?.coordinate else { return }
        locationTextView.text = "Coordinates = \(coord.latitude) \(coord.longitude)"
    }
}
