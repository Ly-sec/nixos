(setq select-enable-clipboard t)
(setq select-enable-primary t)

(use-package! elcord
  :custom
  (elcord-use-major-mode-as-main-icon nil)
  (elcord-editor-icon "doom_cute_icon")
  (elcord-refresh-rate 5)
  :config
  (setq elcord-idle-message "Idling"
        elcord-idle-time 300
        elcord-display-elapsed nil)
  (elcord-mode 1))

;; Magit auto-refresh after save
(after! magit
  (add-hook 'after-save-hook #'magit-after-save-refresh-status t))

(provide 'tools)
