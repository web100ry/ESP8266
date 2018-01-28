 --init.lua

wifi.setmode(wifi.STATION)
wifi.sta.config("MyPlace","8310000570")
wifi.sta.connect()
tmr.alarm(1, 5000, 1, function() 
    if wifi.sta.getip()== nil then
        print('IP unavaiable, waiting...') 
    else
        tmr.stop(1)
        print('IP is '..wifi.sta.getip())
        dofile('web.lua')
    
    end
 end)
