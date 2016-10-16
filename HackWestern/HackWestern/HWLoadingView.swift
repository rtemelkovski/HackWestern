//
//  HSLLoadingView.swift
//  Headswitch Live
//
//  Created by Illya Bakurov on 2016-10-02.
//  Copyright © 2016 Alex Nguyen. All rights reserved.
//

import UIKit
import pop

class HWLoadingView: UIViewController {
    
    //-----------------
    // MARK: - Variables
    //-----------------
    
    struct Constants {
        //The width and height for the view which contains the circle view
        static let viewWithLoadingCircleWidth: CGFloat = 70.0
        static let viewWithLoadingCircleHeight: CGFloat = 70.0
        //The width and height for the circle view
        static let loadingCircleWidth: CGFloat = 35.0
        static let loadingCircleHeight: CGFloat = 35.0
    }
    
    //View to contain the circle view
    var viewWithLoadingCircle: UIView!
    //The actual circle, which is going to be animated if needed
    var loadingCircle: HWCircularView!
    
    //Variable which tracks if animation is needed
    var isAnimated = true
    
    //-----------------
    // MARK: - Initializers
    //-----------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Setup views first
        setupViews()
        //And then if needed setup animation of the circle view
        if isAnimated {
            setupAnimation()
        }
    }
    func setupViews() {
        //make proper color for the whole view controller
        view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        
        //Setup views
        setupViewWithLoadingCircle()
        setupLoadingCircle()
        
        //Layout views
        view.layoutIfNeeded()
    }
    
    func setupViewWithLoadingCircle() {
        //init proper frame for the view to contain loading circle
        viewWithLoadingCircle = UIView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: Constants.viewWithLoadingCircleWidth, height: Constants.viewWithLoadingCircleHeight)))
        //Round corners and change colour
        viewWithLoadingCircle.layer.cornerRadius = 15.0
        viewWithLoadingCircle.backgroundColor = UIColor.white
        
        //Add view to view hierarchy
        view.addSubview(viewWithLoadingCircle)
        
        //Turn off the autoresizing masks, so layouts are supported
        viewWithLoadingCircle.translatesAutoresizingMaskIntoConstraints = false
        //Init constraints to properly align the views
        let centerX = NSLayoutConstraint(item: view, attribute: .centerX, relatedBy: .equal, toItem: viewWithLoadingCircle, attribute: .centerX, multiplier: 1, constant: 0)
        let centerY = NSLayoutConstraint(item: view, attribute: .centerY, relatedBy: .equal, toItem: viewWithLoadingCircle, attribute: .centerY, multiplier: 1, constant: 0)
        let width = NSLayoutConstraint(item: viewWithLoadingCircle, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: Constants.viewWithLoadingCircleWidth)
        let height = NSLayoutConstraint(item: viewWithLoadingCircle, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: Constants.viewWithLoadingCircleHeight)
        //Activate constraints
        NSLayoutConstraint.activate([centerX, centerY, width, height])
        //Add constraints
        view.addConstraint(centerX)
        view.addConstraint(centerY)
        viewWithLoadingCircle.addConstraint(width)
        viewWithLoadingCircle.addConstraint(height)
        
    }
    
    func setupLoadingCircle() {
        //init the loading circle view
        loadingCircle = HWCircularView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: Constants.loadingCircleWidth, height: Constants.loadingCircleHeight)))
        //Make the background colour clear colour
        loadingCircle.backgroundColor = UIColor.clear
        
        //Add view to view hierarchy
        viewWithLoadingCircle.addSubview(loadingCircle)
        
        //Turn off the autoresizing masks, so layouts are supported
        loadingCircle.translatesAutoresizingMaskIntoConstraints = false
        //Init constraints to properly align the view
        let centerX = NSLayoutConstraint(item: viewWithLoadingCircle, attribute: .centerX, relatedBy: .equal, toItem: loadingCircle, attribute: .centerX, multiplier: 1, constant: 0)
        let centerY = NSLayoutConstraint(item: viewWithLoadingCircle, attribute: .centerY, relatedBy: .equal, toItem: loadingCircle, attribute: .centerY, multiplier: 1, constant: 0)
        let width = NSLayoutConstraint(item: loadingCircle, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: Constants.loadingCircleWidth)
        let height = NSLayoutConstraint(item: loadingCircle, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: Constants.loadingCircleHeight)
        //Activate constraints
        NSLayoutConstraint.activate([centerX, centerY, width, height])
        //Add constraints
        viewWithLoadingCircle.addConstraint(centerX)
        viewWithLoadingCircle.addConstraint(centerY)
        loadingCircle.addConstraint(width)
        loadingCircle.addConstraint(height)
        
    }
    
    /**Setting the animtaion and running it*/
    func setupAnimation() {
        //Generating the animation
        let rotateAnimation = POPBasicAnimation(propertyNamed: kPOPLayerRotation)
        //Repeating it forever until the view dissappears
        rotateAnimation?.repeatForever = true
        //Rotation on 360 degrees clockwise
        rotateAnimation?.toValue = M_PI * 2.0
        //Duration of full animation
        rotateAnimation?.duration = 1.0
        //Adding animation to the layer
        loadingCircle.layer.pop_add(rotateAnimation, forKey: "Rotation")
    }
    
    
}
