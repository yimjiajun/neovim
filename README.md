<img src="https://upload.wikimedia.org/wikipedia/commons/4/4f/Neovim-logo.svg" alt="Neovim-logo" width="600"/>

# 下載

## 方法一

透過該`install.sh`下載一切所需要的內容

1. 透過git repository 下載安裝工具

		git clone https://github.com/yimjiajun/nvimSetup.git

2. 執行安裝

		cd nvimSetup && ./install.sh

## 方法二

**手動下載**

下載`Neovim`: https://github.com/neovim/neovim/wiki/Building-Neovim

**使用該存儲庫提供的設定:**

1. 下載套件管理- [packer](https://github.com/wbthomason/packer.nvim)
	- linux / unix

			git clone --depth 1 https://github.com/wbthomason/packer.nvim\
			 ~/.local/share/nvim/site/pack/packer/start/packer.nvim

	- window

			git clone https://github.com/wbthomason/packer.nvim "$env:LOCALAPPDATA\nvim-data\site\pack\packer\start\packer.nvim"

2. 備份目前的設定檔案:
	- linux / unix

			mv ~/.config/nvim /tmp/

	- window

			~\AppData\Local\nvim

3. 下載該設定檔案
	- linux / unix

			git clone git@github.com:yimjiajun/neovim.git ~/.config/nvim

	- window

			git clone git@github.com:yimjiajun/neovim.git ~\AppData\Local\nvim

4. 更新

		nvim +PackerSync

開始使用

	nvim

# 工具

- [ ] [fzf](https://github.com/junegunn/fzf) : 簡易且快速找尋檔案
- [ ] [htop](https://htop.dev/) : 系統管理
- [ ] [ripgrep](https://github.com/BurntSushi/ripgrep) : 閃電速度找尋文字
- [ ] [lazygit](https://github.com/jesseduffield/lazygit) : 終端機版本的git圖形介面
- [ ] [ncdu](https://dev.yorhel.nl/ncdu) : 存儲容量管理

# Lsp (language server protocol)
<img src="https://matklad.github.io/assets/LSP-MxN.png" alt="Lsp-description" width="500"/>

## Clangd

<img src="https://llvm.org/img/LLVMWyvernBig.png" alt="Lsp-llvm-clangd" width="200"/>

Getting started : [how's to clangd](https://clangd.llvm.org/installation#compile_commandsjson)

### Cmake

使用cmake規劃build，能同時產生`compile_command.json`.
`compile_command.json`會產生在`build/`檔案裡
- 若在build階段過後，未產生該檔案，需附該設定變數:

		cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=1

連結該檔案到程式最外層`CWD`

	ln -s $project/build/compilie_command.json .

### Customize clangd (compile_command.json)

部分編譯器沒有產生`compile_command.json`,會使clangd無法正常運作，進而無法使用lsp功能。
因此，需要自行新增該檔案到專案裏。

clangd 設定指南:
- [compile_command guide](https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#clangd)
- [json guide](https://clang.llvm.org/docs/JSONCompilationDatabase.html)

# Vim Tips

[Vim Cheat Sheet](https://vim.rtorr.com) / [Vim 訣竅表格](https://vim.rtorr.com/lang/zh_tw)
- vim 基本鍵盤對應的功能介紹

[Vim Command Sheet](https://vimhelp.org/index.txt.html#ex-cmd-index)
- vim 基本指令對應的功能介紹
