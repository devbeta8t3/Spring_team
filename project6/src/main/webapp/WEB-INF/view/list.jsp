<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Top 100 Coins</title>
	
	<!-- Bootstrap 5.2.2 -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-Zenh87qX5JnK2Jl0vWa8Ck2rdkQ2Bzep5IDxbcnCeuOxjzrPF/et3URy9Bv1WTRi" crossorigin="anonymous">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-OERcA2EqjJCMA+/3y+gxIOqMEjwtxJY7qPCqsdltbNJuaOe923+mo//f6V8Qbsw3" crossorigin="anonymous"></script>
	
	<!-- Font-Awesome Icons -->
	<script src="https://kit.fontawesome.com/9ddb6abce0.js" crossorigin="anonymous"></script> 
	
	<!-- Google Fonts -->
	<link rel="preconnect" href="https://fonts.googleapis.com">
	<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
	<link href="https://fonts.googleapis.com/css2?family=Do+Hyeon&family=Jua&display=swap" rel="stylesheet"><!-- 우아한 형제들 폰트 -->
	
	<!-- Inner Style -->
	<style type="text/css">
		/* 페이징 처리를 위한 스타일 */
		.off-screen {
			display: none;
		}
		#pageBtn {
			/* width: 500px; */
			text-align: center;
		}
		#pageBtn a { /* 비활성 버튼 색깔 */
			display: inline-block;
			padding: 3px 5px;
			margin-right: 10px;
			/* font-family:Tahoma; */
			background: #ccc;
			color: #000;
			text-decoration: none;
		}
		#pageBtn a.active { /* 활성화된 버튼 색깔 */
			background: #333;
			color: #fff;
		}
		
		/* 폰트 설정 */
		
		/* 정부상징체
		@font-face{
			src: url("./ROKG_R.TTF"); 
			font-family: "ROKG"; 
		} */
		body {
			font-family: 'Do Hyeon', sans-serif;
		}
		#topBar {
			font-family: 'Jua', san-serif;
		}
		#listTable {
			font-family: "맑은 고딕", san-serif;
		} 
		#copyRight {
			font-family: "맑은 고딕", verdana, san-serif;
			font-size: 6px;
		}
		
		/* 링크 밑줄 없애기 */
		a {
			text-decoration-line: none;
		}
		
	</style>
	
	<!-- Javascript -->
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
	
	<script type="text/javascript">
	
	$(function() {
		//$('#id').on("click", 'tag', function() {	// 해당 문법은 dynamically created elements에서 동작하지 않는다
		//$(document).on('click', '#id tag', function(){	// 위의 문법이 안될 경우 이렇게 작성하자.
				
	
		const key = "3732d88b-29b4-466e-9750-d3d42ed051b3"; // Messari api key
			
		$.ajax({
			url : "https://data.messari.io/api/v2/assets",	// 요청 주소
			data : "assetKey=" +key+ "&limit=100",	//요청 파라미터
			type : "GET", //전송타입
			dataType : "json", //응답타입
			success : function(result) {	//통신 성공시 호출하는 함수
				//alert("요청에 의한 응답 성공 값 : " +result);
				console.log(result);	// response된 json 확인 (완료)
				listParsing(result);	// 가독성 위해 따로 작성
				getDB();
				
			},
			error : function(xhr, status, msg) {	// 통신 실패시 호출하는 함수
				alert('Getting data from server has failed.');
				//console.log("error : ", msg);
				//console.log("status : ", status);
			}
			
		});
		function getDB(){
			$.ajax({
				url : "/api/v2/assets",	// 콘트롤러 주소 - 이주소를 받는 함수를 컨트롤러에 짜야한다. 콘트롤러에서 responseEntity (project4. SampleController ex06)
				data : "u_id=" +sessionId,	//요청 파라미터
				type : "GET", //전송타입
				dataType : "json", //응답타입
				success : function(result){
					compare()	
				}
			
			});
		}
		function listParsing(result) {
			let str = "";
			let symbolText = "";
			let idx = 0;
			let favStar = "☆"; // 즐겨찾기 별
						
			for (index in result.data){
				
				idx++;
				rankText = result.data[index].metrics.marketcap.rank;// 순위 - rank 오류시 idx로 대체할 것
				nameText = result.data[index].name;// 이름
				symbolText = result.data[index].symbol;// 심볼
				priceText = result.data[index].metrics.market_data.price_usd;// 가격 usd
					priceText = priceLength(priceText);// 가격 범위별 소수점 자리수 결정
				priceBtcText = result.data[index].metrics.market_data.price_btc;
					priceBtcText = parseFloat(priceBtcText).toFixed(8);
				changeText = result.data[index].metrics.market_data.percent_change_usd_last_24_hours;// 가격변동% 24h
					changeValue = parseFloat(changeText);
					//console.log("changeValue의 type: " +typeof changeValue); // type 체크 (완료: number)
					changeText = changeValue.toFixed(2);// 가격변동% 24h - 소수점2자리 표시
					//console.log("changeText의 type: " +typeof changeText); // type 체크 (완료: string)
					// 24시간 가격변동 +/- 에 따라 글자색 변경
					if (changeValue == 0){
						coloredChange = changeText+ "%";
					}
					if (changeValue > 0){
						coloredChange = "<span class='text-success'>▲" +changeText +"% </span>";
					}
					if (changeValue < 0){
						coloredChange = "<span class='text-danger'>▼" +changeText +"% </span>";
					}
					
				volText = result.data[index].metrics.market_data.real_volume_last_24_hours// 실제 거래량 24h
					volText = parseInt(volText).toLocaleString('ko-KR');
				mcapText = result.data[index].metrics.marketcap.current_marketcap_usd;// 시가총액
					mcapText = parseInt(mcapText).toLocaleString('ko-KR');
				
				// images source - https://github.com/ErikThiart/cryptocurrency-icons
				iconURL = "<img src='https://raw.githubusercontent.com/ErikThiart/cryptocurrency-icons/master/16/" +result.data[index].slug+ ".png' height='16' width='16' />";
				
				// 즐겨찾기에 포함된 코인인지 확인
				if (false){
					favStar = "<span class='text-warning'>★</span>" 
				}
					
				str += "<tr>";
				//str += "<td>" +rankText+ "</td>";// rank 오류시 idx로 교체할 것.
				str += "<td>" +idx+ "</td>";// rank 오류시 idx로 교체할 것.
				str += "<td>" +favStar+ "</td>";// favorite 테이블과 비교해서 별표 색깔 변경 symbol에 있으면 노란별, symbol에 없으면 그냥별 -------------------------------- todo
				str += "<th scope='row'>" +iconURL+ " " + "<a href='" + "./info.jsp?cSymbol=" +symbolText+ "'>" +nameText+ "</a>" + " <small class='text-muted'>" +symbolText+ "</small></th>";// 링크 삽입 상세정보 페이지(info.jsp?symbol=xxx)로 이동 ---- todo
				str += "<td class='text-end'><strong>" +priceText+ "</strong></td>";
				str += "<td class='text-end'><small><strong>" +priceBtcText+ "</strong></small></td>";
				str += "<td class='text-end'><small><strong>" +coloredChange+ "</strong></small></td>";
				str += "<td class='text-end'><small><strong>" +volText+ "</strong></small></td>";
				str += "<td class='text-end'><small><strong>" +mcapText+ "</strong></small></td>";
				str += "</tr>";
			}
			$("#assetList").empty().append(str);
			
			//////////////////////////////////////////////////////////////////////////////////////////////
			// 페이징 처리 - https://codepen.io/jaehee/pen/mRmNEX
			$('#pageBtn').remove();// 버튼 삭제(초기화)
			$("#listTable").after('<div id="pageBtn">');// 테이블 뒤에 div #pageBtn 태그 삽입
			
			let $tr = $("#listTable").find('tbody tr');
			let rowTotals = $tr.length;// 행 길이 계산
			console.log("행 길이 : " +rowTotals);// 행 길이 확인 (완료)
			
			let rowPerPage = 20;// 페이지당 20개의 행 표시.
			let pageTotal = Math.ceil(rowTotals / rowPerPage);
			console.log("페이지 수 : " +pageTotal);// 페이지 수 확인 (완료)
			let i = 0;

			for (; i < pageTotal; i++) {// 페이지 수만큼 버튼 삽입
				$('<a href="#"></a>').attr('rel', i).html(i + 1).appendTo('#pageBtn');
			}
			
			$tr.addClass('off-screen').slice(0, rowPerPage).removeClass('off-screen');
			
			let $pagingLink = $('#pageBtn a');
			$pagingLink.on('click', function (e) {
				e.preventDefault();
				if ($(this).hasClass('active')) {
					return;
				}
				$pagingLink.removeClass('active');
				$(this).addClass('active');
				
				let currPage = $(this).attr('rel');
				let startItem = currPage * rowPerPage;// 시작행 = 페이지 번호 * 페이지당 행수
				let endItem = startItem + rowPerPage;// 끝행 = 시작행 + 페이지당 행수
				
				$tr.css('opacity', '0.0')
					.addClass('off-screen')
					.slice(startItem, endItem)
					.removeClass('off-screen')
					.animate({opacity: 1}, 300);
			});
			
			$pagingLink.filter(':first').addClass('active');
			// 페이징 처리 끝
			///////////////////////////////////////////////////////////////////////////////////////////////
			
		}// end of function infoParsing
		
		// 가격(usd) 소수점 표시
		function priceLength(numberStr){
			
			let number = parseFloat(numberStr);
			let result = 0.0;
			// 가격이 100 이상이면 소수점 2자리까지 표시
			if (number >= 100){
				result = parseFloat(numberStr).toLocaleString('ko-KR', {maximumFractionDigits: 2}); // 1000단위 쉼표 & 소수점 자리수
			}
			// 100 > 가격 >= 10 이면 소수점 3자리까지 표시
			if (number < 100 & number >= 10){
				result = parseFloat(numberStr).toLocaleString('ko-KR', {maximumFractionDigits: 3});
			}
			// 10 > 가격 >= 1 이면 소수점 4자리까지 표시
			if (number < 10 & number >= 1){
				result = parseFloat(numberStr).toLocaleString('ko-KR', {maximumFractionDigits: 4});
			}
			// 가격이 1 미만이면 소수점 5자리까지 표시
			if (number < 1){
				result = parseFloat(numberStr).toLocaleString('ko-KR', {maximumFractionDigits: 5});
			}
						
			return result;
		}
	});
	
	</script>


