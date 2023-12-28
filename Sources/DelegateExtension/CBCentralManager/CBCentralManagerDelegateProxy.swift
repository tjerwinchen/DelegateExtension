// CBCentralManagerDelegateProxy.swift
//
// Copyright (c) 2023 Codebase.Codes
// Created by Theo Chen on 2023.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the  Software), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Combine
import CoreBluetooth
import DelegateFoundation

public typealias DidDiscoverPeripheralParam = (peripheral: CBPeripheral, advertisementData: [String: Any], RSSI: NSNumber)
public typealias DidFailToConnectPeripheralParam = (peripheral: CBPeripheral, error: Error?)
public typealias DidDisconnectPeripheralParam = (peripheral: CBPeripheral, error: Error?)
public typealias ConnectionEventDidOccurParam = (event: CBConnectionEvent, peripheral: CBPeripheral)

final class CBCentralManagerDelegateProxy: DelegateProxy<CBCentralManager, CBCentralManagerDelegate>, DelegateProxyProtocol {
  static func createProxy(for object: CBCentralManager) -> CBCentralManagerDelegateProxy {
    CBCentralManagerDelegateProxy(object: object, delegateProxyType: CBCentralManagerDelegateProxy.self)
  }

  static func setProxyDelegate(_ object: CBCentralManager, to proxy: CBCentralManagerDelegateProxy) {
    object.delegate = proxy
  }

  static func forwardToDelegate(for object: CBCentralManager) -> CBCentralManagerDelegate? {
    object.delegate
  }

  public let didUpdateStateRelay = PassthroughSubject<CBCentralManager, Never>()
  public let willRestoreStateRelay = PassthroughSubject<[String: Any], Never>()
  public let didDiscoverPeripheralRelay = PassthroughSubject<DidDiscoverPeripheralParam, Never>()
  public let didConnectPeripheralRelay = PassthroughSubject<CBPeripheral, Never>()
  public let didFailToConnectPeripheralRelay = PassthroughSubject<DidFailToConnectPeripheralParam, Never>()
  public let didDisconnectPeripheralRelay = PassthroughSubject<DidDisconnectPeripheralParam, Never>()
  public let connectionEventDidOccurRealy = PassthroughSubject<ConnectionEventDidOccurParam, Never>()
  public let didUpdateANCSAuthorizationForPeripheralRelay = PassthroughSubject<CBPeripheral, Never>()
}

extension CBCentralManagerDelegateProxy: CBCentralManagerDelegate {
  /**
   *  @method centralManagerDidUpdateState:
   *
   *  @param central  The central manager whose state has changed.
   *
   *  @discussion     Invoked whenever the central manager's state has been updated. Commands should only be issued when the state is
   *                  <code>CBCentralManagerStatePoweredOn</code>. A state below <code>CBCentralManagerStatePoweredOn</code>
   *                  implies that scanning has stopped and any connected peripherals have been disconnected. If the state moves below
   *                  <code>CBCentralManagerStatePoweredOff</code>, all <code>CBPeripheral</code> objects obtained from this central
   *                  manager become invalid and must be retrieved or discovered again.
   *
   *  @see            state
   *
   */
  func centralManagerDidUpdateState(_ central: CBCentralManager) {
    didUpdateStateRelay.send(central)
    forwardToDelegate?.centralManagerDidUpdateState(central)
  }

  /**
   *  @method centralManager:willRestoreState:
   *
   *  @param central      The central manager providing this information.
   *  @param dict      A dictionary containing information about <i>central</i> that was preserved by the system at the time the app was terminated.
   *
   *  @discussion      For apps that opt-in to state preservation and restoration, this is the first method invoked when your app is relaunched into
   *            the background to complete some Bluetooth-related task. Use this method to synchronize your app's state with the state of the
   *            Bluetooth system.
   *
   *  @seealso            CBCentralManagerRestoredStatePeripheralsKey;
   *  @seealso            CBCentralManagerRestoredStateScanServicesKey;
   *  @seealso            CBCentralManagerRestoredStateScanOptionsKey;
   *
   */
  func centralManager(_ central: CBCentralManager, willRestoreState dict: [String: Any]) {
    willRestoreStateRelay.send(dict)
    forwardToDelegate?.centralManager?(central, willRestoreState: dict)
  }

