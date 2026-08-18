-- Loader for the exact script supplied by the user.
-- The source is stored unchanged in source.md; this removes only the outer
-- Markdown code fences before compiling it.
local URL = "https://raw.githubusercontent.com/Iayka/newuihost/main/source.md"
local source = game:HttpGet(URL)

if string.sub(source, 1, 3) == "```" then
    local newline = string.find(source, "\n", 1, true)
    if newline then
        source = string.sub(source, newline + 1)
    end
end

source = string.gsub(source, "\r?\n```%s*$", "", 1)

local chunk, compileError = loadstring(source)
if not chunk then
    error("[newuihost] compile failed: " .. tostring(compileError))
end

return chunk()
