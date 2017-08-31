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
LIBS:template-cache
LIBS:MK2-cache
EELAYER 25 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 6
Title "O'PAVES Mk-II"
Date ""
Rev "A"
Comp "AdaCore"
Comment1 "Licensed under CERN OHL v.1.2 or later"
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Sheet
S 1750 5300 1800 1800
U 5874F60A
F0 "Motor" 60
F1 "motor.sch" 60
F2 "VMOTOR" I L 1750 5750 60 
F3 "Encoder_A" O R 3550 5900 60 
F4 "Encoder_B" O R 3550 6050 60 
F5 "PWMA" I L 1750 6150 60 
F6 "IN1" I L 1750 6350 60 
F7 "IN2" I L 1750 6550 60 
F8 "Standby" I L 1750 6750 60 
F9 "VLOGIC" I L 1750 5600 60 
F10 "PWMB" I L 1750 6000 60 
$EndSheet
$Sheet
S 900  1700 1800 1800
U 5885EAE0
F0 "Power" 60
F1 "power.sch" 60
F2 "VBAT_SENSE" O R 2700 2850 60 
F3 "5V" O R 2700 2300 60 
F4 "3V3" O R 2700 2500 60 
F5 "VBAT" O R 2700 3050 60 
F6 "VMOTOR" O R 2700 3250 60 
$EndSheet
$Sheet
S 8200 600  1800 1800
U 5886C1BD
F0 "Sensors" 60
F1 "sensors.sch" 60
F2 "SCL" B L 8200 1050 60 
F3 "SDA" B L 8200 1250 60 
F4 "VCC" I L 8200 850 60 
F5 "Enable_FL" I L 8200 1450 60 
F6 "Enable_FC" I L 8200 1650 60 
F7 "Enable_FR" I L 8200 1850 60 
F8 "Enable_SR" I L 8200 2050 60 
F9 "Enable_BC" I L 8200 2250 60 
$EndSheet
Text Label 2900 2300 0    60   ~ 0
5V
Text Label 2900 2500 0    60   ~ 0
3V3
Text Label 4400 3000 0    60   ~ 0
3V3
Text Label 2900 3050 0    60   ~ 0
VBAT
Text Label 1350 5750 0    60   ~ 0
VMOTOR
Text Label 1450 5600 0    59   ~ 0
3V3
Text Label 7850 850  0    60   ~ 0
3V3
$Comp
L CONN_01X03 steering_servo1
U 1 1 588BDCC9
P 5850 7150
F 0 "steering_servo1" H 5900 7400 50  0000 C CNN
F 1 "MOLEX 22-28-4033" V 5950 7150 50  0001 C CNN
F 2 "Pin_Headers:Pin_Header_Straight_1x03" H 5850 7150 50  0001 C CNN
F 3 "" H 5850 7150 50  0000 C CNN
	1    5850 7150
	1    0    0    -1  
$EndComp
Text Label 5200 7150 0    60   ~ 0
5V
Text Label 5200 7250 0    60   ~ 0
Servo_PWM
Wire Wire Line
	4700 3000 4400 3000
Wire Wire Line
	2700 3050 2900 3050
Wire Wire Line
	2700 2300 4400 2300
Wire Wire Line
	2700 2500 2900 2500
Wire Wire Line
	1450 5600 1750 5600
Wire Wire Line
	8200 850  7850 850 
Wire Notes Line
	6900 6550 4500 6550
Wire Notes Line
	4500 6550 4500 7750
Wire Wire Line
	5200 7150 5650 7150
Text Notes 5150 6750 0    60   ~ 0
Steering Servo Motor
Wire Wire Line
	5650 7050 4950 7050
Wire Wire Line
	4950 7050 4950 7150
Wire Wire Line
	5200 7250 5650 7250
$Comp
L GND #PWR01
U 1 1 588C0CF5
P 4950 7150
F 0 "#PWR01" H 4950 6900 50  0001 C CNN
F 1 "GND" H 4950 7000 50  0000 C CNN
F 2 "" H 4950 7150 50  0000 C CNN
F 3 "" H 4950 7150 50  0000 C CNN
	1    4950 7150
	1    0    0    -1  
$EndComp
Wire Wire Line
	8200 4750 7850 4750
Wire Wire Line
	8200 4900 7850 4900
Text Label 7850 4750 0    60   ~ 0
5V
Text Label 7850 4900 0    60   ~ 0
3V3
Wire Wire Line
	6750 1050 8200 1050
Wire Wire Line
	6900 1250 8200 1250
Wire Wire Line
	1200 4200 4700 4200
Wire Wire Line
	1050 4050 4700 4050
