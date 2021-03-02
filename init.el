(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)



;; Path to nano emacs modules (mandatory)
(add-to-list 'load-path "/Users/jbaty/Dropbox/emacs/nano-emacs")
;;(add-to-list 'load-path ".")

;; Default layout (optional)
(require 'nano-layout)

;; Theming Command line options (this will cancel warning messages)
(add-to-list 'command-switch-alist '("-dark"   . (lambda (args))))
(add-to-list 'command-switch-alist '("-light"  . (lambda (args))))
(add-to-list 'command-switch-alist '("-default"  . (lambda (args))))
(add-to-list 'command-switch-alist '("-no-splash" . (lambda (args))))
(add-to-list 'command-switch-alist '("-no-help" . (lambda (args))))
(add-to-list 'command-switch-alist '("-compact" . (lambda (args))))

(cond
 ((member "-default" command-line-args) t)
 ((member "-dark" command-line-args) (require 'nano-theme-dark))
 (t (require 'nano-theme-light)))

(require 'nano-faces)
(nano-faces)
(require 'nano-theme)
(nano-theme)
(require 'nano-defaults)
(require 'nano-session)
(require 'nano-modeline)
(require 'nano-bindings)

;; Nano counsel configuration (optional)
;; Needs "counsel" package to be installed (M-x: package-install)
(require 'nano-counsel)


;; Welcome message (optional)
(let ((inhibit-message t))
  (message "Welcome to GNU Emacs / N Λ N O edition")
  (message (format "Initialization time: %s" (emacs-init-time))))

;; Splash (optional)
(unless (member "-no-splash" command-line-args)
  (require 'nano-splash))

;; Help (optional)
(unless (member "-no-help" command-line-args)
  (require 'nano-help))

(provide 'nano)

;; Now do my stuff ---------------------------------------------------------------

(setq user-full-name "Jack Baty"
      user-mail-address "jack@baty.net")

;; Org mode
(setq org-directory "~/Dropbox/notes/org/")

(add-to-list 'load-path "~/Dropbox/emacs/lisp")
(add-to-list 'default-frame-alist '(height . 60))
(add-to-list 'default-frame-alist '(width . 120))


(setq org-return-follows-link t)

(setq org-todo-keywords
      '((sequence "TODO(t)" "NEXT(n)" "WAIT(w)" "STRT(s)" "|" "DONE(d)")))

(setq org-capture-templates
      `(("t" "Todo to Inbox" entry
      (file+headline ,(concat org-directory "tasks.org") "Inbox")
      "* TODO %?\nSCHEDULED: %t\n\n%i\n"
      :empty-lines 1)
        ("T" "Todo to Inbox with Clipboard" entry
      (file+headline ,(concat org-directory "tasks.org") "Inbox")
      "* TODO %?\nSCHEDULED: %t\n%c\n\n%i\n"
      :empty-lines 1)
       ("j" "Journal entry" plain (function org-journal-find-location)
       "* %(format-time-string org-journal-time-format)%?\n%i")
       ("w" "Work Timesheet" entry
      (file+olp+datetree ,(concat org-directory "timesheet.org"))
      "* %? %^g\n%T")
     ("l" "Current file log entry" entry
      (file+olp+datetree buffer-file-name)
      "* %? \n")
     ("d" "Daybook" entry
      (file+olp+datetree ,(concat org-directory "daybook.org"))
      "* %?\n\n" :time-prompt t)
     ("n" "Take a note" entry
      (file+headline ,(concat org-directory "notes.org") "Notes")
      "* %i%? \n %U\n" :empty-lines 1 :prepend t)))

(add-hook 'org-mode-hook 'turn-on-auto-fill)
;;(add-hook 'org-mode-hook #'turn-off-smartparens-mode)

;; Attach dragged files relative to current directory
(setq org-attach-id-dir "./attach")

(setq org-agenda-files (list
                   (concat org-directory "timesheet.org")
                   (concat org-directory "fusionary.org")
                   (concat org-directory "tasks.org")))

 (setq org-agenda-include-diary t org-agenda-start-on-weekday nil
       org-agenda-start-day nil
       org-agenda-log-mode-items (quote (closed))
       org-agenda-persistent-filter t
       org-agenda-skip-scheduled-if-deadline-is-shown (quote
       not-today)
       org-agenda-skip-deadline-prewarning-if-scheduled t
       org-agenda-skip-scheduled-if-done t
       org-agenda-skip-deadline-if-done t org-agenda-span (quote
       day) org-deadline-warning-days 7 org-tags-column 0
       org-log-done 'time org-log-into-drawer t
       org-log-redeadline 'note
       org-agenda-text-search-extra-files (quote (agenda-archives))
       org-agenda-window-setup (quote current-window))

(setq org-journal-dir "~/Dropbox/notes/journal"
    org-journal-file-type 'monthly
    org-journal-file-format "%Y-%m-%d.org"
    org-journal-find-file #'find-file
    org-journal-time-prefix ""
    org-journal-time-format ""
    org-journal-enable-agenda-integration nil
    org-journal-enable-encryption nil
    org-journal-date-format "%A, %B %d %Y")

(defun org-journal-file-header-func (time)
  "Custom function to create journal header."
  (concat
    (pcase org-journal-file-type
      (`daily "")
      (`weekly "#+TITLE: Weekly Journal\n#+STARTUP: folded")
      (`monthly "#+TITLE: Monthly Journal\n#+STARTUP: folded")
      (`yearly "#+TITLE: Yearly Journal\n#+STARTUP: folded"))))

(setq org-journal-file-header 'org-journal-file-header-func)

(add-hook 'org-journal-mode-hook 'turn-on-auto-fill)

;;(setq yas-snippet-dirs
  ;;    '("~/Dropbox/emacs/yasnippets"                 ;; personal snippets
  ;;    ))

;;(yas-global-mode 1) ;; or M-x yas-reload-all if you've started YASnippet already.

(setq evil-respect-visual-line-mode t) ;; sane j and k behavior (must be set before evil loads)
(unless (package-installed-p 'evil)
  (package-install 'evil))
;; Enable Evil
(require 'evil)
(evil-mode 1)


(global-visual-line-mode t)

(defun jab/insert-weather ()
  "Use wttr to insert the current weather at point"
  (interactive)
  (let ((w (shell-command-to-string "curl -s 'wttr.in/49301?0q&format=%c+%C+%t' | head -n6")))
  (insert (mapconcat (function (lambda (x) (format ": %s" x)))
           (split-string w "\n")
           "\n"))))

(which-key-mode)

(projectile-mode +1)
(define-key projectile-mode-map (kbd "s-p") 'projectile-command-map)
(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)

(load "~/.emacs.d/config/bindings.el")


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ivy-count-format "")
 '(ivy-height 8)
 '(ivy-mode t)
 '(ivy-use-virtual-buffers t)
 '(package-selected-packages
   '(projectile markdown-mode which-key evil magit org-journal counsel)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
