//
//  RootMapV2ViewController.swift
//  GuangFuJie
//
//  Created by 颜超 on 2017/11/6.
//  Copyright © 2017年 yc. All rights reserved.
//

import UIKit

class RootMapV2ViewController: BaseViewController, BMKMapViewDelegate, BMKPoiSearchDelegate, UITableViewDelegate, UITableViewDataSource, PaoPaoViewDelegate {

    var currentIndex = 0
    var topView: UIView!
    var btns = NSMutableArray()
    var mapView : BMKMapView!
    let times = YCPhoneUtils.screenWidth / 375
    
    var type = 0 // 0 1 2
    var currentLevel: Float = 14
    
    var locService : BMKLocationService!
    var poiService : BMKPoiSearch!
    
    var currentLoation : CLLocationCoordinate2D!
    var searchType = "province"
    
    var installerPoints = NSMutableArray()
    var roofPoints = NSMutableArray()
    var nearbyPoints = NSMutableArray()
    
    var hasLocated = false
    
    var isLoading = false
    
    var applyInstallButton: UIButton!
    
    var pguButton: UIButton!
    
    var chuzuButton: UIButton!
    
    var cesuanButton: UIButton!
    
    var installerArray = NSMutableArray()
    var headerView: UIView!
    var installerTableView: UITableView!
    let cellReuseIdentifier = "cellReuseIdentifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.tabBarItem.selectedImage = self.tabBarItem.selectedImage?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        
        self.title = "地图"
        initTopView()
        initMapView()
        initTableView()
    }
    
    func closeButtonClicked() {
        headerView.isHidden = true
        installerTableView.isHidden = true
    }
    
    func initTableView() {
        headerView = UIView.init(frame: CGRect(x: 0, y: self.navigationBarAndStatusBarHeight() + 200 * times, width: YCPhoneUtils.screenWidth, height: 50 * times))
        headerView.backgroundColor = UIColor.white
        headerView.isHidden = true
        let titleLabel = UILabel.init(frame: CGRect(x: 0, y: 0, width: YCPhoneUtils.screenWidth, height: headerView.frame.size.height))
        titleLabel.textAlignment = NSTextAlignment.center
        titleLabel.text = "附近安装商"
        headerView.addSubview(titleLabel)
        
        let closeButton = UIButton.init(type: UIButtonType.custom)
        closeButton.frame = CGRect(x: YCPhoneUtils.screenWidth - headerView.frame.size.height, y: 0, width: headerView.frame.size.height, height: headerView.frame.size.height)
        closeButton.setTitle("X", for: UIControlState.normal)
        closeButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        closeButton.addTarget(self, action: #selector(closeButtonClicked), for: UIControlEvents.touchUpInside)
        closeButton.titleLabel?.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 17))
        headerView.addSubview(closeButton)
        self.view.addSubview(headerView)
        
        installerTableView = UITableView.init(frame: CGRect(x: 0, y: headerView.frame.maxY, width: YCPhoneUtils.screenWidth, height: YCPhoneUtils.screenHeight - headerView.frame.maxY - 50))
        installerTableView.delegate = self
        installerTableView.dataSource = self
        installerTableView.isHidden = true
        self.view.addSubview(installerTableView)
        
        installerTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
    }
    
    func getCityByLatLng(lat: NSNumber, lng: NSNumber) {
        API.sharedInstance.getCityFromLatlng(lat: lat, lng: lng, success: { (location) in
            self.getInsallerBYId(provinceId: YCStringUtils.getNumber(location.province_id), cityId: YCStringUtils.getNumber(location.city_id), areaId: YCStringUtils.getNumber(location.area_id))
        }) { (msg) in
            self.showHint(msg)
        }
    }
    
    func getInsallerBYId(provinceId: NSNumber, cityId: NSNumber, areaId: NSNumber) {
        if (searchType == "province") {
            self.searchNearByInstaller(provinceId: provinceId, cityId: nil, areaId: nil)
        } else if (searchType == "city") {
            self.searchNearByInstaller(provinceId: nil, cityId: cityId, areaId: nil)
        } else {
            self.searchNearByInstaller(provinceId: nil, cityId: cityId, areaId: nil)
        }
    }
    
    func searchNearByInstaller(provinceId: NSNumber? = nil, cityId: NSNumber? = nil, areaId: NSNumber? = nil) {
        API.sharedInstance.getNearInstallerV2(provinceId, city_id: cityId, area_id: areaId, success: { (array) in
            self.installerArray.removeAllObjects()
            if (array.count > 0) {
                self.headerView.isHidden = false
                self.installerTableView.isHidden = false
                self.installerArray.addObjects(from: array as! [Any])
            }
            self.installerTableView.reloadData()
        }) { (msg) in
            self.showHint(msg)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80 * times
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return installerArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: UITableViewCellStyle.subtitle, reuseIdentifier: cellReuseIdentifier)
        cell.textLabel?.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 15))
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 15))
        let info = installerArray[indexPath.row] as! InstallInfo
        cell.textLabel?.text = YCStringUtils.getString(info.company_name)
        cell.textLabel?.textColor = UIColor.black
        cell.detailTextLabel?.text = "地址:" + YCStringUtils.getString(info.province_name) + YCStringUtils.getString(info.city_name) + YCStringUtils.getString(info.address_detail)
        cell.detailTextLabel?.textColor = UIColor.black
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let info = installerArray[indexPath.row] as! InstallInfo
        let vc = InstallerDetailOldViewController.init(nibName: "InstallerDetailOldViewController", bundle: nil)
        vc.installer_id = YCStringUtils.getNumber(info.id)
        self.pushViewController(vc)
    }
    
    func initTopView() {
        topView = UIView.init(frame: CGRect(x: 0, y: self.navigationBarAndStatusBarHeight(), width: YCPhoneUtils.screenWidth, height: 42 * times))
        topView.backgroundColor = UIColor.white
        self.view.addSubview(topView)
        
        let titles = ["全部", "安装商", "屋顶", "供电局"]
        let imgs = ["ic_porsit_violet", "ic_map_orange", "ic_map_green", "ic_map_red"]
        let btnWidth = YCPhoneUtils.screenWidth / 4
        for i in 0..<titles.count {
            let btn = UIButton.init(type: UIButtonType.custom)
            btn.titleEdgeInsets = UIEdgeInsetsMake(0, 3 * times, 0, 0)
            btn.frame = CGRect(x: CGFloat(i) * btnWidth, y: 0, width: btnWidth, height: topView.frame.size.height)
            btn.setTitle(titles[i], for: UIControlState.normal)
            btn.setTitleColor(UIColor.black, for: UIControlState.normal)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 15))
            btn.setImage(UIImage(named: imgs[i]), for: UIControlState.normal)
            self.addBottomLine(view: btn, color: i == 0 ? Colors.appBlue : UIColor.white)
            btn.tag = i
            btn.addTarget(self, action: #selector(self.topButtonClicked(button:)), for: UIControlEvents.touchUpInside)
            topView.addSubview(btn)
            btns.add(btn)
        }
    }
    
    func addBottomLine(view: UIView, color: UIColor) {
        let bottomBorder = CALayer()
        let height = view.frame.size.height - 2.0
        let width = view.frame.size.width
        bottomBorder.frame = CGRect(x: 0, y: height, width: width, height: 2)
        bottomBorder.backgroundColor = color.cgColor
        view.layer.addSublayer(bottomBorder)
    }
    
    func resetAllBottomColors() {
        for i in 0..<btns.count {
            let btn = btns[i] as! UIButton
            let layer = btn.layer.sublayers![2]
            layer.backgroundColor = UIColor.white.cgColor
        }
    }
    
    func topButtonClicked(button: UIButton) {
        resetAllBottomColors()
        currentIndex = button.tag
        type = button.tag
        
        applyInstallButton.isHidden = true
        pguButton.isHidden = true
        chuzuButton.isHidden = true
        cesuanButton.isHidden = true
        if (currentIndex == 1) {
            applyInstallButton.isHidden = false
        } else if (currentIndex == 2) {
            pguButton.isHidden = false
            chuzuButton.isHidden = false
            cesuanButton.isHidden = false
        }
        
        let bottomLayer = button.layer.sublayers![2]
        bottomLayer.backgroundColor = Colors.appBlue.cgColor

        loadData()
    }
    
    //#MARK: 地图状态变更
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
    
    
    //#MARK: initMapView
    func initMapView() {
        mapView = BMKMapView.init(frame: CGRect(x: 0, y: topView.frame.maxY, width: YCPhoneUtils.screenWidth, height: YCPhoneUtils.screenHeight - topView.frame.maxY - 50))
        mapView.delegate = self
        mapView.showsUserLocation = true
        self.view.addSubview(mapView)
        
        locService = BMKLocationService()
        poiService = BMKPoiSearch()
        
        addMapMenus()
    }
    
    func addMapMenus() {
        let locationButton = UIButton.init(type: UIButtonType.custom)
        locationButton.setBackgroundImage(UIImage(named: "ic_location"), for: UIControlState.normal)
        locationButton.frame = CGRect(x: 15 * times, y: mapView.frame.size.height - 65 * times, width: 35 * times, height: 35 * times)
        locationButton.backgroundColor = UIColor.white
        locationButton.addTarget(self, action: #selector(self.startLocation), for: UIControlEvents.touchUpInside)
        mapView.addSubview(locationButton)
        
        let addButton = UIButton.init(type: UIButtonType.custom)
        addButton.setTitle("+", for: UIControlState.normal)
        addButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 22))
        addButton.frame = CGRect(x: YCPhoneUtils.screenWidth - 40 * times, y: mapView.frame.size.height - 100 * times, width: 35 * times, height: 40 * times)
        addButton.setTitleColor(UIColor.darkGray, for: UIControlState.normal)
        addButton.backgroundColor = UIColor.white
        addButton.addTarget(self, action: #selector(self.addButtonClicked), for: UIControlEvents.touchUpInside)
        mapView.addSubview(addButton)
        YCLineUtils.addBottomLine(addButton, color: UIColor.lightGray, percent: 100)
        
        let reduceButton = UIButton.init(type: UIButtonType.custom)
        reduceButton.setTitle("-", for: UIControlState.normal)
        reduceButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 22))
        reduceButton.frame = CGRect(x: YCPhoneUtils.screenWidth - 40 * times, y: addButton.frame.maxY, width: 35 * times, height: 40 * times)
        reduceButton.setTitleColor(UIColor.darkGray, for: UIControlState.normal)
        reduceButton.backgroundColor = UIColor.white
        reduceButton.addTarget(self, action: #selector(self.reduceButtonClicked), for: UIControlEvents.touchUpInside)
        mapView.addSubview(reduceButton)
        
        applyInstallButton = UIButton.init(type: UIButtonType.custom)
        applyInstallButton.frame = CGRect(x: YCPhoneUtils.screenWidth - 66 * times, y: 10 * times, width: 56 * times, height: 56 * times)
        applyInstallButton.setBackgroundImage(UIImage(named: "ic_map_function_installapply"), for: UIControlState.normal)
        applyInstallButton.addTarget(self, action: #selector(applyInstallerButtonClicked), for: UIControlEvents.touchUpInside)
        mapView.addSubview(applyInstallButton)
        
        pguButton = UIButton.init(type: UIButtonType.custom)
        pguButton.frame = CGRect(x: YCPhoneUtils.screenWidth - 66 * times, y: 10 * times, width: 56 * times, height: 56 * times)
        pguButton.setBackgroundImage(UIImage(named: "ic_map_function_pg"), for: UIControlState.normal)
        pguButton.addTarget(self, action: #selector(mapCalButtonClicked), for: UIControlEvents.touchUpInside)
        mapView.addSubview(pguButton)
        
        chuzuButton = UIButton.init(type: UIButtonType.custom)
        chuzuButton.frame = CGRect(x: YCPhoneUtils.screenWidth - 66 * times, y: pguButton.frame.maxY + 10 * times, width: 56 * times, height: 56 * times)
        chuzuButton.setBackgroundImage(UIImage(named: "ic_map_fuction_cz"), for: UIControlState.normal)
        chuzuButton.addTarget(self, action: #selector(leaseButtonClicked), for: UIControlEvents.touchUpInside)
        mapView.addSubview(chuzuButton)
        
        cesuanButton = UIButton.init(type: UIButtonType.custom)
        cesuanButton.frame = CGRect(x: YCPhoneUtils.screenWidth - 66 * times, y: chuzuButton.frame.maxY + 10 * times, width: 56 * times, height: 56 * times)
        cesuanButton.setBackgroundImage(UIImage(named: "ic_map_function_cs"), for: UIControlState.normal)
        cesuanButton.addTarget(self, action: #selector(cesuanButtonClicked), for: UIControlEvents.touchUpInside)
        mapView.addSubview(cesuanButton)
        
        applyInstallButton.isHidden = true
        pguButton.isHidden = true
        chuzuButton.isHidden = true
        cesuanButton.isHidden = true
    }
    
    func applyInstallerButtonClicked() {
        if (UserDefaultManager.isLogin() == false) {
            let sb = UIStoryboard.init(name: "Main", bundle: nil)
            self.pushViewController(sb.instantiateViewController(withIdentifier: "LoginViewController"))
            return
        }
        let role = YCStringUtils.getNumber(UserDefaultManager.getUser()!.identity)
        if (role != 1) {
            //安装商
            let sb = UIStoryboard.init(name: "Main", bundle: nil)
            self.pushViewController(sb.instantiateViewController(withIdentifier: "InstallerApplyViewController"))
        }
    }
    
    func cesuanButtonClicked() {
        self.tabBarController?.selectedIndex = 2
    }
    
    func addButtonClicked() {
        mapView.zoomLevel = mapView.zoomLevel+1
    }
    
    func reduceButtonClicked() {
        mapView.zoomLevel = mapView.zoomLevel-1
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
        self.navigationItem.leftBarButtonItem = nil
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
        let paopaoView = PaoPaoView.init(frame: CGRect(x: 0, y: 0, width: 120, height: 50))
        paopaoView.initView()
        paopaoView.cor = annotation.coordinate
        paopaoView.titleLabel.text = YCStringUtils.getString(annotation.title!())
        paopaoView.describeLabel.text = YCStringUtils.getString(annotation.subtitle!())
        paopaoView.delegate = self
        
        let bmkView = BMKActionPaopaoView.init(customView: paopaoView)
        bmkView?.isUserInteractionEnabled = true
        annotationView?.paopaoView = bmkView
        
        let imageNameVio = "ic_mark_violet"
        let imageNameRed = "ic_map_redpoint"
        let imageNameOrange = "ic_map_orangepoint"
        let imageNameGreen = "ic_mark_green"
        
        if (type == 0) {
            annotationView?.image = UIImage(named: imageNameVio)
        } else if (type == 1) {
            annotationView?.image = UIImage(named: imageNameOrange)
        } else if (type == 2) {
            annotationView?.image = UIImage(named: imageNameGreen)
        } else {
            annotationView?.image = UIImage(named: imageNameRed)
        }
        
        annotationView?.annotation = annotation
        return annotationView
    }
    
    func paopaoViewClick(cor: CLLocationCoordinate2D) {
        if (currentIndex != 1) {
            return
        }
        self.getCityByLatLng(lat: NSNumber.init(value: cor.latitude), lng: NSNumber.init(value: cor.longitude))
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
    
    //地图计算
    func mapCalButtonClicked() {
        let vc = MapViewController()
        self.pushViewController(vc)
    }
    
    //出租
    func leaseButtonClicked() {
        let vc = LeaseViewController.init(nibName: "LeaseViewController", bundle: nil)
        self.pushViewController(vc)
    }
    
    //评估
    func normalCalButtonClicked() {
        let vc = RoofPriceViewController()
        self.pushViewController(vc)
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
        let companyName = YCStringUtils.getString(installer.name)
        
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
        let companyName = YCStringUtils.getString(roof.name)
        
        let item = BMKPointAnnotation()
        if (roof.lat == nil || roof.lng == nil) {
            return
        }
        let coordinate = CLLocationCoordinate2D.init(latitude: roof.lat!.doubleValue, longitude: roof.lng!.doubleValue)
        item.coordinate = coordinate
        item.title = companyName
        item.subtitle = "居民屋顶:\(YCStringUtils.getString(roof.jumingroof))"
        mapView.addAnnotation(item)
    }
}
