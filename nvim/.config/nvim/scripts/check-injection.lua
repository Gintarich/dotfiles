local function parse_args()
    local verbose = false
    local debug = false
    local file_path = nil

    for _, arg in ipairs(vim.fn.argv()) do
        if arg == "-v" or arg == "--verbose" then
            verbose = true
        elseif arg == "-d" or arg == "--debug" then
            debug = true
        elseif arg == "-h" or arg == "--help" then
            print([[check-injection.lua - Verify JSX injection in HTML files
Usage: nvim --headless -c "luafile ~/.config/nvim/scripts/check-injection.lua" [OPTIONS] [FILE]

Options:
  -v, --verbose    Show detailed output
  -d, --debug      Show debug information
  -h, --help       Show this help message
]])
            vim.cmd("cq")
            return nil
        elseif not file_path and not arg:match("^-") then
            file_path = arg
        end
    end

    return { verbose = verbose, debug = debug, file_path = file_path }
end

local function ensure_test_file(file_path)
    if file_path and vim.fn.filereadable(file_path) == 1 then
        return file_path
    end

    local tmp_file = "/tmp/test-jsx.html"
    local content = [[<html>
<head>
    <title>JSX Injection Test</title>
</head>
<body>
    <div class="js-container"></div>
    <script type="text/babel">
        const button = <button>hello</button>;
        const paragraph = <p>paragraph of text</p>;
        const div = <div>
            <button>hello</button>
            <p>paragraph of text</p>
        </div>;
        const container = document.querySelector('.js-container');
        ReactDOM.createRoot(container).render(div);
    </script>
</body>
</html>
]]

    vim.fn.writefile(vim.split(content, "\n"), tmp_file)
    return tmp_file
end

local function load_file_content(file_path)
    local lines = vim.fn.readfile(file_path)
    if not lines or #lines == 0 then
        return nil, "Failed to read test file"
    end
    return lines, nil
end

local function get_injection_status(buf, opts)
    local ok, parser = pcall(vim.treesitter.get_parser, buf, "html")
    if not ok then
        return { working = false, error = "Treesitter parser not available for html" }
    end

    parser:parse()
    local query = vim.treesitter.query.get("html", "injections")
    if not query then
        return { working = false, error = "No injections query loaded for html" }
    end

    local root = parser:parse()[1]:root()
    local found_injection = false
    local found_babel = false
    local capture_data = {}

    for id, node in query:iter_captures(root, buf, 0, -1) do
        local name = query.captures[id]
        local text = vim.treesitter.get_node_text(node, buf)
        capture_data[#capture_data + 1] = { name = name, text = text }
        if name == "injection.content" then
            found_injection = true
        end
        if name == "injection.language" and text == "tsx" then
            found_babel = true
        end
    end

    return {
        working = found_injection,
        captures = capture_data,
        parser = parser,
        root = root,
        found_babel = found_babel,
    }
end

local function print_results(status, opts)
    if status.error then
        print("ERROR: " .. status.error)
        return
    end

    if status.working then
        print("INJECTION WORKING")
    else
        print("INJECTION FAILED")
    end

    if status.found_babel then
        print("Detected babel injection language: tsx")
    end

    if opts.verbose then
        print("\nTree:")
        vim.treesitter.inspect_tree(status.parser)
    end

    if opts.debug then
        print("\nCaptures:")
        for _, capture in ipairs(status.captures or {}) do
            print(string.format("- %s: %s", capture.name, capture.text))
        end
    end
end

local function main()
    local opts = parse_args()
    if not opts then
        return
    end

    local file_path = ensure_test_file(opts.file_path)
    local lines, err = load_file_content(file_path)
    if err then
        print("ERROR: " .. err)
        vim.cmd("cq")
        return
    end

    local buf = vim.api.nvim_create_buf(true, false)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    vim.api.nvim_buf_set_option(buf, "filetype", "html")

    local status = get_injection_status(buf, opts)
    print_results(status, opts)

    vim.api.nvim_buf_delete(buf, { force = true })
    vim.cmd("cq")
end

main()
