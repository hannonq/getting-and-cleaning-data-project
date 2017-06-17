# 1. The Dataset
Detailed information about the original dataset can be found on the `.txt` files located in `/data/UCI HAR Dataset/` folder. 

This session will describe the variables of the `tidydata.txt` file.

* `Subject`: the ID of the subject
* `Activity`: R factors representing the activities of:
  * Walking
  * Walking upstairs
  * Walking downstairs
  * Sitting
  * Standing
  * Laying
 
Some of the original variables have been renamed to give descriptive names.

Variables containing the following patterns have been ranamed:

* `Acc` -> `Acceleration`
* `Gyro` -> `Gyroscope`
* `Mag` -> `Magnitude`
* `GyroJerk` -> `AngularAcceleration`

Variables starting with:

* `t` -> `Time`
* `f` -> `Frequency`

And variables containing the pattern `-std` have been ranamed to `StandardDeviation`