//
//  Mastering RxSwift
//  Copyright (c) KxCoding <help@kxcoding.com>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//


import UIKit
import CoreLocation
import RxSwift
import RxCocoa
import MapKit

//Delegate Proxy는 구현하기 어렵지만, 익숙해지면 거의 모든부분을 Rxswift방식으로 구현할 수 있게 된다.

class DelegateProxyViewController: UIViewController {
    
    let bag = DisposeBag()
    
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        locationManager.rx.didUpdateLocations
            .subscribe(onNext: { locations in
                print(locations)
                
            })
            .disposed(by: bag)
        
//        locationManager.rx.didFailWithError
//            .subscribe(onNext: { error in
//                print(error)
//            })
//            .disposed(by: bag)
        
        // didUpdateLocations이 방출하는 첫번째 좌표를 센터 속성에 바인딩
        locationManager.rx.didUpdateLocations
            .map { $0[0] }
            .bind(to: mapView.rx.center)
            .disposed(by: bag)
    }
}


extension Reactive where Base: MKMapView {
    public var center: Binder<CLLocation> {
        return Binder(self.base) { mapView, location in
            let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
            self.base.setRegion(region, animated: true)
        }
    }
}

// Delegate Proxy를 구현할 때는 하나의 클래스와 두개의 익스텐션을 구현

extension CLLocationManager: HasDelegate {
    public typealias Delegate = CLLocationManagerDelegate
}

class RxCLLocationManagerDelegateProxy: DelegateProxy<CLLocationManager, CLLocationManagerDelegate>, DelegateProxyType, CLLocationManagerDelegate {
    weak private(set) var locationManager: CLLocationManager? //클래스 내부에서 확장 대상을 접근할때는 weak로 선언해야 사이클 문제가 발생안함
    
    init(locationManager: CLLocationManager) {
        self.locationManager = locationManager
        super.init(parentObject: locationManager, delegateProxy: RxCLLocationManagerDelegateProxy.self)
    }
    
    static func registerKnownImplementations() {
        self.register {
            RxCLLocationManagerDelegateProxy(locationManager: $0)
        }
    }
}

extension Reactive where Base: CLLocationManager {
    var delegate: DelegateProxy<CLLocationManager, CLLocationManagerDelegate> {
        // 인스턴스 생성 시 RxCLLocationManagerDelegateProxy의 생성자를 사용하는 것이 아닌 .proxy(for: base)를 사용
        return RxCLLocationManagerDelegateProxy.proxy(for: base)
    }
    
    var didUpdateLocations: Observable<[CLLocation]> {
        return delegate.methodInvoked(#selector(CLLocationManagerDelegate.locationManager(_:didUpdateLocations:)))
            .map { parameters in
                return parameters[1] as! [CLLocation]
            }
    }
    
//    var didFailWithError: Observable<[CLLocation]> {
//        return delegate.methodInvoked(#selector(CLLocationManagerDelegate.locationManager(_:didFailWithError:)))
//            .map { parameters in
//                return parameters[1] as! [Error]
//            }
}

