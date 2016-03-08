highlight link cssTagName Special
highlight link cssPseudoClass Special
highlight link cssPseudoClassId Special
highlight link cssBraces Special
highlight link cssProp Statement

highlight link sassClass Special
highlight link sassClassChar Special
highlight link sassId Special
highlight link sassIdChar Special
highlight link sassAmpersand Special
highlight link sassMixing Special
highlight link sassMixinName Function

let s:webkit_props = [
\	'-webkit-appearance',
\	'-webkit-filter',
\	'-webkit-font-smoothing',
\	'-webkit-overflow-scrolling',
\	'-webkit-tap-highlight-color',
\	'-webkit-text-size-adjust',
\]

execute 'syntax match cssWebkitProp contained "\<\(' . join(s:webkit_props, '\|') . '\)\>"'

highlight link cssWebkitProp cssProp

syntax keyword cssCommonAttr contained touch
