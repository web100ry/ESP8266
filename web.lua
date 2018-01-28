pinDHT = 7

function Set_gpio(gpio_name, val)
    --print(gpio_name.."="..val)
    
    local gpio_val = gpio.LOW
    if (val ~= "0") then gpio_val = gpio.HIGH; end
       
    if (gpio_name == "GPIO00") then gpio.mode(3, gpio.OUTPUT); gpio.write(3, gpio_val);
    elseif (gpio_name == "GPIO01") then gpio.mode(10, gpio.OUTPUT);  gpio.write(10, gpio_val);
    elseif (gpio_name == "GPIO02") then gpio.mode(4, gpio.OUTPUT);  gpio.write(4, gpio_val);
    elseif (gpio_name == "GPIO03") then gpio.mode(9, gpio.OUTPUT);  gpio.write(9, gpio_val);
    elseif (gpio_name == "GPIO04") then gpio.mode(2, gpio.OUTPUT);  gpio.write(2, gpio_val);
    elseif (gpio_name == "GPIO05") then gpio.mode(1, gpio.OUTPUT);  gpio.write(1, gpio_val);
    elseif (gpio_name == "GPIO09") then gpio.mode(11, gpio.OUTPUT);  gpio.write(11, gpio_val);
    elseif (gpio_name == "GPIO10") then gpio.mode(12, gpio.OUTPUT);  gpio.write(12, gpio_val);
    elseif (gpio_name == "GPIO12") then gpio.mode(6, gpio.OUTPUT);  gpio.write(6, gpio_val);
    elseif (gpio_name == "GPIO13") then gpio.mode(7, gpio.OUTPUT);  gpio.write(7, gpio_val);
    elseif (gpio_name == "GPIO14") then gpio.mode(5, gpio.OUTPUT);  gpio.write(5, gpio_val);
    elseif (gpio_name == "GPIO15") then gpio.mode(8, gpio.OUTPUT);  gpio.write(8, gpio_val);
    elseif (gpio_name == "GPIO16") then gpio.mode(0, gpio.OUTPUT);  gpio.write(0, gpio_val);
    end
end

srv=net.createServer(net.TCP)
srv:listen(80, function(conn)
    conn:on("receive", function(client, request)
        print(request)
        local _, _, method, path, vars = string.find(request, "([A-Z]+) (.+)?(.+) HTTP");

        if (vars ~= nil)then
            for k, v in string.gmatch(vars, "(%w+)=(%w+)&*") do
                Set_gpio(k, v)
            end
        end

        local buf = "HTTP/1.1 200 OK\r\n";
        buf = buf.."Content-type: text/html\r\n";
        buf = buf.."Connection: close\r\n\r\n";
        buf = buf.."<html><body>";
        buf = buf.."<h1> ESP8266 Web Server</h1>";

        local status,temp,humi,temp_decimal,humi_decimal = dht.read(pinDHT)
        if (status == dht.OK) then
            buf = buf.."<p>Temperature: "..temp.."."..temp_decimal.." C</p>";
            buf = buf.."<p>Humidity: "..humi.."."..humi_decimal.." %</p>";
           
        elseif (status == dht.ERROR_CHECKSUM) then
            buf = buf.."<p>DHT Checksum error</p>";
        elseif (status == dht.ERROR_TIMEOUT) then
            buf = buf.."<p>DHT Time out</p>";
        end
        
 --      buf = buf.. "<br><p><H1>TEST1</H1></p>";
    buf = buf.."<p>GPIO00 <a href=\"?GPIO00=1\"><button>ON</button></a><a href=\"?GPIO00=0\"><button>OFF</button></a></p>";
    buf = buf.."<p>GPIO01 <a href=\"?GPIO01=1\"><button>ON</button></a><a href=\"?GPIO01=0\"><button>OFF</button></a></p>";
    buf = buf.."<p>GPIO02 <a href=\"?GPIO02=1\"><button>ON</button></a><a href=\"?GPIO02=0\"><button>OFF</button></a></p>";
    buf = buf.."<p>GPIO03 <a href=\"?GPIO03=1\"><button>ON</button></a><a href=\"?GPIO03=0\"><button>OFF</button></a></p>";
    buf = buf.."<p>GPIO04 <a href=\"?GPIO04=1\"><button>ON</button></a><a href=\"?GPIO04=0\"><button>OFF</button></a></p>";
    buf = buf.."<p>GPIO05 <a href=\"?GPIO05=1\"><button>ON</button></a><a href=\"?GPIO05=0\"><button>OFF</button></a></p>";
    buf = buf.."<p>GPIO09 <a href=\"?GPIO09=1\"><button>ON</button></a><a href=\"?GPIO09=0\"><button>OFF</button></a></p>";
    buf = buf.."<p>GPIO10 <a href=\"?GPIO10=1\"><button>ON</button></a><a href=\"?GPIO10=0\"><button>OFF</button></a></p>";
    buf = buf.."<p>GPIO12 <a href=\"?GPIO12=1\"><button>ON</button></a><a href=\"?GPIO12=0\"><button>OFF</button></a></p>";
 --   buf = buf.."<p>GPIO13 <a href=\"?GPIO13=1\"><button>ON</button></a><a href=\"?GPIO13=0\"><button>OFF</button></a></p>";
    buf = buf.."<p>GPIO14 <a href=\"?GPIO14=1\"><button>ON</button></a><a href=\"?GPIO14=0\"><button>OFF</button></a></p>";
    buf = buf.."<p>GPIO15 <a href=\"?GPIO15=1\"><button>ON</button></a><a href=\"?GPIO15=0\"><button>OFF</button></a></p>";
    buf = buf.."<p>GPIO16 <a href=\"?GPIO16=1\"><button>ON</button></a><a href=\"?GPIO16=0\"><button>OFF</button></a></p>";
client:send(buf);
      --  buf1 = buf1.."</body></html>";

     --   client:send(buf1);
        client:close();
        collectgarbage();
    end)
end)