Wire Wire Line
	900  3900 4700 3900
Wire Wire Line
	750  3750 4700 3750
Wire Wire Line
	6500 2650 6750 2650
Wire Wire Line
	6750 2650 6750 1050
Wire Wire Line
	6900 1250 6900 2800
Wire Wire Line
	6900 2800 6500 2800
Wire Wire Line
	6500 2950 7050 2950
Wire Wire Line
	7050 2950 7050 1450
Wire Wire Line
	7050 1450 8200 1450
Wire Wire Line
	8200 1650 7200 1650
Wire Wire Line
	7200 1650 7200 3100
Wire Wire Line
	7200 3100 6500 3100
Wire Wire Line
	7350 1850 8200 1850
Wire Wire Line
	7650 2250 7650 3550
Wire Wire Line
	7650 2250 8200 2250
Wire Wire Line
	7350 1850 7350 3250
Wire Wire Line
	7350 3250 6500 3250
Wire Wire Line
	6500 3400 7500 3400
Wire Wire Line
	7500 3400 7500 2050
Wire Wire Line
	7500 2050 8200 2050
Wire Wire Line
	7650 3550 6500 3550
Wire Wire Line
	3550 5900 3950 5900
Wire Wire Line
	750  3750 750  6750
Wire Wire Line
	750  6750 1750 6750
Wire Wire Line
	1200 4200 1200 6150
Wire Wire Line
	1050 4050 1050 6350
Wire Wire Line
	1050 6350 1750 6350
Wire Wire Line
	1200 6150 1750 6150
Wire Wire Line
	900  3900 900  6550
Wire Wire Line
	900  6550 1750 6550
Wire Wire Line
	4700 3250 3750 3250
Wire Wire Line
	3750 3250 3750 2850
Wire Wire Line
	3750 2850 2700 2850
Text Notes 600  850  0    60   ~ 0
TODO:\n\nDONE:\n
Wire Notes Line
	550  1350 3500 1350
Wire Notes Line
	3500 1350 3500 500 
Text Label 3950 4500 0    60   ~ 0
Servo_PWM
Text Notes 3550 850  0    60   ~ 0
Known Problems:\n\nFIxed:\n
Wire Notes Line
	3550 1350 6500 1350
Wire Notes Line
	6500 1350 6500 500 
Wire Wire Line
	2700 3250 2900 3250
Text Label 2900 3250 0    60   ~ 0
VMOTOR
Wire Wire Line
	3550 6050 4100 6050
$Sheet
S 8200 4600 1800 1800
U 58866A88
F0 "Interfaces" 60
F1 "interfaces.sch" 60
F2 "5V" I L 8200 4750 60 
F3 "3V3" I L 8200 4900 60 
$EndSheet
$Sheet
S 4700 2550 1800 2350
U 5885D1CF
F0 "microcontroller" 60
F1 "microcontroller.sch" 60
F2 "MCU_VCC" I L 4700 3000 60 
F3 "VBAT_SENSE" I L 4700 3250 60 
F4 "MCU_NRST" O R 6500 4200 60 
F5 "Distance_SCL" B R 6500 2650 60 
F6 "Distance_SDA" B R 6500 2800 60 
F7 "Encoder_A" I L 4700 4650 60 
F8 "Encoder_B" I L 4700 4800 60 
F9 "Motor_PWMA" O L 4700 4200 60 
F10 "Motor_IN1" O L 4700 4050 60 
F11 "Motor_IN2" O L 4700 3900 60 
F12 "Motor_Standby" O L 4700 3750 60 
F13 "Enable_FR" O R 6500 3250 60 
F14 "Enable_FC" O R 6500 3100 60 
F15 "Enable_FL" O R 6500 2950 60 
F16 "Enable_BC" O R 6500 3550 60 
F17 "Enable_SR" O R 6500 3400 60 
F18 "Steering_PWM" O L 4700 4500 60 
F19 "5V" I L 4700 2850 60 
F20 "Motor_PWMB" O L 4700 4350 60 
$EndSheet
Wire Wire Line
	4400 2300 4400 2850
Wire Wire Line
	4400 2850 4700 2850
Wire Wire Line
	3950 4500 4700 4500
Wire Wire Line
	4700 4650 3950 4650
Wire Wire Line
	3950 4650 3950 5900
Wire Wire Line
	4100 6050 4100 4800
Wire Wire Line
	4100 4800 4700 4800
Wire Wire Line
	1750 5750 1350 5750
Wire Wire Line
	1750 6000 1250 6000
Wire Wire Line
	1250 6000 1250 4350
Wire Wire Line
	1250 4350 4700 4350
$EndSCHEMATC
