source "%val{config}/plugins/plug.kak/rc/plug.kak"

plug "andreyorst/fzf.kak"
plug "alexherbo2/prelude.kak"
plug "alexherbo2/terminal-mode.kak"
plug "alexherbo2/connect.kak"
plug "ul/kak-lsp" do %{
        cargo install --locked --force --path .
}
plug "gustavo-hms/luar"
plug "atomrc/kakoune-jsdoc"
plug "delapouite/kakoune-buffers"
plug "https://gitlab.com/Screwtapello/kakoune-state-save"
plug "delapouite/kakoune-registers"
# plug "WhatNodyn/kakoune-wakatime"
plug "eraserhd/kak-ansi" do %{
  make
}
plug "Delapouite/kakoune-colors" theme
plug 'delapouite/kakoune-palette'
plug "dgmulf/local-kakrc" config %{
      set-option global source_local_kakrc true
}
