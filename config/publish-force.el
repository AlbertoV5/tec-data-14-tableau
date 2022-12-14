;; ------------------------------------
;;         CONFIG VARIABLES
;;------------------------------------
(defvar publish-setup-dir ".")
(defvar publish-config-path "config")
(defvar publish-setup-regex "^setup-")
(defvar publish-file-suffix ".org")
(defvar publish-path-root (with-current-buffer (current-buffer) default-directory))
;;------------------------------------
;;         DEFINE PUBLISHING
;;------------------------------------
(setq org-publish-project-alist
      '(("gfm"
         :base-directory "./src"
         :base-extension "org"
         :publishing-directory "./docs"
         :publishing-function org-gfm-publish-to-gfm
         :recursive t
         :with-toc nil
         :with-sub-superscript nil
         )
        ("html"
         :base-directory "./src"
         :base-extension "org"
         :publishing-directory "./public/build"
         :publishing-function org-html-publish-to-html
         :recursive t
         :with-sub-superscript nil
        )
        ("static"
         :base-directory "./resources"
         :base-extension "ico\\|png\\|jpg\\|jpeg\\|gif\\|svg\\|html\\|css\\|js\\|txt"
         :publishing-directory "./public/resources"
         :publishing-function org-publish-attachment
         :recursive t)))
;;------------------------------------
;;         RESET PROCESSES
;;------------------------------------
(defun reset-sessions ()
  (setq kill-buffer-query-functions nil)
  (run-python)
  (kill-buffer "*Python*")
  (run-python))
;;------------------------------------
;;          USE SETUP FILES
;;------------------------------------
(dolist (buffer (seq-filter (lambda (buf) (string-suffix-p publish-file-suffix (buffer-name buf)))
            (buffer-list)))
  (dolist (p (directory-files-recursively publish-setup-dir publish-setup-regex nil))
    (with-current-buffer buffer
      (load-file (concat publish-path-root p)))))
;;------------------------------------
;;              PUBLISH
;;------------------------------------
;;----------------CODE----------------
(org-babel-lob-ingest "./config/org-header.config")
;;----------------GFM-----------------
;;(reset-sessions)
(dolist (p (directory-files-recursively "./src" "\\.org$" nil)) (org-babel-tangle-file p))
(setq org-babel-exp-code-template "#+begin_src %lang%switches%flags\n%body\n#+end_src")
(org-publish-project "gfm" t)
;;----------------HTML----------------
;;(reset-sessions)
(dolist (p (directory-files-recursively "./src" "\\.org$" nil)) (org-babel-tangle-file p))
(setq org-babel-exp-code-template "#+begin_src-name\n%name\n#+end_src-name\n#+begin_src %lang%switches%flags\n%body\n#+end_src")
(org-publish-project "html" t)
;;---------------STATIC----------------
(org-publish-project "static" t)
