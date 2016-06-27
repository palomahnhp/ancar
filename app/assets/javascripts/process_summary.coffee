App.ProcessSummary =

  initialize: ->

    $('#js-summary-process').each ->
      $this = $(this)js-id

      callback = ->
        $.ajax
          url: $this.data('js-url')
          data: {id: 'js-id'},
          type: 'GET',
          dataType: 'html'
          success: (stHtml) ->
            js_suggest_selector = $this.data('js-suggest')
            $(js_suggest_selector).html(stHtml)

      $this.on 'keyup', ->
        window.clearTimeout(callback)
        window.setTimeout(callback, 1000)

      $this.on 'click', callback
