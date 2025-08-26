local function findAndRunExecutable(folder)
    local exe_path = vim.fn.glob("**/bin/**/*.exe", false, true)[1]
    if #exe_path > 0 then
        print("Running executable:", exe_path)
        vim.fn.jobstart(exe_path, { detach = 1 })
    else
        print("No executable found.")
    end
end

local function findAndBuild()
    local sln_files = vim.fn.glob('*.sln')
    print(sln_files)
    local sln_files_deeper = vim.fn.glob('**/*.sln')
    if #sln_files > 0 then
        P(vim.fn.system('MSBuild.exe' .. sln_files))
    elseif #sln_files_deeper > 0 then
        vim.fn.system('MSBuild.exe' .. sln_files_deeper)
    else
        print("No sln file found")
    end
end

local function buildProj()
    local csproj_files = vim.fn.glob('**/*.csproj', false, true)
    if #csproj_files > 0 then
        print(vim.fn.system('MSBuild.exe ' .. csproj_files[1]))
    else
        print("No csproj file found")
    end
end

function BuildRunGB()
    -- local root_dir = vim.fn.getcwd()
    -- print("Root dir:" .. root_dir)
    buildProj()
    findAndRunExecutable()
end
-- vim.keymap.set('n', '<C-b>', BuildRunGB)
