EESchema Schematic File Version 2
LIBS:power
LIBS:device
LIBS:transistors
LIBS:conn
LIBS:linear
LIBS:regul
LIBS:74xx
LIBS:cmos4000
LIBS:adc-dac
LIBS:memory
LIBS:xilinx
LIBS:microcontrollers
LIBS:dsp
LIBS:microchip
LIBS:analog_switches
LIBS:motorola
LIBS:texas
LIBS:intel
LIBS:audio
LIBS:interface
LIBS:digital-audio
LIBS:philips
LIBS:display
LIBS:cypress
LIBS:siliconi
LIBS:opto
LIBS:atmel
LIBS:contrib
LIBS:valves
LIBS:OPAVES_components
LIBS:74xgxx
LIBS:ac-dc
LIBS:actel
LIBS:Altera
LIBS:analog_devices
LIBS:battery_management
LIBS:bbd
LIBS:brooktre
LIBS:cmos_ieee
LIBS:dc-dc
LIBS:diode
LIBS:elec-unifil
LIBS:ESD_Protection
LIBS:ftdi
LIBS:gennum
LIBS:graphic
LIBS:hc11
LIBS:ir
LIBS:Lattice
LIBS:logo
LIBS:maxim
LIBS:microchip_dspic33dsc
LIBS:microchip_pic10mcu
LIBS:microchip_pic12mcu
LIBS:microchip_pic16mcu
LIBS:microchip_pic18mcu
LIBS:microchip_pic32mcu
LIBS:motor_drivers
LIBS:msp430
LIBS:nordicsemi
LIBS:nxp_armmcu
LIBS:onsemi
LIBS:Oscillators
LIBS:powerint
LIBS:Power_Management
LIBS:pspice
LIBS:references
LIBS:relays
LIBS:rfcom
LIBS:sensors
LIBS:silabs
LIBS:stm8
LIBS:stm32
LIBS:supertex
LIBS:switches
LIBS:transf
LIBS:ttl_ieee
LIBS:video
LIBS:Worldsemi
LIBS:Xicor
LIBS:Zilog
LIBS:encoder-cache
EELAYER 25 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 1
Title "O'PAVES - Encoders for TAMIYA High Speed Gearbox"
Date ""
Rev "A"
Comp "AdaCore"
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L Digital_Latch_Hall_Effect_Sensor SOT-23-A1
U 1 1 58889495
P 3350 1250
F 0 "SOT-23-A1" H 3400 1300 60  0000 C CNN
F 1 "Digital_Latch_Hall_Effect_Sensor" H 4100 1150 60  0000 C CNN
F 2 "TO_SOT_Packages_SMD:SOT-23" H 3350 1250 60  0001 C CNN
F 3 "" H 3350 1250 60  0001 C CNN
	1    3350 1250
	1    0    0    -1  
$EndComp
$Comp
L Digital_Latch_Hall_Effect_Sensor SOT-23-B1
U 1 1 5888965D
P 3350 2450
F 0 "SOT-23-B1" H 3400 2500 60  0000 C CNN
F 1 "Digital_Latch_Hall_Effect_Sensor" H 4100 2350 60  0000 C CNN
F 2 "TO_SOT_Packages_SMD:SOT-23" H 3350 2450 60  0001 C CNN
F 3 "" H 3350 2450 60  0001 C CNN
	1    3350 2450
	1    0    0    -1  
$EndComp
$Comp
L R R1
U 1 1 58889A60
P 6800 4400
F 0 "R1" V 6880 4400 50  0000 C CNN
F 1 "10k" V 6800 4400 50  0000 C CNN
F 2 "Resistors_SMD:R_0805" V 6730 4400 50  0001 C CNN
F 3 "" H 6800 4400 50  0000 C CNN
	1    6800 4400
	1    0    0    -1  
$EndComp
$Comp
L C C1
U 1 1 58889BB0
P 4150 4450
F 0 "C1" H 4175 4550 50  0000 L CNN
F 1 "C" H 4175 4350 50  0000 L CNN
F 2 "Capacitors_SMD:C_0805" H 4188 4300 50  0001 C CNN
F 3 "" H 4150 4450 50  0000 C CNN
	1    4150 4450
	1    0    0    -1  
