if exists('b:current_syntax') | finish | endif

syn case match

syn keyword apiVersion        syntax
syn keyword apiImport         import 
syn keyword apiTypeDelaration type   
syn keyword apiService        service
syn keyword apiInfo           info   

hi def link apiVersion        Statement
hi def link apiImport         Statement
hi def link apiTypeDelaration Keyword
hi def link apiService        Keyword
hi def link apiInfo           Keyword

" ----------------------------------

syn keyword apiStatement get post delete put returns
syn region apiExplainServer  start="@server"  end=")"
syn region apiExplainHandler start="@handler" end="\n"
syn region apiExplainDoc     start="@doc"     end="\n"

hi def link apiStatement      Statement
hi def link apiExplainServer  Comment
hi def link apiExplainHandler Comment
hi def link apiExplainDoc     Comment

"-----------------------------------

syn keyword apiType bool int int8 int16 int32 int64 uint uint8 uint16 uint32 uint64 uintptr  float32 float64 complex64 complex128 string byte rune
hi def link     apiType              Type

" Strings and their contents
syn region      apiString            start=+"+ skip=+\\\\\|\\"+ end=+"+
syn region      apiRawString         start=+`+ end=+`+

hi def link     apiString            String
hi def link     apiRawString         String

syn region      apiCharacter         start=+'+ skip=+\\\\\|\\'+ end=+'+
hi def link     apiCharacter         Character

let b:current_syntax = 'goctl'
