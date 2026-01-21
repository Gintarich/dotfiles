;; extends

(
  (script_element
    (start_tag
      (attribute
        (attribute_name) @_name
        (quoted_attribute_value
          (attribute_value) @_value)))
    (raw_text) @injection.content)
  (#eq? @_name "type")
  (#match? @_value "text/babel")
  (#set! injection.language "tsx")
  (#set! priority 200)
)
