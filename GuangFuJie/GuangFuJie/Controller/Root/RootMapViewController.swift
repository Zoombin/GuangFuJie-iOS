//
//  RootMapViewController.swift
//  GuangFuJie
//
//  Created by 颜超 on 2017/7/6.
//  Copyright © 2017年 yc. All rights reserved.
//

import UIKit

class RootMapViewController:BaseViewController, BMKLocationServiceDelegate, BMKMapViewDelegate {
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var pgButton: UIButton!
    @IBOutlet weak var leaseButton: UIButton!
    @IBOutlet weak var calButton: UIButton!
    
    @IBOutlet weak var lineView1: UIView!
    @IBOutlet weak var lineView2: UIView!
    @IBOutlet weak var lineView3: UIView!
    
    var type = 0 // 0 1 2
    var currentLevel: Float = 14
    
    var locService : BMKLocationService!
    var currentLoation : CLLocationCoordinate2D!
    var searchType = "province"
    
    @IBOutlet weak var mapView : BMKMapView!
    var points = NSMutableArray()
    var hasLocated = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "屋顶地图"
        initView()
        locService = BMKLocationService()
        
        loadData()
    }
    
    func mapStatusDidChanged(_ mapView: BMKMapView!) {
        print(mapView.zoomLevel)
        if (currentLevel == mapView.zoomLevel) {
            return
        }
        
        if (mapView.zoomLevel < 7) {
            if (searchType == "province") {
                return
            }
            searchType = "province"
        } else if (mapView.zoomLevel > 7 && mapView.zoomLevel < 11) {
            if (searchType == "city") {
                return
            }
            searchType = "city"
        } else {
            if (searchType == "area") {
                return
            }
            searchType = "area"
        }
        currentLevel = mapView.zoomLevel
        loadData()
    }
    
    @IBAction func topButtonClicked(sender: UIButton) {
        type = sender.tag
        lineView1.isHidden = true
        lineView2.isHidden = true
        lineView3.isHidden = true
        if (type == 0) {
            lineView1.isHidden = false
        } else if (type == 1) {
            lineView2.isHidden = false
        } else {
            lineView3.isHidden = false
        }
        loadData()
    }
    
    func loadData() {
        if (!hasLocated) {
            return
        }
        if (type == 0) {
            getInstallerMap()
        } else if (type == 1) {
            getRoofMap()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.navigationController?.tabBarItem.selectedImage = self.tabBarItem.selectedImage?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
    }
    
    func getInstallerMap() {
        self.showHud(in: self.view, hint: "获取数据中...")
        API.sharedInstance.installerMapListV2(type: searchType, lat: NSNumber.init(value: currentLoation.latitude), lng: NSNumber.init(value: currentLoation.longitude), success: { (count, roofList) in
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
    
    func getRoofMap() {
        self.showHud(in: self.view, hint: "获取数据中...")
        API.sharedInstance.roofMapListV2(type: searchType, lat: NSNumber.init(value: currentLoation.latitude), lng: NSNumber.init(value: currentLoation.longitude), success: { (count, roofList) in
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
            if (type == 0) {
                let installer = self.points[i] as! InstallerMapInfo
                let companyName = StringUtils.getString(installer.name)
                
                let item = BMKPointAnnotation()
                if (installer.lat == nil || installer.lng == nil) {
                    continue
                }
                
                let coordinate = CLLocationCoordinate2D.init(latitude: installer.lat!.doubleValue, longitude: installer.lng!.doubleValue)
                item.coordinate = coordinate
                item.title = companyName
                item.subtitle = "\(installer.count!)家安装商"
                mapView.addAnnotation(item)
            } else if (type == 1) {
                let roof = self.points[i] as! RoofMapInfo
                let companyName = StringUtils.getString(roof.name)
                
                let item = BMKPointAnnotation()
                if (roof.lat == nil || roof.lng == nil) {
                    continue
                }
                let coordinate = CLLocationCoordinate2D.init(latitude: roof.lat!.doubleValue, longitude: roof.lng!.doubleValue)
                item.coordinate = coordinate
                item.title = companyName
                item.subtitle = "居民屋顶:\(StringUtils.getString(roof.jumingroof))"
                mapView.addAnnotation(item)
                
            }
        }
    }
    
    func initView() {
        mapView.zoomLevel = 14
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
            annotationView?.image = UIImage(named: type == 0 ? "ic_map_redpoint" : "ic_map_bluepoint")
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
    func didUpdate(_ userLocation: BMKUserLocation!) {
        print("didUpdateUserLocation lat:\(userLocation.location.coordinate.latitude) lon:\(userLocation.location.coordinate.longitude)")
        mapView.updateLocationData(userLocation)
        if (hasLocated == false) {
            locService.stopUserLocationService()
            hasLocated = true
            currentLoation = userLocation.location.coordinate
            mapView.centerCoordinate = userLocation.location.coordinate
            loadData()
        }
    }
    
    /**
     *在地图View停止定位后，会调用此函数
     *@param mapView 地图View
     */
    func didStopLocatingUser() {
        print("didStopLocatingUser")
    }
    
    //微信地图计算
    @IBAction func mapCalButtonClicked() {
        let vc = MapViewController()
        self.pushViewController(vc)
    }
    
    //出租
    @IBAction func leaseButtonClicked() {
        let vc = LeaseViewController.init(nibName: "LeaseViewController", bundle: nil)
        self.pushViewController(vc)
    }
    
    //评估
    @IBAction func normalCalButtonClicked() {
        let vc = RoofPriceViewController()
        self.pushViewController(vc)
    }
    
    @IBAction func closeButtonClicked() {
        closeButton.isSelected = !closeButton.isSelected
        UIView.animate(withDuration: 0.5, animations: {
            self.pgButton.alpha = !self.closeButton.isSelected ? 0.0 : 1.0
            self.leaseButton.alpha = !self.closeButton.isSelected ? 0.0 : 1.0
            self.calButton.alpha = !self.closeButton.isSelected ? 0.0 : 1.0
        }) { (true) in
            self.pgButton.isUserInteractionEnabled = self.closeButton.isSelected
            self.leaseButton.isUserInteractionEnabled = self.closeButton.isSelected
            self.calButton.isUserInteractionEnabled = self.closeButton.isSelected
        }
    }

}
