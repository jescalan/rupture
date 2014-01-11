(function() {
  require.config({
    paths: {
      jquery: '//cdnjs.cloudflare.com/ajax/libs/jquery/2.0.3/jquery.min'
    }
  });

  require(['jquery'], function($) {
    $('nav a[href*=#]:not([href=#])').on('click', function() {
      var target;
      if (location.pathname.replace(/^\//, '') === this.pathname.replace(/^\//, '') && location.hostname === this.hostname) {
        target = $(this.hash);
        if (!target.length) {
          target = $("[name=" + (this.hash.slice(1)) + "]");
        }
        if (target.length) {
          $('html,body').animate({
            scrollTop: target.offset().top
          }, 400);
          return false;
        }
      }
    });
    return $('h2,h3,h4,h5,h6').on('click', function() {
      return document.location.hash = $(this).attr('id');
    });
  });

}).call(this);
