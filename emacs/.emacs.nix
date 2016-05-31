(setq inhibit-startup-message t)
(menu-bar-mode -1)
(tool-bar-mode -1)

(display-time-mode 1)
(line-number-mode 1)
(column-number-mode 1)
(display-battery-mode 1)
(delete-selection-mode 1)

(setq tab-width 4)
(defalias 'yes-or-no-p 'y-or-n-p)
(prefer-coding-system 'utf-8)

(require 'package)

(when (>= emacs-major-version 24)
  (require 'package)
  (package-initialize)
  (add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
  (add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/") t)
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

(ensure-package-installed 'undo-tree 'neotree 'elpy 'smex 'ido-ubiquitous 'ido-vertical-mode) ;  --> (nil nil) if iedit and magit are already installed

;; activate installed packages
(package-initialize)

;;************************************************************************
;;				   ibuffer
;;************************************************************************

(global-set-key (kbd "C-x C-b") 'ibuffer)
(autoload 'ibuffer "ibuffer" "List buffers." t)

;;************************************************************************
;;				   Undo-tree
;;************************************************************************

(global-undo-tree-mode)
;;************************************************************************
;;				 Swimmers
;;************************************************************************
(add-to-list 'load-path "~/.emacs.d/swimmers")
(load "swimmers.el")
(require 'swimmers)
(setq swimmers-timer (run-with-idle-timer 60 t 'swimming))
;;************************************************************************
;;				 NeoTree
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
    ;;(defvar orgdir "c:/org/")))
    ;; (defvar orgdir "c:/Users/Paytr05/Desktop/")
    ;; (defvar orgdir (concat "c:" (getenv "HOMEPATH") "\\Documents\\org"))
    (defvar orgdir (concat "c:" (getenv "HOMEPATH") "\\Dropbox\\org"))
    (defvar blogdir (concat "c:" (getenv "HOMEPATH") "\\Desktop"))
    )
  )
 ((string-equal system-type "gnu/linux") ; GNU/Linux
  (progn
    (defvar orgdir "~/Dropbox/org/")))
 )

(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))

(define-key global-map "\C-cl" 'org-store-link)
(global-set-key (kbd "C-c C-s") 'calendar)
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
	     :publishing-function org-publish-org-to-html
	     )))
    ))
 )

;;(setq org-agenda-diary-file (concat orgdir "\\diary.org"))

;; Org-mode günlüğü de içeriyor.
(setq org-agenda-include-diary t)

(setq diary-file (concat orgdir "/diary"))

;;(setq org-agenda-diary-file (concat orgdir "/diary.org"))
;; "|"'nin solu yapılacak/eylem bekleyen, sağı yapılmayacak/eylem beklemeyen
;; parantez içindeki ilk harf CcCt kombinasyonundan sonraki kısayolu
;; ! otomatik olarak saatin ekleneceği
;; @ mesaj yazmanı istiyor
;; /! Tam anlamadım. Aşağıdakini oku anlarsan sil
;; The setting for WAIT is even more special: the ‘!’ after the slash means
;; that in addition to the note taken when entering the state, a timestamp
;; should be recorded when leaving the WAIT state, if and only if the target
;; state does not configure logging for entering it. So it has no effect when
;; switching from WAIT to DONE, because DONE is configured to record a timestamp
;; only. But when switching from WAIT back to TODO, the ‘/!’ in the WAIT setting
;; now triggers a timestamp even though TODO has no logging configured.
(setq org-todo-keywords
       '((sequence "TODO(t)" "WAIT(w@/!)" "REVIVED(r@/!)" "|" "DONE(d!)"
		   "CANCELED(c@)")))
