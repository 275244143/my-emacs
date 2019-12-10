;;; package --- Summary
(eval-when-compile
  (add-to-list 'load-path "~/.emacs.d/el-pkg/use-package")
  (require 'use-package))

(setq package-archives '(("gnu"   . "http://elpa.emacs-china.org/gnu/")
                         ("melpa" . "http://elpa.emacs-china.org/melpa/")))
(package-initialize)
;;
(setq debug-on-error t)
;;for linux/win garbage collection
(when (eq system-type 'gnu/linux)
  (setq gc-cons-threshold (* 256 1024 1024))
)
(when (eq system-type 'win-nt)
  (setq gc-cons-threshold (* 512 1024 1024))
  (setq gc-cons-percentage 0.5)
  (run-with-idle-timer 5 t #'garbage-collect)
  (setq garbage-collection-messages t))
;;设置有用的个人信息,这在很多地方有用。
(setq user-full-name "lixu")
(setq user-mail-address "lixu@ruijie.com.cn")
;;测试当前启动时间
(add-hook 'emacs-startup-hook
    (lambda ()
        (message "Emacs ready in %s with %d garbage collections."
            (format "%.2f seconds"
                (float-time
                    (time-subtract after-init-time before-init-time)))
            gcs-done)))

;;设置窗口位置,左上角为起始坐标
;(set-frame-position (selected-frame) 128 0)
;;设置窗口宽,数字为字符数
(set-frame-width (selected-frame) 135)
;设置窗口高,数字为行数
(set-frame-height (selected-frame) 48)
;在标题栏显示buffer的名字
(progn
  (setq dfname (format ":<%s@%s>" (user-login-name) (system-name)))
  (setq frame-title-format (list '(buffer-file-name "%f" (dired-directory dired-directory "%b")) dfname))
)
;取消自动备份
(setq make-backup-files nil)
(setq create-lockfiles nil)
;;允许emacs和外部其他程序的粘贴
(setq select-enable-clipboard t)
;;使用鼠标中键可以粘贴
(setq mouse-yank-at-point t)
;;highlight当前行
;;(global-hl-line-mode 1)
;;设置光标颜色
(set-cursor-color "DeepSkyBlue")
;;
(menu-bar-mode 0)
;;
(tool-bar-mode -1)
;;
(scroll-bar-mode -1)
;;
(column-number-mode t)
;;字体设置
(set-frame-font "Consolas Bold 13")
;;Enable syntax highlighting of **all** languages
(global-font-lock-mode t)
;
(setq inhibit-start-message t)
;;
(setq gnus-inhibit-start-message t)
;;
(setq inhibit-splash-screen 1)
;;
(show-paren-mode t)
(electric-pair-mode t)
;;
(setq ring-bell-function 'ignore)
;;
(fset 'yes-or-no-p 'y-or-n-p)
;;
(global-linum-mode t)
;;
;;(setq default-cursor-type 'bar)
;;tab 改为插入空格
(setq-default indent-tabs-mode nil)
(setq c-basic-offset 4)
(setq c-default-style "linux")
(setq default-tab-width 4)
;;设置tab键补全
(global-set-key (kbd "C-i") 'tab-to-tab-stop)
;;python setting
(setq python-indent-offset 4
      python-indent-guess-indent-offset-verbose nil
      python-sort-imports-on-save t
      python-shell-interpreter "python3"
      pippel-python-command "python3"
      importmagic-python-interpreter "python3")
;;
(display-time-mode 1)
(setq display-time-24hr-format t) 
(setq display-time-dayanddat t) 
;;上下折行之显示1行
(global-visual-line-mode)
;;不折行
(toggle-truncate-lines)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;package start 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Useful elisp pkg
(use-package cl-lib
  :load-path "~/.emacs.d/el-pkg/cl-lib"
  :defer t)
;ibuffer
(use-package ibuffer 
  :load-path "~/.emacs.d/el-pkg/ibuffer"
  :bind
    ("C-x b" . ibuffer))
;hide-region
(use-package hide-region
  :load-path "~/.emacs.d/el-pkg/hide-region-lines"
  :bind
    (("M-r" . hide-region-hide)
     ("M-R" . hide-region-unhide)))
;hide-lines
(use-package hide-lines
  :load-path "~/.emacs.d/el-pkg/hide-region-lines"
  :bind
    (("M-l" . hide-lines)
     ("M-L" . show-all-invisible)))
;;env vars copy to emacs
(use-package exec-path-from-shell
  :load-path "~/.emacs.d/el-pkg/exec-path-from-shell"
  :init
    (setq exec-path-from-shell-check-startup-files nil)
  :config
    (when (memq window-system '(mac ns x))
        (exec-path-from-shell-initialize)))
;;unicad:文件编码格式自动检测
(use-package unicad
  :load-path "~/.emacs.d/el-pkg/unicad"
  :defer t)
;;desert-theme
(use-package desert-theme
  :init
    (add-to-list 'load-path "~/.emacs.d/themes/"))
;;evil
(use-package evil
  :load-path "~/.emacs.d/el-pkg/evil"
  :config
    (evil-mode 1))
;;evil-leader
(use-package evil-leader 
  :load-path "~/.emacs.d/el-pkg/evil-leader"
  :config
    (global-evil-leader-mode)
    (evil-leader/set-leader ",")
    (evil-leader/set-key
      "b"   'helm-buffers-list
      "yy"  'kill-ring-save
      "*"   'search-current-word
      "&"   'search-selection
      "dd"  'delete-duplicate-lines
      "F"   'find-file
      "f"   'helm-find-files
      "lf"  'flush-lines
      "lk"  'keep-lines
      "o"   'occur
      "u"   'undo-tree-visualize
      ;"X"  'smex
      "X"   'counsel-M-x 
      "x"   'helm-M-x
      "tb"  'toggle-scroll-bar
      "gb"  'grep-current-buffer
      "gl"  'goto-line
      "gn"  'next-error
      "gp"  'previous-error
      "gs"  'magit-status
      "cc"  'compile 
      "dot" 'graphviz-dot-preview
      "m"   'scroll-other-window
      "n"   'scroll-other-window-down
      "sm"  'bookmark-set
      "lm"  'bookmark-bmenu-list
      "jm"  'bookmark-jump
      "zf"  'yafolding-toggle-element
      "gd"  'dumb-jump-hydra/body
      "ld"  'down-list
      "lu"  'backward-up-list
      "qr"  'query-replace-regexp
      "qs"  'query-replace
      "cb"  'comment-box
      "cc"  'comment-dwim
      "cl"  'comment-line
      "cr"  'comment-region
      "tc"  'transpose-chars
      "tw"  'transpose-words
      "te"  'transpose-sexps
      "lc"  'set-fill-column ;;sets fill colum width
      "lx"  'set-fill-prefix 
      "lp"  'fill-paragraph 
      "cu"  'universal-argument ;;lc -> lu -> lp
      "sm"  'kmacro-start-macro
      "em"  'kmacro-end-macro
      "cm"  'kmacro-end-and-call-macro
      "ht"  'helm-tramp
      "cl"  'slime
      "pp"  'indent-pp-sexp
      ))
;;powerline
(use-package powerline
  :init
    (add-to-list 'load-path "~/.emacs.d/el-pkg/powerline/"))
;;powerline-evil
(use-package powerline-evil
  :init
    (add-to-list 'load-path "~/.emacs.d/el-pkg/powerline-evil/")
  :config
    (powerline-evil-vim-color-theme))
;;evil-numbers
(use-package evil-numbers
  :load-path "~/.emacs.d/el-pkg/evil-numbers"
  :config
    (define-key evil-normal-state-map (kbd "C-c +") 'evil-numbers/inc-at-pt)
    (define-key evil-normal-state-map (kbd "C-c -") 'evil-numbers/dec-at-pt))
;;evil-matchit
(use-package evil-matchit
  :load-path "~/.emacs.d/el-pkg/evil-matchit"
  :config
    (global-evil-matchit-mode t))
;;evil-lion
(use-package evil-lion 
  :load-path "~/.emacs.d/el-pkg/evil-lion"
  :config
    (evil-lion-mode))
;;company
(use-package company 
  :load-path "~/.emacs.d/el-pkg/company-0.9.10"
  :config
    (company-mode 1)
    (add-hook 'after-init-hook 'global-company-mode))
;;ivy
(use-package ivy
  :load-path "~/.emacs.d/el-pkg/ivy" 
  :config
    (ivy-mode 1))
;;ivy-rich
(use-package ivy-rich
  :load-path "~/.emacs.d/el-pkg/ivy-rich"
  :init
    (setq ivy-rich-path-style 'abbrev)
  :config
    (ivy-rich-mode 1)
    (setcdr (assq t ivy-format-functions-alist) #'ivy-format-function-line))
;;iedit
(use-package iedit
  :load-path "~/.emacs.d/el-pkg/iedit"
  :config
    (define-key global-map (kbd "C-c ;") 'iedit-mode) )
;;ace jump mode
(use-package ace-jump-mode
  :load-path "~/.emacs.d/el-pkg/ace-jump-mode"
  :config
    (define-key global-map (kbd "C-c SPC") 'ace-jump-mode))
;;ag-mode
(use-package ag
  :load-path "~/.emacs.d/el-pkg/ag")
;;anaconda-mode 
(use-package anaconda-mode
  :config
    (add-hook 'python-mode-hook 'anaconda-mode)
    (add-hook 'python-mode-hook 'anaconda-eldoc-mode))
;;jedi-mode 
(use-package jedi 
  :init
    (setq jedi:complete-on-dot t)
  :config
    (add-hook 'python-mode-hook 'jedi:setup))
;;panddoc
(use-package markdown-mode
  :init
    (setq markdown-command "/usr/bin/pandoc"))
;;PlanUML
(use-package plantuml-mode
  :init
    (setq plantuml-jar-path "/home/soft/plantuml/plantuml.jar")
    (setq plantuml-default-exec-mode 'jar)
  :config
    (add-to-list 'auto-mode-alist '("\\.plantuml\\'" . plantuml-mode))
    (plantuml-set-output-type "png"))
;;flycheck
(use-package flycheck 
  :init
    (setq flycheck-python-pylint-executable "/home/soft/anaconda3/bin/pylint"
          flycheck-python-pycompile-executable "/home/soft/anaconda3/bin/python")
  :config
    (add-hook 'after-init-hook #'global-flycheck-mode))
;;;highlight-parent
(use-package highlight-parentheses
  :load-path "~/.emacs.d/el-pkg/highlight-parentheses"
  :config
    (add-hook 'prog-mode-hook 'highlight-parentheses-mode))
;;;pop-win
(use-package popwin
  :defer 2
  :init
    (add-to-list 'load-path "~/.emacs.d/el-pkg/popwin")
  :config
    (popwin-mode 1))
;;;window-numbering
(use-package window-numbering 
  :defer 2
  :init
    (add-to-list 'load-path "~/.emacs.d/el-pkg/window-numbering")
  :config
    (window-numbering-mode))
;;dropdown-list
(use-package dropdown-list
  :load-path "~/.emacs.d/el-pkg/dropdown-list")
;;;yasnippet
(use-package yasnippet
  :load-path "~/.emacs.d/el-pkg/yasnippet"
  :defer 2
  :config
    (yas-reload-all)
    (yas-global-mode 1))
;;yasnippet-snippets
(use-package yasnippet-snippets 
  :load-path "~/.emacs.d/el-pkg/yasnippet-snippets"
  :defer 2)
;;undo-tree
;;C-x u
(use-package undo-tree 
  :load-path "~/.emacs.d/el-pkg/undo-tree"
  :config
    (progn
      (global-undo-tree-mode)
      (setq undo-tree-visualizer-diff t)
      (setq undo-tree-visualizer-timestamps t)))
;;hl-defined
(use-package hl-defined
  :init
    (add-to-list 'load-path "~/.emacs.d/el-pkg/hl-defined")
  :config
    (add-hook 'emacs-lisp-mode-hook 'hdefd-highlight-mode 'APPEND))
;;hlinum
(use-package hlinum
  :init
    (add-to-list 'load-path "~/.emacs.d/el-pkg/hlinum")
  :config
    (hlinum-activate))
;;graphviz-dot-mode
(use-package graphviz-dot-mode
  :defer 2
  :init
    (add-to-list 'load-path "~/.emacs.d/el-pkg/graphviz-dot-mode")
  :config
    (setq graphviz-dot-preview-extension "png"))
;;multi-term
(use-package multi-term
  :defer 2
  :init
    (add-to-list 'load-path "~/.emacs.d/el-pkg/multi-term")
  :config
    (setq multi-term-program "/bin/bash"))
;;indent-guide
;(use-package indent-guide
;  :load-path "~/.emacs.d/el-pkg/indent-guide"
;  :init
;    ;(setq indent-guide-recursive t)
;  :config
;    ;(indent-guide-global-mode))
;;awesome-pair
(use-package awesome-pair
  :load-path "~/.emacs.d/el-pkg/awesome-pair"
  :config
    (dolist (hook (list
                   'c-mode-common-hook
                   'c-mode-hook
                   'c++-mode-hook
                   'java-mode-hook
                   'haskell-mode-hook
                   'emacs-lisp-mode-hook
                   'lisp-interaction-mode-hook
                   'lisp-mode-hook
                   'maxima-mode-hook
                   'ielm-mode-hook
                   'sh-mode-hook
                   'makefile-gmake-mode-hook
                   'php-mode-hook
                   'python-mode-hook
                   'js-mode-hook
                   'go-mode-hook
                   'qml-mode-hook
                   'jade-mode-hook
                   'css-mode-hook
                   'ruby-mode-hook
                   'coffee-mode-hook
                   'rust-mode-hook
                   'qmake-mode-hook
                   'lua-mode-hook
                   'swift-mode-hook
                   'minibuffer-inactive-mode-hook
                   'verilog-mode-hook
                   ))
    (add-hook hook '(lambda () (awesome-pair-mode 1))))
    (define-key awesome-pair-mode-map (kbd "(") 'awesome-pair-open-round)
    (define-key awesome-pair-mode-map (kbd "[") 'awesome-pair-open-bracket)
    (define-key awesome-pair-mode-map (kbd "{") 'awesome-pair-open-curly)
    (define-key awesome-pair-mode-map (kbd ")") 'awesome-pair-close-round)
    (define-key awesome-pair-mode-map (kbd "]") 'awesome-pair-close-bracket)
    (define-key awesome-pair-mode-map (kbd "}") 'awesome-pair-close-curly)
    (define-key awesome-pair-mode-map (kbd "=") 'awesome-pair-equal)
    (define-key awesome-pair-mode-map (kbd "%") 'awesome-pair-match-paren)
    (define-key awesome-pair-mode-map (kbd "\"") 'awesome-pair-double-quote)
    (define-key awesome-pair-mode-map (kbd "SPC") 'awesome-pair-space)
    (define-key awesome-pair-mode-map (kbd "M-o") 'awesome-pair-backward-delete)
    (define-key awesome-pair-mode-map (kbd "C-d") 'awesome-pair-forward-delete)
    (define-key awesome-pair-mode-map (kbd "C-k") 'awesome-pair-kill)
    (define-key awesome-pair-mode-map (kbd "M-\"") 'awesome-pair-wrap-double-quote)
    (define-key awesome-pair-mode-map (kbd "M-[") 'awesome-pair-wrap-bracket)
    (define-key awesome-pair-mode-map (kbd "M-{") 'awesome-pair-wrap-curly)
    (define-key awesome-pair-mode-map (kbd "M-(") 'awesome-pair-wrap-round)
    (define-key awesome-pair-mode-map (kbd "M-)") 'awesome-pair-unwrap)
    (define-key awesome-pair-mode-map (kbd "M-p") 'awesome-pair-jump-right)
    (define-key awesome-pair-mode-map (kbd "M-n") 'awesome-pair-jump-left)
    (define-key awesome-pair-mode-map (kbd "M-:") 'awesome-pair-jump-out-pair-and-newline))
;;centaur-tabs
;(use-package centaur-tabs
;  :load-path "~/.emacs.d/el-pkg/centaur-tabs"
;  :init
;    ;(setq centaur-tabs-set-icons t)
;    ;(setq centaur-tabs-gray-out-icons 'buffer)
;  :config
;    ;(centaur-tabs-mode t))
;;neotree
(use-package neotree 
  :load-path "~/.emacs.d/el-pkg/neotree"
  )
;;smex
(use-package smex
  :load-path "~/.emacs.d/el-pkg/smex"
  :init
    (setq neo-theme (if (display-graphic-p) 'icons 'arrow))
  :config
    (smex-initialize)
    ;(global-set-key (kbd "M-x") 'smex)
    ;(global-set-key (kbd "M-X") 'smex-major-mode-commands)
  )
;;old M-x
(global-set-key (kbd "C-c C-c e") 'execute-extended-command)
;;all-the-icons
(use-package all-the-icons 
  :defer 2
  :init
    (add-to-list 'load-path "~/.emacs.d/el-pkg/memoize")
    (add-to-list 'load-path "~/.emacs.d/el-pkg/all-the-icons"))
;;rainnow-delimiters
(use-package rainbow-delimiters
  :init
    (add-to-list 'load-path "~/.emacs.d/el-pkg/rainbow-delimiters")
  :config
    (add-hook 'prog-mode-hook #'rainbow-delimiters-mode)
    (custom-set-faces
        '(rainbow-delimiters-depth-1-face ((t (:foreground "White"))))
        '(rainbow-delimiters-depth-2-face ((t (:foreground "Green"))))
        '(rainbow-delimiters-depth-3-face ((t (:foreground "Magenta"))))
        '(rainbow-delimiters-depth-4-face ((t (:foreground "Blue"))))
        '(rainbow-delimiters-depth-5-face ((t (:foreground "Orange"))))
        '(rainbow-delimiters-depth-6-face ((t (:foreground "Cyan"))))
        '(rainbow-delimiters-depth-7-face ((t (:foreground "Purple"))))
        '(rainbow-delimiters-depth-8-face ((t (:foreground "Yellow"))))
        '(rainbow-delimiters-depth-9-face ((t (:foreground "Brown"))))
        '(rainbow-delimiters-unmatched-face ((t (:foreground "Red"))))
    ))
;;which-key
(use-package which-key
  :defer 2
  :init
    (add-to-list 'load-path "~/.emacs.d/el-pkg/which-key")
  :config
    (which-key-mode))
;;hydra
(use-package hydra
  ;:load-path "~/.emacs.d/el-pkg/hydra"
  :config
    (defhydra dumb-jump-hydra (:color blue :columns 3)
       "Dumb Jump"
       ("j" dumb-jump-go "Go")
       ("o" dumb-jump-go-other-window "Other window")
       ("e" dumb-jump-go-prefer-external "Go external")
       ("x" dumb-jump-go-prefer-external-other-window "Go external other window")
       ("i" dumb-jump-go-prompt "Prompt")
       ("l" dumb-jump-quick-look "Quick look")
       ("b" dumb-jump-back "Back")))
;;dumb-jump
(use-package dumb-jump
  :load-path "~/.emacs.d/el-pkg/dumb-jump"
  :init
    (setq dumb-jump-force-searcher 'ag)
    (setq dumb-jump-default-project "/home/project/ALTERA_RRU_CSIM")
  :config
    (dumb-jump-mode))
;;restart-emacs
(use-package restart-emacs
  :load-path "~/.emacs.d/el-pkg/restart-emacs"
  :init
    (setq restart-emacs-restore-frames t))
;;vi-tilde-fringe
(use-package vi-tilde-fringe
  :load-path "~/.emacs.d/el-pkg/vi-tilde-fringe"
  :config
    (global-vi-tilde-fringe-mode))
;;move-text
(use-package move-text 
  :load-path "~/.emacs.d/el-pkg/move-text"
  :config
    (move-text-default-bindings))
;;highlight
(use-package highlight
  :load-path "~/.emacs.d/el-pkg/highlight")
;;evil-search-highlight-persist
(use-package evil-search-highlight-persist
  :load-path "~/.emacs.d/el-pkg/evil-search-highlight-persist"
  :init
    (setq evil-search-highlight-string-min-len 3)
  :config
    (global-evil-search-highlight-persist t))
;;helm
(use-package helm-config 
  :config
    (helm-mode 1)
    (global-set-key (kbd "M-x") #'helm-M-x)
    (global-set-key (kbd "C-x r b") #'helm-filtered-bookmarks)
    (global-set-key (kbd "C-x C-f") #'helm-find-files)
    (global-set-key (kbd "C-x C-b") #'helm-buffers-list))
;;pdf-tools
;;(pdf-tools-install)
;;helm-tramp
(use-package helm-tramp
  :load-path "~/.emacs.d/el-pkg/helm-tramp"
  :init
    (setq tramp-default-method "ssh")
    (setq helm-tramp-custom-connections '(/ssh:lixu@192.168.1.12:~ /ssh:ubuntu@118.25.122.94:~)))
;;esup
(use-package esup
  :load-path "~/.emacs.d/el-pkg/esup"
  :defer t
  ;:config
    ;(autoload 'esup "esup" "Emacs Start Up Profiler." nil)
  )
;;benchmark-init
(use-package benchmark-init-loaddefs
  :load-path "~/.emacs.d/el-pkg/benchmark-init"
  :config
    (benchmark-init/activate))
;;slime
(use-package slime
  :defer 1
  :init
    (add-to-list 'load-path "~/.emacs.d/el-pkg/slime-2.24")
    (setq inferior-lisp-program "/usr/local/bin/sbcl")
  :config
    (slime-setup '(slime-fancy slime-banner)))
;;折叠
(use-package yafolding
  :config
    (global-set-key (kbd "C-c 1") 'yafolding-toggle-all)
    (global-set-key (kbd "C-c 2") 'yafolding-toggle-element))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;lsp-mode
;(use-package lsp-mode
;  :hook (python-mode . lsp)
;  :commands lsp)
(use-package lsp-mode
  :init
    (setq lsp-clients-python-command "/home/soft/anaconda3/bin/pyls")
  :hook
    (python-mode . lsp-deferred)
  :commands
    (lsp lsp-deferred))
;; optionally
(use-package helm-lsp
  :commands
    helm-lsp-workspace-symbol)
(use-package lsp-treemacs
  :commands
    lsp-treemacs-errors-list)
;; optionally if you want to use debugger
(use-package dap-mode)
;; (use-package dap-LANGUAGE) to load the dap adapter for your language
(use-package lsp-ui
    :init
      ;;启用 lsp-ui
      (add-hook 'lsp-mode-hook 'lsp-ui-mode)
      ;;启用 flycheck
      (add-hook 'python-mode-hook 'flycheck-mode))
(use-package company-lsp
    :config
      ;;设置 company-lsp 为后端
      (push 'company-lsp company-backends))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;package end
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(global-set-key [f1] 'help-for-help)
;;定义函数,快速打开 init.el 配置文件
;;将函数 open-init-file 绑定到 <C-f1> 键上
(defun open-init-file()
  (interactive)
  (find-file "~/.emacs.d/init.el"))
(global-set-key [C-f1] 'open-init-file)
;;设置窗口跳转（c-x o）
(global-set-key [f2] 'other-window)
(global-set-key [C-tab] 'other-window)
;;关闭其他窗口（c-x 0）
(global-set-key [f3] 'delete-other-windows)
;;设置[F2]为调用dired命令    
;;i,find-dired ....
(global-set-key [C-f3] 'dired)
;
(global-set-key [f4] 'toggle-frame-maximized)
;;
(global-set-key [C-f4] 'sr-speedbar-toggle)
;;
(global-set-key [f5] 'maximize-window)
;;
(global-set-key [f6] 'compile)
;;
(global-set-key [f7] 'auto-insert)
;;
(global-set-key [f8] 'neotree-toggle)
;;
(global-set-key [f9] 'multi-term)
;;mode help
(global-set-key [f11] 'describe-mode)
;;ielm
(global-set-key [f12] 'ielm)
;;window shrink&enlarge
(global-set-key (kbd "<M-up>") 'shrink-window)
(global-set-key (kbd "<M-down>") 'enlarge-window)
(global-set-key (kbd "<M-left>") 'shrink-window-horizontally)
(global-set-key (kbd "<M-right>") 'enlarge-window-horizontally)
;;;shell commands
;;M-! calss shell cmd and prints output
;;C-u M-! .. insert to buffer
;;M-& async ..
;;C-u M-&
;;M-| pipe ..
;;C-u M-|
;;M-x proced --> top 
;;M-x man --> man 
;;C-c C-s save last command output to a file
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;verilog-mode
;;User customization for Verilog mode
(use-package verilog-mode 
  :init
    (setq verilog-indent-level             4
          verilog-indent-level-module      4
          verilog-indent-level-declaration 4
          verilog-indent-level-behavioral  4
          verilog-indent-level-directive   1
          verilog-case-indent              4
          verilog-auto-newline             nil
          verilog-auto-indent-on-newline   t
          verilog-tab-always-indent        t
          verilog-auto-endcomments         t
          verilog-minimum-comment-distance 40
          verilog-indent-begin-after-if    t
          verilog-auto-lineup              'declarations
          verilog-highlight-p1800-keywords t
          verilog-linter                   "nLint -2001 -beauty -detail -fullname -sort r -out screen"
          verilog-simulator                "irun -sv"
          ))
;;折叠模式
(use-package hideshow
  :init
  (setq hs-special-modes-alist
        (cons '(verilog-mode "\\<begin\\>\\|\\<task\\>\\|\\<function\\>\\|\\<program\\>\\|\\<class\\>\\|\\<module\\>\\|\\<package\\>\\|("
                             "\\<end\\>\\|\\<endtask\\>\\|\\<endfunction\\>\\|\\<endprogram\\>\\|\\<endclass\\>\\|\\<endmodule\\>\\|\\<endpackage\\>\\|)"
                             nil
                             verilog-forward-sexp-function)
              hs-special-modes-alist))
  :config
  (add-hook 'prog-mode-hook #'(lambda () (hs-minor-mode t))))


;;shell up-down history
(defun my-comint-mode-hook()
  (interactive)
  (define-key comint-mode-map (kbd "<up>") 'comint-previous-input)
  (define-key comint-mode-map (kbd "<down>") 'comint-next-input))
(add-hook 'comint-mode-hook 'my-comint-mode-hook)
;;;custom function
(defun search-selection (beg end)
  "Search for selected tesxt."
  (interactive "r")
  (let (
        (selection (buffer-substring-no-properties beg end))
        )
    (deactivate-mark)
    (isearch-mode t nil nil nil)
    (isearch-yank-string selection)))
;;
(defun grep-current-buffer ()
  "Grep string in current buffer."
  (interactive)
  (progn
    ;;grep
    (setq filename (buffer-file-name))
    (setq selected-text (buffer-substring-no-properties (region-beginning) (region-end)))
    (setq grep-result (shell-command-to-string (concat "grep -w -n " selected-text " " filename)))
    ;;print to *grep*
    (switch-to-buffer-other-window (get-buffer-create "*grep*"))
    (erase-buffer)
    (insert (concat filename "\n\n"))
    (insert grep-result)
    ;;highlight
    (setq face 'hi-yellow)
    (hi-lock-face-buffer selected-text face)))  
;;
(defun inc-num-region (p m num)
  "Increments the numbers in a given region."
  (interactive "r\nNPlease input +/- num: ")
  (save-restriction
    (save-excursion
      (narrow-to-region p m)   
      (goto-char(point-min))  
      (forward-line)
      (let ((counter num))
        (while(not (eq (point)
                        (point-max)))
          (goto-char (point-at-eol))
          (search-backward-regexp "[0-9]+" (point-at-bol) t)
          (let* ((thisnum (string-to-number (match-string 0)))
                 (newnumstr (number-to-string (+ thisnum
                                                   counter))))
            (replace-match newnumstr)
            (incf counter num)
            (forward-line)
            ))))))
;;按照不同文件类型,自动插入模板
(eval-after-load 'autoinsert
  '(define-auto-insert
     '("\\.\\(CC?\\|cc\\|cxx\\|cpp\\|c++\\)\\'" . "C++ skeleton")
     '("Short description: "
       "/*" \n
       (file-name-nondirectory (buffer-file-name))
       " -- " str \n
       " */" > \n \n
       "#include <iostream>" \n \n
       "using namespace std;" \n \n
       "main()" \n
       "{" \n
       > _ \n
       "}" > \n)))

(eval-after-load 'autoinsert
  '(define-auto-insert
     '("\\.\\(v\\|sv\\|svh\\)\\'" . "verilog-systemverilog skeleton")
     '(""
       "/*=============================================================================" \n
       "// RUIJIE IS PROVIDING THIS DESIGN, CODE, OR INFORMATION \"AS IS\"" \n
       "// SOLELY FOR USE IN DEVELOPING PROGRAMS AND SOLUTIONS FOR" \n
       "// RUIJIE DEVICES.  BY PROVIDING THIS DESIGN, CODE, OR INFORMATION" \n
       "// AS ONE POSSIBLE IMPLEMENTATION OF THIS FEATURE, APPLICATION" \n
       "// OR STANDARD, RUIJIE IS MAKING NO REPRESENTATION THAT THIS" \n
       "// IMPLEMENTATION IS FREE FROM ANY CLAIMS OF INFRINGEMENT," \n
       "// AND YOU ARE RESPONSIBLE FOR OBTAINING ANY RIGHTS YOU MAY REQUIRE" \n
       "// FOR YOUR IMPLEMENTATION.  RUIJIE EXPRESSLY DISCLAIMS ANY" \n
       "// WARRANTY WHATSOEVER WITH RESPECT TO THE ADEQUACY OF THE" \n
       "// IMPLEMENTATION, INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OR" \n
       "// REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE FROM CLAIMS OF" \n
       "// INFRINGEMENT, IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS" \n
       "// FOR A PARTICULAR PURPOSE." \n
       "// (c) Copyright 2019 RUIJIE, Inc." \n
       "// All rights reserved." \n
       "" \n
       "//============================================================================" \n
       "//     FileName: " (file-name-nondirectory (buffer-file-name)) \n
       "//         Desc: " \n
       "//       Author: lixu" \n
       "//        Email: lixu@ruijie.com.cn" \n
       "//     HomePage: http://www.ruijie.com.cn" \n
       "//      Version: 0.0.1" \n
       "//   LastChange: " (format-time-string "%Y-%m-%d %H:%M:%S")\n
       "//      History:" \n
       "//============================================================================*/" \n
       "`ifndef " (replace-regexp-in-string "\\." "__" (upcase (file-name-nondirectory (buffer-file-name)))) \n
       "`define " (replace-regexp-in-string "\\." "__" (upcase (file-name-nondirectory (buffer-file-name)))) \n \n
       > _ \n \n
       "`endif" "\n")))
(defun search-current-word()
  "Call `isearch' on current word or text selection.
'word' here is A to Z, a to z, and hyphen 「-」 and underline 「_」,
independent of syntax table."
  (interactive)
  (let ( $p1 $p2 )
    (if (use-region-p)
        (progn
          (setq $p1 (region-beginning))
          (setq $p2 (region-end)))
      (save-excursion
        (skip-chars-backward "-_A-Za-z0-9")
        (setq $p1 (point))
        (right-char)
        (skip-chars-forward "-_A-Za-z0-9")
        (setq $p2 (point))))
    (setq mark-active nil)
    (when (< $p1 (point))
      (goto-char $p1))
    (isearch-mode t)
    (isearch-yank-string (buffer-substring-no-properties $p1 $p2))))
(provide 'init)
;;;ini.el ends here
