<%--
  ~ Developed by JAEYOUNG BAE on 19. 4. 25 오전 9:10.
  ~ Last modified 19. 4. 1 오후 1:21.
  ~ Copyright (c) 2019. All rights reserved.
  --%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!doctype html>
<html lang="ko">
<head>
    <title>${projectTitle}</title>
    <script type="text/javascript" src="${contextPath}/js/agent/ksid.webagent.api.js"></script>
    <%@ include file="/WEB-INF/jsp/inc/inc_header_main.jsp" %>
    <link rel="stylesheet" href="${contextPath}/css/page/login.css"/>
    <style>

    </style>
    <script type="text/javascript">
        if( parent && typeof ( parent.goLogin ) == 'function' ) {
            parent.goLogin();
        } else if( opener && typeof ( opener.goLogin ) == 'function' ) {
            opener.goLogin();
            self.close();
        } else if( opener && opener.parent && typeof ( opener.parent.goLogin ) == 'function' ) {
            opener.parent.goLogin();
            self.close();
        } else if( opener && opener.top && typeof ( opener.top.goLogin ) == 'function' ) {
            opener.top.goLogin();
            self.close();
        }

        // KSID WebAgent API 객체 생성
        var AGT_API = new KSID_WEBAGENT_API();
        var strUpdateUrl = "${contextPath}/agent/KSIDWebAgentInstall.exe";
        AGT_API.setMethod( "POST" );             // 통신 방식 설정(GET/POST, Default=POST)
        AGT_API.setUpdateUrl( strUpdateUrl );    // Update URL 설정
        AGT_API.setVersion( "2017.05.09.0001" ); // 버전 설정
        console.log( 'AGT_API', AGT_API );

        function init() {

            <c:if test="${not empty errorMsg}">
            svc.ui.alert( "${errorMsg}" );
            </c:if>

            $( '#cardLogin .smartcard' ).click( function() {
                doCardLogin();
            } );
        }

        function doSubmit() {
            var bReturn = false;
            if( $( "#login-panel" ).validateForm() ) bReturn = true;
            return bReturn;
        }

        function doCardLogin() {
            AGT_API.ksidwebagt_check( function( response ) {
                console.log( 'doCardLogin() > response', response );
                // 1. status 가 'S':Success 가 아닌 'F':Fail 이라면 Agent 설치 확인 후 Agent 설치파일을 연결하여 설치를 유도한다.
                if( response.getStatus() != 'S' ) {
                    svc.ui.confirm( "The fingerprint smart card authentication agent is not installed.<br />All you need to do is install the agent to authenticate.<br />Do you want to install the agent?", function() {
                        location.href = strUpdateUrl;
                    }, function() {
                        svc.ui.alert( "You have canceled the agent installation." );

                    } );
                }

                // 2. Agent 설치가 된 상태라면 Agent 가 실행되어 있는지 확인 후 실행되어 있지 않다면 Agent를 샐행한다.
                // R: Run , S: Stop
                if( response.getResult() != 'R' ) {
                    AGT_API.ksidwebagt_start( function( response ) {
                        console.log( 'start response', response );
                    } );
                    svc.ui.alert( "The fingerprint smart card authentication agent is not running.<br />Please run the agent from the bottom flicker bar." );
                    return;
                }

                console.log( '여기까지 실행되었다면 Agent 가 실행된 상태이다.' );

                // 지문카드 에이전트의 인증 함수를 호출하여 리더기와 통신하여 해당 사용자의 카드 정보와 인증정보를 가져온다.
                // uniqueId : 카드 unique id, randomValue : 인증에 사용되는 카드에서 발급된 임의 값, hashValue : 인증에 사용되는 hash 값
                AGT_API.ksidwebagt_deviceIdVerify( function( response ) {

                    console.log( 'callback > response', response );

                    // 결과가 실패라면 ...
                    if( response.getStatus() != 'S' ) {
                        console.log( 'AGT_API.ksidwebagt_deviceIdVerify > response', response );
                        svc.ui.alert( response._errorCode + '-' + response._errorText );
                        return;
                    }

                    // uniqueId|randomValue|hashValue 로 넘어온 데이터를 params(파라메터)에 담는다.
                    var arrResData = response.getResult().split( "|" );

                    var params = {};

                    params.uniqueId = arrResData[0];
                    params.randomValue = arrResData[1];
                    params.hashValue = arrResData[2];

                    console.log( 'params', params );
                    //                 ksid.debug.printObj('params', params);

                    ksid.net.ajax("${pageContext.request.contextPath}/client/verifyWeb", params, function(result) {
                        if(result.result == '10') {
                            svc.ui.alert('Hash validation Success');
                            loginCard();
                        } else if( result.result == '12' ) {
                            svc.ui.alert('Hash validation mismatch');
                        } else if( result.result == '11' ) {
                            svc.ui.alert('SmartCard not exists');
                        } else {
                            svc.ui.alert('Login Fail - ' + result.driverName);
                        }
                    });

                } );
            } );
        }

    </script>
</head>
<body>
<div id="wrapBody"></div>
<div id="wrapFormBg1"></div>
<div id="wrapFormBg2"></div>
<div id="wrapFormBg3"></div>
<div id="logo"><img src="../../image/login/ksid.png" alt="ksid로고"></div>
<div id="formLogin">
    <div id="cardLogin" class="wrap-login">
        <h2><spring:message code="login..form-card.title"/></h2>
        <div class="smartcard">
            <div id="smartcardMsg">
                <spring:message code="login..form-card.info1"/>
                <br>
                <spring:message code="login..form-card.info2"/>
                <br>
                <spring:message code="login..form-card.info3"/>
            </div>
        </div>
    </div>
    <div id="idLogin" class="wrap-login">
        <h2><spring:message code="login.form-id,title"/></h2>
        <div id="idLoginBg"></div>
        <div id="idpw-login-panel">

            <form id="login-panel" name="login-panel" method="post" action="${contextPath}/login/security" onsubmit="return doSubmit()">

                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                <input type="hidden" name="lgnmode" value="login"/>

                <table class="tb-login">
                    <colgroup>
                        <col class="width100">
                        <col class="width200">
                    </colgroup>
                    <tbody>
                    <tr>
                        <th><label for="loginMngrId"><spring:message code="login.form-id.id"/></label></th>
                        <td><input type="text" id="loginMngrId" name="mngrId" data-title="<spring:message code="login.form-id.id"/>" class="form-login-text form-input-text" autofocus data-required></td>
                    </tr>
                    <tr>
                        <th><label for="loginMngrPwd"><spring:message code="login.form-id.pwd"/></label></th>
                        <td><input type="password" id="loginMngrPwd" name="mngrPwd" data-title="<spring:message code="login.form-id.pwd"/>" class="form-login-text form-input-text" data-required></td>
                    </tr>
                    </tbody>
                </table>

                <div class="button-panel">
                    <button type="submit" class="large green button" title='<spring:message code="login.form-id.button-text"/>'>
                        <spring:message code="login.form-id.button-text"/>
                    </button>
                </div>

            </form>

        </div>
    </div>
</div>
<div id="copyright">Copyright (c) 2019 KSID. All Right Reserved.</div>
</body>
</html>