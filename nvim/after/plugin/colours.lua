function SetColourScheme(colour)
	colour = colour or "carbonfox"
	vim.cmd.colorscheme(colour)
end

SetColourScheme()
