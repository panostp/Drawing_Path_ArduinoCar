# Drawing_Path_ArduinoCar
<b>About the Software</b><br><br>
Control an Arduino based car, via Bluetooth with an app that allows you to draw its path.<br>
A mobile app made with Flutter, allows the user to draw/create a path for the Car to follow.<br>
After that, the user chooses a precision for the orders that will be sent to the Arduino via Bluetooth.<br>
The precision <i>determines</i> the sample rate, thus making a high precision setting more time-consuming (computation and execution) and vise versa for a low precision setting.<br>
The app converts the samples to orders, that <i>must</i> be transmitted to the Arduino with accuracy so no packet is lost and all packets are ordered properly to avoid confusion.<br>
Arduino stored the orders in 1D arrays so that they can be fetched and executed in order.<br><br>
<b>About the Hardware</b><br><br>
<ul>
  <li>Power Source</li>
  Alkaline Batteries 9V. Although, LiPo or Li-Ion Batteries would perform better in such practices, due to their superior energy density.
  <li>Motor Driver Shield L293D</li>
  <li>Arduino UNO</li>
  <li>Movement</li>
  4 DC Motors and Tires
  <ul>
    <li>Reduction Ratio= 1:48</li>
    <li>Vin = 3V ~ 6V</li>
    <li>6V, ≤200mA, 200± 10%RPM</li>
    <li>5V, ≤183.5mA, 163.5± 10%RPM</li>
    <li>3V, ≤150mA, 90± 10% RPM</li>
  </ul>
</ul>
