<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%--
  ~ Developed by JAEYOUNG BAE on 19. 4. 17 오후 1:32.
  ~ Last modified 19. 4. 17 오후 1:32.
  ~ Copyright (c) 2019. All rights reserved.
  --%>

<script type="text/javascript">

    $(function () {

        // console.log( "================  inc_header_page_js" );

        $(":text, :password, textarea").each(function() {
            $(this).attr("autocomplete", "off").attr("spellcheck", false);
        });

        if (typeof(init) == 'function') {
            init();
        }

        $("div[id$='-panel'],table[id$='-panel']").each(function () {
            $(this).applyFieldOption();
        });

        $(window).resize(function () {
            if (typeof(localResize) == 'function') {
                $('.ui-jqgrid-pager').css('width','100%');
                localResize();
            }
        });

        $(document).css("body", "{'overflow-y':'scroll'}");

        $(window).resize();

    });

    function authSetButton() {
        // if(oMenu != null) {
        //     $('button[auth]').each(function(){
        //         // console.log("$(this).attr('auth')", $(this).attr('auth'));
        //         ( oMenu['auth'+$(this).attr('auth')].toUpperCase() == 'Y' ) ? $(this).show() : $(this).hide();
        //     });
        // }
    }

</script>