</head>

<body>

<!-- Upper Nav bar -->
<%@include file="./topbar.jsp"%>
<!-- end of Upper Nav bar -->

<div class="container-fluid">
	<div class="row mt-3">
		<!-- List -->
		<div id="cryptoList" class="col-sm-12 col-md-8 col-lg-8 px-1">
			<p class="h2"><strong>Crypto Asset Top 100</strong></p>
			
			<table id="listTable" class="table table-sm table-hover table-striped">
				<thead>
					<tr class="table-dark">
						<td scope="col">#</td>
						<td scope="col" class="text-warning">★</td>
						<td scope="col" class="text-center fw-bold">Asset</td>
						<td scope="col" class="text-center fw-bold">Price<br/><small>(USD)</small></td>
						<td scope="col" class="text-center fw-bold">Price<br/><small>(BTC)</small></td>
						<td scope="col" class="text-center fw-bold">Change<br/><small>USD 24h</small></td>
						<td scope="col" class="text-center fw-bold">Real Volume<br/><small>24h (USD)</small></td>
						<td scope="col" class="text-center fw-bold">Market Cap.<br/><small>(USD)</small></td>
					</tr>
				</thead>
				<tbody id="assetList">
					<!-- APT data area -->
					<tr>
						<th scope="row">Gazua</th>
						<td colspan="7" class="text-center">Loading...<br/><img src="./Loading.gif" /></td>
					</tr>
					
					<!-- end of APT data area -->
				</tbody>
			</table>
			
			
				
		</div>
		<!-- end of List -->
		
		<!-- News Widget - https://cryptopanic.com/developers/widgets/ -->
		<div class="col-sm-12 col-md-4 col-lg-4 px-1">
			<p class="h2"><strong>News</strong></p>
			<a href="https://cryptopanic.com/" target="_blank" data-news_feed="recent" data-bg_color="#FFFFFF" data-text_color="#333333" data-link_color="#0091C2" data-header_bg_color="#30343B" data-header_text_color="#FFFFFF" data-posts_limit="10" data-font_family="mono" data-font_size="12" class="CryptoPanicWidget">Latest News</a>
			<script src="https://static.cryptopanic.com/static/js/widgets.min.js"></script>
			<hr/>
			
			<div id="copyRight" class="mt-3">
				<img src="https://www.kogl.or.kr/images/front/sub/img_opencode4_m.jpg" /><br/>
				<small class="text-muted"> 공공누리 제4유형으로 개방한 '대한민국정부상징체 글꼴(문화체육관광부)'을 이용하였으며,
				해당 저작물은 '<a href="https://www.kogl.or.kr/" target=_blank>공공누리 홈페이지</a>'에서 무료로 다운받으실 수 있습니다.</small>
			</div>
		</div>
		<!-- end of News Widget -->
		
	</div>
</div>

	
	
</body>
</html>