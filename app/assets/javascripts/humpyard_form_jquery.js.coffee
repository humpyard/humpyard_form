# HumpyardForm
#
# Copyright (c) 2009-2011 Sven G. Brönstrup
# Licensed under the MIT:
# http://www.opensource.org/licenses/mit-license.php
#
#=require humpyard_form_jquery/jquery.form
class @HumpyardForm
  constructor : (@form_elem) ->        
    # configure date pickers
    # if !detectNative 'date'
    $('input[data-type=date]', @form_elem).datepicker 
      showButtonPanel: true,
      changeMonth: true,
      changeYear: true,
      dateFormat: 'yy-mm-dd'
    
    # if !detectNative 'datetime'
    $('input[data-type=datetime]', @form_elem).datepicker 
      showButtonPanel: true,
      changeMonth: true,
      changeYear: true,
      dateFormat: 'yy-mm-dd'
      
    $('.inputs_for.dynamic_inputs', @form_elem).each ->
      spare_container = $('.spare', this)
      spare_container.hide()
      $(this).append $('<a href="#" class="ui-button ui-widget ui-state-default ui-corner-all ui-button-icon-only"><span class="add-item ui-button-icon-primary ui-icon ui-icon-circle-plus"></span><span class="ui-button-text">+</span></a>').click ->
        spare_container.before spare_container.html()
    
      $('.fields').each ->
        fields = $(this)
        icons = $('<div class="icons">')
        icons.append $('<a href="#" class="ui-button ui-widget ui-state-default ui-corner-all ui-button-icon-only"><span class="add-item ui-button-icon-primary ui-icon ui-icon-circle-minus"></span><span class="ui-button-text">-</span></a>').click ->
          $('input[data-destroy-input]', fields).attr 'value', '1'
          fields.hide()
        fields.append(icons)
  
  detectNative: (type) -> 
    input = document.createElement('input')
    input.setAttribute "type", type
    return input.type != "text"

