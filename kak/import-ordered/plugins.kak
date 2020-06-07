source "%val{config}/plugins/plug.kak/rc/plug.kak"

plug "andreyorst/fzf.kak"
plug "alexherbo2/connect.kak"
plug "alexherbo2/prelude.kak"
plug "ul/kak-lsp" do %{
        cargo install --locked --force --path .
}
plug "gustavo-hms/luar"
plug "atomrc/kakoune-jsdoc"
