;;; build_site.el --- Website Publishing script  -*- lexical-binding: t; -*-

;; Copyright © 2022-2023, Anirban Chakraborty <achakraborty2591@gmail.com>

;; Author/Maintainer: Anirban Chakraborty <achakraborty2591@gmail.com>

;; This file is NOT part of GNU Emacs.

;; This is free software: you can redistribute it and/or modify it under
;; the terms of the GNU General Public License as published by the Free
;; Software Foundation, either version 3 of the License, or (at your
;; option) any later version.

;; This software is distributed in the hope that it will be useful, but
;; WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General
;; Public License for more details.

;; You should have received a copy of the GNU General Public License along
;; with this software. If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; This is a script to publish a website.

;;; Code:

;; Set the package installation directory so that packages aren't stored in the
;; ~/.emacs.d/elpa path.
(require 'package)
(setq package-user-dir (expand-file-name "./packages"))
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

;; Initialize the package system
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;; Install dependencies
(package-install 'htmlize)

(require 'url)

(defun my/download-and-save-file (url dir filename)
  "Download URL content and save it to DIR as FILENAME."
  (let* ((dir-path (expand-file-name dir))
         (file-path (concat (file-name-as-directory dir-path) filename)))
    ;; If file exists, delete it first.
    (when (file-exists-p file-path)
      (delete-file file-path))
    ;; Create directory if it doesn't exist.
    (unless (file-exists-p dir-path)
      (make-directory dir-path t))
    ;; Download and save the file.
    (url-copy-file url file-path t)))

;; Download and save the latest emacs_config.org file from - https://github.com/achakraborty2591/ACH-Emacs-Config repo.
(my/download-and-save-file
"https://raw.githack.com/achakraborty2591/ACH-Emacs-Config/master/emacs_config.org"
"skeleton_files"
"emacs_config.org")

;; Load the publishing system
(require 'ox-publish)

;; Customize the HTML output
(setq org-html-validation-link nil            ;; Don't show validation link
      org-html-head-include-scripts nil       ;; Use our own scripts
      org-html-head-include-default-style nil ;; Use our own styles
      org-html-head "<link rel=\"stylesheet\" href=\"https://raw.githack.com/achakraborty2591/emacs-config-website/main/skeleton_files/style.css\" />")

;; Define the publishing project
(setq org-publish-project-alist
      (list
       (list "website_contents"
             :recursive t
             :base-directory "./skeleton_files/"
             :publishing-directory "./published_contents/"
             :publishing-function 'org-html-publish-to-html
             :with-author t             ;; Include author name
             :with-creator t            ;; Include Emacs and Org versions in footer
             :with-toc t                ;; Include a table of contents
             :section-numbers nil       ;; Don't include section numbers
             :time-stamp-file nil)))    ;; Don't include time stamp in file

;; Generate the site output
(org-publish-all t)

(message "Build complete!")

;;; build_site.el ends here
