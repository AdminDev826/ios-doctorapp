# SRKControls

> Custom controls to turn UITextfields into item-selection with picker and date-selections.

[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/EZSwiftExtensions.svg)](https://img.shields.io/cocoapods/v/LFAlertController.svg)  

[![Platform](https://img.shields.io/cocoapods/p/LFAlertController.svg?style=flat)](http://cocoapods.org/pods/LFAlertController)

Using this library, one can convert `UITextfield` objects in-to a `combo-box-style-item-picker` or `date-time-picker`.
Check-out following screen-shots to understand behaviour and go through following list of features.

* Combo-box style picker
* Date-time picker
* Time picker
* Date picker
* Support for iPad & on iPad it will be shown as a pop-over

---

***Example Screenshot 1: Screen-shot indicates noraml textfields but with different class***

![Example Screen-shot 1](https://github.com/sag333ar/SRKControls/blob/master/ScreenShots/SRKControls%20with%20normal%20appearance.png?raw=true)

---

***Example Screenshot 2: Screen-shot indicates Combo-picker example***

![Example Screen-shot 2](https://github.com/sag333ar/SRKControls/blob/master/ScreenShots/SRKControls%20-%20SRKComboBox.png?raw=true)

---

***Example Screenshot 3: Screen-shot indicates Date-picker example***

![Example Screenshot 3](https://github.com/sag333ar/SRKControls/blob/master/ScreenShots/SRKControls%20-%20SRKDateTimeBox%20-%20Date%20Picker.png?raw=true)

---

***Example Screenshot 4: Screen-shot indicates time-picker example***

![Example Screenshot 4](https://github.com/sag333ar/SRKControls/blob/master/ScreenShots/SRKControls%20-%20SRKDateTimeBox%20-%20Time%20Picker.png?raw=true)

---

## Requirements

- iOS 7.0+
- Xcode 7.3

## Installation

***Step 1.*** `pod 'SRKControls', '~> 3.0.1'`

***Step 2.*** After above pod-line, add line `use_frameworks!`

***Step 3.*** `pod install`

## Usage example

***Step 1.*** Go to your `ViewController.swift` & `import SRKControls`

***Step 2.*** Go to your `ViewController.xib` or `Main.Storyboard`, drag & drop `UITextField` object on user-interface. Connect `delegate` of that textField-object.

***Step 3.*** Change textField-Object class to `SRKComboBox` or `SRKDateTimeBox` as per your need. Also have an `IBOutlet` Connection to your `ViewController`.

***Step 4.*** Add `UITextFieldDelegate`, `SRKComboBoxDelegate` and / or `SRKDateTimeBoxDelegate` as per your need.

***Step 5.*** Put following lines of code


```Swift

	// Some sample objects.
	@IBOutlet weak var myComboBox:SRKComboBox!
	@IBOutlet weak var myDateBox:SRKDateTimeBox!
	@IBOutlet weak var myTimeBox:SRKDateTimeBox!
	
	// Some sample array
	let arrayForComboBox = ["Sagar", "Sagar R. Kothari", "Kothari", "sag333ar", "sag333ar.github.io", "samurai", "jack", "cartoon", "network"]
	
	//MARK:- UITextFieldDelegate
	
	func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
		if let txt = textField as? SRKComboBox {
			txt.delegateForComboBox = self
			txt.showOptions()
			return false
		}
		if let txt = textField as? SRKDateTimeBox {
			txt.delegateForDateTimeBox = self
			txt.showOptions()
			return false
		}
		return true
	}

	//MARK:- SRKComboBoxDelegate
	
	func comboBox(textField:SRKComboBox, didSelectRow row:Int) {
		if textField == self.myComboBox {
			self.myComboBox.text = self.arrayForComboBox[row]
		}
	}
	
	func comboBoxNumberOfRows(textField:SRKComboBox) -> Int {
		if textField == self.myComboBox {
			return self.arrayForComboBox.count
		} else {
			return 0
		}
	}
	
	func comboBox(textField:SRKComboBox, textForRow row:Int) -> String {
		if textField == self.myComboBox {
			return self.arrayForComboBox[row]
		} else {
			return ""
		}
	}
	
	func comboBoxPresentingViewController(textField:SRKComboBox) -> UIViewController {
		return self
	}
	
	func comboBoxRectFromWhereToPresent(textField:SRKComboBox) -> CGRect {
		return textField.frame
	}
	
	func comboBoxFromBarButton(textField:SRKComboBox) -> UIBarButtonItem? {
		return nil
	}
	
	func comboBoxTintColor(textField:SRKComboBox) -> UIColor {
		return UIColor.blackColor()
	}
	
	func comboBoxToolbarColor(textField:SRKComboBox) -> UIColor {
		return UIColor.whiteColor()
	}
	
	func comboBoxDidTappedCancel(textField:SRKComboBox) {
		textField.text = ""
	}
	
	func comboBoxDidTappedDone(textField:SRKComboBox) {
		print("Let's do some action here")
	}
	
	//MARK:- SRKDateTimeBoxDelegate
	
	func dateTimeBox(textField:SRKDateTimeBox, didSelectDate date:NSDate) {
		let df = NSDateFormatter()
		if textField == self.myDateBox {
			df.dateFormat = "dd-MMM-yyyy"
			self.myDateBox.text = df.stringFromDate(date)
		} else if textField == self.myTimeBox {
			df.dateFormat = "HH:mm"
			self.myTimeBox.text = df.stringFromDate(date)
		}
	}
	
	func dateTimeBoxType(textField:SRKDateTimeBox) -> UIDatePickerMode {
		if textField == self.myDateBox {
			return UIDatePickerMode.Date
		} else if textField == self.myTimeBox {
			return UIDatePickerMode.Time
		} else {
			return UIDatePickerMode.Date
		}
	}
	
	func dateTimeBoxMinimumDate(textField:SRKDateTimeBox) -> NSDate? {
		return nil
	}
	
	func dateTimeBoxMaximumDate(textField:SRKDateTimeBox) -> NSDate? {
		return nil
	}
	
	func dateTimeBoxPresentingViewController(textField:SRKDateTimeBox) -> UIViewController {
		return self
	}
	
	func dateTimeBoxRectFromWhereToPresent(textField:SRKDateTimeBox) -> CGRect {
		return textField.frame
	}
	
	func dateTimeBoxFromBarButton(textField:SRKDateTimeBox) -> UIBarButtonItem? {
		return nil
	}
	
	func dateTimeBoxTintColor(textField:SRKDateTimeBox) -> UIColor {
		return UIColor.blackColor()
	}
	
	func dateTimeBoxToolbarColor(textField:SRKDateTimeBox) -> UIColor {
		return UIColor.whiteColor()
	}
	
	func dateTimeBoxDidTappedCancel(textField:SRKDateTimeBox) {
		textField.text = ""
	}
	
	func dateTimeBoxDidTappedDone(textField:SRKDateTimeBox) {
		print("Let's do some action here")
	}
```
