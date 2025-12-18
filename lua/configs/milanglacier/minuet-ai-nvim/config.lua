require("minuet").setup({
  provider = "openai_fim_compatible",
  n_completions = 1, -- recommend for local model for resource saving
  context_window = 4096,
  provider_options = {
    -- ollama {{{
    openai_fim_compatible = {
      -- For Windows users, TERM may not be present in environment variables.
      -- Consider using APPDATA instead.
      api_key = "TERM",
      name = "Ollama",
      end_point = "http://localhost:11434/v1/completions",
      model = "qwen2.5-coder:14b",
      optional = {
        max_tokens = 56,
        top_p = 0.9,
      },
    },
    -- ollama }}}

    -- llama.cpp {{{
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
    -- llama.cpp }}}
  },
})

-- # 1. Ollama {{{
--
-- Install ollama with homebrew:
-- ```
-- brew install ollama
-- ```
--
-- Configure ollama model directory in .zshrc:
-- ```
-- export OLLAMA_MODELS=$HOME/.ollama/models
-- ```
--
-- Pull, run a model, then start a background service:
-- ```
-- ollama pull qwen2.5-coder:14b
-- ollama run qwen2.5-coder:14b
-- ollama serve
-- ```
--
-- It starts an api server on "http://127.0.0.1:11434".
-- # 1. Ollama }}}
--
--
-- # 2. Llama.cpp {{{
--
-- Install llama.cpp with homebrew:
-- ```
-- brew install llama.cpp
-- ```
--
-- Start llama.cpp service:
-- ```
-- llama-server \
--    -hf ggml-org/Qwen2.5-Coder-7B-Q8_0-GGUF \
--    --port 8012 -ngl 99 -fa on -ub 2048 -b 2048 \
--    --ctx-size 0 --cache-reuse 1024
-- ```
-- For full models list, please checkout here: https://huggingface.co/collections/ggml-org/llamavim.
--
-- It starts an api server on "http://localhost:8012".
-- # 2. Llama.cpp }}}
