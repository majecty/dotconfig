;;; init.el --- Emcas config file
;;; Code:

(eval-when-compile
  ;; Following line is not needed if use-package.el is in ~/.emacs.d
;;  (add-to-list 'load-path "<path where use-package is installed>")
  (require 'use-package))

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

;;; Commentary:
;;

(require 'package)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") t)
(add-to-list 'package-archives
	     '("org" . "https://orgmode.org/elpha/") t)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(current-language-environment "UTF-8")
 '(custom-enabled-themes '(adwaita))
 '(default-input-method "korean-hangul390")
 '(package-selected-packages
   '(pomidor org-roam format-all format-all-buffer eyebrowse doom-modeline rainbow-delimiters god-mode ivy-posframe parinfer ivy-rich ivy-hydra discover-clj-refactor clojure-snippets clj-refactor ido-completing-read+ back-button flycheck-clj-kondo lsp-haskell cider parinfer-rust-mode use-package lispy paredit geiser racket-mode undo-tree editorconfig treemacs-magit treemacs which-key company fzf rustic rust-mode tide lsp-ui dap-mode flycheck lsp-treemacs lsp-mode xclip twittering-mode magit))
 '(xterm-mouse-mode t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 143 :width normal :foundry "GOOG" :family "Noto Sans Mono CJK KR")))))

(add-hook 'after-init-hook #'global-flycheck-mode)

(use-package magit
  :ensure t
  :config
  (progn
    (global-set-key (kbd "<f5> g") #'magit-status)))

(use-package flycheck-clj-kondo
  :ensure t)

(use-package clojure-mode
  :ensure t
  :config
  (require 'flycheck-clj-kondo))

(use-package parinfer
  :ensure t
  :bind
  (("C-c ." . parinfer-toggle-mode))
  :init
  (progn
    (setq parinfer-extensions
          '(defaults       ; should be included.
             pretty-parens  ; different paren styles for different modes.
	     ;;            evil           ; If you use Evil.
	     ;;            lispy          ; If you use Lispy. With this extension, you should install Lispy and do not enable lispy-mode directly.
	     ;;            paredit        ; Introduce some paredit commands.
             smart-tab      ; C-b & C-f jump positions and smart shift with tab & S-tab.
             smart-yank))   ; Yank behavior depend on mode.
    (add-hook 'clojure-mode-hook #'parinfer-mode)
    (add-hook 'emacs-lisp-mode-hook #'parinfer-mode)
    (add-hook 'common-lisp-mode-hook #'parinfer-mode)
    (add-hook 'scheme-mode-hook #'parinfer-mode)
    (add-hook 'lisp-mode-hook #'parinfer-mode)))

(use-package posframe
  :ensure t)

(use-package ivy-posframe
  :ensure t
  :config
  (progn
    (require 'ivy-posframe)
    (setq ivy-posframe-display-functions-alist '((t . ivy-posframe-display-at-frame-bottom-left)))
    (ivy-posframe-mode 1)))

(use-package lsp-haskell
  :ensure t)

(use-package format-all
  :ensure t
  :config
  (progn
    (add-hook 'markdown-mode-hook
        (lambda () (progn)
         (add-hook 'before-save-hook #'format-all-buffer nil 'local)
         (message "Hi markdown mode")))))

(use-package org-roam
  :ensure t
  :config
  (progn
    (setq org-roam-directory "~/org-roam")
    (add-hook 'after-init-hook 'org-roam-mode)
    ;; create maps using function keys
    ;; find file
    (global-set-key (kbd "<f5> r f f") #'org-roam-find-file)
    (global-set-key (kbd "<f5> r t") #'org-roam-today)
    (define-key org-roam-mode-map (kbd "<f9> i") #'org-roam-insert)
    (define-key org-roam-mode-map (kbd "<f9> d") #'org-roam-buffer-toggle-display)
    (define-key org-roam-mode-map (kbd "<f9> t a") #'org-roam-tag-add)
    (define-key org-roam-mode-map (kbd "<f9> t d") #'org-roam-tag-delete)))

(global-git-commit-mode)
(xclip-mode 1)
;; (setq lsp-keymap-prefix "s-l")
(setq lsp-keymap-prefix "C-c l")
(setq read-process-output-max (* (* 1024 1024) 8)) ;; 1mb
(setq lsp-completion-provider :capf)
(setq gc-cons-threshold 100000000)
(global-set-key (kbd "M-p") 'ace-window)

(require 'lsp-mode)
(add-hook 'rust-mode-hook #'lsp)
(add-hook 'typescript-mode-hook #'lsp)
(add-hook 'js-mode-hook #'lsp)
(add-hook 'haskell-mode-hook #'lsp)

(when (fboundp 'windmove-default-keybindings)
  (windmove-default-keybindings)
  (global-set-key (kbd "C-S-h") 'windmove-swap-states-left)
  (global-set-key (kbd "C-S-j") 'windmove-swap-states-down)
  (global-set-key (kbd "C-S-k") 'windmove-swap-states-up)
  (global-set-key (kbd "C-S-l") 'windmove-swap-states-right))

(projectile-mode +1)
(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
(setq projectile-project-search-path '("~/code/" "~/code/kodebox/"))

(which-key-mode)

(use-package hydra
  :ensure t)

(use-package ivy
  :ensure t
  :config
  (progn
    (ivy-mode 1)
    (setq ivy-use-virtual-buffers t)
    (setq enable-recursive-minibuffers t)
    ;; enable this if you want `swiper' to use it
    (setq search-default-mode #'char-fold-to-regexp)
    (global-set-key (kbd "C-S-s") 'swiper)
    (global-set-key (kbd "C-c C-r") 'ivy-resume)
    (global-set-key (kbd "<f6>") 'ivy-resume)
    (global-set-key (kbd "M-x") 'counsel-M-x)
    (global-set-key (kbd "C-x C-f") 'counsel-find-file)
    (global-set-key (kbd "<f1> f") 'counsel-describe-function)
    (global-set-key (kbd "<f1> v") 'counsel-describe-variable)
    (global-set-key (kbd "<f1> o") 'counsel-describe-symbol)
    (global-set-key (kbd "<f1> l") 'counsel-find-library)
    (global-set-key (kbd "<f2> i") 'counsel-info-lookup-symbol)
    (global-set-key (kbd "<f2> u") 'counsel-unicode-char)
    (global-set-key (kbd "C-c g") 'counsel-git)
    (global-set-key (kbd "C-c j") 'counsel-git-grep)
    (global-set-key (kbd "C-c k") 'counsel-ag)
    (global-set-key (kbd "C-x l") 'counsel-locate)
    (global-set-key (kbd "C-S-o") 'counsel-rhythmbox)
    (global-set-key (kbd "C-c C-SPC C-SPC") 'counsel-mark-ring)
    (global-set-key (kbd "C-c C-SPC C-b") 'counsel-bookmark)
    (define-key minibuffer-local-map (kbd "C-r") 'counsel-minibuffer-history)))

(use-package ivy-hydra
  :ensure t)

(use-package ivy-rich
  :after ivy
  :config
  (progn
    (ivy-rich-mode 1)
    (setq ivy-rich-path-style 'abbrev)))

(use-package clj-refactor
  :ensure t
  :config
  (progn
    (require 'clj-refactor)
    (add-hook 'clojure-mode-hook
	      (lambda ()
		(clj-refactor-mode 1)
		(yas-minor-mode 1)
		(cljr-add-keybindings-with-prefix "C-c C-m")))))

(use-package discover
  :ensure t
  :config
  (progn
    (require 'discover)
    (global-discover-mode 1)))

(use-package clojure-snippets
  :ensure t)

(use-package discover-clj-refactor
  :ensure t)

(use-package god-mode
  :ensure t
  :init
  (setq god-mode-enable-function-key-translation nil)
  :config
  (progn
    (god-mode)
    (global-set-key (kbd "<escape>") #'god-mode-all)
    (setq god-exempt-major-modes nil)
    (setq god-exempt-predicates nil)

    (defun my-god-mode-update-cursor ()
      (setq cursor-type (if (or god-local-mode buffer-read-only)
                            'box
			  'bar)))
    (add-hook 'god-mode-enabled-hook #'my-god-mode-update-cursor)
    (add-hook 'god-mode-disabled-hook #'my-god-mode-update-cursor)
    (define-key god-local-mode-map (kbd "i") #'god-mode-all)
    (define-key god-local-mode-map (kbd ".") #'repeat)
    (define-key god-local-mode-map (kbd "C-x C-b") #'ivy-switch-buffer)
    (define-key flycheck-mode-map (kbd "C-c C-!") flycheck-command-map)
    (global-set-key (kbd "C-x C-1") #'delete-other-windows)
    (global-set-key (kbd "C-x C-2") #'split-window-below)
    (global-set-key (kbd "C-x C-3") #'split-window-right)
    (global-set-key (kbd "C-x C-0") #'delete-window)
    (global-set-key (kbd "C-x C-5 C-1") #'delete-other-frames)
    (global-set-key (kbd "C-x C-5 C-2") #'make-frame-command)
    (global-set-key (kbd "C-x C-5 C-o") #'other-frame)
    (global-set-key (kbd "C-x C-5 C-9") #'other-frame)))

(use-package all-the-icons)

(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1))

(which-key-enable-god-mode-support)

(use-package rainbow-delimiters
  :ensure t
  :config
  (progn
    (add-hook 'prog-mode-hook 'rainbow-delimiters-mode)))

(use-package eyebrowse
  :ensure t
  :diminish eyebrowse-mode
  :config (progn
            (define-key eyebrowse-mode-map (kbd "M-1") 'eyebrowse-switch-to-window-config-1)
            (define-key eyebrowse-mode-map (kbd "M-2") 'eyebrowse-switch-to-window-config-2)
            (define-key eyebrowse-mode-map (kbd "M-3") 'eyebrowse-switch-to-window-config-3)
            (define-key eyebrowse-mode-map (kbd "M-4") 'eyebrowse-switch-to-window-config-4)
            (eyebrowse-mode t)
            (setq eyebrowse-new-workspace t)))

(use-package fzf
  :ensure t
  :config
  (progn
    (global-set-key (kbd "<f5> f f") #'fzf)
    (global-set-key (kbd "<f5> f g") #'fzf-git)
    (global-set-key (kbd "<f5> f p") #'fzf-projectile)))

(use-package treemacs
  :ensure t
  :config
  (progn
    (global-set-key (kbd "<f5> t") #'treemacs)))

(use-package pomidor
  :ensure t
  :bind (("<f5> p" . pomidor))
  :config (setq pomidor-sound-tick nil
                pomidor-sound-tack nil)
  :hook (pomidor-mode . (lambda ()
                          (display-line-numbers-mode -1) ; Emacs 26.1+
                          (setq left-fringe-width 0 right-fringe-width 0)
                          (setq left-margin-width 2 right-margin-width 0)
                          ;; force fringe update
                          (set-window-buffer nil (current-buffer)))))

(add-to-list 'load-path "~/jhconfig/emacs")
(setq flycheck-emacs-lisp-load-path 'inherit)
(require 'frame-fns)
(require 'frame-cmds)
(require 'zoom-frm)
(editorconfig-mode 1)

(setq geiser-active-implementations '(chicken))
(autoload 'enable-paredit-mode "paredit"
  "Turn on pseudo-structural editing of Lisp code."
  t)
(add-hook 'emacs-lisp-mode-hook       'enable-paredit-mode)
(add-hook 'lisp-mode-hook             'enable-paredit-mode)
(add-hook 'lisp-interaction-mode-hook 'enable-paredit-mode)
(add-hook 'scheme-mode-hook           'enable-paredit-mode)
(add-hook 'clojure-mode-hook          'enable-paredit-mode)
(define-key paredit-mode-map (kbd "C-<left>") #'paredit-forward-barf-sexp)
(define-key paredit-mode-map (kbd "C-<right>") #'paredit-forward-slurp-sexp)
(define-key paredit-mode-map (kbd "C-S-<left>") #'paredit-backward-slurp-sexp)
(define-key paredit-mode-map (kbd "C-S-<right>") #'paredit-backward-barf-sexp)

(add-hook 'cider-repl-mode-hook #'company-mode)
(add-hook 'cider-mode-hook #'company-mode)

(global-set-key (kbd "C-c C-g C-s") 'swiper-isearch-thing-at-point)

(global-set-key (kbd "C-+") 'zoom-in)
(global-set-key (kbd "C--") 'zoom-out)

(defhydra hydra-window (:color red
                               :hint nil)
  "
 Split: _v_ert _x_:horz
Delete: _o_nly  _da_ce  _dw_indow  _db_uffer  _df_rame
  Move: _s_wap
Frames: _f_rame new  _df_ delete
  Misc: _m_ark _a_ce  _u_ndo  _r_edo"
  ("h" windmove-left)
  ("j" windmove-down)
  ("k" windmove-up)
  ("l" windmove-right)
  ("H" hydra-move-splitter-left)
  ("J" hydra-move-splitter-down)
  ("K" hydra-move-splitter-up)
  ("L" hydra-move-splitter-right)
  ("|" (lambda ()
         (interactive)
         (split-window-right)
         (windmove-right)))
  ("_" (lambda ()
         (interactive)
         (split-window-below)
         (windmove-down)))
  ("v" split-window-right)
  ("x" split-window-below)
					;("t" transpose-frame "'")
  ;; winner-mode must be enabled
  ("u" winner-undo)
  ("r" winner-redo) ;;Fixme, not working?
  ("o" delete-other-windows :exit t)
  ("a" ace-window :exit t)
  ("f" new-frame :exit t)
  ("s" ace-swap-window)
  ("da" ace-delete-window)
  ("dw" delete-window)
  ("db" kill-this-buffer)
  ("df" delete-frame :exit t)
  ("q" nil)
					;("i" ace-maximize-window "ace-one" :color blue)
					;("b" ido-switch-buffer "buf")
  ("m" headlong-bookmark-jump))

(global-set-key (kbd "<f5> w") #'hydra-window/body)
(global-set-key (kbd "C-x C-o") #'hydra-window/body)

(provide 'init)

;;; init.el ends here
