jQuery.validator.addMethod("price", function(value, element) {
  return this.optional(element) || value.replace(/[,$]/g, '') > 0.0;
}, "Please enter a valid price");
