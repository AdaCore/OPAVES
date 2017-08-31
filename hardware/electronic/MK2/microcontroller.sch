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
$Descr A3 16535 11693
encoding utf-8
Sheet 6 6
Title "O'PAVES Mk-II"
Date ""
Rev "A"
Comp "AdaCore"
Comment1 "Licensed under CERN OHL v.1.2 or later"
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
Text HLabel 8450 4750 2    60   Input ~ 0
MCU_VCC
Text HLabel 8450 4150 2    60   Input ~ 0
VBAT_SENSE
Wire Notes Line
	550  8950 11800 8950
Wire Notes Line
	3650 8950 3650 11200
Wire Notes Line
	7950 8950 7950 11200
Text HLabel 5950 4250 2    60   Input ~ 0
Distance_SCL
Text HLabel 5950 4150 2    60   Input ~ 0
Distance_SDA
Wire Notes Line
	11800 8950 11800 9950
Text Notes 10100 9250 0    118  ~ 0
Pull-UPs
$Comp
L R R11
U 1 1 5891BCC4
P 10350 10300
F 0 "R11" V 10430 10300 50  0000 C CNN
F 1 "10k" V 10350 10300 50  0000 C CNN
F 2 "Resistors_SMD:R_0805" V 10280 10300 50  0001 C CNN
F 3 "" H 10350 10300 50  0000 C CNN
	1    10350 10300
	1    0    0    -1  
$EndComp
$Comp
L R R12
U 1 1 5891BCCA
P 10650 10300
F 0 "R12" V 10730 10300 50  0000 C CNN
F 1 "10k" V 10650 10300 50  0000 C CNN
F 2 "Resistors_SMD:R_0805" V 10580 10300 50  0001 C CNN
F 3 "" H 10650 10300 50  0000 C CNN
	1    10650 10300
	1    0    0    -1  
$EndComp
Wire Wire Line
	10350 10150 10650 10150
Wire Wire Line
	10500 10150 10500 9950
Connection ~ 10500 10150
Text HLabel 10500 9950 1    60   Input ~ 0
MCU_VCC
Text HLabel 10350 10450 3    60   Input ~ 0
Distance_SCL
Text HLabel 10650 10450 3    60   Input ~ 0
Distance_SDA
Text HLabel 5950 4650 2    60   Input ~ 0
Encoder_A
Text HLabel 8450 4250 2    60   Input ~ 0
Encoder_B
Text HLabel 8450 3850 2    60   Input ~ 0
Motor_PWMA
Text HLabel 5950 4550 2    60   Input ~ 0
Motor_IN1
Text HLabel 5950 4350 2    60   Input ~ 0
Motor_IN2
Text HLabel 5950 4450 2    60   Input ~ 0
Motor_Standby
Text HLabel 8600 6250 2    60   Input ~ 0
Enable_FR
Text HLabel 8600 6150 2    60   Input ~ 0
Enable_FC
Text HLabel 8600 6350 2    60   Input ~ 0
Enable_FL
Text HLabel 8600 6050 2    60   Input ~ 0
Enable_BC
Text HLabel 8600 6450 2    60   Input ~ 0
Enable_SR
Text HLabel 8450 4050 2    60   Input ~ 0
Steering_PWM
$Comp
L CF_EXP_LEFT P1
U 1 1 5984C28A
P 5250 4300
F 0 "P1" H 5250 3750 60  0000 C CNN
F 1 "CF_EXP_LEFT" H 5250 3650 60  0000 C CNN
F 2 "crazyflie2-exp:CF2-DECK-SMD-HOLES" H 5400 3650 60  0001 C CNN
F 3 "" H 5400 3650 60  0000 C CNN
	1    5250 4300
	1    0    0    -1  
