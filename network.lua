--[[
53 - dns
67 - dhcp
68 - dhcp
647 - dhcp fallback
]]
local serial = require("serialization")
local file = io.open("/etc/network.cfg")
local text = file:read("*all")
file:close()
config = serial.unserialize(text)

local component = require("component")
local event = require("event")
local modem = component.modem 
modem.open(65535)

function send(hostname, port , message)
    if type(hostname) == "number" then
        if hostname == range(192168000000, 192168255255) then
            modem.send(config.ipdns.addresspriv, port)
        elseif hostname == nil then
            modem.send(config.ipdns.address, port)
        end
    elseif type(hostname) == "string" then
            modem.send(config.dns.addr, 53, "get" ,hostname)
            _, _, _, _, _, addr = event.pull("modem_message")
            modem.send(addr,port,message)
    else
        print("unsuppoted hostname type")
    end
end
function register(name)
    modem.send(config.dns.addr,53,"register", name, modem.address)
    _, _, _, _, _, status = event.pull("modem_message")
    if status then
        print("registerd")
    else
        print("didn't register")
    end
end
register("google.nl")