App.FillOptions =

  initialize: ->
    console.log("Ejecuta FillOptions")
    $ ->
      $(document).on 'change', '#js-organizations-selected', (evt) ->
        $.ajax 'update_period',
          type: 'GET'
          dataType: 'script'
          data: {organization_type_id: $("#js-organizations-select option:selected").val()}
          error: (jqXHR, textStatus, errorThrown) ->
            console.log("AJAX Error: #{textStatus}")
          success: (data, textStatus, jqXHR) ->
            console.log("Dynamic organization select OK!")
