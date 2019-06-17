<%--
  ~ Developed by JAEYOUNG BAE on 19. 4. 23 오후 4:14.
  ~ Last modified 19. 4. 23 오후 4:14.
  ~ Copyright (c) 2019. All rights reserved. 
  --%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<html>
<head>
    <title>${projectTitle}</title>

    <%@ include file="/WEB-INF/jsp/inc/inc_header_main.jsp" %>

<%--    <link rel="stylesheet" href="/webjars/jquery-easyui/css/easyui.css">--%>
    <link rel="stylesheet" href="${contextPath}/css/custom/easyui-theme-material.css">
<%--    <link rel="stylesheet" href="${contextPath}/css/custom/gnb.css">--%>
    <link rel="stylesheet" href="${contextPath}/css/custom/button.css">
    <link rel="stylesheet" href="${contextPath}/css/jquery/sm-core-css.css">
<%--    <link rel="stylesheet" href="${contextPath}/css/jquery/sm-blue/sm-blue.css">--%>
<%--    <link rel="stylesheet" href="${contextPath}/css/jquery/sm-clean/sm-clean.css">--%>
    <link rel="stylesheet" href="${contextPath}/css/jquery/sm-mint/sm-mint.css">
<%--    <link rel="stylesheet" href="${contextPath}/css/jquery/sm-simple/sm-simple.css">--%>
    <link rel="stylesheet" href="${contextPath}/css/page/main.css">

    <script type="text/javascript" src="/webjars/jquery-easyui/js/jquery.easyui.min.js"></script>
    <script type="text/javascript" src="${contextPath}/js/custom/svc-page.js"></script>
    <script type="text/javascript" src="${contextPath}/js/lib/jquery.smartmenus.js"></script>
    <script type="text/javascript" src="${contextPath}/js/custom/svc-gnb.js"></script>

    <script type="text/javascript">

        var page = new svc.page();
        page.menuArray = [];
        var menu = new svc.gnb(1);

        function init() {

            fnLoadGnb();    // 메인메뉴 Load

            $("#tabs").tabs({
                plain: true
            });
            $(".tabs-panels").css({"border":0});

        }

        function localResize() {

            $("#tabs").find('div').css('width', '100%');

            var frameWidth = $(window).width();
            var frameHeight = $(window).height() - 114;

            $('#tabs iframe').css({"width":frameWidth + "px","height":frameHeight + "px"});

        }

        // 로고 클릭시 /main 으로 이동
        function goMain() {
            top.location.href = "/main";
        }

        // 메인메뉴 Load
        function fnLoadGnb() {

            // 사용자 메뉴정보를 가져오는 중입니다. block 메시지 표시
            $.blockUI({
                message: '<spring:message code="main.menu.load"/>'
                , css: { "font-weight": "700", "height": "80px", "color": "#000", "opacity": "1", "font-size": "10pt", "line-height": "1.8", "padding-top": "8px"}
            });

            menu.load("/main/mainMenuList");

            // 사용자 메뉴정보를 가져오는 중입니다. block 메시지 감춤
            setTimeout('$.unblockUI()', 1000);

        }

        function fnGnbClick(menuId, bRefresh) {
            var menuObj = menu.selMenu(menuId);

            if( menuObj.execCmd.trim() != "" ) {
                if(bRefresh) {
                    $('#tabFrm' + menuId).attr('src', menuObj.execCmd);
                } else {
                    var oTabs = $('#tabs');
                    if (oTabs.tabs('exists', menuObj.menuNm)){
                        oTabs.tabs('select', menuObj.menuNm);
                        if(bRefresh) {
                            $('#tabFrm' + menuObj.menuId).attr('src', menuObj.execCmd);
                        }
                    } else {
                        // menuObj.execCmd = "/html/blank.html"
                        var content = '<iframe id="tabFrm' + menuObj.menuId + '" class="frameBox" src="'+menuObj.execCmd+'" style="width:100%;height:100%;"></iframe>';
                        $('#tabs').tabs('add',{
                            title: menuObj.menuNm,
                            content:content,
                            closable:true
                        });
                        localResize();
                    }
                }
            }
        }

        function goLogin() {
            top.location.href = "/login";
        }

        function doLogout() {
            top.location.href = "/logout";
        }

    </script>
</head>
<body>
<div class="wrap-main">
    <header id="main-header" class="wrap-logo" role="banner">
        <div class="banner"><a href="javascript:goMain()"><img src="${contextPath}/image/main/logo01.png" alt="로고"></a></div>
        <div class="login-info">
            <span class="welcome"><spring:message code="main.welcome"/></span>
            &nbsp;
            <u>${sessionScope.sessionUser.mngrNm}</u>
            <button class="small button" onclick="doLogout()"><spring:message code="main.logout"/></button>
        </div>
    </header>
<%--    <nav id="gnb" class="wrap-menu" role="navigation">--%>
    <nav id="gnb" role="navigation">
        <!-- // Global Navigation Bar -->
    </nav>
    <main role="main" id="tabs" class="wrap-mdi easyui-tabs" style="height:auto">

    </main>
</div>
</body>
</html>
