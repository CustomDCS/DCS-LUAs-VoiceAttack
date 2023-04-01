dofile(LockOn_Options.script_path.."command_defs.lua")
dofile(LockOn_Options.script_path.."devices.lua")

local t_start = 0.0
local t_stop = 0.0
local dt = 0.005 -- Default interval between commands in the stack.
local mto = 8.0 -- Default message timeout time.
local start_sequence_time = 2.1 * 60 -- Quick startup takes about 2m00s (orignal was 3m20s)
local stop_sequence_time = 60.0 -- TODO: timeout

start_sequence_full = {}
stop_sequence_full = {}

function push_command(sequence, run_t, command)
sequence[#sequence + 1] = command
sequence[#sequence]["time"] = run_t
end

function push_start_command(delta_t, command)
t_start = t_start + delta_t
push_command(start_sequence_full,t_start, command)
end

function push_stop_command(delta_t, command)
t_stop = t_stop + delta_t
push_command(stop_sequence_full,t_stop, command)
end

NO_FUEL = 1
COLLECTIVE = 2
BATTERY_LOW	= 3
APU_START_FAULT = 4
FUEL_PUMP_FAULT = 5
LEFT_ENGINE_START_FAULT = 6
RIGHT_ENGINE_START_FAULT = 7

alert_messages = {}
alert_messages[COLLECTIVE] = { message = _("SET THE COLLECTIVE STICK DOWN"), message_timeout = 10}
alert_messages[NO_FUEL] = 	 { message = _("CHECK FUEL QUANTITY"), message_timeout = 10}
alert_messages[BATTERY_LOW] = { message = _("POWER SUPPLY FAULT. CHECK THE BATTERY"), message_timeout = 10}
alert_messages[APU_START_FAULT] = { message = _("AI-9 NOT READY TO START ENGINE"), message_timeout = 10}
alert_messages[FUEL_PUMP_FAULT] = { message = _("FEEDING FUEL TANK PUMP FAULT"), message_timeout = 10}
alert_messages[LEFT_ENGINE_START_FAULT] = { message = _("LEFT ENGINE START FAULT"), message_timeout = 10}
alert_messages[RIGHT_ENGINE_START_FAULT] = { message = _("RIGHT ENGINE START FAULT"), message_timeout = 10}

----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------

-- Function to collect all the start sequence commands.

local function doStartSequence()

push_start_command(dt, {message = _(" "), message_timeout = start_sequence_time})	
push_start_command(dt, {message = _("=================================================="), message_timeout = 122})
push_start_command(dt, {message = _("  CustomDCS.com Super Quick Autostart Sequence Is Running (2m 05sec)"), message_timeout = 122})
push_start_command(dt, {message = _("          This Auto Start is Set For FARP SHARON"), message_timeout = 122})
--push_start_command(dt, {message = _("       Night Mode - Doppler is Off For Night Vision"), message_timeout = 122}) -- Remove -- for Night Mode
push_start_command(dt, {message = _("=================================================="), message_timeout = 122})


-- Lights - Brightness Knobs - All To MAX - Day Mode

push_start_command(dt, {device = devices.LIGHT_SYSTEM, action = device_commands.Button_11, value = 1.0}) -- 5.5V Lights Brightness Rheostat
push_start_command(dt, {device = devices.LIGHT_SYSTEM, action = device_commands.Button_10, value = 1.0}) -- Central Red Lights Brightness Group 2 Rheostat
push_start_command(dt, {device = devices.LIGHT_SYSTEM, action = device_commands.Button_9, value = 1.0}) -- Central Red Lights Brightness Group 1 Rheostat
push_start_command(dt, {device = devices.LIGHT_SYSTEM, action = device_commands.Button_8, value = 1.0}) -- Right Red Lights Brightness Group 2 Rheostat
push_start_command(dt, {device = devices.LIGHT_SYSTEM, action = device_commands.Button_7, value = 1.0}) -- Right Red Lights Brightness Group 1 Rheostat
push_start_command(dt, {device = devices.LIGHT_SYSTEM, action = device_commands.Button_6, value = 1.0}) -- Left Red Lights Brightness Group 2 Rheostat
push_start_command(dt, {device = devices.LIGHT_SYSTEM, action = device_commands.Button_5, value = 1.0}) -- Left Red Lights Brightness Group 1 Rheostat
push_start_command(dt, {device = devices.LIGHT_SYSTEM, action = device_commands.Button_23, value = 1.0}) -- Cargo Cabin Common Lights Switch
push_start_command(dt, {device = devices.LIGHT_SYSTEM, action = device_commands.Button_4, value = 1.0}) -- 5.5V Lights Switch
push_start_command(dt, {device = devices.SYS_CONTROLLER, action = device_commands.Button_6, value = 1.0}) -- Transparent Switch
push_start_command(dt, {device = devices.NAVLIGHT_SYSTEM, action = device_commands.Button_12, value = 1.0}) -- ANO Switch- Bright - NAV Lights?
push_start_command(dt, {device = devices.NAVLIGHT_SYSTEM, action = device_commands.Button_13, value = 1.0}) -- Formation Lights - Bright

-- Lights - Brightness Knobs - All To HALF - Night Mode

--push_start_command(dt, {device = devices.LIGHT_SYSTEM, action = device_commands.Button_11, value = 0.5}) -- 5.5V Lights Brightness Rheostat
--push_start_command(dt, {device = devices.LIGHT_SYSTEM, action = device_commands.Button_10, value = 0.5}) -- Central Red Lights Brightness Group 2 Rheostat
--push_start_command(dt, {device = devices.LIGHT_SYSTEM, action = device_commands.Button_9, value = 0.5}) -- Central Red Lights Brightness Group 1 Rheostat
--push_start_command(dt, {device = devices.LIGHT_SYSTEM, action = device_commands.Button_8, value = 0.5}) -- Right Red Lights Brightness Group 2 Rheostat
--push_start_command(dt, {device = devices.LIGHT_SYSTEM, action = device_commands.Button_7, value = 0.5}) -- Right Red Lights Brightness Group 1 Rheostat
--push_start_command(dt, {device = devices.LIGHT_SYSTEM, action = device_commands.Button_6, value = 0.5}) -- Left Red Lights Brightness Group 2 Rheostat
--push_start_command(dt, {device = devices.LIGHT_SYSTEM, action = device_commands.Button_5, value = 0.5}) -- Left Red Lights Brightness Group 1 Rheostat
--push_start_command(dt, {device = devices.LIGHT_SYSTEM, action = device_commands.Button_23, value = 0.5}) -- Cargo Cabin Common Lights Switch
--push_start_command(dt, {device = devices.LIGHT_SYSTEM, action = device_commands.Button_2, value = -1.0}) -- Left Ceiling Light Switch
--push_start_command(dt, {device = devices.LIGHT_SYSTEM, action = device_commands.Button_3, value = -1.0}) -- Right Ceiling Light Switch
--push_start_command(dt, {device = devices.LIGHT_SYSTEM, action = device_commands.Button_4, value = 0.5}) -- 5.5V Lights Switch
--push_start_command(dt, {device = devices.SYS_CONTROLLER, action = device_commands.Button_6, value = 1.0}) -- Transparent Switch
--push_start_command(dt, {device = devices.NAVLIGHT_SYSTEM, action = device_commands.Button_12, value = -1.0}) -- ANO Switch - Dim
--push_start_command(dt, {device = devices.NAVLIGHT_SYSTEM, action = device_commands.Button_13, value = -1.0}) -- Formation Lights - Dim
--push_start_command(dt, {device = devices.PKV, action = device_commands.Button_1, value = 0.15}) -- Sight Brightness Knob - 15%
--push_start_command(dt, {device = devices.AUTOPILOT, action = device_commands.Button_21, value = 0.50}) -- Auto Pilot Brigtness Knob - Pitch/Roll
--push_start_command(dt, {device = devices.AUTOPILOT, action = device_commands.Button_19, value = 0.50}) -- Auto Pilot Brigtness Knob - Heading ON
--push_start_command(dt, {device = devices.AUTOPILOT, action = device_commands.Button_20, value = 0.50}) -- Auto Pilot Brigtness Knob - Heading OFF
--push_start_command(dt, {device = devices.AUTOPILOT, action = device_commands.Button_22, value = 0.50}) -- Auto Pilot Brigtness Knob - ALT Hold ON
--push_start_command(dt, {device = devices.AUTOPILOT, action = device_commands.Button_23, value = 0.50}) -- Auto Pilot Brigtness Knob - ALT Hold OFF


-- Pretty Lights on the Outside

push_start_command(dt, {device = devices.NAVLIGHT_SYSTEM, action = device_commands.Button_14, value = 1.0}) -- Tip Lights Switch
--push_start_command(dt, {device = devices.NAVLIGHT_SYSTEM, action = device_commands.Button_16, value = 1.0}) -- ANO Code Button - Don't Know What This One Does
push_start_command(dt, {device = devices.NAVLIGHT_SYSTEM, action = device_commands.Button_15, value = 1.0}) -- Strobe Light - Red Flashing Light


-- Power levers and throttle

push_start_command(dt, {action = Keys.iCommand_PlaneAUTDecreaseRegime}) -- ?
push_start_command(dt, {action = Keys.iCommand_PlaneAUTDecreaseRegime}) -- ?
push_start_command(dt, {action = Keys.iCommand_PlaneAUTIncreaseRegime}) -- ?
push_start_command(dt, {action = Keys.iCommand_ThrottleDecrease}) -- ?
push_start_command(dt, {device = devices.ENGINE_INTERFACE, action = device_commands.Button_69, value = -1.0}) -- ?
push_start_command(dt, {device = devices.ENGINE_INTERFACE, action = device_commands.Button_70, value = -1.0}) -- ?
push_start_command(dt, {action = Keys.iCommand_ThrottleStop}) -- ?
push_start_command(dt, {device = devices.SPU_7, action = device_commands.Button_4, value = 1.0}) -- Radio Set to ICS
push_start_command(dt, {device = devices.ELEC_INTERFACE, action = device_commands.Button_3, value = 1.0}) -- Battery 1 Switch
push_start_command(dt, {device = devices.ELEC_INTERFACE, action = device_commands.Button_2, value = 1.0}) -- Battery 2 Switch
push_start_command(dt, {device = devices.ELEC_INTERFACE, action = device_commands.Button_12, value = -1.0}) -- 115V Inverter Switch
push_start_command(dt, {device = devices.ELEC_INTERFACE, action = device_commands.Button_22, value = 1.0}) -- CB Group 1 ON
push_start_command(dt, {device = devices.ELEC_INTERFACE, action = device_commands.Button_22, value = 0.0}) -- Return
push_start_command(dt, {device = devices.ELEC_INTERFACE, action = device_commands.Button_23, value = 1.0}) -- CB Group 2 ON
push_start_command(dt, {device = devices.ELEC_INTERFACE, action = device_commands.Button_23, value = 0.0}) -- Return
push_start_command(dt, {device = devices.ELEC_INTERFACE, action = device_commands.Button_24, value = 1.0}) -- CB Group 3 ON
push_start_command(dt, {device = devices.ELEC_INTERFACE, action = device_commands.Button_24, value = 0.0}) -- Return
push_start_command(dt, {device = devices.ELEC_INTERFACE, action = device_commands.Button_25, value = 1.0}) -- CB Group 4 ON
push_start_command(dt, {device = devices.ELEC_INTERFACE, action = device_commands.Button_25, value = 0.0}) -- Return
push_start_command(dt, {device = devices.ELEC_INTERFACE, action = device_commands.Button_26, value = 1.0}) -- CB Group 5 ON
push_start_command(dt, {device = devices.ELEC_INTERFACE, action = device_commands.Button_26, value = 0.0}) -- Return
push_start_command(dt, {device = devices.ELEC_INTERFACE, action = device_commands.Button_27, value = 1.0}) -- CB Group 6 ON
push_start_command(dt, {device = devices.ELEC_INTERFACE, action = device_commands.Button_27, value = 0.0}) -- Return
push_start_command(dt, {device = devices.ELEC_INTERFACE, action = device_commands.Button_28, value = 1.0}) -- CB Group 7 ON
push_start_command(dt, {device = devices.ELEC_INTERFACE, action = device_commands.Button_28, value = 0.0}) -- Return
push_start_command(dt, {device = devices.ELEC_INTERFACE, action = device_commands.Button_29, value = 1.0}) -- CB Group 8 ON
push_start_command(dt, {device = devices.ELEC_INTERFACE, action = device_commands.Button_29, value = 0.0}) -- Return
push_start_command(dt, {device = devices.ELEC_INTERFACE, action = device_commands.Button_30, value = 1.0}) -- CB Group 9 ON
push_start_command(dt, {device = devices.ELEC_INTERFACE, action = device_commands.Button_30, value = 0.0}) -- Return
push_start_command(dt, {device = devices.FIRE_EXTING_INTERFACE, action = device_commands.Button_10, value = 1.0}) -- Check Fire Circuits Switch
push_start_command(dt, {device = devices.FUELSYS_INTERFACE, action = device_commands.Button_8, value = 0.1}) -- Fuel Meter Switch, Set To ALL
push_start_command(dt, {device = devices.FUELSYS_INTERFACE, action = device_commands.Button_9, value = 1.0}) -- Left Shutoff Valve Switch Cover - Open
push_start_command(dt, {device = devices.FUELSYS_INTERFACE, action = device_commands.Button_1, value = 1.0}) -- Left Shutoff Valve Switch
push_start_command(dt, {device = devices.FUELSYS_INTERFACE, action = device_commands.Button_9, value = 0.0}) -- Left Shutoff Valve Switch Cover - Close
push_start_command(dt, {device = devices.FUELSYS_INTERFACE, action = device_commands.Button_10, value = 1.0}) -- Right Shutoff Valve Switch Cover - Open
push_start_command(dt, {device = devices.FUELSYS_INTERFACE, action = device_commands.Button_2, value = 1.0}) -- Right Shutoff Valve Switch
push_start_command(dt, {device = devices.FUELSYS_INTERFACE, action = device_commands.Button_10, value = 0.0}) -- Right Shutoff Valve Switch Cover - Vlose
push_start_command(dt, {device = devices.FUELSYS_INTERFACE, action = device_commands.Button_6, value = 1.0}) -- Feed Tank Pump Switch
push_start_command(dt, {device = devices.FUELSYS_INTERFACE, action = device_commands.Button_3, value = 1.0}) -- Left Tank Pump Switch
push_start_command(dt, {device = devices.FUELSYS_INTERFACE, action = device_commands.Button_5, value = 1.0}) -- Right Tank Pump Switch


-- JADRO

push_start_command(dt, {device = devices.JADRO_1A, action = device_commands.Button_13, value = 1.0}) -- Jadro 1A, Power Switch
push_start_command(dt, {device = devices.JADRO_1A, action = device_commands.Button_1, value = 1.0}) -- Jadro 1A, Mode Switch
push_start_command(dt, {device = devices.JADRO_1A, action = device_commands.Button_2, value = 1.0}) -- Jadro 1A, Frequency Selector


-- Fans

push_start_command(dt, {device = devices.CPT_MECH, action = device_commands.Button_20, value = 1.0}) -- Pilot Fan
push_start_command(dt, {device = devices.CPT_MECH, action = device_commands.Button_21, value = 1.0}) -- Co Pilot Fan


-- Generators and Rectifiers

push_start_command(dt, {device = devices.ELEC_INTERFACE, action = device_commands.Button_1, value = 1.0}) -- Standby Generator Switch
push_start_command(dt, {device = devices.ELEC_INTERFACE, action = device_commands.Button_9, value = 1.0}) -- Equipment Test Switch
push_start_command(dt, {device = devices.ELEC_INTERFACE, action = device_commands.Button_15, value = 1.0}) -- Generator 1 Switch
push_start_command(dt, {device = devices.ELEC_INTERFACE, action = device_commands.Button_16, value = 1.0}) -- Generator 2 Switch
push_start_command(dt, {device = devices.ELEC_INTERFACE, action = device_commands.Button_7, value = 1.0}) -- Rectifier 1 Switch
push_start_command(dt, {device = devices.ELEC_INTERFACE, action = device_commands.Button_5, value = 1.0}) -- Rectifier 2 Switch
push_start_command(dt, {device = devices.ELEC_INTERFACE, action = device_commands.Button_6, value = 1.0}) -- Rectifier 3 Switch
push_start_command(dt, {device = devices.ELEC_INTERFACE, action = device_commands.Button_8, value = 0.5}) -- DC Voltmeter Selector
push_start_command(dt, {device = devices.ELEC_INTERFACE, action = device_commands.Button_17, value = 1.0}) -- AC Voltmeter Selector
push_start_command(dt, {device = devices.ELEC_INTERFACE, action = device_commands.Button_13, value = -1.0}) -- 36V Inverter Switch


-- Pilot's Triangular Panel

push_start_command(dt, {device = devices.AGB_3K_LEFT, action = device_commands.Button_4, value = 1.0}) -- Left Attitude Indicator Power Switch
push_start_command(dt, {device = devices.CORRECTION_INTERRUPT, action = device_commands.Button_1, value = 1.0}) -- Gyro Cutout
push_start_command(dt, {device = devices.SPUU_52, action = device_commands.Button_5, value = 1.0}) -- Pitch Limit System


-- Copilot's Triangular Panel

push_start_command(dt, {device = devices.DISS_15, action = device_commands.Button_1, value = 1.0}) -- Doppler Navigator Power Switch
push_start_command(dt, {device = devices.GMK1A, action = device_commands.Button_1, value = 1.0}) -- GMC Power Switch
push_start_command(dt, {device = devices.AGB_3K_RIGHT, action = device_commands.Button_4, value = 1.0}) -- Right Attitude Indicator Power Switch
push_start_command(dt, {device = devices.ARC_UD, action = device_commands.Button_4, value = 0.0}) -- ARC-UD, Channel Selector Switch
push_start_command(dt, {device = devices.ARC_UD, action = device_commands.Button_12, value = 1.0}) -- ARC-UD, Lock Switch


-- Other

push_start_command(dt, {device = devices.RADAR_ALTIMETER, action = device_commands.Button_3, value = 1.0}) -- RADALT On
push_start_command(dt, {device = devices.EXT_CARGO_EQUIPMENT, action = device_commands.Button_5, value = 1.0}) -- Auto Unhook
push_start_command(dt, {device = devices.ENGINE_INTERFACE, action = device_commands.Button_10, value = 1.0}) -- Fuel Cutoff Lever - Left
push_start_command(dt, {device = devices.ENGINE_INTERFACE, action = device_commands.Button_9, value = 1.0}) -- Fuel Cutoff Lever - Right
push_start_command(dt, {device = devices.PKV, action = device_commands.Button_3, value = .215}) -- Set Sight Limb Knob - 0.3 Default
push_start_command(dt, {device = devices.RADAR_ALTIMETER, action = device_commands.Button_1, value = -0.80}) -- Set RADALT to 20 Meters


-- Turn On Rocket Systems

push_start_command(dt, {device = devices.WEAPON_SYS, action = device_commands.Button_30, value = 1.0}) -- RS/GUV Selector Switch
push_start_command(dt, {device = devices.WEAPON_SYS, action = device_commands.Button_22, value = -1.0}) -- UPK/PKT/RS Switch Set to RS - Rockets
push_start_command(dt, {device = devices.WEAPON_SYS, action = device_commands.Button_20, value = -1.0}) -- 8/16/4 Switch - Set to 4
push_start_command(dt, {device = devices.WEAPON_SYS, action = device_commands.Button_27, value = 1.0}) -- Wepons Master ARM - On


-- UV-26 Countermeasures System

push_start_command(dt, {device = devices.UV_26, action = device_commands.Button_10, value = 1.0}) -- CMD Power On
push_start_command(dt, {device = devices.UV_26, action = device_commands.Button_2, value = 0.5}) -- Set CMD To Both


-- APU

push_start_command(dt, {message = _("  APU Start"), message_timeout = mto})

push_start_command(dt, {device = devices.ENGINE_INTERFACE, action = device_commands.Button_12, value = 1.0}) -- APU Start Mode Switch, START/COLD CRANKING/FALSE START
push_start_command(0.2, {device = devices.ENGINE_INTERFACE, action = device_commands.Button_26, value = 1.0}) -- Press
push_start_command(0.2, {device = devices.ENGINE_INTERFACE, action = device_commands.Button_26, value = 0.0}) -- Release


-- R-828 Radio

push_start_command(dt, {device = devices.R_828, action = device_commands.Button_5, value = 1.0}) -- 250AM Power On


-- Turning up Main Radio, Turning Other to Half Volume

push_start_command(dt, {device = devices.ARC_9, action = device_commands.Button_11, value = 0.0}) -- ARC 9 MAIN PRESS
push_start_command(dt, {device = devices.ARC_9, action = device_commands.Button_3, value = 0.1}) -- ARC 9 COMP
push_start_command(dt, {device = devices.R_828, action = device_commands.Button_2, value = 0.5}) -- 828 VOLUME KNOB - 30FM
push_start_command(dt, {device = devices.R_863, action = device_commands.Button_5, value = 1.00}) -- MAIN RADIO VOLUME KNOB 250AM


-- Tune ADF

-- Main - Set To 700kHz
push_start_command(dt, {device = devices.ARC_9, action = device_commands.Button_6, value = -0.5}) -- ARC 9 10KHZ DIAL
push_start_command(dt, {device = devices.ARC_9, action = device_commands.Button_5, value = 0.25}) -- ARC 9 100KHZ DIAL

-- Reserve - Set To 260kHz
push_start_command(dt, {device = devices.ARC_9, action = device_commands.Button_9, value = 0.6}) -- ARC 9 10KHZ DIAL
push_start_command(dt, {device = devices.ARC_9, action = device_commands.Button_8, value = 0.05}) -- ARC 9 100KHZ DIAL

push_start_command(dt, {device = devices.ARC_9, action = device_commands.Button_11, value = 1.0}) -- Main/Reserve Switch - Set To Main

-- Set QNH To FARP Height - Not Automatic - Set to SHARON

for i = 1, 100, 1 do
	push_start_command(0.01, {device = devices.BAR_ALTIMETER_L, action = device_commands.Button_1, value = 1}) -- Set QNH = Pilot
end

for i = 1, 100, 1 do
	push_start_command(0.01, {device = devices.BAR_ALTIMETER_R, action = device_commands.Button_1, value = 1}) -- Set QNH - Copilot
end


-- Information Message - Current Set Up

push_start_command(dt, {message = _(" "), message_timeout = 100})
push_start_command(dt, {message = _("================================="), message_timeout = 100})
push_start_command(dt, {message = _("  Altimeter Set To FARP SHORON"), message_timeout = 100})
push_start_command(dt, {message = _("  Radio Set To ICS To Allow Rearm And Refuel"), message_timeout = 100})
--push_start_command(dt, {message = _("  The Rocket Systems Are On, Master Arm Is OFF"), message_timeout = 100})
push_start_command(dt, {message = _("  The Rocket Systems Are On, Master Arm Is ON"), message_timeout = 100})
push_start_command(dt, {message = _("  Main ADF Tuned To FARP SHARON (260kHz)"), message_timeout = 100})
push_start_command(dt, {message = _("  Reserve ADF Tuned To FARP ARROW (600kHz)"), message_timeout = 100})
push_start_command(dt, {message = _("     ARROW    - 600kHz - 15nm 012 N"), message_timeout = 100})
push_start_command(dt, {message = _("  A  TAJI     - 270kHz - 29nm 042 NE  "), message_timeout = 100})
push_start_command(dt, {message = _("  B  GLORY    - 290kHz - 17nm 076 E"), message_timeout = 100})
push_start_command(dt, {message = _("  C  BLKHORSE - 700kHz - 47nm 075 E"), message_timeout = 100})
push_start_command(dt, {message = _(" "), message_timeout = 100})

push_start_command(12.0, {message = _("  APU Running"), message_timeout = mto})
push_start_command(dt, {message = _(" "), message_timeout = mto})


-- Left Engine

push_start_command(dt, {device = devices.NAVLIGHT_SYSTEM, action = device_commands.Button_17, value = 1.0}) -- Taxi Light - On
push_start_command(dt, {device = devices.ENGINE_INTERFACE, action = device_commands.Button_11, value = 0.0}) -- Rotor Brake Handle - Off

push_start_command(dt, {message = _("  Left Engine Start"), message_timeout = 44.0})
push_start_command(dt, {message = _(" "), message_timeout = 44})

push_start_command(dt, {device = devices.ENGINE_INTERFACE, action = device_commands.Button_27, value = 1.0}) -- Engine Start Mode Switch
push_start_command(dt, {device = devices.ENGINE_INTERFACE, action = device_commands.Button_8, value = -1.0}) -- Engine Selector Switch
push_start_command(dt, {device = devices.ENGINE_INTERFACE, action = device_commands.Button_5, value = 1.0}) -- Engine Start Button - Push to start engine
push_start_command(0.2, {device = devices.ENGINE_INTERFACE, action = device_commands.Button_5, value = 0.0}) -- Relese
push_start_command(2.0, {device = devices.CPT_MECH, action = device_commands.Button_15, value = 0.0}) -- Pilot Blister Window Close


-- Reset G Meter

push_start_command(1.0, {device = devices.CPT_MECH, action =  device_commands.Button_6, value = 1.0}) -- Press - G Meter
push_start_command(1.0, {device = devices.CPT_MECH, action = device_commands.Button_6, value = 0.0}) -- Release - G Meter


-- Throttle Up

push_start_command(dt, {action = Keys.iCommand_ThrottleIncrease}) -- Collective Throttle To MAX
push_start_command(1.5, {action = Keys.iCommand_ThrottleStop}) -- MAX Value


-- Then We Can Tune To 30.00 FM

push_start_command(dt, {device = devices.R_828, action = device_commands.Button_1, value = 0.4}) -- 30FM On
push_start_command(dt, {device = devices.R_828, action = device_commands.Button_3, value = 1.0}) -- Press - R-828, Radio Tuner Button
push_start_command(3.0, {device = devices.R_828, action = device_commands.Button_3, value = 0.0}) -- Release - R-828, Radio Tuner Button

push_start_command(46, {message = _("  Left Engine Running"), message_timeout = mto})
push_start_command(dt, {message = _(" "), message_timeout = mto})


-- Right Engine

push_start_command(dt, {message = _("  Right Engine Start"), message_timeout = 44.0})
push_start_command(dt, {message = _(" "), message_timeout = 44})

push_start_command(dt, {device = devices.ENGINE_INTERFACE, action = device_commands.Button_8, value = 1.0}) -- Start Selector
push_start_command(dt, {device = devices.ENGINE_INTERFACE, action = device_commands.Button_5, value = 1.0}) -- Push to Start
push_start_command(0.2, {device = devices.ENGINE_INTERFACE, action = device_commands.Button_5, value = 0.0}) -- Relese


-- Cage Gyros

push_start_command(22, {message = _("  Cage/Uncage Gyros 30sec To Align"), message_timeout = 30})
push_start_command(dt, {message = _(" "), message_timeout = 30})

push_start_command(0.8, {device = devices.AGB_3K_LEFT, action = device_commands.Button_2, value = 1.0}) -- Press - Cage Left Gyro
push_start_command(0.8, {device = devices.AGB_3K_LEFT, action = device_commands.Button_2, value = 0.0}) -- Release - Uncage Left Gyro
push_start_command(0.8, {device = devices.AGB_3K_RIGHT, action = device_commands.Button_2, value = 1.0}) -- Press - Cage Right Gryo
push_start_command(0.8, {device = devices.AGB_3K_RIGHT, action = device_commands.Button_2, value = 0.0}) -- Release - Uncage Right Gyro

push_start_command(24.0, {message = _("  Right Engine Running"), message_timeout = mto})
push_start_command(dt, {message = _(" "), message_timeout = mto})


-- APU Stop

push_start_command(0.1, {device = devices.ENGINE_INTERFACE, action = device_commands.Button_7, value = 1.0}) -- Press - APU Stop Button
push_start_command(0.1, {device = devices.ENGINE_INTERFACE, action = device_commands.Button_7, value = 0.0}) -- Release - APU Start Button

push_start_command(dt, {message = _("================="), message_timeout = mto})
push_start_command(dt, {message = _("  Stabilizing Engine RPM"), message_timeout = 12})
push_start_command(dt, {message = _("================="), message_timeout = 12})

push_start_command(10.0, {message = _(""), message_timeout = 0.0}) -- Pause for 10sec To Let The Engine RPM Stabilize


-- Radios

push_start_command(dt, {device = devices.SPU_7, action = device_commands.Button_4, value = 0.0}) -- Radio Set to Radio


-- Auto Pilot

push_start_command(0.1, {device = devices.AUTOPILOT, action = device_commands.Button_2, value = 1.0}) -- Press
push_start_command(0.1, {device = devices.AUTOPILOT, action = device_commands.Button_2, value = 0.0}) -- Release
push_start_command(dt, {device = devices.VMS, action = device_commands.Button_6, value = 1.0}) -- Bitchin Betty - On

push_start_command(dt, {message = _(" "), message_timeout = 10})
push_start_command(dt, {message = _("================================"), message_timeout = 10})
push_start_command(dt, {message = _("  Autopilot Pitch/Roll Channel - ON"), message_timeout = 10})
push_start_command(dt, {message = _("  ICS Off"), message_timeout = 10})
push_start_command(dt, {message = _("  PTT for SRS will Now Transmit On 250kHz AM"), message_timeout = 10})
push_start_command(dt, {message = _("  99.5% Chance You Are Ready To Fly"), message_timeout = 10})
push_start_command(dt, {message = _("  Auto Start Complete"), message_timeout = 10})
push_start_command(dt, {message = _("================================"), message_timeout = 10})
push_start_command(dt, {message = _(" "), message_timeout = 10})


-- Toot the Horn

push_start_command(0.30, {device = devices.MISC_SYSTEMS_INTERFACE, action = device_commands.Button_1, value = 1.0}) -- Press
push_start_command(0.20, {device = devices.MISC_SYSTEMS_INTERFACE, action = device_commands.Button_1, value = 0.0}) -- Release
push_start_command(0.30, {device = devices.MISC_SYSTEMS_INTERFACE, action = device_commands.Button_1, value = 1.0}) -- Press
push_start_command(0.20, {device = devices.MISC_SYSTEMS_INTERFACE, action = device_commands.Button_1, value = 0.0}) -- Release
push_start_command(0.30, {device = devices.MISC_SYSTEMS_INTERFACE, action = device_commands.Button_1, value = 1.0}) -- Press
push_start_command(0.20, {device = devices.MISC_SYSTEMS_INTERFACE, action = device_commands.Button_1, value = 0.0}) -- Release


end
doStartSequence()


----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------

local function

doStopSequence()


-- Stop sequence

push_stop_command(dt, {message = _(" "), message_timeout = 49})
push_stop_command(dt, {message = _("================================================"), message_timeout = 49})
push_stop_command(dt, {message = _("  CustomDCS.com - Super Quick Autostop Sequence Is Running (50sec)"), message_timeout = 49})
push_stop_command(dt, {message = _("================================================"), message_timeout = 49})
push_stop_command(dt, {message = _(" "), message_timeout = 49})

push_stop_command(dt, {device = devices.SPU_7, action = device_commands.Button_4, value = -1.0}) -- Radio Set To ICS
push_stop_command(dt, {device = devices.NAVLIGHT_SYSTEM, action = device_commands.Button_18, value = 0.0}) -- Left Landing Light Switch - Off
push_stop_command(dt, {device = devices.NAVLIGHT_SYSTEM, action = device_commands.Button_19, value = 0.0}) -- Right Landing Light Switch - Off
push_stop_command(dt, {device = devices.NAVLIGHT_SYSTEM, action = device_commands.Button_17, value = -1.0}) -- Taxi Light - Off
push_stop_command(0.1, {device = devices.ENGINE_INTERFACE, action = device_commands.Button_7, value = 1.0}) -- Press - APU Stop Button
push_stop_command(0.1, {device = devices.ENGINE_INTERFACE, action = device_commands.Button_7, value = 0.0}) -- Release - APU Start Button
push_stop_command(dt, {device = devices.VMS, action = device_commands.Button_6, value = 0.0}) -- Bitchin Betty - Off
push_stop_command(dt, {device = devices.ENGINE_INTERFACE, action = device_commands.Button_9, value = 0}) -- Left Fuel Lever - Off
push_stop_command(dt, {device = devices.ENGINE_INTERFACE, action = device_commands.Button_10, value = 0}) -- Right Fuel Lever - Off
push_stop_command(dt, {device = devices.RADAR_ALTIMETER, action = device_commands.Button_1, value = 0.80}) -- Set RADALT to STD
push_stop_command(dt, {action = Keys.iCommand_ThrottleDecrease}) -- Throttle Down
push_stop_command(0.5, {action = Keys.iCommand_ThrottleStop})
push_stop_command(3.5, {device = devices.ENGINE_INTERFACE, action = device_commands.Button_11, value = 1}) -- Rotor Brake - On

for i = device_commands.Button_31, device_commands.Button_31 + 75, 1 do
	push_stop_command(0.005, {device = devices.ELEC_INTERFACE, action = i, value = 0.0}) -- Turn off All Circut Brakers
end

push_stop_command(dt, {device = devices.ELEC_INTERFACE, action = device_commands.Button_3, value = -1.0}) -- Battery 1 Switch - Off
push_stop_command(dt, {device = devices.ELEC_INTERFACE, action = device_commands.Button_2, value = -1.0}) -- Battery 2 Switch - Off


for i = 1, 100, 1 do
	push_stop_command(0.01, {device = devices.BAR_ALTIMETER_L, action = device_commands.Button_1, value = -1}) -- Set QNH = Pilot
end

for i = 1, 100, 1 do
	push_stop_command(0.01, {device = devices.BAR_ALTIMETER_R, action = device_commands.Button_1, value = -1}) -- Set QNH - Copilot
end


-- Wait for rotor to spin down.

push_stop_command(6, {message = _("  Rotor Spool Down (40s)"), message_timeout = 19.0})
push_stop_command(dt, {message = _(" "), message_timeout = 19.0})
push_stop_command(20.0, {message = _("  Rotor Spool Down (20s)"), message_timeout = 9.0})
push_stop_command(dt, {message = _(" "), message_timeout = 9.0})
push_stop_command(10, {message = _("  Rotor Spool Down (10s)"), message_timeout = 7.0})
push_stop_command(dt, {message = _(" "), message_timeout = 8.0})

push_stop_command(5.0, {message = _(""), message_timeout = 0.0})

push_stop_command(2.0, {device = devices.CPT_MECH, action = device_commands.Button_15, value = 1.0})

push_stop_command(2.0, {message = _(""), message_timeout = 0.0})

push_stop_command(dt, {message = _(" "), message_timeout = mto})
push_stop_command(dt, {message = _("============================================"), message_timeout = mto})
push_stop_command(dt, {message = _("  CustomDCS.com - Super Quick Autostop Sequence Is Complete"), message_timeout = mto})
push_stop_command(dt, {message = _("============================================"), message_timeout = mto})
push_stop_command(dt, {message = _(" "), message_timeout = mto})
end
doStopSequence()