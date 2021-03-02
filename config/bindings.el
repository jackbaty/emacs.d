;; Mac specific
 (when (eq system-type 'darwin)
   (setq ns-use-native-fullscreen t
         mac-command-modifier 'super
         mac-option-modifier 'meta
         mac-use-title-bar nil))


(global-set-key (kbd "C-c j") 'org-journal-new-entry)
(global-set-key (kbd "C-c l") 'org-store-link)

;; you know, like a Mac
(global-set-key (kbd "s-s") 'save-buffer)
(global-set-key (kbd "s-f") 'swiper)
(global-set-key (kbd "s-z") 'undo)
(global-set-key (kbd "s-v") 'yank) ;; paste
(global-set-key (kbd "s-c") 'kill-ring-save) ;; copy


