# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
  ($ "#slides").slides
    animationStart: (current) ->
      $('.caption').animate
        bottom:-50
      ,100
    animationComplete: (current) ->
      $('.caption').animate
        bottom:0
      ,100
    slidesLoaded: ->
      $('.caption').animate
        bottom:0
      ,100
  
  ($ '#menu').stickyfloat duration: 300
  ($ '#menu a.dscroll').bind 'click', (event) ->
    $.scrollTo $($(this).data 'scroll-to')
    event.preventDefault()