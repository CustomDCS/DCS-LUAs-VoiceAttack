dofile(LockOn_Options.script_path.."devices.lua")
dofile(LockOn_Options.script_path.."command_defs.lua")

local current_time=0.0
std_message = 10.0
std_dt = 0.1
local stop_current_time=0.0

function add_time(timeout)
	current_time = current_time + timeout
	return current_time
end

function add_stop_time(timeout)
	stop_current_time = stop_current_time + timeout
	return stop_current_time
end

start_sequence_full = {
{time = 0.0,message = _("Shifty Fast Custom AUTOSTART SEQUENCE IS RUNNING"),message_timeout = std_message},
{time = add_time(std_dt),device = devices.FLIGHT_CONTROLS,action = device_commands.Button_11,value = 0.0,message = _("DOORS - CLOSE"),message_timeout = std_message},
{time = add_time(std_dt),device = devices.FD,action = device_commands.Button_4,value = 1.0,message = _("FLARE DISPENSER - COVER OFF"),message_timeout = std_message},
{time = add_time(2.5),device = devices.ELECTRIC,action = device_commands.Button_1,value = 1.0,message = _("BATTERY SWITCH - ON"),message_timeout = std_message},
{time = add_time(std_dt),device = devices.ELECTRIC,action = device_commands.Button_2,value = 1.0,message = _("ALTERNATOR SWITCH - ON"),message_timeout = std_message},
{time = add_time(std_dt),device = devices.ELECTRIC,action = device_commands.Button_3,value = 1.0,message = _("GENERATOR SWITCH - ON"),message_timeout = std_message},
{time = add_time(std_dt),device = devices.AM_RADIO,action = device_commands.Button_1,value = 0.33,message = _("AM RADIO - ON"),message_timeout = std_message},
{time = add_time(std_dt),device = devices.NAVLIGHTS,action = device_commands.Button_1,value = 1.0,message = _("NAV LIGHTS - ON"),message_timeout = std_message},
{time = add_time(std_dt),device = devices.NAVLIGHTS,action = device_commands.Button_2,value = 1.0,message = _("STROBE LIGHTS - ON"),message_timeout = std_message},
{time = add_time(std_dt),device = devices.NADIR,action = device_commands.Button_2,value = 0.2,message = _("NADIR - VEILLE"),message_timeout = std_message},
{time = add_time(std_dt),device = devices.ELECTRIC,action = device_commands.Button_6,value = 1.0,message = _("FUEL PUMP SWITCH - ON"),message_timeout = std_message},
{time = add_time(std_dt),device = devices.SA342_BASE_FM,action = device_commands.Button_7,value = 1.0,message = _("ROTOR BRAKE - RELEASE"),message_timeout = std_message},
{time = add_time(std_dt),device = devices.SYNC_CONTROLS,action = device_commands.Button_103,value = 0.66,message = _("ADF MODE - ADF"),message_timeout = std_message},
{time = add_time(std_dt),device = devices.SYNC_CONTROLS,action = device_commands.Button_161,value = 0.16,message = _("UHF MODE - FF"),message_timeout = std_message},
{time = add_time(std_dt),device = devices.WEAPONS,action = device_commands.Button_4,value = 1.0,message = _("WEAPON PANEL - ON"),message_timeout = std_message},
{time = add_time(std_dt),device = devices.WEAPONS,action = device_commands.Button_13,value = 1.0,message = _("WEAPON COVER RIGHT - OFF"),message_timeout = std_message},
{time = add_time(std_dt),device = devices.WEAPONS,action = device_commands.Button_11,value = 1.0,message = _("WEAPON COVER LEFT - OFF"),message_timeout = std_message},
{time = add_time(std_dt),device = devices.NADIR,action = device_commands.Button_3,value = 0.4,message = _("NADIR - PARAMETER"),message_timeout = std_message},
{time = add_time(std_dt),device = devices.FD,action = device_commands.Button_3,value = 0.5,message = _("FLARE DISPENSER - FAST"),message_timeout = std_message},
{time = add_time(std_dt),device = devices.SYNC_CONTROLS,action = device_commands.Button_191,value = 0.2,message = _("FM SELECTOR - ON"),message_timeout = std_message},
{time = add_time(std_dt),device = devices.WEAPONS,action = device_commands.Button_1,value = 1.0,message = _("MASTER ARM - ON"),message_timeout = std_message},
{time = add_time(2.0),message = _("WAIT FOR FUEL PUMP"),message_timeout = 16.5},
{time = add_time(std_dt+17.5),device = devices.ELECTRIC,action = device_commands.Button_8,value = 1.0,message = _("STARTER SWITCH - ON"),message_timeout = std_message},
{time = add_time(std_dt),message = _("WAIT FOR ENGINE IDLE RPM"),message_timeout = 25.1},
{time = add_time(std_dt+26.1),device = devices.FUEL,action = device_commands.Button_8,value = 1.0,message = _("FUEL FLOW LEVER - ROTOR ROTATE POSITION"),message_timeout = std_message},
{time = add_time(std_dt+3.9),message = _("WAIT FOR ROTOR RPM SYNC"),message_timeout = 29.0},
{time = add_time(std_dt+29.0),device = devices.FUEL,action = device_commands.Button_9,value = 1.0,message = _("FUEL FLOW LEVER - FULL FORWARD"),message_timeout = 16.0},
{time = add_time(0.1),device = devices.SYNC_CONTROLS,action = device_commands.Button_167,value = 1.0}, -- Push button 2
{time = add_time(0.1),device = devices.SYNC_CONTROLS,action = device_commands.Button_167,value = 0.0},
{time = add_time(0.1),device = devices.SYNC_CONTROLS,action = device_commands.Button_170,value = 1.0}, -- Push button 5
{time = add_time(0.1),device = devices.SYNC_CONTROLS,action = device_commands.Button_170,value = 0.0},
{time = add_time(0.1),device = devices.SYNC_CONTROLS,action = device_commands.Button_175,value = 1.0}, -- Push button 0
{time = add_time(0.1),device = devices.SYNC_CONTROLS,action = device_commands.Button_175,value = 0.0},
{time = add_time(0.1),device = devices.SYNC_CONTROLS,action = device_commands.Button_175,value = 1.0}, -- Push button 0
{time = add_time(0.1),device = devices.SYNC_CONTROLS,action = device_commands.Button_175,value = 0.0},
{time = add_time(0.1),device = devices.SYNC_CONTROLS,action = device_commands.Button_175,value = 1.0}, -- Push button 0
{time = add_time(0.1),device = devices.SYNC_CONTROLS,action = device_commands.Button_175,value = 0.0},
{time = add_time(0.1),device = devices.SYNC_CONTROLS,action = device_commands.Button_175,value = 1.0}, -- Push button 0
{time = add_time(0.1),device = devices.SYNC_CONTROLS,action = device_commands.Button_175,value = 0.0},
{time = add_time(0.1),device = devices.SYNC_CONTROLS,action = device_commands.Button_163,value = 1.0}, -- Push button VLD
{time = add_time(0.1),device = devices.SYNC_CONTROLS,action = device_commands.Button_163,value = 0.0},
{time = add_time(std_dt+16.0),device = devices.ELECTRIC,action = device_commands.Button_5,value = 1.0,message = _("PITOT SWITCH - ON"),message_timeout = std_message},
{time = add_time(std_dt),device = devices.AUTOPILOT,action = device_commands.Button_6,value = 1.0,message = _("TRIM SWITCH - ON"),message_timeout = std_message},
{time = add_time(std_dt),device = devices.AUTOPILOT,action = device_commands.Button_7,value = 1.0,message = _("MAGNETIC BRAKE SWITCH - ON"),message_timeout = std_message},
{time = add_time(std_dt),device = devices.AUTOPILOT,action = device_commands.Button_17,value = 0.5,message = _("GYRO KNOB - GM"),message_timeout = std_message},
{time = add_time(std_dt),device = devices.AUTOPILOT,action = device_commands.Button_2,value = 1.0,message = _("AUTOPILOT PITCH SWITCH - ON"),message_timeout = std_message},
{time = add_time(std_dt),device = devices.AUTOPILOT,action = device_commands.Button_3,value = 1.0,message = _("AUTOPILOT ROLL SWITCH - ON"),message_timeout = std_message},
{time = add_time(std_dt),device = devices.AUTOPILOT,action = device_commands.Button_4,value = 1.0,message = _("AUTOPILOT YAW SWITCH - ON"),message_timeout = std_message},
{time = add_time(std_dt),device = devices.AUTOPILOT,action = device_commands.Button_1,value = 1.0,message = _("AUTOPILOT MASTER SWITCH - ON"),message_timeout = std_message},
{time = add_time(std_dt),device = devices.FLIGHT_CONTROLS,action = device_commands.Button_12,value = 1.0,message = _("ARTIFICIAL HORIZON - UNLOCK"),message_timeout = std_message},
{time = add_time(4.0),device = devices.FLIGHT_CONTROLS,action = device_commands.Button_13,value = 1.0,message = _("STANDBY HORIZON - UNLOCK"),message_timeout = std_message},
{time = add_time(std_dt),device = devices.RADAR_ALTIMETER,action = device_commands.Button_4,value = 1.0,message = _("RADAR ALTIMETER - ON"),message_timeout = std_message},
{time = add_time(std_dt),device = devices.RADAR_ALTIMETER,action = device_commands.Button_5,value = 1.0,message = _("RADAR ALTIMETER - ALTITUDE SET"),message_timeout = std_message},
{time = add_time(std_dt),device = devices.NADIR,action = device_commands.Button_2,value = 0.4,message = _("NADIR - TERRE"),message_timeout = std_message},
{time = add_time(std_dt),message = _("WAIT FOR NADIR - If you want"),message_timeout = 10.0},
{time = add_time(10.0),message = _("AUTOSTART COMPLETE"),message_timeout = 20.0},
}

