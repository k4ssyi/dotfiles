# 手動対応内容

## powerline font のインストール

https://github.com/powerline/fonts
自動化できる内容だし自動化したい

## VIM

Vimのプラグイン管理にvim-plugを使っています。
以下を見て初回セットアップしてください。

https://github.com/junegunn/vim-plug


Vimのファイルマネージャーに coc explorer を使っています。
以下を見て初回セットアップしてください

https://github.com/weirongxu/coc-explorer
以下を参考にしてます。

https://zenn.dev/hira/articles/940549483bf2da


:CocConfig


```
{
  "languageserver": {
    "golang": {
      "command": "gopls",
      "rootPatterns": ["go.work", "go.mod", ".vim/", ".git/", ".hg/"],
      "filetypes": ["go"],
      "initializationOptions": {
        "usePlaceholders": true
      }
    }
  }
}

```

nvim と coc-settings.json の設定を共通化する

```
ln -s ~/.vim/coc-settings.json ~/.config/nvim/coc-settings.json
```