$EndComp
Text GLabel 2800 1300 1    60   Input ~ 0
VCC
$Comp
L R R2
U 1 1 58889F12
P 6400 4400
F 0 "R2" V 6480 4400 50  0000 C CNN
F 1 "10k" V 6400 4400 50  0000 C CNN
F 2 "Resistors_SMD:R_0805" V 6330 4400 50  0001 C CNN
F 3 "" H 6400 4400 50  0000 C CNN
	1    6400 4400
	1    0    0    -1  
$EndComp
Text GLabel 2800 2500 1    60   Input ~ 0
VCC
Text GLabel 6950 1300 1    60   Input ~ 0
VCC
Text GLabel 6950 2500 1    60   Input ~ 0
VCC
$Comp
L GND #PWR01
U 1 1 5888A135
P 3100 2000
F 0 "#PWR01" H 3100 1750 50  0001 C CNN
F 1 "GND" H 3100 1850 50  0000 C CNN
F 2 "" H 3100 2000 50  0000 C CNN
F 3 "" H 3100 2000 50  0000 C CNN
	1    3100 2000
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR02
U 1 1 5888A1D7
P 3100 3200
F 0 "#PWR02" H 3100 2950 50  0001 C CNN
F 1 "GND" H 3100 3050 50  0000 C CNN
F 2 "" H 3100 3200 50  0000 C CNN
F 3 "" H 3100 3200 50  0000 C CNN
	1    3100 3200
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR03
U 1 1 5888A1FD
P 6950 3250
F 0 "#PWR03" H 6950 3000 50  0001 C CNN
F 1 "GND" H 6950 3100 50  0000 C CNN
F 2 "" H 6950 3250 50  0000 C CNN
F 3 "" H 6950 3250 50  0000 C CNN
	1    6950 3250
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR04
U 1 1 5888A27D
P 6950 2000
F 0 "#PWR04" H 6950 1750 50  0001 C CNN
F 1 "GND" H 6950 1850 50  0000 C CNN
F 2 "" H 6950 2000 50  0000 C CNN
F 3 "" H 6950 2000 50  0000 C CNN
	1    6950 2000
	1    0    0    -1  
$EndComp
$Comp
L CONN_01X04 P1
U 1 1 5888A684
P 4950 4450
F 0 "P1" H 4950 4700 50  0000 C CNN
F 1 "CONN_01X04" V 5050 4450 50  0000 C CNN
F 2 "Pin_Headers:Pin_Header_Straight_1x04" H 4950 4450 50  0001 C CNN
F 3 "" H 4950 4450 50  0000 C CNN
	1    4950 4450
	1    0    0    -1  
$EndComp
Text GLabel 4150 4300 1    60   Input ~ 0
VCC
$Comp
L GND #PWR05
U 1 1 5888A8C2
P 4150 4600
F 0 "#PWR05" H 4150 4350 50  0001 C CNN
F 1 "GND" H 4150 4450 50  0000 C CNN
F 2 "" H 4150 4600 50  0000 C CNN
F 3 "" H 4150 4600 50  0000 C CNN
	1    4150 4600
	1    0    0    -1  
$EndComp
Wire Wire Line
	2800 1550 3150 1550
Wire Wire Line
	2800 1300 2800 1550
Wire Wire Line
	2800 2500 2800 2750
Wire Wire Line
	6950 1550 7300 1550
Wire Wire Line
	6950 1300 6950 1550
Wire Wire Line
	6950 2750 7300 2750
Wire Wire Line
	6950 2500 6950 2750
Wire Wire Line
	3150 1950 3100 1950
Wire Wire Line
	3100 1950 3100 2000
Wire Wire Line
	3150 3150 3100 3150
Wire Wire Line
	3100 3150 3100 3200
Wire Wire Line
	4750 4300 4150 4300
Wire Wire Line
	4750 4400 4400 4400
Wire Wire Line
	4400 4400 4400 4600
Wire Wire Line
	4400 4600 4150 4600
