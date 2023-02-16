require("hop").setup()

local map = require("conf/keymap").map

local keys = {
    { "f", "HopChar1", "by {char}" },
    { "s", "HopChar2", "by {char}{char}" },
    { "w", "HopWord", "by word" },
    { "l", "HopLine", "by line" },
}

for _, k in ipairs(keys) do
    for i = 1, 2 do
        map(
            { "n", "x" },
            string.format(
                "<leader><leader>%s",
                i == 1 and k[1] or string.upper(k[1])
            ), -- f/F
            string.format(
                "<cmd>%s<cr>",
                i == 1 and k[2] .. "AC" or k[2] .. "BC"
            ), -- HopChar1AC/HopChar1BC
            {
                desc = i == 1 and "Jump forward " .. k[3]
                    or "Jump backward " .. k[3],
            }
        )
    end
end
