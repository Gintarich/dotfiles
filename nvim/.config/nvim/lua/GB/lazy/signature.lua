return{
    "ray-x/lsp_signature.nvim",
    enabled = false,
    event = "VeryLazy",
    opts = {
        select_signature_key = 'M-n',
    },
    config = function(_, opts) 
        require'lsp_signature'.setup(opts)
    end

}
