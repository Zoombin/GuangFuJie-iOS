//
//  RootMapViewController.swift
//  GuangFuJie
//
//  Created by 颜超 on 2017/7/6.
//  Copyright © 2017年 yc. All rights reserved.
//

import UIKit

class RootMapViewController:BaseViewController, BMKLocationServiceDelegate, BMKMapViewDelegate, BMKPoiSearchDelegate {
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var pgButton: UIButton!
    @IBOutlet weak var leaseButton: UIButton!
    @IBOutlet weak var calButton: UIButton!
    
    @IBOutlet weak var lineView1: UIView!
    @IBOutlet weak var lineView2: UIView!
    @IBOutlet weak var lineView3: UIView!
    @IBOutlet weak var lineView4: UIView!
    
    var type = 0 // 0 1 2
    var currentLevel: Float = 14
    
    var locService : BMKLocationService!
    var poiService : BMKPoiSearch!
    
    var currentLoation : CLLocationCoordinate2D!
    var searchType = "province"
    
    @IBOutlet weak var mapView : BMKMapView!
    var installerPoints = NSMutableArray()
    var roofPoints = NSMutableArray()
    var nearbyPoints = NSMutableArray()
    
    var hasLocated = false
    
    var isLoading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "屋顶地图"
        initView()
        locService = BMKLocationService()
        poiService = BMKPoiSearch()
        
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
        lineView4.isHidden = true
        if (type == 0) {
            lineView1.isHidden = false
        } else if (type == 1) {
            lineView2.isHidden = false
        } else if (type == 2){
            lineView3.isHidden = false
        } else {
            lineView4.isHidden = false
        }
        loadData()
    }
    
    func loadData() {
        if (!hasLocated) {
            return
        }
        if (type == 0) {
            //全部搜索
            mapView.removeAnnotations(mapView.annotations)
            installerPoints.removeAllObjects()
            roofPoints.removeAllObjects()
            nearbyPoints.removeAllObjects()
            
            getInstallerMap()
            getRoofMap()
            getNearbyElectric()
        } else if (type == 1) {
            installerPoints.removeAllObjects()
            getInstallerMap()
        } else if (type == 2) {
            roofPoints.removeAllObjects()
            getRoofMap()
        } else {
            nearbyPoints.removeAllObjects()
            getNearbyElectric()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.navigationController?.tabBarItem.selectedImage = self.tabBarItem.selectedImage?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
    }
    
    func getInstallerMap() {
        showLoading()
        API.sharedInstance.installerMapListV2(type: searchType, lat: NSNumber.init(value: currentLoation.latitude), lng: NSNumber.init(value: currentLoation.longitude), success: { (count, roofList) in
            self.hideLoading()
            self.installerPoints.removeAllObjects()
            if (roofList.count > 0) {
                self.installerPoints.addObjects(from: roofList as [AnyObject])
            }
            self.addPoints()
        }) { (msg) in
            self.hideLoading()
            self.showHint(msg)
            
        }
    }
    
    func showLoading() {
        if (!isLoading) {
            isLoading = true
            self.showHud(in: self.view, hint: "获取数据中...")
        }
    }
    
    func hideLoading() {
        isLoading = false
        self.hideHud()
    }
    
    func getNearbyElectric() {
        let option = BMKNearbySearchOption()
        option.pageIndex = 0
        option.pageCapacity = 10
        option.location = currentLoation
        option.keyword = "供电局"
        option.radius = 30000
        let flag = poiService.poiSearchNear(by: option)
        showLoading()
        if (flag) {
            print("搜索成功")
        } else {
            print("搜索失败")
        }
    }
    
    func getRoofMap() {
        showLoading()
        API.sharedInstance.roofMapListV2(type: searchType, lat: NSNumber.init(value: currentLoation.latitude), lng: NSNumber.init(value: currentLoation.longitude), success: { (count, roofList) in
            self.hideLoading()
            self.roofPoints.removeAllObjects()
            if (roofList.count > 0) {
                self.roofPoints.addObjects(from: roofList as [AnyObject])
            }
            self.addPoints()
        }) { (msg) in
            self.hideLoading()
            self.showHint(msg)
        }
    }
    
    func addPoints() {
        if (type != 0) {
            mapView.removeAnnotations(mapView.annotations)
        }
        if (self.installerPoints.count == 0 && self.roofPoints.count == 0) {
            return
        }
        if (type == 0) {
            if (installerPoints.count > 0 && roofPoints.count > 0 && nearbyPoints.count > 0) {
                mapView.removeAnnotations(mapView.annotations)
                for i in 0..<installerPoints.count {
                    let object = self.installerPoints[i] as! NSObject
                    addInstallerPoint(object: object)
                }
                for i in 0..<roofPoints.count {
                    let object = self.roofPoints[i] as! NSObject
                    addRoofPoint(object: object)
                }
                for i in 0..<nearbyPoints.count {
                    let object = self.nearbyPoints[i] as! BMKAnnotation
                    mapView.addAnnotation(object)
                }
            }
        } else if (type == 1) {
            for i in 0..<installerPoints.count {
                let object = self.installerPoints[i] as! NSObject
                addInstallerPoint(object: object)
            }
        } else if (type == 2) {
            for i in 0..<roofPoints.count {
                let object = self.roofPoints[i] as! NSObject
                addRoofPoint(object: object)
            }
        } else if (type == 3) {
            for i in 0..<nearbyPoints.count {
                let object = self.nearbyPoints[i] as! BMKAnnotation
                mapView.addAnnotation(object)
            }
        }
    }
    
    func addInstallerPoint(object: NSObject) {
        let installer = object as! InstallerMapInfo
        let companyName = StringUtils.getString(installer.name)
        
        let item = BMKPointAnnotation()
        if (installer.lat == nil || installer.lng == nil) {
            return
        }
        
        let coordinate = CLLocationCoordinate2D.init(latitude: installer.lat!.doubleValue, longitude: installer.lng!.doubleValue)
        item.coordinate = coordinate
        item.title = companyName
        item.subtitle = "\(installer.count!)家安装商"
        mapView.addAnnotation(item)
    }
    
    func addRoofPoint(object: NSObject) {
        let roof = object as! RoofMapInfo
        let companyName = StringUtils.getString(roof.name)
        
        let item = BMKPointAnnotation()
        if (roof.lat == nil || roof.lng == nil) {
            return
        }
        let coordinate = CLLocationCoordinate2D.init(latitude: roof.lat!.doubleValue, longitude: roof.lng!.doubleValue)
        item.coordinate = coordinate
        item.title = companyName
        item.subtitle = "居民屋顶:\(StringUtils.getString(roof.jumingroof))"
        mapView.addAnnotation(item)
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
        poiService.delegate = self
        mapView.delegate = self
        startLocation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        mapView.viewWillDisappear()
        locService.delegate = nil
        poiService.delegate = nil
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
    
    func onGetPoiResult(_ searcher: BMKPoiSearch!, result poiResult: BMKPoiResult!, errorCode: BMKSearchErrorCode) {
        hideLoading()
        if (errorCode == BMK_SEARCH_NO_ERROR) {
//            mapView.removeAnnotations(mapView.annotations)
            nearbyPoints.removeAllObjects()
            for i in 0..<poiResult.poiInfoList.count {
                let poi = poiResult.poiInfoList[i] as! BMKPoiInfo
                let item = BMKPointAnnotation()
                item.coordinate = poi.pt
                item.title = poi.name
                item.subtitle = poi.address
                nearbyPoints.add(item)
//                mapView.addAnnotation(item)
            }
            addPoints()
        } else {
            //出现异常
        }
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
            // 设置颜色
            annotationView!.pinColor = UInt(BMKPinAnnotationColorRed)
            // 从天上掉下的动画
            annotationView!.animatesDrop = false
            // 设置是否可以拖拽
            //            annotationView!.isDraggable = false
        }
        let imageNameRed = "ic_map_redpoint"
        let imageNameOrange = "ic_map_orangepoint"
        let imageNameBlue = "ic_map_bluepoint"
        if (type == 0) {
            annotationView?.image = UIImage(named: imageNameRed)
        } else if (type == 1) {
            annotationView?.image = UIImage(named: imageNameOrange)
        } else if (type == 2) {
            annotationView?.image = UIImage(named: imageNameBlue)
        } else {
            annotationView?.image = UIImage(named: imageNameRed)
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
