# O'PAVES build instructions

## 3D printing

Many of O'PAVES' parts can be 3D printed. The settings and instructions
described below are for the Taz Mini 3D printer from Lulzbot with the optional
Flexystruder to print flexible material like NinjaFlex. The O'PAVES part can
be printed with a different machine, but in that case the settings and
procedure will be different.

### Solid parts (PLA)

They are printed with the Taz Mini stock extruder in the standard quickprint
profile using eSUN PLA material.

Here is the list of parts to print:
 - hardware/3D_models/for_printing/
   - front_hub_left.stl
   - front_hub_right.stl
   - front_bom_mounting_block.stl  (2 times)
   - lower_front_bom.stl
   - upper_front_bom.stl
   - steering_linkage.stl
   - rear_wheel_mount_dual_motor_1.stl (2 times)
   - rear_wheel_mount_dual_motor_2.stl (2 times)
   - rim.stl (4 times)

As shown below, all the parts can be printed at the same time on the Taz Mini:
![](doc/media/OPAVES_Lulzbot_mini.png)

### Flexible parts (NinjaFlex)

Only the 4 tires of O'PAVES are printed using the Flexystruder head and black
NinjaFlex material. The 3D model is the same for all tire:
`hardware/3D_models/for_printing/tire.stl`. We recommend to print only one tire
at a time to avoid bump and print artifacts on the surface, as shown in the
picture below:

## PCB manufacturing

