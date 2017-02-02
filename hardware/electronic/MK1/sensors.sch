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
LIBS:stm32
LIBS:battery_management
LIBS:logo
LIBS:motor_drivers
LIBS:nordicsemi
LIBS:nxp_armmcu
LIBS:powerint
LIBS:Power_Management
LIBS:references
LIBS:silabs
LIBS:stm8
LIBS:switches
LIBS:transf
LIBS:video
LIBS:Worldsemi
LIBS:Xicor
LIBS:Zilog
LIBS:MK1-cache
EELAYER 25 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 6 7
Title "O'PAVES Mk-I"
Date ""
Rev "A"
Comp "AdaCore"
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L Pololu_VL53l0X_Carrier distance_front_center1
U 1 1 5886C498
P 1750 3400
F 0 "distance_front_center1" H 2200 3450 60  0000 C CNN
F 1 "Pololu_VL53l0X_Carrier + 3M 929870-01-07-RA" H 2300 3300 60  0000 C CNN
F 2 "OPAVES_Footprints:Pololu_VL53L0x_Carrier" H 1750 3350 60  0001 C CNN
F 3 "" H 1750 3350 60  0001 C CNN
	1    1750 3400
	1    0    0    -1  
$EndComp
$Comp
L Pololu_VL53l0X_Carrier distance_front_right1
U 1 1 5886C802
P 1750 5150
F 0 "distance_front_right1" H 2200 5200 60  0000 C CNN
F 1 "Pololu_VL53l0X_Carrier + 3M 929870-01-07-RA" H 2300 5050 60  0000 C CNN
F 2 "OPAVES_Footprints:Pololu_VL53L0x_Carrier" H 1750 5100 60  0001 C CNN
F 3 "" H 1750 5100 60  0001 C CNN
	1    1750 5150
	1    0    0    -1  
$EndComp
$Comp
L Pololu_VL53l0X_Carrier distance_front_left1
U 1 1 5886C83E
P 1750 1700
F 0 "distance_front_left1" H 2200 1750 60  0000 C CNN
F 1 "Pololu_VL53l0X_Carrier + 3M 929870-01-07-RA" H 2300 1600 60  0000 C CNN
F 2 "OPAVES_Footprints:Pololu_VL53L0x_Carrier" H 1750 1650 60  0001 C CNN
F 3 "" H 1750 1650 60  0001 C CNN
	1    1750 1700
	1    0    0    -1  
$EndComp
$Comp
L Pololu_VL53l0X_Carrier distance_back_center1
U 1 1 5886C9A2
P 9300 3100
F 0 "distance_back_center1" H 9750 3150 60  0000 C CNN
F 1 "Pololu_VL53l0X_Carrier + 3M 929870-01-07-RA" H 9850 3000 60  0000 C CNN
F 2 "OPAVES_Footprints:Pololu_VL53L0x_Carrier" H 9300 3050 60  0001 C CNN
F 3 "" H 9300 3050 60  0001 C CNN
	1    9300 3100
	1    0    0    -1  
$EndComp
$Comp
L Pololu_VL53l0X_Carrier distance_side_right1
U 1 1 5886C9C5
P 6500 1650
F 0 "distance_side_right1" H 6950 1700 60  0000 C CNN
F 1 "Pololu_VL53l0X_Carrier + 3M 929870-01-07-RA" H 7050 1550 60  0000 C CNN
F 2 "OPAVES_Footprints:Pololu_VL53L0x_Carrier" H 6500 1600 60  0001 C CNN
F 3 "" H 6500 1600 60  0001 C CNN
	1    6500 1650
	1    0    0    -1  
$EndComp
Text HLabel 1550 2150 0    60   Input ~ 0
VCC
Text HLabel 1550 3850 0    60   Input ~ 0
VCC
Text HLabel 1550 5600 0    60   Input ~ 0
VCC
Text HLabel 6300 2100 0    60   Input ~ 0
VCC
Text HLabel 9100 3550 0    60   Input ~ 0
VCC
NoConn ~ 9100 3350
NoConn ~ 6300 1900
NoConn ~ 1550 1950
NoConn ~ 1550 3650
NoConn ~ 1550 5400
NoConn ~ 1550 4850
NoConn ~ 1550 6600
NoConn ~ 1550 3150
NoConn ~ 6300 3100
NoConn ~ 9100 4550
Text HLabel 1550 6000 0    60   Input ~ 0
SDA
Text HLabel 1550 6200 0    60   Input ~ 0
SCL
Wire Wire Line
	1550 5800 1050 5800
