-- first and best stormys sb script : https://github.com/codexvsberserkerxylo/SBscripts/blob/main/lunarX
-- this is the first and best stormys sb definition, soundid dumper. current word dump : https://github.com/codexvsberserkerxylo/SBscripts/blob/main/stormy%20sb%20word%20dump.lua
-- made by nick (.weound) at like 2:50 am dont judge code

-- fetch version
local v = "v0.60" -- fallback
local success, result = pcall(function()
    return game:HttpGet("https://raw.githubusercontent.com/codexvsberserkerxylo/SBscripts/refs/heads/main/v")
end)
if success and type(result) == "string" then
    v = result:gsub('"', ''):gsub('%s', '') 
end

-- tables
local meme = {
    "Easy Memes",
    "Advanced Memes",
    "Extreme Memes",
}

local default = {
    "Easy Words",
    "Advanced Words",
    "Extreme Words",
    "Impossible Words",
}
-- tables end

local function find(name)
   local search = game.SoundService
   if not search then return end
   if search then
      local found = search:WaitForChild(name)
      local children = found:GetChildren()
      if children ~= nil then 
         return children 
        else
         warn("no children")
         return
      end
   end
end

local t1 = os.clock()
local founddefault = {}
for _, diff in ipairs(default) do
    local children = find(diff)
    if children then
        local group = {}
        for _, c in ipairs(children) do
            table.insert(group, c)
        end
        table.sort(group, function(a, b) 
            return a.Name:lower() < b.Name:lower() 
        end)
        table.insert(founddefault, {diff = diff, items = group})
    end
end
local tdef = os.clock() - t1

local t2 = os.clock()
local foundmeme = {}
for _, diff in ipairs(meme) do
    local children = find(diff)
    if children then
        local group = {}
        for _, c in ipairs(children) do
            table.insert(group, c)
        end
        table.sort(group, function(a, b) 
            return a.Name:lower() < b.Name:lower() 
        end)
        table.insert(foundmeme, {diff = diff, items = group})
    end
end
local tmem = os.clock() - t2

local t3 = os.clock()
local defs = {}
local rsfound = game.ReplicatedStorage:FindFirstChild("wordDefinitions")
if rsfound then
    -- require()
    local s, r = pcall(require, rsfound)
    if s and type(r) == "table" then
        defs = r
    else
        warn("couldnt require defs")
    end
else
    warn("defs not found")
end
local tdefs = os.clock() - t3

print(foundmeme) -- output: table: 0x...
print(founddefault) -- output: table: 0x...(idk why i added these)
print(defs) -- output: table: 0x...

local function format(t, tname, dt)
   if not t then return "err" end
   
   -- handles am / pm
   local tform = os.date("%x %I:%M:%S %p")
   local dumptime = string.format("%.4f", dt)

   local words = 0
   for _, group in ipairs(t) do
       if group.items then
           words = words + #group.items
       end
   end
   
   local startsec = "-- .gg/q5BCRbUmf7\n-- dumped by Lunar X " .. v .. "\n-- time : ".. tform .."\n-- took : ".. dumptime .."s\n-- total words : " .. words .. "\n\nlocal " .. tname .. " = {\n"
   local endsec = "} -- table " .. tname
   
   local body = ""
   for _, group in ipairs(t) do
      body = body .. "\t-- " .. group.diff .. "\n"
      
      for _, c in ipairs(group.items) do
         local name = c.Name
         local id = tostring(c.SoundId) 
         
         local other = c:FindFirstChild("otherSpelling")
         local comm = ""
         if other and other:IsA("StringValue") then
             comm = " -- other: " .. tostring(other.Value)
         end

         local s = name:gsub('"', '\\"')
         
         local template = '\t["' .. s .. '"] = "' .. id .. '",' .. comm .. '\n'
         body = body .. template
      end
   end
   
   return startsec .. body .. endsec
end

local function formatDict(t, tname, dt)
   if not t then return "err" end
   if type(t) == "table" then
      local tform = os.date("%x %I:%M:%S %p")
      local dumptime = string.format("%.4f", dt)
      
      local keys = {}
      for key in pairs(t) do
          table.insert(keys, key)
      end
      table.sort(keys, function(a, b) 
          return tostring(a):lower() < tostring(b):lower() 
      end)
      
      local words = #keys
      local startsec = "-- .gg/q5BCRbUmf7\n-- dumped by Lunar X " .. v .. "\n-- time : ".. tform .."\n-- took : ".. dumptime .."s\n-- total definitions : " .. words .. "\n\nlocal " .. tname .. " = {\n"
      local endsec = "} -- table " .. tname
      
      local keys = {}
      for key in pairs(t) do
          table.insert(keys, key)
      end
      table.sort(keys, function(a, b) 
          return tostring(a):lower() < tostring(b):lower() 
      end)
      
      local body = ""
      for _, key in ipairs(keys) do
         local val = t[key]
         local template = '\t["' .. tostring(key) .. '"] = ' .. string.format("%q", tostring(val)) .. ',\n'
         body = body .. template
      end
      
      return startsec .. body .. endsec
   end
end

-- init 67
local formattedmeme = format(foundmeme, "memes", tmem)
local formatteddefault = format(founddefault, "ids", tdef)
local formatteddefs = formatDict(defs, "defs", tdefs)
setclipboard(formatteddefault .. "\n\n" .. formattedmeme .. "\n\n" .. formatteddefs) -- ez
