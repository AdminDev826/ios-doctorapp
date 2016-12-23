//
//  CustomCustomComboBoxVCtr.swift
//  BeautyNotes
//
//  Created by Sagar on 12/18/15.
//  Copyright © 2015 Sagar R. Kothari. All rights reserved.
//

import UIKit

@objc public protocol SRKCustomComboBoxDelegate: NSObjectProtocol {

	func customComboBox(textField: SRKCustomComboBox, didSelect row: Int)
	func customComboBoxNumberOfRows(textField: SRKCustomComboBox) -> Int
	func customComboBoxHeightForRows(textField: SRKCustomComboBox) -> CGFloat
	func customComboBox(textField: SRKCustomComboBox, viewFor row: Int, reusingView view: UIView?) -> UIView

	func customComboBoxPresentingViewController(textField: SRKCustomComboBox) -> UIViewController
	func customComboBoxRectFromWhereToPresent(textField: SRKCustomComboBox) -> CGRect

	func customComboBoxFromBarButton(textField: SRKCustomComboBox) -> UIBarButtonItem?

	func customComboBoxTintColor(textField: SRKCustomComboBox) -> UIColor
	func customComboBoxToolbarColor(textField: SRKCustomComboBox) -> UIColor

	func customComboBoxDidTappedCancel(textField: SRKCustomComboBox)
	func customComboBoxDidTappedDone(textField: SRKCustomComboBox)
}

@objc public class SRKCustomComboBox: UITextField {
	public weak var delegateForComboBox: SRKCustomComboBoxDelegate?
	var objCustomComboBoxVCtr: CustomComboBoxVCtr?

	public func showOptions() {
		let podBundle = NSBundle(forClass: self.classForCoder)
		if let bundleURL = podBundle.URLForResource("SRKControls", withExtension: "bundle") {
			if let bundle = NSBundle(URL: bundleURL) {
				self.objCustomComboBoxVCtr = CustomComboBoxVCtr(nibName: "CustomComboBoxVCtr", bundle: bundle)
				self.objCustomComboBoxVCtr?.modalPresentationStyle = .Popover
				self.objCustomComboBoxVCtr?.popoverPresentationController?.delegate = self.objCustomComboBoxVCtr
				self.objCustomComboBoxVCtr?.refSRKCustomComboBox = self
				if let btn = self.delegateForComboBox?.customComboBoxFromBarButton(self) {
					self.objCustomComboBoxVCtr?.popoverPresentationController?.barButtonItem = btn
				} else {
					self.objCustomComboBoxVCtr?.popoverPresentationController?.sourceView = self.delegateForComboBox?.customComboBoxPresentingViewController(self).view
					self.objCustomComboBoxVCtr?.popoverPresentationController?.sourceRect = self.delegateForComboBox!.customComboBoxRectFromWhereToPresent(self)
				}
				self.delegateForComboBox?.customComboBoxPresentingViewController(self).presentViewController(self.objCustomComboBoxVCtr!, animated: true, completion: nil)
			} else {
				assertionFailure("Could not load the bundle")
			}
		} else {
			assertionFailure("Could not create a path to the bundle")
		}
	}

}

@objc public class CustomComboBoxVCtr: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UIPopoverPresentationControllerDelegate {

	@IBOutlet weak var pickerView: UIPickerView!
	@IBOutlet weak var toolBar: UIToolbar!
	weak var refSRKCustomComboBox: SRKCustomComboBox?

	override public func viewDidLoad() {
		super.viewDidLoad()
		self.preferredContentSize = CGSizeMake(320, 260)
		if let clr = self.refSRKCustomComboBox?.delegateForComboBox?.customComboBoxTintColor(self.refSRKCustomComboBox!) {
			self.toolBar.tintColor = clr
		}

		if let clr = self.refSRKCustomComboBox?.delegateForComboBox?.customComboBoxToolbarColor(self.refSRKCustomComboBox!) {
			self.toolBar.backgroundColor = clr
		}

		self.refSRKCustomComboBox!.delegateForComboBox?.customComboBox(self.refSRKCustomComboBox!, didSelect: 0)
	}

	override public func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}

	public func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		self.refSRKCustomComboBox!.delegateForComboBox?.customComboBox(self.refSRKCustomComboBox!, didSelect: row)
	}

	public func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return (self.refSRKCustomComboBox?.delegateForComboBox?.customComboBoxNumberOfRows(self.refSRKCustomComboBox!))!
	}

	public func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
		return (self.refSRKCustomComboBox?.delegateForComboBox?.customComboBoxHeightForRows(self.refSRKCustomComboBox!))!
	}

	public func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
		return (self.refSRKCustomComboBox!.delegateForComboBox?.customComboBox(self.refSRKCustomComboBox!, viewFor: row, reusingView: view))!
	}

	public func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
		return 1
	}

	@IBAction public func btnDoneTapped(sender: UIBarButtonItem) {
		self.refSRKCustomComboBox?.delegateForComboBox?.customComboBoxDidTappedDone(self.refSRKCustomComboBox!)
		self.dismissViewControllerAnimated(true, completion: nil)
	}

	@IBAction public func btnCancelTapped(sender: UIBarButtonItem) {
		self.refSRKCustomComboBox?.delegateForComboBox?.customComboBoxDidTappedCancel(self.refSRKCustomComboBox!)
		self.dismissViewControllerAnimated(true, completion: nil)
	}

	public func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
		return UIModalPresentationStyle.None
	}

}
