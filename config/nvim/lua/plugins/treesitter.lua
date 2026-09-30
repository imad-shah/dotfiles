return {
    'nvim-treesitter/nvim-treesitter',
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
        local treesitter = require("nvim-treesitter")
        treesitter.install({
            "python",
            "go",
            "lua",
            "rust",

            "gomod",
            "gosum",
            "luadoc",

            "bash",
            "json",
            "yaml",
            "toml",
            "markdown",
            "markdown_inline",
            "diff",
            "vim",
            "vimdoc",
            "query",
        })

        -- get_files instead of query.get: query.get caches its result, so a
        -- miss would stick after the queries get installed
        local function has_query(lang, name)
            return #vim.treesitter.query.get_files(lang, name) > 0
        end

        -- a parser alone is not enough: without a highlights query, starting
        -- treesitter would just switch the regex syntax off
        local function ready(lang)
            return vim.treesitter.language.add(lang) and has_query(lang, "highlights")
        end

        local function enable(buf, lang)
            if not vim.api.nvim_buf_is_loaded(buf) or not ready(lang) then
                return
            end
            vim.treesitter.start(buf, lang)
            if has_query(lang, "indents") then
                vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            end
        end

        vim.api.nvim_create_autocmd("FileType", {
            group = vim.api.nvim_create_augroup("treesitter_enable", { clear = true }),
            callback = function(args)
                local lang = vim.treesitter.language.get_lang(args.match)
                if not lang then
                    return
                end
                if ready(lang) then
                    enable(args.buf, lang)
                elseif vim.list_contains(treesitter.get_available(), lang) then
                    -- not installed yet: install it, then enable
                    treesitter.install(lang):await(function()
                        enable(args.buf, lang)
                    end)
                end
            end,
        })
    end
}
