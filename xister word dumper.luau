-- first xisters sb script : loadstring(game:HttpGet("https://raw.githubusercontent.com/codexvsberserkerxylo/SBscripts/refs/heads/main/lunarX"))()
-- first xisters sb word dumper
-- made by nick (.weound) 
-- ud

local v = "v0.60"
local success, result = pcall(function()
    return game:HttpGet("https://raw.githubusercontent.com/codexvsberserkerxylo/SBscripts/refs/heads/main/v")
end)
if success and type(result) == "string" then
    v = result:gsub('"', ''):gsub('%s', '') 
end

local t1 = os.clock()

local defs = {}
local rsfound

for _, child in ipairs(game:GetService("ReplicatedStorage"):GetChildren()) do
    if child:IsA("ModuleScript") and child.Name:match("Words") and child.Name ~= "Kohl's Admin Source" and not child.Name:match("[%z\128-\255]") then
        rsfound = child
        break
    end
end

if rsfound then
    local s, r = pcall(require, rsfound)
    if s and type(r) == "table" then
        defs = r
    end
end

local tform = os.date("%x %I:%M:%S %p")
local out = "-- .gg/q5BCRbUmf7\n-- Lunar X " .. v .. "\n-- time : " .. tform .. "\nreturn {\n"

local entries = {}

for _, val in ipairs(defs) do
    if type(val) == "table" then
        local word = val[1]
        local id = val[2]
        local def = val[3]
        local alt = val[4]
        
        if word and id and def then
            table.insert(entries, {
                word = tostring(word),
                id = tostring(id),
                def = tostring(def),
                alt = alt
            })
        end
    end
end

table.sort(entries, function(a, b) 
    return a.word:lower() < b.word:lower() 
end)

for _, entry in ipairs(entries) do
    local safew = string.format("%q", entry.word)
    local safed = string.format("%q", entry.def)
    local ids = entry.id
    
    if type(entry.alt) == "table" and #entry.alt > 0 then
        local alts = "{ "
        for i, a in ipairs(entry.alt) do
            alts = alts .. string.format("%q", tostring(a))
            if i < #entry.alt then alts = alts .. ", " end
        end
        alts = alts .. " }"
        
        out = out .. '\t{ ' .. safew .. ', ' .. ids .. ', ' .. safed .. ', ' .. alts .. ' },\n'
    else
        out = out .. '\t{ ' .. safew .. ', ' .. ids .. ', ' .. safed .. ' },\n'
    end
end

out = out .. "}"

local dt = os.clock() - t1
local dumptime = string.format("%.4f", dt)
out = out:gsub("return {", "-- took : " .. dumptime .. "s\nreturn {")

--setclipboard(out)
writefile("xister-dump.lua", out)
