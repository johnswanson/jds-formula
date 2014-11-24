(setq evil-want-C-u-scroll t
      evil-want-C-w-in-emacs-state t)

(require 'package)
; list the packages you want
(setq package-list '(clojure-mode
										 cider
										 evil-surround
										 markdown-mode
										 evil
										 evil-leader
										 exec-path-from-shell
										 smartparens
										 flx-ido
										 projectile
										 rainbow-delimiters
										 magit
										 git-gutter
										 gist
										 color-theme-solarized
										 zenburn-theme
										 tramp
										 column-marker
										 yaml-mode
										 nginx-mode))

(setq auto-save-default nil)
(setq make-backup-files nil)

(setq tramp-debug-buffer t)
(setq tramp-default-method "ssh")

(setq cider-lein-command "/Users/jds/bin/lein")

(defun cider-reset ()
	(interactive)
	(cider-interactive-eval "(reset)"))

; things to try
; flash sexp-eval: https://github.com/samaaron/nrepl-eval-sexp-fu
; M-x ido:         https://github.com/nonsequitur/smex

; list the repositories containing them
(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/") t)

(add-to-list 'auto-mode-alist '("\\.sls$" . yaml-mode))

; activate all the packages (in particular autoloads)
(package-initialize)

; fetch the list of packages available
(unless package-archive-contents
  (package-refresh-contents))

; install the missing packages
(dolist (package package-list)
  (unless (package-installed-p package)
    (package-install package)))


;; Always ALWAYS use UTF-8
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(prefer-coding-system 'utf-8)
(load-library "iso-transl")

;; Automatically save buffers before compiling
(setq compilation-ask-about-save nil)

;; Always ask for y/n keypress instead of typing out 'yes' or 'no'
(defalias 'yes-or-no-p 'y-or-n-p)

; General UI stuff
(global-linum-mode t)
(global-hl-line-mode t)
(setq default-tab-width 2)
(setq inhibit-startup-message t)
(setq visible-bell 'top-bottom)
(setq x-underline-at-descent-line t)
(when (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(when (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(menu-bar-mode -1)
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1)))
(setq mouse-wheel-progressive-speed nil)
(setq mouse-wheel-follow-mouse 't)
(setq scroll-step 1)

(load-theme 'solarized-dark t)
(set-default-font "Ubuntu Mono-16")

(require 'exec-path-from-shell)
(setq exec-path-from-shell-arguments (delete "-i" exec-path-from-shell-arguments))
(when (memq window-system '(mac ns))
  (exec-path-from-shell-initialize))

(require 'evil-surround)
(global-evil-surround-mode 1)

(require 'projectile)
(projectile-global-mode)
(setq projectile-enable-caching 0)
(setq projectile-indexing-method 'native)

(require 'flx-ido)
(ido-mode 1)
(ido-everywhere 1)
(flx-ido-mode 1)
;; disable ido faces to see flx highlights.
(setq ido-enable-flex-matching t)
(setq ido-use-faces nil)

(require 'recentf)
(recentf-mode 1)

(defun recentf-ido-find-file ()
  "Find a recent file using Ido."
  (interactive)
  (let ((file (ido-completing-read "Choose recent file: " recentf-list nil t)))
    (when file
      (find-file file))))

;; Making Emacs better
(require 'evil-leader)
(global-evil-leader-mode)
(evil-leader/set-leader ",")
(evil-leader/set-key
	"e" 'cider-eval-buffer
  "r" 'cider-reset
  "," 'projectile-find-file
  "c" 'comment-or-uncomment-region
  "w" 'save-buffer
  "b" 'switch-to-buffer
  "k" 'kill-buffer)



(require 'evil)
(evil-mode t)

(define-key evil-insert-state-map "k" #'cofi/maybe-exit)
(define-key evil-normal-state-map (kbd "C-h") 'evil-window-left)
(define-key evil-normal-state-map (kbd "C-j") 'evil-window-down)
(define-key evil-normal-state-map (kbd "C-k") 'evil-window-up)
(define-key evil-normal-state-map (kbd "C-l") 'evil-window-right)

(evil-define-command cofi/maybe-exit ()
                     :repeat change
                     (interactive)
                     (let ((modified (buffer-modified-p)))
                       (insert "k")
                       (let ((evt (read-event (format "Insert %c to exit insert state" ?k)
                                              nil 0.5)))
                         (cond
                           ((null evt) (message ""))
                           ((and (integerp evt) (char-equal evt ?j))
                            (delete-char -1)
                            (set-buffer-modified-p modified)
                            (push 'escape unread-command-events))
                           (t (setq unread-command-events (append unread-command-events
                                                                  (list evt))))))))

(require 'rainbow-delimiters nil)
(rainbow-delimiters-mode 1)

(require 'icomplete)

(smartparens-global-mode t)
; https://github.com/Fuco1/smartparens/wiki/Example-configuration

(require 'git-gutter)
(global-git-gutter-mode t)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector ["#262626" "#d70000" "#5f8700" "#af8700" "#0087ff" "#af005f" "#00afaf" "#626262"])
 '(background-color "#1c1c1c")
 '(background-mode dark)
 '(cursor-color "#808080")
 '(custom-safe-themes (quote ("1e7e097ec8cb1f8c3a912d7e1e0331caeed49fef6cff220be63bd2a6ba4cc365" "fc5fcb6f1f1c1bc01305694c59a1a861b008c534cae8d0e48e4d5e81ad718bc6" "d677ef584c6dfc0697901a44b885cc18e206f05114c8a3b7fde674fce6180879" "146d24de1bb61ddfa64062c29b5ff57065552a7c4019bee5d869e938782dfc2a" "8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" default)))
 '(foreground-color "#808080"))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(defvar my-linum-format-string "%3d")

(global-set-key (kbd "RET") 'newline-and-indent)
(add-hook 'linum-before-numbering-hook 'my-linum-get-format-string)
(add-hook 'clojure-mode-hook '(lambda ()
																(interactive) (column-marker-1 80)))


(defun my-linum-get-format-string ()
  (let* ((width (1+ (length (number-to-string
                             (count-lines (point-min) (point-max))))))
         (format (concat "%" (number-to-string width) "d")))
    (setq my-linum-format-string format)))

(defvar my-linum-current-line-number 0)

(setq linum-format 'my-linum-relative-line-numbers)

(defun my-linum-relative-line-numbers (line-number)
  (let ((offset (abs (- line-number my-linum-current-line-number))))
    (propertize (format my-linum-format-string offset) 'face 'linum)))

(defadvice linum-update (around my-linum-update)
  (let ((my-linum-current-line-number (line-number-at-pos)))
    ad-do-it))
(ad-activate 'linum-update)

(defun clipboard-dwim ()
	(interactive)
	(if (region-active-p)
			(clipboard-kill-ring-save (region-beginning) (region-end))
		(clipboard-yank)))

(global-set-key (kbd "C-c w") 'clipboard-dwim)

(defun sudo-edit (&optional arg)
  "Edit currently visited file as root.

With a prefix ARG prompt for a file to visit.
Will also prompt for a file to visit if current
buffer is not visiting a file."
  (interactive "P")
  (if (or arg (not buffer-file-name))
      (find-file (concat "/sudo:root@localhost:"
                         (ido-read-file-name "Find file(as root): ")))
    (find-alternate-file (concat "/sudo:root@localhost:" buffer-file-name))))

(global-set-key (kbd "C-x C-r") 'sudo-edit)
