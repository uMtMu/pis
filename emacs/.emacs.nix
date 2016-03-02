(setq inhibit-startup-message t)
(menu-bar-mode -1)
(tool-bar-mode -1)

(display-time-mode 1)
(line-number-mode 1)
(column-number-mode 1)
(display-battery-mode 1)


(setq tab-width 4)
(defalias 'yes-or-no-p 'y-or-n-p)
(prefer-coding-system 'utf-8)

(require 'package)

(when (>= emacs-major-version 24)
  (require 'package)
  (package-initialize)
  (add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
  )

(show-paren-mode 1)

(setq tramp-default-method "ssh")

;;************************************************************************
;;				 Package Check
;;************************************************************************

(defun ensure-package-installed (&rest packages)
  "Assure every package is installed, ask for installation if it’s not.

Return a list of installed packages or nil for every skipped package."
  (mapcar
   (lambda (package)
      (if (package-installed-p package)
         nil
       (if (y-or-n-p (format "Package %s is missing. Install it? " package))
           (package-install package)
         package)))
   packages))

;; make sure to have downloaded archive description.
;; Or use package-archive-contents as suggested by Nicolas Dudebout
(or (file-exists-p package-user-dir)
    (package-refresh-contents))

(ensure-package-installed 'undo-tree 'neotree 'elpy) ;  --> (nil nil) if iedit and magit are already installed

;; activate installed packages
(package-initialize)

;;************************************************************************
;;				   Undo-tree
;;************************************************************************

(global-undo-tree-mode)

;;;;************************************************************************
;;;;				 Swimmers
;;;;************************************************************************
;;(add-to-list 'load-path "~/.emacs.d/swimmers")
;;(load "swimmers.el")
;;(require 'swimmers)

;;************************************************************************
;;				 Neotree
;;************************************************************************
(require 'neotree)
(global-set-key [f8] 'neotree-toggle)

;;************************************************************************
;;                                Org-Mode
;;************************************************************************

(require 'org)
(require 'org-install)
(require 'org-mobile)

(cond
 ((string-equal system-type "windows-nt") ; Microsoft Windows
  (progn
    (defvar orgdir "c:/org/")))
 ((string-equal system-type "gnu/linux") ; GNU/Linux
  (progn
    (defvar orgdir "~/Dropbox/org/")))
 )
 
(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))

(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(setq org-log-done t)
(setq org-directory orgdir)
(setq org-agenda-files (list (concat orgdir "/is.org")
			     (concat orgdir "/kisisel.org")
			     (concat orgdir "/gunluk.org")
			     (concat orgdir "/pc.org")
			     (concat orgdir "/notlar.org")
))

(setq org-default-notes-file (concat orgdir "/notlar.org"))
(define-key global-map "\C-cc" 'org-capture)

(setq org-refile-targets '((org-agenda-files . (:maxlevel . 6))))

(cond
 ((string-equal system-type "windows-nt") ; Microsoft Windows
  (progn
    (setq org-publish-project-alist
	  '(("site"
	     :base-directory (concat orgdir "/blog")
	     :publishing-directory (concat orgdir "/blog")
	     :section-numbers nil
	     :table-of-contents nil
	     :publishing-function org-html-publish-to-html
	     )))
    ))
 ((string-equal system-type "gnu/linux") ; GNU/Linux
  (progn
    (setq org-publish-project-alist
	  '(("site"
	     :base-directory "~/Projeler/umtmu.github.io"
	     :publishing-directory "~/Projeler/umtmu.github.io"
	     :section-numbers nil
	     :table-of-contents nil
	     :publishing-function org-html-publish-to-html
	     )))
    ))
 )


;; Org-mode günlüğü de içeriyor.
(setq org-agenda-include-diary t)

;;(setq org-agenda-diary-file (concat orgdir "/diary.org"))

;;************************************************************************
;;                            Org-Mobile
;;************************************************************************

(defun webdav_sync()
  (interactive)
  (shell-command "sync")
)
;; Set to <your Dropbox root directory>/MobileOrg.
;(setq org-mobile-directory "~/Dropbox/Apps/MobileOrg")
(setq org-mobile-directory "/mnt/webdav/org")
(setq org-mobile-inbox-for-pull "~/.frommobileorg")
(if (file-exists-p org-mobile-directory)
    (progn
      (add-hook 'after-init-hook 'org-mobile-pull)
      (add-hook 'kill-emacs-hook 'org-mobile-push)
      (add-hook 'kill-emacs-hook 'webdav_sync)
      )
    (message "WebDav sunucusuna bağlanılamadı....")
)

;;************************************************************************
;;                            Auto-Completion
;;************************************************************************

(ido-mode)
(setq org-completion-use-ido t)


;;************************************************************************
;;                               Auto-Fill
;;************************************************************************

(setq-default fill-column 80)
(setq auto-fill-mode t)
(add-hook 'text-mode-hook 'turn-on-auto-fill)
(setq-default auto-fill-function 'do-auto-fill)

;;;;************************************************************************
;;;;                                  W3M
;;;;************************************************************************
;;
;;(add-to-list 'load-path "~/.elisp/emacs-w3m/")
;;(require 'w3m-load)
;;
;;;;************************************************************************
;;;;                              Newsticker 
;;;;************************************************************************
;;
;;(require 'newsticker)
;;
;;; W3M HTML renderer isn't essential, but it's pretty useful.
;;(require 'w3m)
;;(setq newsticker-html-renderer 'w3m-region)
;;
;;; We want our feeds pulled every 10 minutes.
;;(setq newsticker-retrieval-interval 600)
;;
;;; Setup the feeds. We'll have a look at these in just a second.
;;(setq newsticker-url-list-defaults nil)
;;(setq newsticker-url-list
;;      '(
;;	("Hacker News"
;;         "http://feeds.feedburner.com/hacker-news-feed-50?format=xml"
;;         nil nil nil)
;;	("Python Planet"
;;	 "http://planetpython.org/rss20.xml"
;;	 nil nil nil)
;;	("Cumhuriyet - Dünya"
;;	 "http://www.cumhuriyet.com.tr/rss/5.xml"
;;	 nil nil nil)
;;	("Cumhuriyet - Türkiye"
;;	 "http://www.cumhuriyet.com.tr/rss/4.xml"
;;	 nil nil nil)
;;      )
;;)
;;; Optionally bind a shortcut for your new RSS reader.
;;(global-set-key (kbd "C-c r") 'newsticker-treeview)
;;
;;; Don't forget to start it!
;;;(newsticker-start)
;;
;;;;************************************************************************
;;;;                          EMMS Media Player
;;;;************************************************************************
;;
;;
;;(add-to-list 'load-path "~/.elisp/emms/lisp")
;;(require 'emms-setup)
;;(emms-standard)
;;(emms-default-players)

;;************************************************************************
;;                               El-Py
;;************************************************************************

(package-initialize)
(elpy-enable)
;; Fixing a key binding bug in elpy
(define-key yas-minor-mode-map (kbd "C-c k") 'yas-expand)
;; Fixing another key binding bug in iedit mode
(define-key global-map (kbd "C-c o") 'iedit-mode)
(setenv "PYTHONPATH” “/usr/bin/python")
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(elpy-project-root-finder-functions (quote (elpy-project-find-python-root elpy-project-find-hg-root elpy-project-find-svn-root))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;;************************************************************************
;;                               Tema
;;************************************************************************

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector
   ["#212526" "#ff4b4b" "#b4fa70" "#fce94f" "#729fcf" "#e090d7" "#8cc4ff" "#eeeeec"])
 '(custom-enabled-themes (quote (deeper-blue))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;;************************************************************************
;;                            Php-Mode
;;************************************************************************
(autoload 'php-mode "php-mode" "Major mode for editing php code" t)
(add-to-list 'auto-mode-alist '("\\.php$" . php-mode))
(add-to-list 'auto-mode-alist '("\\.inc$" . php-mode))
