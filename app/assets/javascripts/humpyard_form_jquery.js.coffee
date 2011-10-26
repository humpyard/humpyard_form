# HumpyardForm
#
# Copyright (c) 2009-2011 Sven G. Brönstrup
# Licensed under the MIT:
# http://www.opensource.org/licenses/mit-license.php
#
#=require humpyard_form_jquery/jquery.form
class @HumpyardForm
  constructor : (@form_elem) ->       
    @form_elem.data 'humpyardForm', this
     
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
      dateFormat: 'yy-mm-dd',
      beforeShow: (input,inst) ->
        if $(input).attr('data-popup-position') == 'top'
          cnt = 0;
          interval = setInterval ->
            cnt++;
            if inst.dpDiv.is(":visible")
              parent = inst.input.closest "div"
              inst.dpDiv.position 
                my: "left top", 
                at: "left bottom",
                of: parent
              clearInterval(interval)
            else if cnt > 50
              clearInterval(interval)
          , 10
      
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
    
    @form_elem.trigger('humpyard:form:init', @form_elem)
        
  submit : (dialog, targetForm) ->
    if typeof(targetForm) == 'undefined'
      targetForm = @form_elem
    
    options = 
      dataType: 'json',
      complete: (xhr, status) ->
        result = jQuery.parseJSON(xhr.responseText)
        # reset error messages
        $('.field-highlight', @form_elem).removeClass("ui-state-error")
        $('.field-errors', @form_elem).empty().hide()
        # execute commands given by ajax call
        # $.each result, -> (attr, options)
        for attr, options of result
          if $.humpyard.ajax_dialog_commands[attr]
            $.humpyard.ajax_dialog_commands[attr] dialog, targetForm, options

    if @form_elem.find('input[type=file]').length > 0 || @form_elem.attr("enctype") == "multipart/form-data"
      options['data'] = 
        ul_quirk: 'true'
      options['iframe'] = true
    

    if @form_elem.trigger('humpyard:form:submit')
      @form_elem.ajaxSubmit(options);
  
  detectNative: (type) -> 
    input = document.createElement('input')
    input.setAttribute "type", type
    return input.type != "text"

