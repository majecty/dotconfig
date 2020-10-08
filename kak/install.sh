
echo "install kak-lsp.toml"
mkdir -p ~/.config/kak-lsp
ln -rs kak-lsp.toml ~/.config/kak-lsp/kak-lsp.toml

echo "install color schemes"
mkdir -p ~/.config/kak/colors
ln -rs colors/seagull-custom.kak ~/.config/kak/colors/seagull-custom.kak
