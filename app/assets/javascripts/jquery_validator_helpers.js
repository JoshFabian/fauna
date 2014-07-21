jQuery.validator.addMethod("any-price", function(value, element) {
  return this.optional(element) || value.replace(/[,$]/g, '') >= 0.0;
}, "Please enter a valid price");

jQuery.validator.addMethod("price", function(value, element) {
  return this.optional(element) || value.replace(/[,$]/g, '') > 0.0;
}, "Please enter a valid price");

jQuery.validator.addMethod("international-phone", function(value, element) {
  return this.optional(element) || value.match(/^\+?\d{10,15}$/, '') > 0.0;
}, "Please enter a valid phone number");


jQuery.validator.addMethod("state_code", function(value, element) {
  return this.optional(element) || value.match(/^[A-Z]{2,2}$/);
}, "Please enter a valid state code");
