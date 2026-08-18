-- Loader for the exact Lua script supplied by the user.
-- The script is split into raw text chunks only because of GitHub connector
-- upload-size limits. The chunks are concatenated byte-for-byte before running.

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
local chunk, compileError = loadstring(source)

if not chunk then
    error("[newuihost] compile failed: " .. tostring(compileError))
end

return chunk()
