
(eval-when-compile
  ;; Following line is not needed if use-package.el is in ~/.emacs.d
;;  (add-to-list 'load-path "<path where use-package is installed>")
  (require 'use-package))

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(require 'package)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") t)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(current-language-environment "UTF-8")
 '(custom-enabled-themes '(adwaita))
 '(default-input-method "korean-hangul390")
 '(package-selected-packages
   '(ido-completing-read+ back-button flycheck-clj-kondo lsp-haskell cider parinfer-rust-mode use-package lispy paredit geiser racket-mode undo-tree editorconfig treemacs-magit treemacs which-key company fzf rustic rust-mode tide lsp-ui dap-mode flycheck lsp-treemacs lsp-mode xclip twittering-mode magit))
 '(xterm-mouse-mode t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "#EDEDED" :foreground "#2E3436" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 120 :width normal :foundry "GOOG" :family "Noto Sans Mono CJK KR")))))

(add-hook 'after-init-hook #'global-flycheck-mode)

(use-package flycheck-clj-kondo
  :ensure t)

(use-package clojure-mode
  :ensure t
  :config
  (require 'flycheck-clj-kondo))

(global-git-commit-mode)
(xclip-mode 1)
(setq lsp-keymap-prefix "s-l")
(setq read-process-output-max (* (* 1024 1024) 8)) ;; 1mb
(setq lsp-completion-provider :capf)
(setq gc-cons-threshold 100000000)
(global-set-key (kbd "M-p") 'ace-window)

(require 'lsp-mode)
(add-hook 'rust-mode-hook #'lsp)
(add-hook 'typescript-mode-hook #'lsp)

(when (fboundp 'windmove-default-keybindings)
  (windmove-default-keybindings))

(projectile-mode +1)
(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
(setq projectile-project-search-path '("~/code/" "~/code/kodebox/"))

(which-key-mode)
(ido-mode t)
(icomplete-mode t)

(add-to-list 'load-path "~/jhconfig/emacs")
(require 'frame-fns)
(require 'frame-cmds)
(require 'zoom-frm)
(editorconfig-mode 1)
