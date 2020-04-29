local component = require("component")
local event = require("event")
local m = component.modem 
for k, n in pairs(m) do
  print(k,n)
end