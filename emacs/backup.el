;; related backup
;; Emacs saves backup files in the same directory as the original file.
;; The line below changes the backup directory to other directory.
(setq backup-directory-alist '(("." . "~/.config/emacs/backups")))
;; The line below makes emacs remove excess backup versions silently
(setq delete-old-versions -1)
;; Make Emacs versioning its backup files. I don't know how this affect my workflow.
;; It seems that this [link](https://www.emacswiki.org/emacs/ForceBackups) is related.
(setq version-control t)
;; Backup files in git repository, since we don't commit every changes.
(setq vc-make-backup-files t)
;; Move auto saved `#file-name#` files to a directory.
(setq auto-save-file-name-transforms '((".*" "~/.config/emacs/auto-save-list/" t)))
