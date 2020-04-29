local event = require("event")
while true do
    require("component").modem.open(80)
    print(event.pull("modem_message"))
    require("component").modem.close(80)
end