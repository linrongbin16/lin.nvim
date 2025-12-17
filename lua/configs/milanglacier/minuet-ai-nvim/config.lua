require("minuet").setup({
  provider = "openai_fim_compatible",
  n_completions = 1, -- recommend for local model for resource saving
  context_window = 4096,
  provider_options = {

    -- llama.cpp
    --
    -- openai_fim_compatible = {
    --   -- For Windows users, TERM may not be present in environment variables.
    --   -- Consider using APPDATA instead.
    --   api_key = "TERM",
    --   name = "Llama.cpp",
    --   end_point = "http://localhost:8012/v1/completions",
    --   -- The model is set by the llama-cpp server and cannot be altered
    --   -- post-launch.
    --   model = "PLACEHOLDER",
    --   optional = {
    --     max_tokens = 56,
    --     top_p = 0.9,
    --   },
    --   -- Llama.cpp does not support the `suffix` option in FIM completion.
    --   -- Therefore, we must disable it and manually populate the special
    --   -- tokens required for FIM completion.
    --   template = {
    --     prompt = function(context_before_cursor, context_after_cursor, _)
    --       return "<|fim_prefix|>"
    --         .. context_before_cursor
    --         .. "<|fim_suffix|>"
    --         .. context_after_cursor
    --         .. "<|fim_middle|>"
    --     end,
    --     suffix = false,
    --   },
    -- },

    -- Ollama
    openai_fim_compatible = {
      api_key = "TERM",
      name = "Ollama",
      end_point = "http://localhost:11434/v1/completions",
      model = "qwen2.5-coder:14b",
      optional = {
        max_tokens = 56,
        top_p = 0.9,
      },
    },
  },
})

-- Use minuet-ai with llama.cpp local model:
--
-- Install llama.cpp with homebrew:
-- ```
-- brew install llama.cpp
-- ```
--
-- Run (and initialize) llama.cpp with Qwen2.5-Coder model:
--
-- For 32+GB memory machine, use 7B (7 billion parameters):
-- ```
-- llama-server \
--    -hf ggml-org/Qwen2.5-Coder-7B-Q8_0-GGUF \
--    --port 8012 -ngl 99 -fa on -ub 2048 -b 2048 \
--    --ctx-size 0 --cache-reuse 1024
-- ```
--
-- For 16+GB memory machine, use 3B:
-- ```
-- llama-server \
--    -hf ggml-org/Qwen2.5-Coder-3B-Q8_0-GGUF \
--    --port 8012 -ngl 99 -fa on -ub 2048 -b 2048 \
--    --ctx-size 0 --cache-reuse 1024
-- ```
--
-- For 8+GB memory machine, use 1.5B:
-- ```
-- llama-server \
--    -hf ggml-org/Qwen2.5-Coder-1.5B-Q8_0-GGUF \
--    --port 8012 -ngl 99 -fa on -ub 1024 -b 1024 \
--    --ctx-size 0 --cache-reuse 256
-- ```
--
-- It starts an api server on "http://localhost:8012", so minuet-ai can query it and provide LSP completion sources for blink.cmp.
-- For full models list, please checkout here: https://huggingface.co/collections/ggml-org/llamavim
