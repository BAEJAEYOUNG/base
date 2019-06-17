<%--
  Created by IntelliJ IDEA.
  User: user
  Date: 2019-04-03
  Time: 오전 9:15
  To change this template use File | Settings | File Templates.
--%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <meta http-equiv="refresh" content="0.1;url=/main">
    <title>Title</title>

    <%@ include file="/WEB-INF/jsp/inc/inc_header_main.jsp" %>

    <script type="text/javascript">

        location.href = "/main";

        $(function(){
            console.log("jqeury started ~~~");
        });

        function fnWindowOpen() {
            var win = new svc.ui.window().open();
            win.focus();
        }
        function fnWindowOpenWithParams() {
            var win = new svc.ui.window('/hello', 'winTest');//.open({param1:1111, param2:2222, param3:'가가가가'});
            var params = {};
            params.param1 = "aaaa";
            params.param2 = "bbbb";
            params.param3 = "cccc";
            params.param3 = "dddd";
            win.open(params);
            win.focus();
        }
        function fnCheckedRows() {
            var selectedRows = grid1.getCheckedRows();
            console.log("fnCheckedRows() > selectedRows", selectedRows);
        }
    </script>
</head>
<body>
    index.jsp
    <br/>
    locale : <c:out value="${pageContext.response.locale.language}"/>
    <br/>
    spring locale test message : <spring:message code="test.message"/>
    <br/>
    <button type="button" onclick="search()">조회</button>
    <button type="button" onclick="fnClear()">clear</button>
    <button type="button" onclick="fnCheckedRows()">선택 Data</button>
    <br/>
    <table id="grid1"></table>
    <div id="pager1"></div>
    <br />
    <button type="button" onclick="svc.ui.alert('alert 테스트 입니다', function() { svc.ui.alert('alert callback function') });">alert</button>
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    <button type="button" onclick="svc.ui.confirm('confirm 테스트 입니다', function(){ svc.ui.alert('confirm callback function'); }, function(){ svc.ui.alert('confirm cancel function'); });">confirm</button>
    <br/>
    <button type="button" onclick="fnWindowOpen()">window open</button>
    <br/>
    <button type="button" onclick="fnWindowOpenWithParams()">window open with params</button>
</body>
</html>
