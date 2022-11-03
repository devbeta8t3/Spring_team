<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Welcome to Coin-list</title>
	
	<!-- Bootstrap 5.2.2 -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-Zenh87qX5JnK2Jl0vWa8Ck2rdkQ2Bzep5IDxbcnCeuOxjzrPF/et3URy9Bv1WTRi" crossorigin="anonymous">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-OERcA2EqjJCMA+/3y+gxIOqMEjwtxJY7qPCqsdltbNJuaOe923+mo//f6V8Qbsw3" crossorigin="anonymous"></script>
	
	<!-- Javascript -->
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
	
	<style>
	#homeWelcome {
		background-image: url('./bg_doge_1920.jpg');
		background-repeat: no-repeat;
		background-attachment: fixed;
		background-size: cover;
		color: white;
		height: 880px;
	}
	
	@font-face{
			src: url("./ROKG_R.TTF");
			font-family: "ROKG"; 
	}
	body {
		font-family: "ROKG", "맑은 고딕", verdana, san-serif;
	}
		
	</style>


</head>

<body>

<!-- Upper Nav bar -->
<%@include file="./topbar.jsp"%>
<!-- end of Upper Nav bar -->

<div class="container-fluid">
	<div id="homeWelcome" class="row" >
		<!-- Welcome -->
		<div>
			<p class="h2 mt-5 text-center">Welcome</p>
			<p class="text-center"> Crypto List에 오신 것을 환영합니다.</p>
			<p class="text-center"> 암호화폐 랭킹과 정보를 이용하세요.</p>
			<p class="text-center"> 회원으로 등록하시면 즐겨찾기 메뉴를 이용할 수 있습니다.</p>
			<p class="text-center"><button type="button" class="btn btn-primary btn-lg" onclick="href:location='./list.jsp'">시작하기</button></p>
		</div>
		<!-- end of Welcome -->
	</div>
</div>

	
	
</body>
</html>