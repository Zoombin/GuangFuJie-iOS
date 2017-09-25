//
//  MapViewController.swift
//  Opple
//
//  Created by 颜超 on 2016/11/3.
//  Copyright © 2016年 颜超. All rights reserved.
//

import UIKit

class MapViewController: BaseViewController, BMKMapViewDelegate, BMKGeoCodeSearchDelegate, UISearchBarDelegate, UIAlertViewDelegate {
    var searchBar : UISearchBar!
    
    var polyline: BMKPolyline?
    var colorfulPolyline: BMKPolyline?
    var locService : BMKLocationService!
    var geocodeSearch: BMKGeoCodeSearch!
    var address = ""
    var canDraw = true
    var cityName = ""
    
    
    var currentLocation = CLLocationCoordinate2D()
    var mapView : BMKMapView!
    var points = NSMutableArray()
    var hasLocated = false
    
    let EDIT_ALERT_TAG = 1001
    let CANCEL_ALERT_TAG = 1002
    let SURE_ALERT_TAG = 1003
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "屋顶地图"
        initView()
        locService = BMKLocationService()
        
        geocodeSearch = BMKGeoCodeSearch()
    }
    
    func initView() {
        mapView = BMKMapView.init(frame: CGRect(x: 0, y: 50, width: PhoneUtils.kScreenWidth, height: PhoneUtils.kScreenHeight - 50))
        mapView.zoomLevel = 18
        mapView.mapType = UInt(BMKMapTypeSatellite)

        self.view.addSubview(mapView)
        
        searchBar = UISearchBar.init(frame: CGRect(x: 0, y: 64, width: PhoneUtils.kScreenWidth, height: 50))
        searchBar.barTintColor = Colors.bkgColor
        searchBar.delegate = self
        self.view.addSubview(searchBar)
        
        addBottomButton()
    }
    
    func addBottomButton() {
        let buttonWidth : CGFloat = 40
        let buttonHeight : CGFloat = 40
        
        let bottomView = UIView.init(frame: CGRect(x: (PhoneUtils.kScreenWidth - buttonWidth * 3) / 2, y: PhoneUtils.kScreenHeight - buttonHeight - 20, width: buttonWidth * 3, height: buttonHeight))
        bottomView.backgroundColor = UIColor.white
        self.view.addSubview(bottomView)
        
        let cancelButton = UIButton.init(type: UIButtonType.custom)
        cancelButton.layer.borderColor = UIColor.lightGray.cgColor
        cancelButton.layer.borderWidth = 0.5
        cancelButton.frame = CGRect(x: 0, y: 0, width: buttonWidth, height: buttonHeight)
        cancelButton.setImage(UIImage(named: "ic_cancle"), for: UIControlState.normal)
        cancelButton.addTarget(self, action: #selector(self.cancelButtonClicked), for: UIControlEvents.touchUpInside)
        bottomView.addSubview(cancelButton)
        
        let editButton = UIButton.init(type: UIButtonType.custom)
        editButton.layer.borderColor = UIColor.lightGray.cgColor
        editButton.layer.borderWidth = 0.5
        editButton.frame = CGRect(x: buttonWidth, y: 0, width: buttonWidth, height: buttonHeight)
        editButton.setImage(UIImage(named: "ic_edit"), for: UIControlState.normal)
        editButton.addTarget(self, action: #selector(self.editButtonClicked), for: UIControlEvents.touchUpInside)
        bottomView.addSubview(editButton)
        
        let sureButton = UIButton.init(type: UIButtonType.custom)
        sureButton.layer.borderColor = UIColor.lightGray.cgColor
        sureButton.layer.borderWidth = 0.5
        sureButton.frame = CGRect(x: buttonWidth * 2, y: 0, width: buttonWidth, height: buttonHeight)
        sureButton.setImage(UIImage(named: "ic_yes"), for: UIControlState.normal)
        sureButton.addTarget(self, action: #selector(self.sureButtonClicked), for: UIControlEvents.touchUpInside)
        bottomView.addSubview(sureButton)
        
        let locationButton = UIButton.init(type: UIButtonType.custom)
        locationButton.backgroundColor = UIColor.white
        locationButton.layer.borderColor = UIColor.lightGray.cgColor
        locationButton.layer.borderWidth = 0.5
        locationButton.frame = CGRect(x: 20, y: PhoneUtils.kScreenHeight - buttonHeight - 20, width: buttonWidth, height: buttonHeight)
        locationButton.setImage(UIImage(named: "ic_location"), for: UIControlState.normal)
        locationButton.addTarget(self, action: #selector(self.startLocation), for: UIControlEvents.touchUpInside)
        self.view.addSubview(locationButton)
    }
    
    func cancelButtonClicked() {
        let alertView = UIAlertView.init(title: "提示", message: "是否清除选择区域？", delegate: self, cancelButtonTitle:"取消", otherButtonTitles: "确定")
        alertView.tag = CANCEL_ALERT_TAG
        alertView.show()
    }
    
    func editButtonClicked() {
        let alertView = UIAlertView.init(title: "提示", message: "请在地图上点选区域！", delegate: self, cancelButtonTitle:"取消", otherButtonTitles: "确定")
        alertView.tag = EDIT_ALERT_TAG
        alertView.show()
    }
    
    func sureButtonClicked() {
        let alertView = UIAlertView.init(title: "提示", message: "是否计算所选区域的屋顶发电量？", delegate: self, cancelButtonTitle:"取消", otherButtonTitles: "确定")
        alertView.tag = SURE_ALERT_TAG
        alertView.show()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        geoSearch()
    }
    
    func addPolygon() {
        if (mapView.annotations.count < 3) {
            return
        }
        mapView.removeOverlays(mapView.overlays)
        
        var polygon = BMKPolygon()
        var coords = [CLLocationCoordinate2D]()
        for i in 0..<mapView.annotations.count {
            let item = mapView.annotations[i] as! BMKAnnotation
            coords.append(item.coordinate)
        }
        polygon = BMKPolygon(coordinates: &coords, count: UInt(coords.count))
        mapView.add(polygon)
    }
    
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        if (alertView.cancelButtonIndex == buttonIndex) {
            return
        }
        if (alertView.tag == EDIT_ALERT_TAG) {
            canDraw = true
            mapView.removeOverlays(mapView.overlays)
            mapView.removeAnnotations(mapView.annotations)
        } else if (alertView.tag == CANCEL_ALERT_TAG) {
            mapView.removeOverlays(mapView.overlays)
            mapView.removeAnnotations(mapView.annotations)
        } else if (alertView.tag == SURE_ALERT_TAG) {
            if (mapView.annotations.count < 3) {
                self.showHint("请选择至少3个点")
                return
            }
            let model = CalcModel()
            model.type = 0
            model.area = ""
            model.province_id = 0
            model.city_id = 0
            
            var value = "["
            for i in 0..<mapView.annotations.count {
                let item = mapView.annotations[i] as! BMKAnnotation
                let lat = item.coordinate.latitude
                let lng = item.coordinate.longitude
                let latlngStr = "{lat:\(lat),lng:\(lng)}"
                value = value + latlngStr
                if (i != mapView.annotations.count - 1) {
                    value = value + ","
                }
            }
            value = value + "]"
            
            let vc = CalResultViewController()
            vc.cityName = cityName
            vc.calModel = model
            vc.polygon = value
            self.pushViewController(vc, animation: false)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        mapView.viewWillAppear()
        
        locService.delegate = self
        geocodeSearch.delegate = self
        
        mapView.delegate = self
        
        startLocation()
    }
    
    func geoSearch() {
        let geocodeSearchOption = BMKGeoCodeSearchOption()
        //        geocodeSearchOption.city = "苏州"
        geocodeSearchOption.address = searchBar.text
        let flag = geocodeSearch.geoCode(geocodeSearchOption)
        if flag {
            print("geo 检索发送成功")
        } else {
            print("geo 检索发送失败")
        }
        searchBar.resignFirstResponder()
    }
    
    func reGeoSearch(location: CLLocationCoordinate2D) {
        let reverseGeoOption = BMKReverseGeoCodeOption()
        reverseGeoOption.reverseGeoPoint = location
        let flag = geocodeSearch.reverseGeoCode(reverseGeoOption)
        if flag {
            print("反地理编码成功")
        } else {
            print("反地理编码失败")
        }
    }
    
    
    // MARK: - BMKMapViewDelegate
    
    /**
     *根据overlay生成对应的View
     *@param mapView 地图View
     *@param overlay 指定的overlay
     *@return 生成的覆盖物View
     */
    internal func mapView(_ mapView: BMKMapView!, viewFor overlay: BMKOverlay!) -> BMKOverlayView! {
        
        if (overlay as? BMKCircle) != nil {
            let circleView = BMKCircleView(overlay: overlay)
            circleView?.fillColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.5)
            circleView?.strokeColor = UIColor(red: 0, green: 0, blue: 1, alpha: 0.5)
            circleView?.lineWidth = 5
            
            return circleView
        }
        
        if (overlay as? BMKPolygon) != nil {
            let polygonView = BMKPolygonView(overlay: overlay)
            polygonView?.strokeColor = UIColor(red: 0, green: 0, blue: 0.5, alpha: 1)
            polygonView?.fillColor = UIColor(red: 0, green: 1, blue: 1, alpha: 0.2)
            polygonView?.lineWidth = 2
            polygonView?.lineDash = true
            return polygonView
        }
        
        if let overlayTemp = overlay as? BMKPolyline {
            let polylineView = BMKPolylineView(overlay: overlay)
            if overlayTemp == polyline {
                polylineView?.strokeColor = UIColor(red: 0, green: 1, blue: 0, alpha: 1)
                polylineView?.lineWidth = 10
                polylineView?.loadStrokeTextureImage(UIImage(named: "texture_arrow.png"))
            } else if overlayTemp == colorfulPolyline {
                polylineView?.lineWidth = 5
                /// 使用分段颜色绘制时，必须设置（内容必须为UIColor）
                polylineView?.colors = [UIColor(red: 0, green: 1, blue: 0, alpha: 1),
                                       UIColor(red: 1, green: 0, blue: 0, alpha: 1),
                                       UIColor(red: 1, green: 1, blue: 0, alpha: 1)]
            }
            return polylineView
        }
        
        if (overlay as? BMKGroundOverlay) != nil {
            let groundView = BMKGroundOverlayView(overlay: overlay)
            return groundView
        }
        
        if (overlay as? BMKArcline) != nil {
            let arclineView = BMKArclineView(overlay: overlay)
            arclineView?.strokeColor = UIColor(red: 0, green: 0, blue: 1, alpha: 1)
            arclineView?.lineDash = true
            arclineView?.lineWidth = 6
            
            return arclineView
        }
        return nil
    }
    
    // MARK: - BMKGeoCodeSearchDelegate
    
    /**
     *返回地址信息搜索结果
     *@param searcher 搜索对象
     *@param result 搜索结BMKGeoCodeSearch果
     *@param error 错误号，@see BMKSearchErrorCode
     */
    func onGetGeoCodeResult(_ searcher: BMKGeoCodeSearch!, result: BMKGeoCodeResult!, errorCode error: BMKSearchErrorCode) {
        print("onGetGeoCodeResult error: \(error)")
        
        if error == BMK_SEARCH_NO_ERROR {
            mapView.centerCoordinate = result.location
        }
    }
    
    func onGetReverseGeoCodeResult(_ searcher: BMKGeoCodeSearch!, result: BMKReverseGeoCodeResult!, errorCode error: BMKSearchErrorCode) {
        if error == BMK_SEARCH_NO_ERROR {
            cityName = result.addressDetail.city
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        mapView.viewWillDisappear()
        
        locService.delegate = nil
        geocodeSearch.delegate = nil
        
        mapView.delegate = nil
        
    }
    
    func mapView(_ mapView: BMKMapView!, onClickedMapBlank coordinate: CLLocationCoordinate2D) {
        if (canDraw == false) {
            return
        }
        let item = BMKPointAnnotation()
        item.coordinate = coordinate
        mapView.addAnnotation(item)
        
        addPolygon()
    }
    
    // MARK: - IBAction
    func startLocation() {
        print("进入普通定位态");
        mapView.centerCoordinate = currentLocation
        hasLocated = false
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
            annotationView?.image = UIImage(named: "ic_annview_roof")
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
     *用户位置更新后，会调用此函数
     *@param userLocation 新的用户位置
     */
    override func didUpdate(_ userLocation: BMKUserLocation!) {
        print("didUpdateUserLocation lat:\(userLocation.location.coordinate.latitude) lon:\(userLocation.location.coordinate.longitude)")
        mapView.updateLocationData(userLocation)
        if (hasLocated == false) {
            hasLocated = true
            currentLocation = userLocation.location.coordinate
            mapView.centerCoordinate = userLocation.location.coordinate
            reGeoSearch(location: userLocation.location.coordinate)
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
