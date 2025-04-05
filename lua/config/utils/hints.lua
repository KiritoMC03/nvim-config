local M = {}

local supported_ft = {
	cs = true,
}

function M.toggle_inlay_hint(enalbed)
	if not supported_ft[vim.bo.filetype] then
		return
	end

	if enalbed then
		vim.cmd("call coc#config('inlayHint.enable', v:true)")
		vim.cmd("call coc#config('inlayHint.display', v:true)")
	else
		vim.cmd("call coc#config('inlayHint.enable', v:false)")
		vim.cmd("call coc#config('inlayHint.display', v:false)")
	end
end

return M
