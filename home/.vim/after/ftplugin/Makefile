# Based on http://peox.net/articles/vimconfig.html
# CWD must be ~/.vim/after/ftplugin/

VIM_DIR = /usr/share/vim/vimcurrent
VIM_FTPLUGIN_DIR = $(VIM_DIR)/ftplugin
COMMON_VIM = common.vim

FTPLUGIN_VIM = $(notdir $(wildcard $(VIM_FTPLUGIN_DIR)/*.vim))

.PHONY: install clean

install: $(FTPLUGIN_VIM)

$(FTPLUGIN_VIM): %.vim: $(COMMON_VIM)
	@ln -fs $< $@

clean:
	@find . -maxdepth 1 -name $(COMMON_VIM) -o -name "*.vim" -delete

