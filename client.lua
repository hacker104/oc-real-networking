local packagename="dnsocclient"
local shell=require("shell")
local fs=require("filesystem")
fs.rename("/etc/oppm.cfg", "/etc/oppm.cfg.bck")
shell.execute("pastebin get aaZTqY9T /etc/oppm.cfg")
shell.execute("oppm install "..packagename)
fs.remove("/etc/oppm.cfg")
fs.rename("/etc/oppm.cfg.bck", "/etc/oppm.cfg")
shell.execute("/usr/bin/dnsinstall")