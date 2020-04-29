local component = require("component")
local event = require("event")
local modem = component.modem 
local serial = require("serialization")
local file = io.open("/etc/network.cfg")

local text = file:read("*all")
file:close()
config = serial.unserialize(text)
modem.open(65535)
modem.setWakeMessage("wake" .. modem.address, true)

function send(hostname, port , message, ...)
    if type(hostname) == "string" then
            modem.send(config.dns.addr, 53, "get" ,hostname)
            _, _, _, _, _, addr = event.pull("modem_message")
            print(modem.send(addr,port,message, ...))
            return true
    else
        return false
    end
end

function wake(hostname)
    if type(hostname) == "string" then
            modem.send(config.dns.addr, 53, "get" ,hostname)
            _, _, _, _, _, addr = event.pull("modem_message")
            print(modem.send(addr,9,"wake"+addr))
            return true
    else
        return false
    end
end

function open(...)
    return modem.open(...)
end


function close(...)
    return modem.close(...)
end

function isOpen(...)
    return modem.isOpen(...)
end

function isWireless()
    return modem.iswireless()
end

function isWired()
    return modem.isWired()
end

function slot()
    return modem.slot()
end

function address()
    return modem.address()
end
function addr()
    return modem.address()
end
function broadcast(...)
    return modem.broadcast(...)
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