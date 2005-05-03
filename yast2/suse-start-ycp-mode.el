(autoload 'ycp-mode "ycp-mode")
(setq auto-mode-alist
      (append
       (list
        '("\\.ycp$" . ycp-mode)
        '("\\.scr$" . ycp-mode))
       auto-mode-alist))
