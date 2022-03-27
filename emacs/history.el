
;; history
;; minibuffer history is saved in the file
(setq savehist-file "~/.config/emacs/savehist")
(savehist-mode 1)

;; Do not truncate history
(setq history-length t)
(setq history-delete-duplicates t)
(setq savehist-save-minibuffer-history 1)
(setq savehist-additional-variables
      '(kill-ring
        search-ring
        regexp-search-ring))