;; TODO -> DONE as for TIME
(setq org-log-done 'time)

(setq org-capture-templates
      '(
		("t" "Todo" entry
		 (file+headline (concat orgdir "/notlar.org") "Tasks") "* TODO %? %^G\n  %i\n  %a")
        ("j" "Journal" entry
		 (file+datetree (concat orgdir "/journal.org") "Journal")	"* %?  %^G\nEntered on %U\n  %i\n  %a")
		("r" "Read" entry
		 (file+headline (concat orgdir "/notlar.org") "Readings") "* TODO %c\n  %a")
		)
)
;;************************************************************************
;;                            Org-Mobile
;;************************************************************************

 (when (string-equal system-type "gnu/linux") ; GNU/Linux
  (progn
(defun webdav_sync()
  (interactive)
  (shell-command "sync")
)
))
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
;;;;************************************************************************
;;;;				   Org-Alert
;;;;************************************************************************
;;(require 'org-alert)
;;(setq alert-default-style 'mode-line)

;;************************************************************************
;;                            Auto-Completion
;;************************************************************************
(ido-mode 1)
(ido-everywhere 1)
(setq org-completion-use-ido t)

(require 'ido-vertical-mode)
;; Color codes can be used to customize
(set-face-attribute 'ido-vertical-first-match-face nil
                    :background nil
                    :foreground nil)
(set-face-attribute 'ido-vertical-only-match-face nil
                    :background nil
                    :foreground nil)
(set-face-attribute 'ido-vertical-match-face nil
                    :background nil
                    :foreground nil)

;; optionally
(setq ido-use-faces nil)

(ido-vertical-mode 1)
(setq ido-vertical-define-keys 'C-n-and-C-p-only)

(require 'ido-ubiquitous)
(ido-ubiquitous-mode 1)

;;************************************************************************
;;                               Smex
;;************************************************************************

(require 'smex) ; Not needed if you use package.el
(smex-initialize) ; Can be omitted. This might cause a (minimal) delay
                  ; when Smex is auto-initialized on its first run.

(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)
;; This is your old M-x.
(global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)

;;************************************************************************
;;                               Auto-Fill
;;************************************************************************w

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
;;************************************************************************
;;                              Newsticker 
;;************************************************************************
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
;;	("Planet Emacsen"
;;	 "http://planet.emacsen.org/atom.xml"
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
;;(newsticker-start)
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
;;                                  W3M
;;************************************************************************

;;(add-to-list 'load-path "~/.elisp/emacs-w3m/")
;;(require 'w3m-load)
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
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["#212526" "#ff4b4b" "#b4fa70" "#fce94f" "#729fcf" "#e090d7" "#8cc4ff" "#eeeeec"])
 '(compilation-message-face (quote default))
 '(custom-enabled-themes (quote (tango-dark)))
 '(custom-safe-themes
   (quote
    ("71ecffba18621354a1be303687f33b84788e13f40141580fa81e7840752d31bf" default)))
 '(fci-rule-color "#3E3D31")
 '(highlight-changes-colors (quote ("#FD5FF0" "#AE81FF")))
 '(highlight-tail-colors
   (quote
    (("#3E3D31" . 0)
     ("#67930F" . 20)
     ("#349B8D" . 30)
     ("#21889B" . 50)
     ("#968B26" . 60)
     ("#A45E0A" . 70)
     ("#A41F99" . 85)
     ("#3E3D31" . 100))))
 '(magit-diff-use-overlays nil)
 '(pos-tip-background-color "#A6E22E")
 '(pos-tip-foreground-color "#272822")
 '(vc-annotate-background nil)
 '(vc-annotate-color-map
   (quote
    ((20 . "#F92672")
     (40 . "#CF4F1F")
     (60 . "#C26C0F")
     (80 . "#E6DB74")
     (100 . "#AB8C00")
     (120 . "#A18F00")
     (140 . "#989200")
     (160 . "#8E9500")
     (180 . "#A6E22E")
     (200 . "#729A1E")
     (220 . "#609C3C")
     (240 . "#4E9D5B")
     (260 . "#3C9F79")
     (280 . "#A1EFE4")
     (300 . "#299BA6")
     (320 . "#2896B5")
     (340 . "#2790C3")
     (360 . "#66D9EF"))))
 '(vc-annotate-very-old-color nil)
 '(weechat-color-list
   (unspecified "#272822" "#3E3D31" "#A20C41" "#F92672" "#67930F" "#A6E22E" "#968B26" "#E6DB74" "#21889B" "#66D9EF" "#A41F99" "#FD5FF0" "#349B8D" "#A1EFE4" "#F8F8F2" "#F8F8F0")))
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

;;************************************************************************
;;                            Winner-Mode
;;************************************************************************
;; With C-x left and C-x right buttons you can switch between window layouts
;; Usefull with newsticker :D
(when (fboundp 'winner-mode)
  (winner-mode 1))


;;************************************************************************
;;                            Dikey Yatay Pencere
;;************************************************************************
;; Deneme sürecindeki kod
(defun toggle-window-split ()
  (interactive)
  (if (= (count-windows) 2)
      (let* ((this-win-buffer (window-buffer))
             (next-win-buffer (window-buffer (next-window)))
             (this-win-edges (window-edges (selected-window)))
             (next-win-edges (window-edges (next-window)))
             (this-win-2nd (not (and (<= (car this-win-edges)
                                         (car next-win-edges))
                                     (<= (cadr this-win-edges)
                                         (cadr next-win-edges)))))
             (splitter
              (if (= (car this-win-edges)
                     (car (window-edges (next-window))))
                  'split-window-horizontally
                'split-window-vertically)))
        (delete-other-windows)
        (let ((first-win (selected-window)))
          (funcall splitter)
          (if this-win-2nd (other-window 1))
          (set-window-buffer (selected-window) this-win-buffer)
          (set-window-buffer (next-window) next-win-buffer)
          (select-window first-win)
          (if this-win-2nd (other-window 1))))))

(global-set-key [f9] 'toggle-window-split)


;;************************************************************************
;;                            GIT
;;************************************************************************
;; GIT windows makinada terminalden değil popup üzerinde kullanıcı/parola
;; istiyor
(if (string-equal system-type "windows-nt")
    (setenv "GIT_ASKPASS" "git-gui--askpass")
  )