Text GLabel 4750 4500 0    60   Input ~ 0
A
Text GLabel 4750 4600 0    60   Input ~ 0
B
Text GLabel 3050 1750 0    60   Input ~ 0
A
Text GLabel 3050 2950 0    60   Input ~ 0
B
Text GLabel 7200 1950 0    60   Input ~ 0
A
Text GLabel 7200 3150 0    60   Input ~ 0
B
Text Notes 4300 900  0    60   ~ 0
We have two versions of the same circuit here. The reason is that we\n want to be able to try the SOT-23 and TO-92 packages and see\n which one works best.
Wire Wire Line
	2800 2750 3150 2750
Wire Wire Line
	3150 2950 3050 2950
Wire Wire Line
	6800 4250 6400 4250
Wire Wire Line
	6600 4250 6600 4100
Connection ~ 6600 4250
Text GLabel 6600 4100 1    60   Input ~ 0
VCC
Wire Wire Line
	3050 1750 3150 1750
Text GLabel 6400 4700 3    60   Input ~ 0
A
Text GLabel 6800 4700 3    60   Input ~ 0
B
Wire Wire Line
	6800 4700 6800 4550
Wire Wire Line
	6400 4700 6400 4550
$Comp
L CIRCLE2 Mounting_Hole1
U 1 1 5888CC1C
P 9150 4450
F 0 "Mounting_Hole1" H 9200 4500 50  0001 C CNN
F 1 "Mounting_Hole1" H 9150 4350 50  0000 C CNN
F 2 "Mounting_Holes:MountingHole_6.4mm_M6_DIN965" H 9150 4450 60  0001 C CNN
F 3 "" H 9150 4450 60  0001 C CNN
	1    9150 4450
	1    0    0    -1  
$EndComp
$Comp
L CIRCLE2 Mounting_Hole2
U 1 1 5888CCF6
P 9150 5150
F 0 "Mounting_Hole2" H 9200 5200 50  0001 C CNN
F 1 "Mounting_Hole2" H 9150 5050 50  0000 C CNN
F 2 "Mounting_Holes:MountingHole_6.4mm_M6_DIN965" H 9150 5150 60  0001 C CNN
F 3 "" H 9150 5150 60  0001 C CNN
	1    9150 5150
	1    0    0    -1  
$EndComp
$Comp
L Digital_Latch_Hall_Effect_Sensor_TO-92 TO-92-A1
U 1 1 5888CFCF
P 7500 1250
F 0 "TO-92-A1" H 7550 1300 60  0000 C CNN
F 1 "Digital_Latch_Hall_Effect_Sensor_TO-92" H 8250 1150 60  0000 C CNN
F 2 "TO_SOT_Packages_THT:TO-92_Inline_Wide" H 7500 1250 60  0001 C CNN
F 3 "" H 7500 1250 60  0001 C CNN
	1    7500 1250
	1    0    0    -1  
$EndComp
$Comp
L Digital_Latch_Hall_Effect_Sensor_TO-92 TO-92-B1
U 1 1 5888D106
P 7500 2450
F 0 "TO-92-B1" H 7550 2500 60  0000 C CNN
F 1 "Digital_Latch_Hall_Effect_Sensor_TO-92" H 8250 2350 60  0000 C CNN
F 2 "TO_SOT_Packages_THT:TO-92_Inline_Wide" H 7500 2450 60  0001 C CNN
F 3 "" H 7500 2450 60  0001 C CNN
	1    7500 2450
	1    0    0    -1  
$EndComp
Wire Wire Line
	7200 3150 7300 3150
Wire Wire Line
	7300 2950 6950 2950
Wire Wire Line
	6950 2950 6950 3250
Wire Wire Line
	6950 2000 6950 1750
Wire Wire Line
	6950 1750 7300 1750
Wire Wire Line
	7200 1950 7300 1950
Text Notes 600  7450 0    157  ~ 0
Known problems:\n - SMD hall effect sensors are not close \n    enough to the magnet to work\n - B sensor GND is not connected to common GND\n - Too much noise from the motor
Wire Notes Line
	500  6100 6950 6100
Wire Notes Line
	6950 6100 6950 6550
$EndSCHEMATC
