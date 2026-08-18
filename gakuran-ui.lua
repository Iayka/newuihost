-- Loader for the exact Lua script supplied by the user.
-- The script is split into raw text chunks only because of GitHub connector
-- upload-size limits. The chunks are concatenated before running.

local BASE = "https://raw.githubusercontent.com/Iayka/newuihost/main/parts/"
local PARTS = {
    "00.txt",
    "01.txt",
    "02.txt",
    "03.txt",
    "04.txt",
    "05.txt",
    "06.txt",
    "07.txt",
    "08.txt",
}

local chunks = {}

for i, fileName in ipairs(PARTS) do
    local part = game:HttpGet(BASE .. fileName)

    if type(part) ~= "string" or part == "" then
        error("[newuihost] failed to download " .. fileName)
    end

    chunks[i] = part
end

local source = table.concat(chunks)

-- Upstream Gakuran changed its UI host from neaxusxgod-png/INS-ui to
-- artxficial/INS-ui. The shared wrapper searches for that exact upstream
-- loader line, so update only the wrapper's search marker before compiling.
-- The replacement UI payload inside the shared script is left untouched.
local oldMarker = 'local _w=[[local UI_Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/neaxusxgod-png/INS-ui/main/uilib.min.lua"))() or INSui]]'
local newMarker = 'local _w=[[local UI_Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/artxficial/INS-ui/main/uilib.min.lua"))() or INSui]]'

local markerStart, markerEnd = string.find(source, oldMarker, 1, true)
if markerStart then
    source = string.sub(source, 1, markerStart - 1)
        .. newMarker
        .. string.sub(source, markerEnd + 1)
end

local chunk, compileError = loadstring(source)

if not chunk then
    error("[newuihost] compile failed: " .. tostring(compileError))
end

return chunk()
