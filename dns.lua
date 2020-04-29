local component = require("component")
local event = require("event")
local fs = require("filesystem")
local serial = require("serialization")
local term = require("term")
local modem = component.modem 

function register(name, addr)
    domain = string.gsub(name,'%.','')
    if liste[domain] == nil or liste[domain] ~= addr then
        liste[domain] = addr
        liste[addr] = addr
    end
    local file = io.open("/etc/dnsTable", "w")
    file:write(serial.serialize(liste))
    file:close()
    return true
end
function get(name)
    domain = string.gsub(name,'%.','')
    return liste[domain]
end
function startdns()
    modem.open(53)
    modem.open(65535)
    running = true
end
function stop()
    modem.close(53)
    modem.close(65535)
    running = false
end

startdns()
while running do
    _, _, from, port, _, fun, name, addr = event.pull("modem_message")
    if fs.exists("/etc/dnsTable") then
        local file = io.open("/etc/dnsTable", "r")
        local text = file:read("*all")
        file:close()
        liste = serial.unserialize(text)
    end
    if port == 53 then
        if fun == "get" then
            message = get(name)
            modem.send(from, 65535, message)
        elseif fun == "register" then
            message = register(name, addr)
            modem.send(from, 65535, message)
        elseif fun ==  "stop" then
            running = false
        end
    end
end