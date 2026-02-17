Locales = {}

function _L(key, ...)
    local lang = Config.Locale or 'fr'
    local str = Locales[lang] and Locales[lang][key]

    if not str then
        -- Fallback to French if key not found in selected language
        str = Locales['fr'] and Locales['fr'][key]
    end

    if not str then
        return key
    end

    if ... then
        return string.format(str, ...)
    end

    return str
end
