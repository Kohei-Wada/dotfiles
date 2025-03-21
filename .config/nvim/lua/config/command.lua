vim.api.nvim_create_user_command("TrackAllEvents", function()
  local events = {
    "BufAdd",
    "BufDelete",
    "BufEnter",
    "BufFilePost",
    "BufFilePre",
    "BufHidden",
    "BufLeave",
    "BufModifiedSet",
    "BufNew",
    "BufNewFile",
    "BufRead",
    "BufReadPost",
    "BufReadPre",
    "BufUnload",
    "BufWinEnter",
    "BufWinLeave",
    "BufWrite",
    "BufWritePost",
    "BufWritePre",
    "CmdUndefined",
    "CmdWinEnter",
    "CmdWinLeave",
    "CursorHold",
    "CursorHoldI",
    "CursorMoved",
    "CursorMovedI",
    "DiagnosticChanged",
    "DirChanged",
    "FileAppendCmd",
    "FileAppendPost",
    "FileAppendPre",
    "FileChangedRO",
    "FileChangedShell",
    "FileChangedShellPost",
    "FileReadCmd",
    "FileReadPost",
    "FileReadPre",
    "FileType",
    "FileWriteCmd",
    "FileWritePost",
    "FileWritePre",
    "FilterReadPost",
    "FilterReadPre",
    "FilterWritePost",
    "FilterWritePre",
    "FocusGained",
    "FocusLost",
    "InsertChange",
    "InsertEnter",
    "InsertLeave",
    "LspAttach",
    "LspDetach",
    "LspNotify",
    "LspRequest",
    "LspTokenUpdate",
    "MenuPopup",
    "ModeChanged",
    "OptionSet",
    "QuickFixCmdPost",
    "QuickFixCmdPre",
    "QuitPre",
    "SearchWrapped",
    "SessionLoadPost",
    "ShellCmdPost",
    "ShellFilterPost",
    "Signal",
    "SourceCmd",
    "SourcePost",
    "SourcePre",
    "SpellFileMissing",
    "StdinReadPost",
    "StdinReadPre",
    "SwapExists",
    "Syntax",
    "TabEnter",
    "TabLeave",
    "TabNew",
    "TabNewEntered",
    "TermClose",
    "TermOpen",
    "TermResponse",
    "TextChanged",
    "TextChangedI",
    "TextChangedP",
    "TextChangedT",
    "TextYankPost",
    "UIEnter",
    "UILeave",
    "User",
    "VimEnter",
    "VimLeave",
    "VimLeavePre",
    "VimResized",
    "WinClosed",
    "WinEnter",
    "WinLeave",
    "WinNew",
    "WinScrolled",
  }

  -- autocommandグループの作成
  vim.api.nvim_create_augroup("TrackAllEventsGroup", { clear = true })

  -- 各イベントに対応するautocmdを設定
  for _, event in ipairs(events) do
    vim.api.nvim_create_autocmd(event, {
      group = "TrackAllEventsGroup",
      callback = function(args)
        local msg = string.format("Event: %s, File: %s", event, args.file or "N/A")
        print(msg)                           -- コマンドラインに出力
        local log_file = "/tmp/nvim_events.log"
        vim.fn.writefile({ msg }, log_file, "a") -- ログファイルに記録
      end,
    })
  end

  print("Event tracking started. Logs will be written to /tmp/nvim_events.log")
end, {})

-- :ClearTrackedEvents コマンドでautocmdを削除
vim.api.nvim_create_user_command("ClearTrackedEvents", function()
  vim.api.nvim_clear_autocmds({ group = "TrackAllEventsGroup" })
  print("Event tracking stopped.")
end, {})
