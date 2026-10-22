# ~/.config/fish/conf.d/00-mise.fish

# Homebrew 版 mise の自動 activate の無効化(activate は config.fish 末尾で実行)
# 自動 activate は PATH 整備前に走り、/usr/bin 優先の順序で固定されてしまうため
# "00-" は vendor_conf.d/mise-activate.fish より先に読ませるための接頭辞
set -gx MISE_FISH_AUTO_ACTIVATE 0
