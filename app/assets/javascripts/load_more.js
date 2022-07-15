jQuery(function() {
    $(window).data('ajaxready', true);
    if ($('#all-infinite-scrolling .pagination').length >= 0) {
        $(window).data('ajaxready', true).scroll(function(e) {
            var more_users_url;
            if ($(window).data('ajaxready') === false) {
                return;
            }
            more_users_url = $('#all-infinite-scrolling  .pagination a[rel=next]').attr('href');
            if (more_users_url && $(window).scrollTop() + $(window).height() >= $(document).height()) {
                $("#loading").removeClass('d-none');
                $(window).data('ajaxready', false);
                $.getScript(more_users_url);
            }
        });
    }
});