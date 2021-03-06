//
//  NearByInstallerViewController.swift
//  GuangFuJie
//
//  Created by 颜超 on 2017/1/6.
//  Copyright © 2017年 颜超. All rights reserved.
//

import UIKit

class NearByInstallerViewController: BaseViewController, BMKMapViewDelegate {
    var locService : BMKLocationService!
    
    var mapView : BMKMapView!
    var points = NSMutableArray()
    var hasLocated = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "附近安装商"
        initView()
        locService = BMKLocationService()
    }
    
    func getNearByPoints(_ loation : CLLocationCoordinate2D) {
        self.showHud(in: self.view, hint: "获取数据中...")
        API.sharedInstance.getNearInstallerV1(loation.latitude as NSNumber, latitude: loation.longitude as NSNumber, size: 10, success: { (roofList) in
            self.hideHud()
            self.points.removeAllObjects()
            if (roofList.count > 0) {
                self.points.addObjects(from: roofList as [AnyObject])
            }
            self.addPoints()
        }) { (msg) in
            self.hideHud()
            self.showHint(msg)
        }
    }
    
    func addPoints() {
        mapView.removeAnnotations(mapView.annotations)
        if (self.points.count == 0) {
            return
        }
        for i in 0..<self.points.count {
            let installer = self.points[i] as! InstallInfo
            var companyName = ""
            if (installer.company_name != nil) {
                companyName = installer.company_name! + companyName
            }
            
            let item = BMKPointAnnotation()
            if (installer.lat == nil || installer.lng == nil) {
                continue
            }
            let coordinate = CLLocationCoordinate2D.init(latitude: installer.lat!.doubleValue, longitude: installer.lng!.doubleValue)
            item.coordinate = coordinate
            item.title = companyName
            mapView.addAnnotation(item)
        }
    }
    
    func initView() {
        mapView = BMKMapView.init(frame: CGRect(x: 0, y: 50,width: PhoneUtils.kScreenWidth, height: PhoneUtils.kScreenHeight - 50))
        mapView.zoomLevel = 14
        self.view.addSubview(mapView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        mapView.viewWillAppear()
        locService.delegate = self
        mapView.delegate = self
        startLocation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        mapView.viewWillDisappear()
        locService.delegate = nil
        mapView.delegate = nil
    }
    
    // MARK: - IBAction
    func startLocation() {
        print("进入普通定位态");
        locService.startUserLocationService()
        mapView.showsUserLocation = false//先关闭显示的定位图层
        mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
        mapView.showsUserLocation = true//显示定位图层
    }
    
    func stopLocation() {
        locService.stopUserLocationService()
        mapView.showsUserLocation = false
    }
    
    // MARK: - BMKMapViewDelegate
    
    /**
     *根据anntation生成对应的View
     *@param mapView 地图View
     *@param annotation 指定的标注
     *@return 生成的标注View
     */
    func mapView(_ mapView: BMKMapView!, viewFor annotation: BMKAnnotation!) -> BMKAnnotationView! {
        let AnnotationViewID = "renameMark"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: AnnotationViewID) as! BMKPinAnnotationView?
        if annotationView == nil {
            annotationView = BMKPinAnnotationView(annotation: annotation, reuseIdentifier: AnnotationViewID)
            annotationView?.image = UIImage(named: "ic_annview_installer")
            // 设置颜色
            annotationView!.pinColor = UInt(BMKPinAnnotationColorRed)
            // 从天上掉下的动画
            annotationView!.animatesDrop = false
            // 设置是否可以拖拽
            //            annotationView!.isDraggable = false
        }
        annotationView?.annotation = annotation
        return annotationView
    }
    
    // MARK: - BMKMapViewDelegate
    
    
    // MARK: - BMKLocationServiceDelegate
    
    /**
     *在地图View将要启动定位时，会调用此函数
     *@param mapView 地图View
     */
    func willStartLocatingUser() {
        print("willStartLocatingUser");
    }
    
    /**
     *用户方向更新后，会调用此函数
     *@param userLocation 新的用户位置
     */
    func didUpdateUserHeading(_ userLocation: BMKUserLocation!) {
        print("heading is \(userLocation.heading)")
        mapView.updateLocationData(userLocation)
    }
    
    /**
     *用户位置更新后，会调用此函数
     *@param userLocation 新的用户位置
     */
    override func didUpdate(_ userLocation: BMKUserLocation!) {
        print("didUpdateUserLocation lat:\(userLocation.location.coordinate.latitude) lon:\(userLocation.location.coordinate.longitude)")
        mapView.updateLocationData(userLocation)
        if (hasLocated == false) {
            hasLocated = true
            mapView.centerCoordinate = userLocation.location.coordinate
            getNearByPoints(mapView.centerCoordinate)
        }
    }
    
    /**
     *在地图View停止定位后，会调用此函数
     *@param mapView 地图View
     */
    func didStopLocatingUser() {
        print("didStopLocatingUser")
    }
    
}
