//
//  ViewController.swift
//  splokhmatikovPW2
//
//  Created by Сергей Лохматиков on 22.09.2021.
//

import UIKit
import CoreLocation
import AVKit

class ViewController: UIViewController {
    private let settingsView = UIStackView()
    private let locationTextView = UITextView()
    private let locationManager = CLLocationManager()
    private let locationToggle = UISwitch()
    private var musicPlayer: AVAudioPlayer?
    private let sliders = [UISlider(), UISlider(), UISlider()]
    private let colors = ["Red", "Green", "Blue"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestWhenInUseAuthorization()
        setupSettingsButton()
        setupLocationxtView()
        setupSettingsView()
        setupLocationToggle()
        setupSliders()
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
    
    private var buttonCount = 0
    @objc private func settingsButtonPressed() {
        let memeAudio = NSDataAsset(name: "amogus")
        if  memeAudio != nil{
            musicPlayer = try? AVAudioPlayer(data: memeAudio!.data)
            musicPlayer?.play()
        }
        switch buttonCount {
        case 0, 1:
            UIStackView.animate(withDuration: 0.1, animations: {
                self.settingsView.alpha = 1 - self.settingsView.alpha
            })
        case 2:
            let navigationController = UINavigationController()
            navigationController.pushViewController(
                SettingsViewController(locationTextView: locationTextView, locationManager: locationManager, masterToggle: locationToggle, sliders: sliders, function: changeColor(red:green:blue:)),
                animated: true
            )
        case 3:
            present(SettingsViewController(locationTextView: locationTextView, locationManager: locationManager, masterToggle: locationToggle, sliders: sliders, function: changeColor(red:green:blue:)), animated: true, completion: nil)
            buttonCount = -1
        default:
            buttonCount = -1
        }
        buttonCount += 1
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
            slider.minimumValue = 0
            slider.maximumValue = 1
            slider.addTarget(self, action:
                                #selector(sliderChangedValue), for: .valueChanged)
            view.addSubview(slider)
            slider.pinTop(to: view, 5)
            slider.setHeight(to: 20)
            slider.pinLeft(to: view, 60)
            slider.pinRight(to: view)
        }
    }
    
    @objc private func sliderChangedValue() {
        let red: CGFloat = CGFloat(sliders[0].value)
        let green: CGFloat = CGFloat(sliders[1].value)
        let blue: CGFloat = CGFloat(sliders[2].value)
        changeColor(red: red, green: green, blue: blue)
    }
    
    private func changeColor(red: CGFloat, green: CGFloat, blue: CGFloat){
        view.backgroundColor = UIColor(red: red, green: green, blue:
                                        blue, alpha: 1)
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