The O'PAVES PCB can be manufactured from online services like 
[OSHpark](https://oshpark.com/) or
[SeeedFusion](https://www.seeedstudio.com/fusion_pcb.html).

The required characteristic of the board are:
 - 2 Layers
 - 1.6 mm thickness
 - Copper Weigh: 1oz.

You can find the GERBER files here:
[hardware/electronic/MK2/rev_A/mk2_rev_A_gerber.zip](hardware/electronic/MK2/rev_A/mk2_rev_A_gerber.zip)

## Bill of Material

Here is the list of components required for the O'PAVES car (in addition to the
3d printed parts and the circuit board):
 - Tamiya 70168 Double Gearbox Kit (Pololu #114)
 - Pololu 5V step-up/step-down (Pololu #2123)
 - Pololu 3.3V step-up/step-down (Pololu #2122)
 - 5x VL53L0X Time-of-Flight Distance Sensor (Pololu #2490)
 - Machine screws:
   - M3 6mm (25 pack) (pololu #2694)
   - M3 16mm (25 pack) (pololu #1077)
   - M3 25mm (25 pack) (pololu #1077)
 - DS65HB Digital Servo (pololu #1051)
 - Tamiya 3mm Threaded Shaft Set (pololu #733)
 - B6612FNG Dual Motor Driver Carrier (pololu #713)
 - MCP23008 8-bit IO expander 

## Car assembly

### PCB assembly

1. Solder the front distance sensors sockets and 3-pin servo header.
![](doc/media/build_pictures/build_picture_04.jpg)
1. Solder the master switch and the 3-pin battery connector.
![](doc/media/build_pictures/build_picture_05.jpg)
1. Solder the 5V and 3.3V step-up/step-down voltage regulator.
![](doc/media/build_pictures/build_picture_06.jpg)
1. Solder the Crazyflie 2.0 expansion headers.
![](doc/media/build_pictures/build_picture_07.jpg)
1. Solder the MCP23008 I/O expander and the 4-pin UART header.
![](doc/media/build_pictures/build_picture_08.jpg)
1. Solder two wires from the left motor to the PCB.
1. Solder two wires from the right motor to the PCB.

### Distance sensors
1. Solder the angled header pins to the sensor.
![](doc/media/build_pictures/build_picture_00.jpg)

1. Plug the senors on the headers.
![](doc/media/build_pictures/build_picture_03.jpg)

### Steering block
For the steering block, you will need the following 3D printed parts:
 - 1 front_hub_left
 - 1 front_hub_right
 - 2 front_bom_mounting_block
 - 1 lower_front_bom
 - 1 upper_front_bom
 - 1 steering_linkage
 - 2 rims
 - 2 tires
and the following off the shelf parts:
 - DS65HB Digital Servo 
 - 10 M3 x 6mm screws
 - 2 M3 nuts
 - 2 M3 x 25mm screws
 - a paper clip
 - some super glue

#### Instructions:

1. Take the two `front_bom_mounting_block`, the servo and the two small screws
provided with the servo.
![](doc/media/build_pictures/build_picture_20.jpg)

1. Screw the servo on the two `front_bom_mounting_block`.
![](doc/media/build_pictures/build_picture_21.jpg)

1. With two M3 x 6mm screws, attach the `upper_front_bom` to the two
`front_bom_mounting_block`. Make sure the sticker on the servo is facing up.
![](doc/media/build_pictures/build_picture_22.jpg)

1. Take the `front_hub_left` and `front_hub_right`, insert an M3 x 25mm screw in
each of them and secure it with an M3 nut. You can also add some super glue to
make sure the screw will not undo.
![](doc/media/build_pictures/build_picture_23.jpg)

1. Attach the two front hubs to the `upper_front_bom` with two M3 x 6mm screws.
Don't tighten the screws all the way, the hubs should be able to move freely.
![](doc/media/build_pictures/build_picture_24.jpg)

1. Attach the `steering_linkage` to the front hubs with two M3 x 6mm screws. Make
sure that the small hole in the `steering_linkage` is closer to the left hub.
Again, the parts should be able to move freely.
![](doc/media/build_pictures/build_picture_25.jpg)

1. Return the steering block and place on top of it the PCB face down.

![](doc/media/build_pictures/build_picture_26.jpg)

1. With two (or four) M3 x 6mm screws, attach the `lower_front_bom` to the
`front_bom_mounting_blocks` through the PCB.
![](doc/media/build_pictures/build_picture_27.jpg)

1. Attach the `lower_front_bom` to the two font hubs with two M3 x 6mm screws.
Again, do not tighten all the way, the hubs should be able to move freely.
![](doc/media/build_pictures/build_picture_28.jpg)

1. Take the paper clip, cut it and bend it according to this shape.
![](doc/media/build_pictures/build_picture_31.jpg)

1. Take the long servo arm and insert the paper clip in the last hole.
![](doc/media/build_pictures/build_picture_32.jpg)

1. Insert the other end of the paper clip in the small hole on the
`steering_linkage`.
![](doc/media/build_pictures/build_picture_33.jpg)

1. Press the servo arm on the servo shaft.
![](doc/media/build_pictures/build_picture_34.jpg)

1. Connect the servo lead to the servo header. Be careful with the polarity.
Fold the extra cable lenght between the header and the servo, under the
upper_front_bom.
![](doc/media/build_pictures/build_picture_37.jpg)

1. Secure the two tires with M3 lock nuts.
![](doc/media/build_pictures/build_picture_36.jpg)

1. Your steering block should look like this:
![](doc/media/build_pictures/build_picture_38.jpg)

### Motor block
For the motor block, you will need the following 3D printed parts:
 - 2 rear_wheel_mount_dual_motor_1
 - 2 rear_wheel_mount_dual_motor_2 
 - 2 rims
 - 2 tires
and the following off the shelf parts:
 - Tamiya 70168 Double Gearbox Kit 
 - Tamiya 3mm Threaded Shaft Set
 - 4 M3 lock nuts
 - 2 M3 standard nuts
 - 2 M3 x 16mm screws
 - 6 M3 x 6mm screws
 - Some super glue

#### Instructions:

1. Take one 3 mm threaded shaft from the Tamiya 3mm Threaded Shaft Set, and cut
it to make two 45 mm long rods.

1. Follow the assembly instructions of the Tamiya Twin-Motor Gearbox (A type,
standard speed), but replace the two hexagonal shafts with the two halves of
the threaded shaft.

1. Take a M3 lock nut and insert it in one of the `rear_wheel_mount_dual_motor_1`.
![](doc/media/build_pictures/build_picture_09.jpg)

1. Screw the `rear_wheel_mount_dual_motor_1` with lock nut on one of the motor
threaded shaft.
![](doc/media/build_pictures/build_picture_11.jpg)

1. Screw it until the lock nut is 1 mm from the motor block.
![](doc/media/build_pictures/build_picture_12.jpg)

1. Secure the `rear_wheel_mount_dual_motor_1` with an M3 nut.
![](doc/media/build_pictures/build_picture_13.jpg)

1. Insert an M3 x 16mm screw in one of the `rear_wheel_mount_dual_motor_2` and
secure it with a little bit of super glue.
![](doc/media/build_pictures/build_picture_14.jpg)
![](doc/media/build_pictures/build_picture_15.jpg)

1. Attach the `rear_wheel_mount_dual_motor_2` to the
`rear_wheel_mount_dual_motor_1` with three M3 x 6mm screws.
![](doc/media/build_pictures/build_picture_16.jpg)

1. Repeat the from step 3 on the other side of the motor.
![](doc/media/build_pictures/build_picture_18.jpg)

1. Secure the motor block to the PCB using two M3 x 6mm screws and two M3 nuts.
The motor block should be on top of the PCB, where you can see the O'PAVES
logo.
![](doc/media/build_pictures/build_picture_17.jpg)

1. Install and secure the two wheels with two M3 lock nuts.
![](doc/media/build_pictures/build_picture_19.jpg)

1. The motor block is ready.

### Crazyflie 2.0

1. Remove the 4 motors and motor mounts from the Crazyflie 2.0 and unplug the
connectors.

1. Plug the Crazyflie 2.0 on the O'PAVES board following the orientation
drawings.
![](doc/media/build_pictures/build_picture_39.jpg)

### Programming the micro-controller

Please follow the [instructions](https://github.com/AdaCore/Certyflie#flashing-the-firmware)
provided in the Certyflie project.

### Final Step

Secure the battery on the PCB using tape or zip ties. Plug the battery
connector on the battery header. Be careful with the polarity

Your O'PAVES car is ready!
