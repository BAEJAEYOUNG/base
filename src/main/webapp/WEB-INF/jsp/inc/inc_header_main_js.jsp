<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%--
  ~ Developed by JAEYOUNG BAE on 19. 4. 17 오후 1:32.
  ~ Last modified 19. 4. 17 오후 1:32.
  ~ Copyright (c) 2019. All rights reserved.
  --%>

<script type="text/javascript">

    $(function () {

        $(":text, :password, textarea").each(function() {
            $(this).attr("autocomplete", "off").attr("spellcheck", false);
        });

        if (typeof(init) == 'function') {
            init();
        }

        $("div[id$='-panel'],table[id$='-panel'],form[id$='-panel']").each(function () {
            $(this).applyFieldOption();
        });

        $(window).resize(function () {
            if ( typeof(localResize) == 'function') {
                localResize();
            }
        });

        $(window).resize();

    });


</script>