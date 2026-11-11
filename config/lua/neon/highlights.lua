-- Grupos de resaltado del tema neon. Los colores salen de la paleta del
-- wallpaper (ver neon/palette.lua); aqui solo se reparten.
local palette = require("neon.palette")
local mix = palette.mix

local M = {}

--- @param p table paleta con solid/accent1/accent2/text/muted/power/bg_alpha
--- @return table<string, table|string>
function M.build(p)
	local solid = p.solid
	local a1, a2 = p.accent1, p.accent2
	local text, muted, power = p.text, p.muted, p.power
	-- El dotfiles deja neon_bg con alfa < 1 (barra translucida). En nvim no hay
	-- alfa, asi que se usa fondo transparente para que se vea el terminal; se
	-- puede forzar opaco con `vim.g.neon_transparent = false`.
	local transparent = vim.g.neon_transparent
	if transparent == nil then
		transparent = p.bg_alpha < 0.9
	end

	local bg = transparent and "NONE" or solid
	local bg_float = mix(solid, a1, 0.05)
	local bg_alt = mix(solid, a1, 0.08)
	local bg_sel = mix(solid, a2, 0.28)
	local bg_status = mix(solid, a1, 0.14)
	local bg_pmenu = mix(solid, a1, 0.07)
	local bg_line = mix(solid, a1, 0.10)
	local bg_virtual = mix(solid, a1, 0.10)
	local faint = mix(muted, solid, 0.35)

	local hl = {
		-- base
		Normal = { fg = text, bg = bg },
		NormalNC = { fg = muted, bg = bg },
		NormalFloat = { fg = text, bg = bg_float },
		FloatBorder = { fg = a1, bg = bg_float },
		FloatTitle = { fg = solid, bg = a1, bold = true },
		FloatFooter = { fg = muted, bg = bg_float },
		Cursor = { fg = solid, bg = a1 },
		TermCursor = { fg = solid, bg = a1 },
		CursorLine = { bg = bg_alt },
		CursorColumn = { bg = bg_alt },
		ColorColumn = { bg = bg_alt },
		CursorLineNr = { fg = a1, bold = true },
		CursorLineSign = { bg = bg_alt },
		LineNr = { fg = faint },
		SignColumn = { fg = muted, bg = bg },
		FoldColumn = { fg = muted, bg = bg },
		Folded = { fg = muted, bg = mix(solid, a2, 0.12) },
		WinSeparator = { fg = mix(solid, a1, 0.30) },
		VertSplit = "WinSeparator",
		StatusLine = { fg = text, bg = bg_status },
		StatusLineNC = { fg = muted, bg = mix(solid, a1, 0.05) },
		TabLine = { fg = muted, bg = solid },
		TabLineSel = { fg = a1, bg = bg_line, bold = true },
		TabLineFill = { bg = solid },
		Visual = { bg = bg_sel },
		VisualNOS = { bg = bg_sel },
		Search = { fg = solid, bg = mix(a1, "#ffffff", 0.15), bold = true },
		IncSearch = { fg = solid, bg = a1, bold = true },
		CurSearch = { fg = solid, bg = a2, bold = true },
		MatchParen = { fg = a1, bold = true, underline = true },
		Pmenu = { fg = text, bg = bg_pmenu },
		PmenuSel = { fg = solid, bg = a1, bold = true },
		PmenuSbar = { bg = mix(solid, a1, 0.18) },
		PmenuThumb = { bg = a1 },
		Directory = { fg = a1 },
		Title = { fg = a1, bold = true },
		ErrorMsg = { fg = power, bold = true },
		WarningMsg = { fg = a2 },
		MoreMsg = { fg = a1 },
		Question = { fg = a1 },
		NonText = { fg = faint },
		SpecialKey = { fg = faint },
		Whitespace = { fg = mix(muted, solid, 0.5) },
		EndOfBuffer = { fg = solid, bg = bg },
		QuickFixLine = { bg = mix(solid, a1, 0.18) },
		WildMenu = { fg = solid, bg = a1 },
		ModeMsg = { fg = a1, bold = true },
		MsgArea = { fg = text },
		MsgSeparator = { fg = mix(solid, a1, 0.30), bg = bg_status },
		Cmdline = { fg = text },
		CursorLineFold = { fg = mix(solid, a1, 0.30) },

		-- treesitter
		["@comment"] = { fg = muted, italic = true },
		["@comment.documentation"] = { fg = mix(muted, text, 0.25), italic = true },
		["@keyword"] = { fg = a2, bold = true },
		["@keyword.function"] = { fg = a2, bold = true },
		["@keyword.operator"] = { fg = a2 },
		["@keyword.return"] = { fg = power, bold = true },
		["@string"] = { fg = mix(a1, text, 0.35) },
		["@string.escape"] = { fg = a2, bold = true },
		["@string.special"] = { fg = a2 },
		["@number"] = { fg = a2 },
		["@boolean"] = { fg = a2 },
		["@constant"] = { fg = a2 },
		["@constant.builtin"] = { fg = a2, italic = true },
		["@function"] = { fg = a1, bold = true },
		["@function.call"] = { fg = a1 },
		["@function.builtin"] = { fg = a1, italic = true },
		["@method"] = { fg = a1 },
		["@method.call"] = { fg = a1 },
		["@constructor"] = { fg = a1 },
		["@variable"] = { fg = text },
		["@variable.builtin"] = { fg = a2, italic = true },
		["@variable.parameter"] = { fg = mix(text, a2, 0.35) },
		["@parameter"] = { fg = mix(text, a2, 0.35) },
		["@property"] = { fg = mix(text, a1, 0.40) },
		["@field"] = { fg = mix(text, a1, 0.40) },
		["@type"] = { fg = a2 },
		["@type.builtin"] = { fg = a2, italic = true },
		["@type.qualifier"] = { fg = a2, bold = true },
		["@namespace"] = { fg = a1 },
		["@module"] = { fg = a1 },
		["@operator"] = { fg = a2 },
		["@punctuation"] = { fg = muted },
		["@punctuation.bracket"] = { fg = mix(muted, text, 0.30) },
		["@punctuation.delimiter"] = { fg = muted },
		["@tag"] = { fg = a2 },
		["@tag.attribute"] = { fg = a1 },
		["@tag.delimiter"] = { fg = muted },
		["@attribute"] = { fg = a1 },
		["@label"] = { fg = a2 },
		["@special"] = { fg = power },
		["@text.title"] = { fg = a1, bold = true },
		["@text.literal"] = { fg = mix(a1, text, 0.35) },
		["@text.uri"] = { fg = a1, underline = true },
		["@markup.link"] = { fg = a1, underline = true },
		["@markup.heading"] = { fg = a1, bold = true },
		["@markup.italic"] = { italic = true },
		["@markup.strong"] = { bold = true },

		-- LSP
		LspReferenceText = { bg = mix(solid, a1, 0.22) },
		LspReferenceRead = { bg = mix(solid, a1, 0.16) },
		LspReferenceWrite = { bg = mix(solid, a2, 0.24) },
		LspSignatureActiveParameter = { fg = a2, bold = true },
		LspCodeLens = { fg = mix(muted, a1, 0.30), italic = true },
		LspInlayHint = { fg = faint, italic = true },

		-- diagnósticos
		DiagnosticError = { fg = power },
		DiagnosticWarn = { fg = a2 },
		DiagnosticInfo = { fg = a1 },
		DiagnosticHint = { fg = muted },
		DiagnosticOk = { fg = a1 },
		DiagnosticUnderlineError = { sp = power, undercurl = true },
		DiagnosticUnderlineWarn = { sp = a2, undercurl = true },
		DiagnosticUnderlineInfo = { sp = a1, undercurl = true },
		DiagnosticUnderlineHint = { sp = muted, undercurl = true },
		DiagnosticUnderlineOk = { sp = a1, undercurl = true },
		DiagnosticVirtualTextError = { fg = power, bg = transparent and "NONE" or bg_virtual },
		DiagnosticVirtualTextWarn = { fg = a2, bg = transparent and "NONE" or bg_virtual },
		DiagnosticVirtualTextInfo = { fg = a1, bg = transparent and "NONE" or bg_virtual },
		DiagnosticVirtualTextHint = { fg = muted, bg = transparent and "NONE" or bg_virtual },
		DiagnosticVirtualTextOk = { fg = a1, bg = transparent and "NONE" or bg_virtual },
		DiagnosticSignError = { fg = power },
		DiagnosticSignWarn = { fg = a2 },
		DiagnosticSignInfo = { fg = a1 },
		DiagnosticSignHint = { fg = muted },
		DiagnosticSignOk = { fg = a1 },
		DiagnosticFloatingError = { fg = power },
		DiagnosticFloatingWarn = { fg = a2 },
		DiagnosticFloatingInfo = { fg = a1 },
		DiagnosticFloatingHint = { fg = muted },
		DiagnosticFloatingOk = { fg = a1 },

		-- git
		GitSignsAdd = { fg = a1 },
		GitSignsChange = { fg = a2 },
		GitSignsDelete = { fg = power },
		GitSignsAddNr = { fg = a1 },
		GitSignsChangeNr = { fg = a2 },
		GitSignsDeleteNr = { fg = power },

		-- telescope
		TelescopeNormal = { fg = text, bg = bg_float },
		TelescopeBorder = { fg = a1, bg = bg_float },
		TelescopeTitle = { fg = solid, bg = a1, bold = true },
		TelescopePromptNormal = { fg = text, bg = mix(solid, a1, 0.10) },
		TelescopePromptBorder = { fg = a1, bg = mix(solid, a1, 0.10) },
		TelescopePromptTitle = { fg = solid, bg = a1, bold = true },
		TelescopeResultsTitle = { fg = a2, bg = bg_float, bold = true },
		TelescopePreviewTitle = { fg = a2, bg = bg_float, bold = true },
		TelescopeSelection = { fg = text, bg = mix(solid, a1, 0.25), bold = true },
		TelescopeSelectionCaret = { fg = a1 },
		TelescopeMatching = { fg = a2, bold = true },
		TelescopeMultiSelection = { fg = a1 },
		TelescopeResultsDiffAdd = { fg = a1 },
		TelescopeResultsDiffChange = { fg = a2 },
		TelescopeResultsDiffDelete = { fg = power },

		-- which-key
		WhichKey = { fg = a1 },
		WhichKeyGroup = { fg = a2, bold = true },
		WhichKeyDesc = { fg = text },
		WhichKeySeparator = { fg = muted },
		WhichKeyFloat = { bg = bg_float },
		WhichKeyBorder = { fg = a1, bg = bg_float },
		WhichKeyValue = { fg = muted },

		-- bufferline
		BufferLineFill = { bg = transparent and "NONE" or solid },
		BufferLineBackground = { fg = muted, bg = transparent and "NONE" or solid },
		BufferLineBufferSelected = { fg = a1, bg = bg_line, bold = true },
		BufferLineBufferVisible = { fg = text, bg = transparent and "NONE" or solid },
		BufferLineIndicatorSelected = { fg = a1, bg = bg_line },
		BufferLineSeparator = { fg = mix(solid, a1, 0.25), bg = transparent and "NONE" or solid },
		BufferLineModified = { fg = a2 },
		BufferLineModifiedSelected = { fg = a2 },
		BufferLineModifiedVisible = { fg = a2 },
		BufferLineCloseButton = { fg = power },

		-- snacks (picker, dashboard, notificaciones)
		SnacksPicker = { fg = text, bg = bg_float },
		SnacksPickerBorder = { fg = a1, bg = bg_float },
		SnacksPickerTitle = { fg = solid, bg = a1, bold = true },
		SnacksPickerMatch = { fg = a2, bold = true },
		SnacksPickerSelected = { fg = a1, bg = mix(solid, a1, 0.22) },
		SnacksPickerDir = { fg = muted },
		SnacksPickerFile = { fg = text },
		SnacksPickerIcon = { fg = a1 },
		SnacksNotifierInfo = { fg = a1 },
		SnacksNotifierWarn = { fg = a2 },
		SnacksNotifierError = { fg = power },
		SnacksDashboardHeader = { fg = a1, bold = true },
		SnacksDashboardIcon = { fg = a2 },
		SnacksDashboardDesc = { fg = text },
		SnacksDashboardKey = { fg = a2 },
		SnacksDashboardFooter = { fg = muted },

		-- nvim-cmp
		CmpItemAbbr = { fg = text },
		CmpItemAbbrMatch = { fg = a1, bold = true },
		CmpItemAbbrMatchFuzzy = { fg = a1, bold = true },
		CmpItemKind = { fg = a2 },
		CmpItemMenu = { fg = muted },
		CmpGhostText = { fg = faint },
		CmpDocumentation = { fg = text, bg = bg_float },
		CmpDocumentationBorder = { fg = a1, bg = bg_float },

		-- lazy
		LazyNormal = { fg = text, bg = bg_float },
		LazyButton = { fg = text, bg = mix(solid, a1, 0.08) },
		LazyButtonActive = { fg = solid, bg = a1, bold = true },
		LazySpecial = { fg = a1 },
		LazyH1 = { fg = solid, bg = a1, bold = true },
		LazyH2 = { fg = a2, bold = true },
		LazyCommit = { fg = a2 },
		LazyUrl = { fg = a1, underline = true },

		-- noice
		NoiceCmdline = { fg = text, bg = bg_float },
		NoiceCmdlineIcon = { fg = a1 },
		NoiceCmdlinePopup = { fg = text, bg = bg_float },
		NoiceCmdlinePopupBorder = { fg = a1, bg = bg_float },
		NoiceCmdlinePopupTitle = { fg = solid, bg = a1, bold = true },
		NoiceLspProgressTitle = { fg = a2, bold = true },

		-- trouble
		TroubleNormal = { fg = text, bg = bg_float },
		TroubleText = { fg = text },
		TroubleCount = { fg = a2, bold = true },
		TroubleSource = { fg = muted },
		TroubleIconDirectory = { fg = a1 },
		TroubleFile = { fg = text },
		TroubleLocation = { fg = muted },

		-- dap
		DapUIStoppedThread = { fg = a1, bold = true },
		DapUIScope = { fg = a1 },
		DapUIBreakpointsCurrentLine = { fg = a2, bold = true },
		DapUIBreakpointsPath = { fg = a1 },
		DapUIBreakpointsDisabledLine = { fg = faint },
		DapUIPlayPause = { fg = a1 },
		DapUIStepOver = { fg = a2 },
		DapUIStepInto = { fg = a2 },
		DapUIStepOut = { fg = a2 },

		-- notify
		NotifyERRORBorder = { fg = power },
		NotifyWARNBorder = { fg = a2 },
		NotifyINFOBorder = { fg = a1 },
		NotifyDEBUGBorder = { fg = muted },
		NotifyTRACEBorder = { fg = muted },
		NotifyERRORIcon = { fg = power },
		NotifyWARNIcon = { fg = a2 },
		NotifyINFOIcon = { fg = a1 },

		-- iconos
		MiniIconsRed = { fg = power },
		MiniIconsOrange = { fg = a2 },
		MiniIconsYellow = { fg = a2 },
		MiniIconsGreen = { fg = a1 },
		MiniIconsAzure = { fg = a1 },
		MiniIconsBlue = { fg = a1 },
		MiniIconsCyan = { fg = a1 },
		MiniIconsPurple = { fg = a2 },
		MiniIconsGrey = { fg = muted },
	}

	return hl
end

return M
