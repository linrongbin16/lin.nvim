require("codecompanion").setup({
  adapters = {
    http = {
      ["llama.cpp"] = function()
        return require("codecompanion.adapters").extend("openai_compatible", {
          env = {
            url = "http://127.0.0.1:8012", -- replace with your llama.cpp instance
            api_key = "TERM",
            chat_url = "/v1/chat/completions",
          },
          handlers = {
            parse_message_meta = function(self, data)
              local extra = data.extra
              if extra and extra.reasoning_content then
                data.output.reasoning = { content = extra.reasoning_content }
                if data.output.content == "" then
                  data.output.content = nil
                end
              end
              return data
            end,
          },
        })
      end,
    },
  },
  interactions = {
    chat = {
      adapter = "llama.cpp",
    },
    inline = {
      adapter = "llama.cpp",
    },
  },
})

-- Use llama.cpp, see minuet-ai.nvim config: `lua/configs/milanglacier/minuet-ai-nvim/config.lua`
