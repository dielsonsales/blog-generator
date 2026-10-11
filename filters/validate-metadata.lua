function Pandoc(doc)
    for _, field in ipairs({ "title", "date" }) do
        local value = doc.meta[field]
        if value == nil or pandoc.utils.stringify(value):match("^%s*$") then
            error("missing required '" .. field .. "' metadata")
        end
    end

    local date_text = pandoc.utils.stringify(doc.meta.date)
    local year, month, day = date_text:match("^(%d%d%d%d)%-(%d%d)%-(%d%d)")
    local month_names = {
        "Jan", "Feb", "Mar", "Apr", "May", "Jun",
        "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
    }
    local month_name = month and month_names[tonumber(month)]
    if month_name then
        doc.meta.date = pandoc.MetaString(month_name .. " " .. tonumber(day) .. ", " .. year)
    end

    return doc
end