Wire Wire Line
	1050 5800 1050 5850
$Comp
L GND #PWR025
U 1 1 588B46A8
P 1050 5850
F 0 "#PWR025" H 1050 5600 50  0001 C CNN
F 1 "GND" H 1050 5700 50  0000 C CNN
F 2 "" H 1050 5850 50  0000 C CNN
F 3 "" H 1050 5850 50  0000 C CNN
	1    1050 5850
	1    0    0    -1  
$EndComp
Text HLabel 1550 4250 0    60   Input ~ 0
SDA
Text HLabel 1550 4450 0    60   Input ~ 0
SCL
Wire Wire Line
	1550 4050 1050 4050
Wire Wire Line
	1050 4050 1050 4100
$Comp
L GND #PWR026
U 1 1 588B4727
P 1050 4100
F 0 "#PWR026" H 1050 3850 50  0001 C CNN
F 1 "GND" H 1050 3950 50  0000 C CNN
F 2 "" H 1050 4100 50  0000 C CNN
F 3 "" H 1050 4100 50  0000 C CNN
	1    1050 4100
	1    0    0    -1  
$EndComp
Text HLabel 1550 2550 0    60   Input ~ 0
SDA
Text HLabel 1550 2750 0    60   Input ~ 0
SCL
Wire Wire Line
	1550 2350 1050 2350
Wire Wire Line
	1050 2350 1050 2400
$Comp
L GND #PWR027
U 1 1 588B479C
P 1050 2400
F 0 "#PWR027" H 1050 2150 50  0001 C CNN
F 1 "GND" H 1050 2250 50  0000 C CNN
F 2 "" H 1050 2400 50  0000 C CNN
F 3 "" H 1050 2400 50  0000 C CNN
	1    1050 2400
	1    0    0    -1  
$EndComp
Text HLabel 6300 2500 0    60   Input ~ 0
SDA
Text HLabel 6300 2700 0    60   Input ~ 0
SCL
Wire Wire Line
	6300 2300 5800 2300
Wire Wire Line
	5800 2300 5800 2350
$Comp
L GND #PWR028
U 1 1 588B483E
P 5800 2350
F 0 "#PWR028" H 5800 2100 50  0001 C CNN
F 1 "GND" H 5800 2200 50  0000 C CNN
F 2 "" H 5800 2350 50  0000 C CNN
F 3 "" H 5800 2350 50  0000 C CNN
	1    5800 2350
	1    0    0    -1  
$EndComp
Text HLabel 9100 3950 0    60   Input ~ 0
SDA
Text HLabel 9100 4150 0    60   Input ~ 0
SCL
Wire Wire Line
	9100 3750 8600 3750
Wire Wire Line
	8600 3750 8600 3800
$Comp
L GND #PWR029
U 1 1 588B4912
P 8600 3800
F 0 "#PWR029" H 8600 3550 50  0001 C CNN
F 1 "GND" H 8600 3650 50  0000 C CNN
F 2 "" H 8600 3800 50  0000 C CNN
F 3 "" H 8600 3800 50  0000 C CNN
	1    8600 3800
	1    0    0    -1  
$EndComp
Text HLabel 1550 2950 0    60   Input ~ 0
Enable_FL
Text HLabel 1550 4650 0    60   Input ~ 0
Enable_FC
Text HLabel 1550 6400 0    60   Input ~ 0
Enable_FR
Text HLabel 6300 2900 0    60   Input ~ 0
Enable_SR
Text HLabel 9100 4350 0    60   Input ~ 0
Enable_BC
Text Notes 4400 950  0    236  ~ 0
Distance sensors
$EndSCHEMATC
