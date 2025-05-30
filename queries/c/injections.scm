; extends

((comment)+ @injection.content
  (#match? @injection.content "qmk:json:start")
  (#match? @injection.content "qmk:json:end")
  (#offset! @injection.content 2 0 -1 0) ; rm header and footer
  (#set! injection.language "json")
)
