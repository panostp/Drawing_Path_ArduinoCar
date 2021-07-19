# Drawing_Path_ArduinoCar
Control an Arduino based car, via Bluetooth with an app that allows you to draw its path.

A mobile app made with Flutter, allows the user to draw/create a path for the Car to follow.

After that, the user chooses a precision for the orders that will be sent to the Arduino via Bluetooth.

The precision <b>determines</b> the sample rate, thus making a high precision setting more time-consuming and vise versa for a low precision setting.

The app converts the samples to orders, that <b>must</b> be transmitted to the Arduino with accuracy so no packet is lost and all packets are ordered properly to avoid confusion.

Arduino stored the orders in 1D arrays so that they can be fetched and executed in order.
