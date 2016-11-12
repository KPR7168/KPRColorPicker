KPRColorPicker
===========

KPRColorPicker is an easy to use color picker controller for iOS. RGB and hex value will be presented and update in real time.

![alt tag](https://github.com/KPR7168/KPRColorPicker/blob/master/Simulator%20Screen%20Shot%20Nov%2012%2C%202016%2C%202.40.15%20PM.png)

Features
------------
* Simple and easy to use
* Pre-selected color update in real time
* Return UIColor through delegate

Installation
------------
Drag folder "KPRColorPicker" to your project directory and done!

Usage
------------
To instantiate KPRColorPicker class and present the controller
```swift
let picker = KPRColorPicker.init()
picker.delegate = self
self.present(picker, animated: true, completion: nil)
```

To registered delegation listener
```
func KPRColorPickerDidSelectWithUIColor(sender: UIColor){
self.view.backgroundColor = sender
}
```

Delegate
------------

Use the delegate callbacks to receive selected color as UIColor

```swift
func KPRColorPickerDidSelectWithUIColor(sender: UIColor)
```

@ratanakKy
------------

Twitter: @ratanakKy