  /**
   *  @method centralManager:didDiscoverPeripheral:advertisementData:RSSI:
   *
   *  @param central              The central manager providing this update.
   *  @param peripheral           A <code>CBPeripheral</code> object.
   *  @param advertisementData    A dictionary containing any advertisement and scan response data.
   *  @param RSSI                 The current RSSI of <i>peripheral</i>, in dBm. A value of <code>127</code> is reserved and indicates the RSSI
   *                was not available.
   *
   *  @discussion                 This method is invoked while scanning, upon the discovery of <i>peripheral</i> by <i>central</i>. A discovered peripheral must
   *                              be retained in order to use it; otherwise, it is assumed to not be of interest and will be cleaned up by the central manager. For
   *                              a list of <i>advertisementData</i> keys, see {@link CBAdvertisementDataLocalNameKey} and other similar constants.
   *
   *  @seealso                    CBAdvertisementData.h
   *
   */
  func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
    didDiscoverPeripheralRelay.send((peripheral, advertisementData, RSSI))
    forwardToDelegate?.centralManager?(central, didDiscover: peripheral, advertisementData: advertisementData, rssi: RSSI)
  }

  /**
   *  @method centralManager:didConnectPeripheral:
   *
   *  @param central      The central manager providing this information.
   *  @param peripheral   The <code>CBPeripheral</code> that has connected.
   *
   *  @discussion         This method is invoked when a connection initiated by {@link connectPeripheral:options:} has succeeded.
   *
   */
  func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
    didConnectPeripheralRelay.send(peripheral)
    forwardToDelegate?.centralManager?(central, didConnect: peripheral)
  }

  /**
   *  @method centralManager:didFailToConnectPeripheral:error:
   *
   *  @param central      The central manager providing this information.
   *  @param peripheral   The <code>CBPeripheral</code> that has failed to connect.
   *  @param error        The cause of the failure.
   *
   *  @discussion         This method is invoked when a connection initiated by {@link connectPeripheral:options:} has failed to complete. As connection attempts do not
   *                      timeout, the failure of a connection is atypical and usually indicative of a transient issue.
   *
   */
  func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
    didFailToConnectPeripheralRelay.send((peripheral, error))
    forwardToDelegate?.centralManager?(central, didFailToConnect: peripheral, error: error)
  }

  /**
   *  @method centralManager:didDisconnectPeripheral:error:
   *
   *  @param central      The central manager providing this information.
   *  @param peripheral   The <code>CBPeripheral</code> that has disconnected.
   *  @param error        If an error occurred, the cause of the failure.
   *
   *  @discussion         This method is invoked upon the disconnection of a peripheral that was connected by {@link connectPeripheral:options:}. If the disconnection
   *                      was not initiated by {@link cancelPeripheralConnection}, the cause will be detailed in the <i>error</i> parameter. Once this method has been
   *                      called, no more methods will be invoked on <i>peripheral</i>'s <code>CBPeripheralDelegate</code>.
   *
   */
  func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
    didDisconnectPeripheralRelay.send((peripheral, error))
    forwardToDelegate?.centralManager?(central, didDisconnectPeripheral: peripheral, error: error)
  }

  #if !os(macOS)
    /**
     *  @method centralManager:connectionEventDidOccur:forPeripheral:
     *
     *  @param central      The central manager providing this information.
     *  @param event    The <code>CBConnectionEvent</code> that has occurred.
     *  @param peripheral   The <code>CBPeripheral</code> that caused the event.
     *
     *  @discussion         This method is invoked upon the connection or disconnection of a peripheral that matches any of the options provided in {@link registerForConnectionEventsWithOptions:}.
     *
     */
    func centralManager(_ central: CBCentralManager, connectionEventDidOccur event: CBConnectionEvent, for peripheral: CBPeripheral) {
      connectionEventDidOccurRealy.send((event, peripheral))
      forwardToDelegate?.centralManager?(central, connectionEventDidOccur: event, for: peripheral)
    }

    /**
     *  @method centralManager:didUpdateANCSAuthorizationForPeripheral:
     *
     *  @param central      The central manager providing this information.
     *  @param peripheral   The <code>CBPeripheral</code> that caused the event.
     *
     *  @discussion         This method is invoked when the authorization status changes for a peripheral connected with {@link connectPeripheral:} option {@link CBConnectPeripheralOptionRequiresANCS}.
     *
     */
    func centralManager(_ central: CBCentralManager, didUpdateANCSAuthorizationFor peripheral: CBPeripheral) {
      didUpdateANCSAuthorizationForPeripheralRelay.send(peripheral)
      forwardToDelegate?.centralManager?(central, didUpdateANCSAuthorizationFor: peripheral)
    }
  #endif
}
