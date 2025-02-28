;; extends
; https://tree-sitter.github.io/tree-sitter/using-parsers/queries/1-syntax.html

; (
;  (field_identifier) @property
;  (#set! "priority" 199) 
; )

; (field_declaration 
;   type: (type_identifier)  @property
;   (#set! "priority" 200) 
; )

; an embedded struct's type name
  (type_declaration ; [168, 0] - [170, 1]
    (type_spec ; [168, 5] - [170, 1]
      name: (type_identifier) ; [168, 5] - [168, 25]
      type: (struct_type ; [168, 26] - [170, 1]
        (field_declaration_list ; [168, 33] - [170, 1]
          (field_declaration ; [169, 1] - [169, 34]
            type: (type_identifier) @struct_embedded_struct_name
            (#set! "priority" 200) 
)))))


; the key value of a struct when you're creating it
(keyed_element 
  key: (literal_element 
            (identifier)
            @struct_create_key
            (#set! "priority" 200) 
        ) 

)


(field_declaration 
  name: (field_identifier) @property
  (#set! "priority" 200) 
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

