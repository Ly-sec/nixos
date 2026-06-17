;; -----------------------------
;; Key Bindings
;; -----------------------------

(after! evil
  (map! :leader
        :desc "Tangle lysec dotfiles (bin/tangle-init or Org fallback)" "n t"
        #'my/org-tangle-dotfiles-bootstrap)

  ;; Open Yazi inside vterm with leader key
  (map! :leader
        :desc "Open Yazi (vterm)" "o y"
        (lambda ()
          (interactive)
          (let ((default-directory (expand-file-name default-directory)))
            (vterm)
            (vterm-send-string "yazi\n")))))

(provide 'keybinds)
