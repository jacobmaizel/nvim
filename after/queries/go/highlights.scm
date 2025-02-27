;; extends
; https://tree-sitter.github.io/tree-sitter/using-parsers/queries/1-syntax.html

(
 (field_identifier) @property
 (#set! "priority" 199) 
)

(call_expression 
  function: (identifier) @function
      (#set! "priority" 200) 
)

(call_expression 
  function: (selector_expression
      field: (field_identifier) @function
      (#set! "priority" 200) 
    ) 
)

(method_elem 
    name: (field_identifier) @function
    (#set! "priority" 200) 
  )

; method declaration on a struct
  (method_declaration 
    name: (field_identifier) @function_name
    (#set! "priority" 201) 
  )

; a regular function definition, not a method
  (function_declaration 
    name: (identifier)  @function_name
    (#set! "priority" 201) 
  )



; variables

(parameter_declaration 
    name: (identifier) @param_declaration 
    (#set! "priority" 200) 
  )

