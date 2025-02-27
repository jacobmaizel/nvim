;; extends


; (block_mapping_pair 
;       key: (flow_node 
;         (plain_scalar 
;           (string_scalar))) 

;       value: (flow_node 
;         (plain_scalar 
;           (string_scalar) @rule_binding
;           (#match? @rule_binding "^\\?")
;         )
;       )
; )



(
      (flow_node 
        (plain_scalar 
          (string_scalar) @rule_binding
          (#match? @rule_binding "^\\?")
        )
      )
)


