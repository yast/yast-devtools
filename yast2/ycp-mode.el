;;; ycp-mode.el --- major mode for editing YCP code

;; Copyright (C) 1999 SuSE GmbH

;; Author: Andreas Schwab <schwab@suse.de>
;; Keywords: ycp languages

;; This package is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.

;; This package is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	 See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.	If not, write to the
;; Free Software Foundation, Inc., 59 Temple Place - Suite 330,
;; Boston, MA 02111-1307, USA.

;;; Commentary:

;; This packages provides a GNU Emacs major mode for editing YCP code.

;;; Code:

(require 'cc-vars)
(require 'cc-langs)
(require 'cc-styles)
(eval-when-compile (require 'cc-defs))

(defvar ycp-mode-syntax-table nil
  "Syntax table in use in YCP-mode buffers.")

(unless ycp-mode-syntax-table
  (let ((syntax-table (make-syntax-table)))
    (c-populate-syntax-table syntax-table)
    (modify-syntax-entry ?$ "'" syntax-table)
    (modify-syntax-entry ?` "'" syntax-table)
    (setq ycp-mode-syntax-table syntax-table)))

(defvar ycp-mode-abbrev-table nil
  "Abbrev table in use in YCP-mode buffers.")
(define-abbrev-table 'ycp-mode-abbrev-table ())

(defvar ycp-font-lock-keywords
 (let ((ycp-keywords
	(eval-when-compile
	 (regexp-opt '("if" "else" "while" "do" "repeat" "until"
		       "continue" "return" "define" "break"
		       "empty" "textdomain"))))
       (ycp-builtin-types
	(eval-when-compile
	 (regexp-opt '("any" "void" "integer" "boolean" "float"
		       "string" "byteblock" "path"
		       "locale" "symbol" "declaration" "term"
		       "list" "map" "block" "global"))))
       (ycp-builtin-funcs
	(eval-when-compile
	 (regexp-opt '("is" "select" "lookup" "contains" "setcontains"
		       "size" "haskey" "add" "prepend" "union" "foreach" "filter"
		       "find" "maplist" "flatten" "sort" "time" "toset" "listmap" "mapmap"
		       "tointeger" "tofloat" "tostring" "topath"
		       "crypt" "substring" "findfirstnotof" "tolower"
		       "toascii" "filterchars" "eval" "symbolof"
		       "sleep" "sformat" "y2log" "mergestring" "splitstring"
		       "findfirstof" "issubstring"
		       "fileexist" "checkIP" "isnil" "include" "module" "import"
		       "y2debug" "y2milestone" "y2warning" "y2error" "y2security" "y2internal"
		       ))))
       (ycp-ui-widgets
	(eval-when-compile
	  (regexp-opt '(
		       "`BarGraph"
		       "`Bottom"
		       "`CheckBox"
		       "`ColoredLabel"
		       "`ComboBox"
		       "`Date"
		       "`DownloadProgress"
		       "`DumbTab"
		       "`DummySpecialWidget"
		       "`Empty"
		       "`Frame"
		       "`HBox"
		       "`HCenter"
		       "`HMultiProgressMeter"
		       "`HSpacing"
		       "`HSquash"
		       "`HStretch"
		       "`HVCenter"
		       "`HVSquash"
		       "`HVStretch"
		       "`HWeight"
		       "`Heading"
		       "`IconButton"
		       "`Image"
		       "`IntField"
		       "`Label"
		       "`Left"
		       "`LogView"
		       "`MarginBox"
		       "`MenuButton"
		       "`MinHeight"
		       "`MinSize"
		       "`MinWidth"
		       "`MultiLineEdit"
		       "`MultiSelectionBox"
		       "`PackageSelector"
		       "`PatternSelector"
		       "`PartitionSplitter"
		       "`Password"
		       "`PkgSpecial"
		       "`ProgressBar"
		       "`PushButton"
		       "`RadioButton"
		       "`RadioButtonGroup"
		       "`ReplacePoint"
		       "`RichText"
		       "`Right"
		       "`SelectionBox"
		       "`Slider"
		       "`Table"
		       "`TextEntry"
		       "`Time"
		       "`Top"
		       "`Tree"
		       "`VBox"
		       "`VCenter"
		       "`VMultiProgressMeter"
		       "`VSpacing"
		       "`VSquash"
		       "`VStretch"
		       "`VWeight"
		       "`Wizard"
		       ))))

       (ycp-ui-widget-options
	(eval-when-compile
	  (regexp-opt '(
			"`id"
			"`opt"
			"`icon"
			"`item"
			"`menu"
			"`header"
			"`rgb"
			"`leftMargin"
			"`rightMargin"
			"`topMargin"
			"`bottomMargin"
			"`BackgroundPixmap"

			"`animated"
			"`autoAdvance"
			"`autoScrollDown"
			"`autoShortcut"
			"`boldFont"
			"`centered"
			"`countShowDelta"
			"`debugLayout"
			"`decorated"
			"`default"
			"`defaultsize"
			"`disabled"
			"`easterEgg"
			"`editable"
			"`hstretch"
			"`hvstretch"
			"`immediate"
			"`infocolor"
			"`keepSorting"
			"`keyEvents"
			"`notify"
			"`outputField"
			"`plainText"
			"`scaleToFit"
			"`searchMode"
			"`shrinkable"
			"`smallDecorations"
			"`stepsEnabled"
			"`summaryMode"
			"`testMode"
			"`tiled"
			"`treeEnabled"
			"`updateMode"
			"`vstretch"
			"`warncolor"
			"`youMode"
			"`zeroHeight"
			"`zeroWidth"

			"`key_F1"
			"`key_F2"
			"`key_F3"
			"`key_F4"
			"`key_F5"
			"`key_F6"
			"`key_F7"
			"`key_F8"
			"`key_F9"
			"`key_F10"
			"`key_F11"
			"`key_F12"
			"`key_F13"
			"`key_F14"
			"`key_F15"
			"`key_F16"
			"`key_F17"
			"`key_F18"
			"`key_F19"
			"`key_F20"
			"`key_F21"
			"`key_F22"
			"`key_F23"
			"`key_F24"
			"`key_none"
		       ))))

       (ycp-ui-widget-properties
	(eval-when-compile
	  (regexp-opt '(
			"`CurrentBranch"
			"`CurrentButton"
			"`CurrentItem"
			"`DebugLabel"
			"`DialogDebugLabel"
			"`EasterEgg"
			"`Enabled"
			"`ExpectedSize"
			"`Filename"
			"`InputMaxLength"
			"`Item"
			"`Items"
			"`Label"
			"`Labels"
			"`LastLine"
			"`Notify"
			"`OpenItems"
			"`SelectedItems"
			"`ValidChars"
			"`Value"
			"`Values"
			"`WidgetClass"
			"`WindowID"
			))))

       (ycp-ui-glyphs
	(eval-when-compile
	 (regexp-opt '(
		       "`ArrowLeft"
		       "`ArrowRight"
		       "`ArrowUp"
		       "`ArrowDown"
		       "`CheckMark"
		       "`BulletArrowRight"
		       "`BulletCircle"
		       "`BulletSquare"
		       ))))

       (ycp-ui-functions
	(eval-when-compile
	  ;; For UI functions, presence of the leading backquote depends on UI
	  ;; or WFM context, thus it is optional - see regexp below (the
	  ;; '(cons (concat ...))' line)
	 (regexp-opt '(
		       "AskForExistingDirectory"
		       "AskForExistingFile"
		       "AskForSaveFileName"
		       "BusyCursor"
		       "ChangeWidget"
		       "CheckShortcuts"
		       "CloseDialog"
		       "CollectUserInput"
		       "DumpWidgetTree"
		       "FakeUserInput"
		       "GetDisplayInfo"
		       "GetLanguage"
		       "GetModulename"
		       "GetProductName"
		       "Glyph"
		       "HasSpecialWidget"
		       "MakeScreenShot"
		       "NormalCursor"
		       "OpenDialog"
		       "PlayMacro"
		       "PollInput"
		       "PostponeShortcutCheck"
		       "QueryWidget"
		       "RecalcLayout"
		       "Recode"
		       "RecordMacro"
		       "RedrawScreen"
		       "ReplaceWidget"
		       "RunPkgSelection"
		       "SCR"
		       "SetConsoleFont"
		       "SetFocus"
		       "SetFunctionKeys"
		       "SetKeyboard"
		       "SetLanguage"
		       "SetModulename"
		       "SetProductName"
		       "StopRecordMacro"
		       "TimeoutUserInput"
		       "UI"
		       "UserInput"
		       "WFM"
		       "WaitForEvent"
		       "WidgetExists"
		       "WizardCommand"
		       ))))
       )
  (list
   (cons (concat "\\<\\(" ycp-keywords "\\)\\>")		'font-lock-keyword-face)
   (cons (concat "\\<\\(" ycp-builtin-types "\\)\\>")		'font-lock-type-face)
   (cons (concat "\\<\\(" ycp-builtin-funcs "\\)\\>")		'font-lock-function-name-face)
   (cons (concat "\\<`?\\(" ycp-ui-functions "\\)\\>")		'font-lock-function-name-face)
   (cons (concat "\\<\\(" ycp-ui-widgets "\\)\\>")		'font-lock-reference-face)
   (cons (concat "\\<\\(" ycp-ui-widget-options "\\)\\>")	'font-lock-constant-face)
   (cons (concat "\\<\\(" ycp-ui-widget-properties"\\)\\>")	'font-lock-type-face)
   (cons (concat "\\<\\(" ycp-ui-glyphs"\\)\\>")		'font-lock-type-face)
   (cons "\\<\\(true\\|false\\)\\>"
    ;; Losing XEmacs has no font-lock-constant-face
    (if (facep 'font-lock-constant-face)
     'font-lock-constant-face
     'font-lock-keyword-face))))
     "Default expressions to highlight in YCP mode.")

(defvar ycp-offsets-alist
  '((c-basic-offset . 4)
    (c-offsets-alist
     ;; Half indentation for toplevel statements
     (defun-block-intro	    . *)
     ;; ???
     (arglist-intro	    . c-lineup-arglist-intro-after-paren)
     ;; ???
     (arglist-close	    . c-lineup-arglist)
     ;; Open "substatement" indicates the line after an `if', `else', `while', `do' statement.
     (substatement-open	    . 0)))

  "Association list of syntactic element symbols and indentation offsets.

See `c-offsets-alist' for details")

(unless (assoc "ycp" c-style-alist)
  (c-add-style "ycp" ycp-offsets-alist))

(defun version-lessp (string1 string2)
  (version-lessp-1 (split-string string1 "\\.") (split-string string2 "\\.")))
(defun version-lessp-1 (versions1 versions2)
  (if (or (null versions1) (null versions2))
      (not (null versions2))
    (let ((version1 (string-to-number (car versions1)))
	  (version2 (string-to-number (car versions2))))
      (or (< version1 version2)
	  (and (= version1 version2)
	       (version-lessp-1 (cdr versions1) (cdr versions2)))))))

;;;###autoload
(define-derived-mode ycp-mode c++-mode "YCP"
  "Major mode for editing YCP code.
This is much like C++ mode.  It uses the same keymap as C++ mode and has the
same variables for customizing indentation.  It has its own abbrev table
and its own syntax table.

Turning on YCP mode calls the value of the variable `ycp-mode-hook'
with no args, if that value is non-nil."
  (setq local-abbrev-table ycp-mode-abbrev-table)
  (set-syntax-table ycp-mode-syntax-table)
  (set (make-local-variable 'font-lock-defaults)
       '(ycp-font-lock-keywords nil nil ((?_ . "w") (?` . "w")))))

(provide 'ycp-mode)

;;; ycp-mode.el ends here
