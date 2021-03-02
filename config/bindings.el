;; Mac specific
 (when (eq system-type 'darwin)
   (setq ns-use-native-fullscreen t
         mac-command-modifier 'super
         mac-option-modifier 'meta
         mac-use-title-bar nil))


(global-set-key (kbd "C-c j") 'org-journal-new-entry)
(global-set-key (kbd "M-s") 'save-buffer) ;; you know, like a Mac
(global-set-key (kbd "C-c l") 'org-store-link)
(global-set-key (kbd "s-f") 'swiper)
(global-set-key (kbd "s-z") 'undo)

