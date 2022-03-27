;;; init.el --- Emcas config file
;;; Code:

;; Copy this file to ~/.emacs.d/init.el
;; See https://github.com/jwiegley/use-package#installing-use-package
;; Install use-package from melpa

(require 'package)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") t)
(add-to-list 'package-archives
             '("org" . "https://orgmode.org/elpa/") t)

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

(setq custom-file "~/.emacs.d/custom.el")
(load custom-file)

(defconst user-init-dir "~/jhconfig/emacs")
(defun load-user-file (file)
  "Load a FILE in the user config directory."
  (interactive "f")
  (load-file (expand-file-name file user-init-dir)))

;; related to the emacs backup file
(load-user-file "backup.el")
(load-user-file "history.el")

(setq auto-save-timeout 3)

;; Hide toolbar
(tool-bar-mode -1)

;; Move to previous point
;; I'm still confusing how to move back to the point in Emacs.
(bind-key "C-x p" 'pop-to-mark-command)
(setq set-mark-command-repeat-pop t)

;; set default tab char's display width to 4 spaces
(setq-default tab-width 4) ; emacs 23.1 to 26 default to 8

;; set current buffer's tab char's display width to 4 spaces
(setq tab-width 4)

;; do not use tab to indent
(setq-default indent-tabs-mode nil)

;; to resize org image
(setq org-image-actual-width nil)

;; original f4 is used to record it is moved to f4 f4
(global-unset-key (kbd "<f4>"))

(global-set-key (kbd "C-;") #'save-buffer)
(global-set-key (kbd "<f4> x") #'delete-window)
(global-set-key (kbd "<f4> v") #'split-window-right)
(global-set-key (kbd "<f4> c") #'split-window-below)
(defvar search-key-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "p") #'isearch-forward-symbol-at-point)
    (define-key map (kbd "P") #'swiper-isearch-thing-at-point)
    map))
(global-set-key (kbd "<f4> S") search-key-map)
(global-set-key (kbd "<XF86Launch5>") #'toggle-input-method)

(use-package flycheck :ensure t
  :config
  (progn
    (setq jh-error-map
          (let ((map (make-sparse-keymap)))
                (define-key map (kbd "k") #'flycheck-next-error)
                (define-key map (kbd "j") #'flycheck-previous-error)
                (define-key map (kbd "h") #'previous-error)
                (define-key map (kbd "l") #'next-error)
                map))
    (global-set-key (kbd "<f4> e") jh-error-map)))
(add-hook 'after-init-hook #'global-flycheck-mode)

(bind-key "M-SPC" 'cycle-spacing)
(global-set-key (kbd "C-;") #'save-buffer)
(global-set-key (kbd "<f4> b") #'counsel-switch-buffer)
(global-set-key (kbd "<Hangul>") #'toggle-input-method)

(defun xah-save-all-unsaved ()
  "Save all unsaved files. no ask.
Version 2019-11-05"
  (interactive)
  (save-some-buffers t ))

(if (version< emacs-version "27")
    (add-hook 'focus-out-hook 'xah-save-all-unsaved)
  (setq after-focus-change-function 'xah-save-all-unsaved))

;; stop creating those #auto-save# files
(setq auto-save-default nil)

(setq create-lockfiles nil)

(use-package xclip :ensure t)
(use-package projectile :ensure t)

(use-package magit
  :ensure t
  :config
  (progn
    (global-set-key (kbd "<f4> g") #'magit-status)))

(use-package flycheck-clj-kondo
  :ensure t)

(use-package clojure-mode
  :ensure t
  :config
  (require 'flycheck-clj-kondo))

;; (use-package parinfer
;;   :ensure t
;;   :bind
;;   (("C-c ." . parinfer-toggle-mode))
;;   :init
;;   (progn
;;     (setq parinfer-extensions
;;           '(defaults       ; should be included.
;;              pretty-parens  ; different paren styles for different modes.
;;          ;;            evil           ; If you use Evil.
;;          ;;            lispy          ; If you use Lispy. With this extension, you should install Lispy and do not enable lispy-mode directly.
;;          ;;            paredit        ; Introduce some paredit commands.
;;              smart-tab      ; C-b & C-f jump positions and smart shift with tab & S-tab.
;;              smart-yank))   ; Yank behavior depend on mode.
;;     (add-hook 'clojure-mode-hook #'parinfer-mode)
;;     (add-hook 'emacs-lisp-mode-hook #'parinfer-mode)
;;     (add-hook 'common-lisp-mode-hook #'parinfer-mode)
;;     (add-hook 'scheme-mode-hook #'parinfer-mode)
;;     (add-hook 'lisp-mode-hook #'parinfer-mode)))

;; (use-package parinfer-rust-mode
;;   :hook (emacs-lisp-mode
;;          clojure-mode
;;          common-list-mode
;;          scheme-mode
;;          lisp-mode)
;;   :init
;;   (setq parinfer-rust-auto-download t))


(use-package posframe
  :ensure t)

(use-package ivy-posframe
  :ensure t
  :config
  (progn
    (require 'ivy-posframe)
    (setq ivy-posframe-display-functions-alist '((t . ivy-posframe-display-at-frame-bottom-left)))
    (ivy-posframe-mode 1)))

(ivy-posframe-mode 0)

(use-package lsp-mode
  :ensure t
  :init
  ;; (setq lsp-keymap-prefix "s-l")
  (setq lsp-keymap-prefix "C-c l")
  (setq read-process-output-max (* (* 1024 1024) 8)) ;; 1mb
  (setq lsp-completion-provider :capf)
  (setq gc-cons-threshold 100000000)
  :config
  (progn
    (define-key lsp-mode-map (kbd "<f9> .") #'lsp-execute-code-action)
    (add-hook 'rust-mode-hook #'lsp)
    (add-hook 'typescript-mode-hook #'lsp)
    (add-hook 'js-mode-hook #'lsp)
    (add-hook 'haskell-mode-hook #'lsp)
    (add-hook 'java-mode-hook #'lsp)
    (add-hook 'clojure-mode-hook #'lsp)
    (add-to-list 'lsp-file-watch-ignored-directories "\\.cargo\\'")
    (add-to-list 'lsp-file-watch-ignored-directories "\\.githuub\\'"))
  :commands lsp)

(use-package lsp-ui :ensure t :commands lsp-ui-mode)
(use-package lsp-ivy :ensure t :commands lsp-ivy-workspace-symbol)
(use-package lsp-treemacs :ensure t
  :config
  (progn
    (global-set-key (kbd "<f4> e ;") #'lsp-treemacs-errors-list)))

(use-package lsp-haskell
  :ensure t)

(use-package lsp-java
  :ensure t)

(use-package format-all
  :ensure t
  :config
  (progn
    (global-set-key (kbd "<f4> C-f") #'format-all-buffer)
    (add-hook 'markdown-mode-hook
              (lambda () (add-hook 'before-save-hook #'format-all-buffer nil 'local)))
    (add-hook 'typescript-mode-hook
              (lambda () (add-hook 'before-save-hook #'format-all-buffer nil 'local)))
    (add-hook 'clojure-mode-hook
              (lambda () (add-hook 'before-save-hook #'format-all-buffer nil 'local)))
    (add-hook 'javascript-mode-hook
              (lambda () (add-hook 'before-save-hook #'format-all-buffer nil 'local)))))

(use-package org-roam
  :ensure t
  :init
  (setq org-roam-v2-ack t)
  :config
  (progn
    (setq org-roam-directory "~/org-roam")
    (add-hook 'after-init-hook 'org-roam-mode)
    (org-roam-db-autosync-mode)
    (setq org-roam-mode-section-functions
      (list #'org-roam-backlinks-section
            #'org-roam-reflinks-section
            ;; #'org-roam-unlinked-references-section
            ))
    ;; create maps using function keys
    (let ((jh-roam-map
           (let ((map (make-sparse-keymap)))
            (define-key map (kbd "f f") #'org-roam-node-find)
            (define-key map (kbd "t") #'org-roam-dailies-goto-today)
            (define-key map (kbd "c t") #'org-roam-dailies-capture-today)
            map)
           ))
      (global-set-key (kbd "<f4> r") jh-roam-map))
    ))

(global-git-commit-mode)
(xclip-mode 1)

(global-set-key (kbd "M-p") 'ace-window)

(when (fboundp 'windmove-default-keybindings)
  (windmove-default-keybindings)
  (global-set-key (kbd "C-S-h") 'windmove-swap-states-left)
  (global-set-key (kbd "C-S-j") 'windmove-swap-states-down)
  (global-set-key (kbd "C-S-k") 'windmove-swap-states-up)
  (global-set-key (kbd "C-S-l") 'windmove-swap-states-right)
  (global-set-key (kbd "<f4> <left>") 'windmove-left)
  (global-set-key (kbd "<f4> <down>") 'windmove-down)
  (global-set-key (kbd "<f4> <up>") 'windmove-up)
  (global-set-key (kbd "<f4> <right>") 'windmove-right))

(projectile-mode +1)
(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
(setq projectile-project-search-path '("~/code/" "~/code/read/" "~/code/study"))

(use-package headlong
  :ensure t)

(use-package hydra
  :ensure t)
(use-package counsel :ensure t)
(use-package ivy
  :ensure t
  :config
  (progn
    (ivy-mode 1)
    (setq ivy-use-virtual-buffers t)
    (setq enable-recursive-minibuffers t)
    ;; enable this if you want `swiper' to use it
    (setq search-default-mode #'char-fold-to-regexp)
    (define-key ivy-minibuffer-map (kbd "C-n") #'ivy-next-line)
    (global-set-key (kbd "C-S-s") 'swiper)
    (global-set-key (kbd "C-s") #'isearch-forward)
    (global-set-key (kbd "C-c C-r") 'ivy-resume)
    (global-set-key (kbd "<f6>") 'ivy-resume)
    (global-set-key (kbd "M-x") 'counsel-M-x)
    (global-set-key (kbd "C-f") 'counsel-M-x)
    (global-set-key (kbd "C-x C-f") 'counsel-find-file)
    (global-set-key (kbd "<f4> b") 'counsel-switch-buffer)
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
    (global-set-key (kbd "<f4> SPC") 'counsel-mark-ring)
    (global-set-key (kbd "C-c C-SPC C-b") 'counsel-bookmark)
    (define-key minibuffer-local-map (kbd "C-r") 'counsel-minibuffer-history)
    (global-set-key
      (kbd "<f4> <f4>")
      (defhydra hydra-macro ()
          "macro"
          ("<f4>" end-kbd-macro "end")
          ("<f5>" call-last-kbd-macro "play")))
    ))

(use-package ivy-hydra
  :ensure t)

(use-package pretty-hydra
  :ensure t)
;; (use-package hydra-examples
;;   :ensure t)

;; (use-package ivy-rich
;;   :after ivy
;;   :config
;;   (progn
;;     (ivy-rich-mode 1)
;;     (setq ivy-rich-path-style 'abbrev)))

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

;; (use-package god-mode
;;   :ensure t
;;   :init
;;   (setq god-mode-enable-function-key-translation nil)
;;   :config
;;   (progn
;;     (god-mode)
;;     (global-set-key (kbd "<escape>") #'god-mode-all)
;;     (setq god-exempt-major-modes nil)
;;     (setq god-exempt-predicates nil)

;;     (defun my-god-mode-update-cursor ()
;;       (setq cursor-type (if (or god-local-mode buffer-read-only)
;;                             'box
;;                'bar)))
;;     (add-hook 'god-mode-enabled-hook #'my-god-mode-update-cursor)
;;     (add-hook 'god-mode-disabled-hook #'my-god-mode-update-cursor)
;;     (define-key god-local-mode-map (kbd "i") #'god-mode-all)
;;     (define-key god-local-mode-map (kbd ".") #'repeat)
;;     (define-key god-local-mode-map (kbd "C-x C-b") #'ivy-switch-buffer)
;;     (define-key flycheck-mode-map (kbd "C-c C-!") flycheck-command-map)
;;     (global-set-key (kbd "C-x C-1") #'delete-other-windows)
;;     (global-set-key (kbd "C-x C-2") #'split-window-below)
;;     (global-set-key (kbd "C-x C-3") #'split-window-right)
;;     (global-set-key (kbd "C-x C-0") #'delete-window)
;;     (global-set-key (kbd "C-x C-5 C-1") #'delete-other-frames)
;;     (global-set-key (kbd "C-x C-5 C-2") #'make-frame-command)
;;     (global-set-key (kbd "C-x C-5 C-o") #'other-frame)
;;     (global-set-key (kbd "C-x C-5 C-9") #'other-frame)))

(use-package all-the-icons
  :ensure t)

(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1))

(use-package rainbow-delimiters
  :ensure t
  :config
  (progn
    (add-hook 'prog-mode-hook 'rainbow-delimiters-mode)
    (setq doom-modeline-buffer-file-name-style 'buffer-name)))

(use-package eyebrowse
  :ensure t
  :diminish eyebrowse-mode
  :config (progn
            (define-key eyebrowse-mode-map (kbd "M-1") 'eyebrowse-switch-to-window-config-1)
            (define-key eyebrowse-mode-map (kbd "M-2") 'eyebrowse-switch-to-window-config-2)
            (define-key eyebrowse-mode-map (kbd "M-3") 'eyebrowse-switch-to-window-config-3)
            (define-key eyebrowse-mode-map (kbd "M-4") 'eyebrowse-switch-to-window-config-4)
            (define-key eyebrowse-mode-map (kbd "M-5") 'eyebrowse-switch-to-window-config-5)
            (define-key eyebrowse-mode-map (kbd "M-6") 'eyebrowse-switch-to-window-config-6)
            (define-key eyebrowse-mode-map (kbd "M-7") 'eyebrowse-switch-to-window-config-7)
            (define-key eyebrowse-mode-map (kbd "M-8") 'eyebrowse-switch-to-window-config-8)
            (define-key eyebrowse-mode-map (kbd "M-9") 'eyebrowse-switch-to-window-config-9)
            (define-key eyebrowse-mode-map (kbd "M-0") 'eyebrowse-switch-to-window-config-0)
            (eyebrowse-mode t)
            (setq eyebrowse-new-workspace t)))

(use-package fzf
  :ensure t
  :config
  (progn
    (let ((jh-fzf-map
           (let ((map (make-sparse-keymap)))
             (define-key map (kbd "f") #'fzf)
             (define-key map (kbd "g") #'fzf-git)
             (define-key map (kbd "p") #'fzf-projectile)
             map)))
          (global-set-key (kbd "<f4> f") jh-fzf-map)
      )))

(use-package treemacs
  :ensure t
  :config
  (progn
    (global-set-key (kbd "<f4> t") #'treemacs)))

(use-package treemacs-projectile
  :ensure t)

(use-package pomidor
  :ensure t
  :bind (("<f4> p" . pomidor))
  :config (setq pomidor-sound-tick nil
                pomidor-sound-tack nil)
  :hook (pomidor-mode . (lambda ()
                          (display-line-numbers-mode -1) ; Emacs 26.1+
                          (setq left-fringe-width 0 right-fringe-width 0)
                          (setq left-margin-width 2 right-margin-width 0)
                          ;; force fringe update
                          (set-window-buffer nil (current-buffer)))))

(use-package deadgrep
  :ensure t
  :config
  (progn
    (global-set-key (kbd "<f4> s") #'deadgrep)))

(use-package dashboard
  :ensure t
  :config
  (dashboard-setup-startup-hook))

(use-package avy
  :ensure t)

;;(use-package org-roam-server
;;  :ensure t
;;  :config
;;  (setq org-roam-server-host "127.0.0.1"
;;        org-roam-server-port 8080
;;        org-roam-server-authenticate nil
;;        org-roam-server-export-inline-images t
;;        org-roam-server-serve-files nil
;;        org-roam-server-served-file-extensions '("pdf" "mp4" "ogv")
;;        org-roam-server-network-poll t
;;        org-roam-server-network-arrows nil
;;        org-roam-server-network-label-truncate t
;;        org-roam-server-network-label-truncate-length 60
;;        org-roam-server-network-label-wrap-length 20))
;;
;; (use-package auto-package-update
;;   :ensure t
;;   :config
;;   (setq auto-package-update-delete-old-versions t
;;         auto-package-update-interval 4)
;;   (auto-package-update-maybe))

(use-package undo-tree
  :ensure t
  :config
  (global-undo-tree-mode))

(use-package winner
  :ensure t
  :bind (("M-[" . winner-undo)
         ("M-]" . winndr-redo)
         )
  :config
  (winner-mode 1))

(use-package vterm
  :ensure t)

(use-package ranger
  :ensure t)

(use-package typescript-mode :ensure t)

(use-package company-tabnine :ensure t
  :config
  (add-to-list 'company-backends #'company-tabnine)
  ;; Trigger completion immediately.
  (setq company-idle-delay 0)
  ;; Number the candidates (use M-1, M-2 etc to select completions).
  (setq company-show-numbers t))

(use-package company
  :ensure t
  :config
  (define-key company-mode-map (kbd "C-i") #'company-complete))

(use-package origami
  :ensure t)

(defun org-jh-time-stamp-minute ()
  "Add timestamp minute."
  (interactive)
  (let ((current-prefix-arg '(16)))
    (call-interactively #'org-time-stamp)))

(defun org-roam-jh-open-now ()
  "Open now org roam."
  (interactive)
  (let ((node (org-roam-node-read "Now")))
    (org-roam-node-visit node)))

(defun jh-insert-today ()
  "Insert today."
  (insert (shell-command-to-string "echo -n $(date +%Y-%m-%d)")))

(defun org-roam-jh-insert-today-link ()
  "Insert today org roam link."
  (interactive)
  (set-mark-command nil)
  (jh-insert-today)
  (org-roam-node-insert))

(defvar jh-hydra-input-method-toggled nil)

(pretty-hydra-define hydra-org-roam-jh
  (:color red :quit-key "q"
          :post (progn
                  (when jh-hydra-input-method-toggled
                    (setq jh-hydra-input-method-toggled nil)
                    (toggle-input-method))
                  (setq input-method-function nil)
                  )
          :body-pre (progn
                      (when input-method-function
                        (toggle-input-method)
                        (setq jh-hydra-input-method-toggled t))))
  ("Metadata" (("t" org-roam-tag-add "tag add")
               ("T" org-roam-tag-delete "tag delete")
               ("r" org-roam-ref-add "ref(link) add")
               ("a" org-roam-alias-add "alias add"))
   "Insert" (("n" org-jh-time-stamp-minute "now")
             ("l" org-insert-link "link")
             ("o" org-roam-jh-insert-today-link "today link"))
   "Dailies" (("d" org-roam-dailies-goto-next-note "tomorrow")
              ("s" org-roam-dailies-goto-previous-note "yesterday")
              ("f" org-roam-dailies-goto-date "other day"))
   "Move" (("N" org-roam-jh-open-now "Now")
           ("D" org-roam-dailies-goto-today "Today")
           ("F" org-roam-node-find "Find"))
   ))

(use-package org
  :ensure t
  :config
  (setq org-link-abbrev-alist
        '(("bigkingtravel"  . "~/code/bigkingtravel/"))) ;; Linux/OSX
  (setq org-return-follows-link 't)

  (let ((jh-org-global-map
         (let ((map (make-sparse-keymap)))
           (define-key map (kbd "c") #'org-capture)
           (define-key map (kbd "l") #'org-store-link)
           map)))
    (global-set-key (kbd "<f4> o") jh-org-global-map)
    (define-key org-mode-map (kbd "<f9> <f8>") #'hydra-org-roam-jh/body)
    (define-key org-mode-map (kbd "<f9> i") #'org-roam-node-insert)
    (define-key org-mode-map (kbd "<f9> d") #'org-roam-buffer-toggle-display)
    (define-key org-mode-map (kbd "<f9> r") #'org-roam-ref-add)
    (define-key org-mode-map (kbd "<f9> a") #'org-roam-alias-add)
    (define-key org-mode-map (kbd "<f9> t a") #'org-roam-tag-add)
    (define-key org-mode-map (kbd "<f9> t d") #'org-roam-tag-delete)
    (define-key org-mode-map (kbd "<f9> t") #'org-time-stamp)
    (define-key org-mode-map (kbd "<f9> b") #'org-roam-buffer-toggle)
    (define-key org-mode-map (kbd "<f9> RET") #'org-roam-buffer-visit-thing))
  )

(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(use-package hangul3shinp2
  :straight (hangul3shinp2
             :host github
             :repo "majecty/hangul3shinp2.el"
             :branch "master"))

(use-package color-theme-sanityinc-tomorrow
  :ensure t
  :config (color-theme-sanityinc-tomorrow-night))

(use-package terminal-here :ensure t
  :config
  (global-set-key (kbd "<f5> t h") #'terminal-here-launch)
  (global-set-key (kbd "<f5> t p") #'terminal-here-project-launch))

(use-package lua-mode :ensure t)

(use-package rust-mode :ensure t)

(use-package systemd :ensure t)

(use-package yasnippet :ensure t
  :config
  (yas-global-mode 1))

(use-package yasnippet-snippets :ensure t)

(use-package ivy-yasnippet :ensure t
  :config
  (global-set-key (kbd "<f4> y") #'ivy-yasnippet))

(use-package emmet-mode :ensure t
  :config
  (progn
    (add-hook 'html-mode-hook 'emmet-mode))
  )

(use-package gradle-mode :ensure t)

(use-package peep-dired :ensure t
  :bind (:map peep-dired-mode-map
              ("SPC" . nil)
              ("<backspace>" . nil))
  :config (define-key dired-mode-map (kbd "<f9> p") #'peep-dired))

(use-package eglot :ensure t)

(use-package just-mode :ensure t)

(use-package counsel-projectile :ensure t
  :config
  (progn
    (global-set-key (kbd "<f4> B") #'counsel-projectile-switch-to-buffer)))

(use-package npm :ensure t)

(use-package editorconfig
  :ensure t
  :config
  (editorconfig-mode 1))

(use-package flymake-eslint :ensure t
  :config
  (add-hook 'js-mode-hook #'flymake-eslint-enable))

(use-package which-key :ensure t
  :config
  (progn
    ;; FIXME: save names in list and apply here.
    (which-key-add-keymap-based-replacements global-map
      "<f4> S" "search-prefix"
      "<f4> f" "fzf-prefix"
      "<f4> o" "org-prefix"
      "<f4> e" "error-prefix"
      "<f4> r" "roam-prefix")
    (setq which-key-idle-delay 0.1)
    (which-key-mode)
    (which-key-enable-god-mode-support)))

;; (use-package recomplete
;;   :ensure t
;;   :bind ("M-/" . recomplete-dabbrev))
(use-package treemacs
  :ensure t
  :defer t
  :init
  (with-eval-after-load 'winum
    (define-key winum-keymap (kbd "M-0") #'treemacs-select-window))
  :config
  (progn
    (setq treemacs-collapse-dirs                   (if treemacs-python-executable 3 0)
          treemacs-deferred-git-apply-delay        0.5
          treemacs-directory-name-transformer      #'identity
          treemacs-display-in-side-window          t
          treemacs-eldoc-display                   'simple
          treemacs-file-event-delay                5000
          treemacs-file-extension-regex            treemacs-last-period-regex-value
          treemacs-file-follow-delay               0.2
          treemacs-file-name-transformer           #'identity
          treemacs-follow-after-init               t
          treemacs-expand-after-init               t
          treemacs-find-workspace-method           'find-for-file-or-pick-first
          treemacs-git-command-pipe                ""
          treemacs-goto-tag-strategy               'refetch-index
          treemacs-indentation                     2
          treemacs-indentation-string              " "
          treemacs-is-never-other-window           nil
          treemacs-max-git-entries                 5000
          treemacs-missing-project-action          'ask
          treemacs-move-forward-on-expand          nil
          treemacs-no-png-images                   nil
          treemacs-no-delete-other-windows         t
          treemacs-project-follow-cleanup          nil
          treemacs-persist-file                    (expand-file-name ".cache/treemacs-persist" user-emacs-directory)
          treemacs-position                        'left
          treemacs-read-string-input               'from-child-frame
          treemacs-recenter-distance               0.1
          treemacs-recenter-after-file-follow      nil
          treemacs-recenter-after-tag-follow       nil
          treemacs-recenter-after-project-jump     'always
          treemacs-recenter-after-project-expand   'on-distance
          treemacs-litter-directories              '("/node_modules" "/.venv" "/.cask")
          treemacs-show-cursor                     nil
          treemacs-show-hidden-files               t
          treemacs-silent-filewatch                nil
          treemacs-silent-refresh                  nil
          treemacs-sorting                         'alphabetic-asc
          treemacs-select-when-already-in-treemacs 'move-back
          treemacs-space-between-root-nodes        t
          treemacs-tag-follow-cleanup              t
          treemacs-tag-follow-delay                1.5
          treemacs-text-scale                      nil
          treemacs-user-mode-line-format           nil
          treemacs-user-header-line-format         nil
          treemacs-wide-toggle-width               70
          treemacs-width                           35
          treemacs-width-increment                 1
          treemacs-width-is-initially-locked       t
          treemacs-workspace-switch-cleanup        nil)

    ;; The default width and height of the icons is 22 pixels. If you are
    ;; using a Hi-DPI display, uncomment this to double the icon size.
    ;;(treemacs-resize-icons 44)

    (treemacs-follow-mode t)
    (treemacs-filewatch-mode t)
    (treemacs-fringe-indicator-mode 'always)

    (pcase (cons (not (null (executable-find "git")))
                 (not (null treemacs-python-executable)))
      (`(t . t)
       (treemacs-git-mode 'deferred))
      (`(t . _)
       (treemacs-git-mode 'simple)))

    (treemacs-hide-gitignored-files-mode nil))
  :bind
  (:map global-map
        ("M-0"       . treemacs-select-window)
        ("C-x t 1"   . treemacs-delete-other-windows)
        ("C-x t t"   . treemacs)
        ("C-x t d"   . treemacs-select-directory)
        ("C-x t B"   . treemacs-bookmark)
        ("C-x t C-t" . treemacs-find-file)
        ("C-x t M-t" . treemacs-find-tag)))

(use-package treemacs-evil
  :after (treemacs evil)
  :ensure t)

(use-package treemacs-projectile
  :after (treemacs projectile)
  :ensure t)

(use-package treemacs-icons-dired
  :hook (dired-mode . treemacs-icons-dired-enable-once)
  :ensure t)

(use-package treemacs-magit
  :after (treemacs magit)
  :ensure t)

(use-package treemacs-persp ;;treemacs-perspective if you use perspective.el vs. persp-mode
  :after (treemacs persp-mode) ;;or perspective vs. persp-mode
  :ensure t
  :config (treemacs-set-scope-type 'Perspectives))

(use-package treemacs-tab-bar ;;treemacs-tab-bar if you use tab-bar-mode
  :after (treemacs)
  :ensure t
  :config (treemacs-set-scope-type 'Tabs))

(bind-key "M-/" 'hippie-expand)

(defun sanityinc/dabbrev-friend-buffer (other-buffer)
  (< (buffer-size other-buffer) (* 1 1024 1024)))
(setq dabbrev-friend-buffer-function 'sanityinc/dabbrev-friend-buffer)
(setq hippie-expand-try-functions-list
      '(yas-hippie-try-expand
        try-expand-all-abbrevs
        try-complete-file-name-partially
        try-complete-file-name
        try-expand-dabbrev
        try-expand-dabbrev-from-kill
        try-expand-dabbrev-all-buffers
        try-expand-list
        try-expand-line
        try-complete-lisp-symbol-partially
        try-complete-lisp-symbol))

(add-to-list 'load-path "~/jhconfig/emacs")
(setq flycheck-emacs-lisp-load-path 'inherit)
(require 'frame-fns)
(require 'frame-cmds)
(require 'zoom-frm)

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

(pretty-hydra-define hydra-window
  (:color red :quit-key "q"
          :post (progn
                  (when jh-hydra-input-method-toggled
                    (setq jh-hydra-input-method-toggled nil)
                    (toggle-input-method)
                    (setq input-method-function nil))
                  )
          :body-pre (progn
                      (when input-method-function
                        (toggle-input-method)
                        (setq jh-hydra-input-method-toggled t))))
  ("Move" (("h" windmove-left)
           ("j" windmove-down)
           ("k" windmove-up)
           ("l" windmove-right)
           ("s" ace-swap-window))
   "Split" (("+" balance-windows "balance")
            ("|" (lambda ()
                   (interactive)
                   (split-window-right)
                   (windmove-right)))
            ("_" (lambda ()
                   (interactive)
                   (split-window-below)
                   (windmove-down)))
            ("v" split-window-right)
            ("x" split-window-below))
                                        ;("t" transpose-frame "'")
   ;; winner-mode must be enabled
   "Undo" (("u" winner-undo)
           ("r" winner-redo)) ;;Fixme, not working?
   "Delete" (("o" delete-other-windows)
             ("db" kill-this-buffer)
             ("df" delete-frame :exit t)
             ("dw" delete-window))
   "Buffer" (("b" counsel-switch-buffer "buffer")
             ("B" counsel-projectile-switch-to-buffer "projectile buffer")
             ;;  ("f" new-frame :exit t)
             ("f" fzf "fzf" :exit t)
             ("m" headlong-bookmark-jump)))
  ;;  ("da" ace-delete-window)
                                        ;("i" ace-maximize-window "ace-one" :color blue)
                                        ;("b" ido-switch-buffer "buf")
  )

(global-set-key (kbd "<f4> w") #'hydra-window/body)
(global-set-key (kbd "C-x C-o") #'hydra-window/body)

(defvar jh-hydra-input-method-toggled nil)

(global-set-key (kbd "C-n")
 (defhydra hydra-move
   (:post (progn
            (when jh-hydra-input-method-toggled
              (setq jh-hydra-input-method-toggled nil)
;;              (toggle-input-method)
              )
            )
          :body-pre (progn
                      (when input-method-function
;;                        (toggle-input-method)
                        (setq jh-hydra-input-method-toggled t))))
   "move"
   ("C-n" nil)
   ("k" next-line "up")
   ("i" previous-line "down")
   ("l" forward-char "right")
   ("j" backward-char "left")
   ("M-j" delete-char "delete")
   ("L" forward-word "w-right")
   ("J" backward-word "w-left")
   ("s" beginning-of-line "home")
   ("f" move-end-of-line "end")
   ("d" scroll-up-command "scroll up")
   ;; Converting M-v to V here by analogy.
   ("e" scroll-down-command "scroll down")
   (";" recenter-top-bottom "recenter")
   ("z" avy-goto-char "char")
   ("x" avy-goto-line "line")
   ("c" avy-goto-word-0 "word")
   ("v" avy-goto-word-0-above "Word")
   ))

(global-set-key (kbd "<f4> q")
 (defhydra hydra-toggle-simple (:color blue)
   "toggle"
   ("w" whitespace-mode "whitespace")
   ("u" undo-tree-visualize "undo")
   ("r" view-mode "read-only")
   ("s" visual-line-mode "soft wrap(visual-line)")
   ("a" abbrev-mode "abbrev")
   ("d" toggle-debug-on-error "debug")
   ("f" auto-fill-mode "fill")
   ("t" toggle-truncate-lines "truncate")
   ("q" nil "cancel")))

(global-set-key (kbd "<f4> .") #'completion-at-point)

(put 'narrow-to-region 'disabled nil)

(setq sentence-end-double-space nil)

(global-auto-revert-mode)
(setq default-input-method "korean-hangul3shinp2")
;; 아무것도 안 했을 때와 두 번 했을 때의 상태가 다른 것 같아.
;; 시작할 때 두 번 해주자.
(toggle-input-method)
(toggle-input-method)

(provide 'init)

;;; init.el ends here
