function Pandoc(doc)
    for _, field in ipairs({ "title", "date" }) do
        local value = doc.meta[field]
        if value == nil or pandoc.utils.stringify(value):match("^%s*$") then
            error("missing required '" .. field .. "' metadata")
        end
    end

    return doc
end