$EndComp
$Comp
L CF_EXP_RIGHT P2
U 1 1 5984C362
P 7750 4300
F 0 "P2" H 7750 3750 60  0000 C CNN
F 1 "CF_EXP_RIGHT" H 7750 3650 60  0000 C CNN
F 2 "crazyflie2-exp:CF2-DECK-SMD-HOLES" H 7900 3650 60  0001 C CNN
F 3 "" H 7900 3650 60  0000 C CNN
	1    7750 4300
	1    0    0    -1  
$EndComp
Text HLabel 7400 6050 0    60   Input ~ 0
Distance_SCL
Text HLabel 7400 6150 0    60   Input ~ 0
Distance_SDA
$Comp
L GND #PWR016
U 1 1 5984DF0A
P 8000 7050
F 0 "#PWR016" H 8000 6800 50  0001 C CNN
F 1 "GND" H 8000 6900 50  0000 C CNN
F 2 "" H 8000 7050 50  0000 C CNN
F 3 "" H 8000 7050 50  0000 C CNN
	1    8000 7050
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR017
U 1 1 5984DF24
P 5950 4750
F 0 "#PWR017" H 5950 4500 50  0001 C CNN
F 1 "GND" H 5950 4600 50  0000 C CNN
F 2 "" H 5950 4750 50  0000 C CNN
F 3 "" H 5950 4750 50  0000 C CNN
	1    5950 4750
	1    0    0    -1  
$EndComp
Text HLabel 5950 3950 2    60   Input ~ 0
Extern_RX
Text HLabel 5950 4050 2    60   Input ~ 0
Extern_TX
$Comp
L CONN_01X04 P3
U 1 1 5988473B
P 5600 6300
F 0 "P3" H 5600 6550 50  0000 C CNN
F 1 "CONN_01X04" V 5700 6300 50  0000 C CNN
F 2 "Pin_Headers:Pin_Header_Straight_1x04" H 5600 6300 50  0001 C CNN
F 3 "" H 5600 6300 50  0000 C CNN
	1    5600 6300
	1    0    0    -1  
$EndComp
Text HLabel 5400 6150 0    60   Input ~ 0
Extern_RX
Text HLabel 5400 6250 0    60   Input ~ 0
Extern_TX
$Comp
L GND #PWR018
U 1 1 59884A46
P 5400 6450
F 0 "#PWR018" H 5400 6200 50  0001 C CNN
F 1 "GND" H 5400 6300 50  0000 C CNN
F 2 "" H 5400 6450 50  0000 C CNN
F 3 "" H 5400 6450 50  0000 C CNN
	1    5400 6450
	1    0    0    -1  
$EndComp
Text HLabel 5400 6350 0    60   Input ~ 0
5V
Text HLabel 8450 3950 2    60   Input ~ 0
Motor_PWMB
$Comp
L MCP23008 U2
U 1 1 598C8911
P 7400 5650
F 0 "U2" H 7400 5650 60  0000 C CNN
F 1 "MCP23008" V 8100 4900 60  0000 C CNN
F 2 "Housings_DIP:DIP-18_W7.62mm_LongPads" H 7400 5650 60  0001 C CNN
F 3 "" H 7400 5650 60  0001 C CNN
	1    7400 5650
	1    0    0    -1  
$EndComp
Wire Wire Line
	7400 6250 7400 6450
Connection ~ 7400 6350
$Comp
L GND #PWR019
U 1 1 598C8AD6
P 6700 6400
F 0 "#PWR019" H 6700 6150 50  0001 C CNN
F 1 "GND" H 6700 6250 50  0000 C CNN
F 2 "" H 6700 6400 50  0000 C CNN
F 3 "" H 6700 6400 50  0000 C CNN
	1    6700 6400
	1    0    0    -1  
$EndComp
Wire Wire Line
	6700 6350 7400 6350
NoConn ~ 7400 6750
NoConn ~ 7400 6650
Text HLabel 8000 5750 1    60   Input ~ 0
MCU_VCC
Text HLabel 7400 6550 0    60   Input ~ 0
MCU_VCC
Wire Wire Line
	6700 6350 6700 6400
$EndSCHEMATC