stop_sequence_full = {
{time = 0.0,message = _("STOP SEQUENCE IS RUNNING"),message_timeout = std_message},
{time = add_stop_time(std_dt),device = devices.FUEL,action = device_commands.Button_10,value = 1.0,message = _("FUEL FLOW LEVER - FULL BACKWARD"),message_timeout = 14.5},
{time = add_stop_time(std_dt+31.5),message = _("WAIT FOR ROTOR RPM < 170"),message_timeout = std_message},
{time = add_stop_time(std_dt+8.5),device = devices.SA342_BASE_FM,action = device_commands.Button_8,value = 1.0,message = _("ROTOR BRAKE - FULL BACKWARD"),message_timeout = std_message},
{time = add_stop_time(std_dt+2.0),device = devices.ELECTRIC,action = device_commands.Button_8,value = 0.0,message = _("STARTER SWITCH - OFF"),message_timeout = std_message},
{time = add_stop_time(std_dt),device = devices.ELECTRIC,action = device_commands.Button_6,value = 0.0,message = _("FUEL PUMP - OFF"),message_timeout = std_message},
{time = add_stop_time(std_dt),device = devices.ELECTRIC,action = device_commands.Button_3,value = 0.0,message = _("GENERATOR SWITCH - OFF"),message_timeout = std_message},
{time = add_stop_time(std_dt),device = devices.ELECTRIC,action = device_commands.Button_2,value = 0.0,message = _("ALTERNATOR SWITCH - OFF"),message_timeout = std_message},
{time = add_stop_time(std_dt),device = devices.ELECTRIC,action = device_commands.Button_1,value = 0.0,message = _("BATTERY SWITCH - OFF"),message_timeout = std_message},
{time = add_stop_time(std_dt),message = _("WAIT FOR ROTOR STOP"),message_timeout = std_message},
{time = add_stop_time(std_dt),device = devices.FLIGHT_CONTROLS,action = device_commands.Button_11,value = 1.0,message = _("DOORS - OPEN"),message_timeout = std_message},
{time = add_stop_time(std_dt),message = _("AUTOSTOP COMPLETE"),message_timeout = 20.0},
}

