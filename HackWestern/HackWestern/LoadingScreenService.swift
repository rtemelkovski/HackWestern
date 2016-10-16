//
//  LoadingScreenService.swift
//  HackWestern
//
//  Created by Alex Nguyen on 2016-10-15.
//  Copyright © 2016 Alex Nguyen. All rights reserved.
//

import Foundation
import UIKit
class LoadingScreenService {
    static let shared = LoadingScreenService()
    var loadingView : HWLoadingView?
    
    func presentLoadingView(){
        loadingView = HWLoadingView()
        loadingView?.modalTransitionStyle = .crossDissolve
        loadingView?.modalPresentationStyle = .overFullScreen
        //present(loadingView, animated: true, completion: nil)
        UIApplication.shared.keyWindow?.rootViewController?.present(loadingView!, animated: true, completion: nil)
    }
    
    func dismissLoadingView(){
        loadingView?.dismiss(animated: true, completion: nil)
    }
}
