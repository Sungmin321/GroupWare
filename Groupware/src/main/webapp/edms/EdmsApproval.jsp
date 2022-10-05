<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="edms.*"%>
<%@ page import="java.util.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>전자결재 상신</title>
<script src="http://code.jquery.com/jquery-3.5.1.min.js"></script>

<script type="text/javascript">
	window.onload = function() {

		$('#insert').click(function() {
			if ($("input:checkbox[name='Chk_list']:checked").length===0){
				alert("추가 할 결재선을 선택하세요!")
			}

			var checkbox = $("input:checkbox[name='Chk_list']:checked");
			
			checkbox.each(function(i) {
				var tr = checkbox.parent().parent().eq(i);
				var td = tr.children();
				
				var name = td.eq(0).text(); // td 0번째는 이름
				var code = td.eq(1).text(); // td 1번째는 사번
				var dept = td.eq(2).text(); // td 2번째는 부서
				var pos = td.eq(3).text(); // td 3번째는 직책
				
				var insertTr = "";

				insertTr += "<tr>";
				insertTr += "<td>"+name+"</td>";
				insertTr += '<input type="hidden" name="name" value='+name+'/>';
				insertTr += "<td>"+code+"</td>";
				insertTr += '<input type="hidden" name="code" value='+code+'/>';
				insertTr += "<td>"+dept+"</td>";
				insertTr += '<input type="hidden" name="deptkr" value='+dept+'/>';
				insertTr += "<td>"+pos+"</td>";
				insertTr += '<input type="hidden" name="poskr" value='+pos+'/>';
				insertTr += '<td><input type="checkbox" name="Del_Chk_list"></td>';
				insertTr += "</tr>";

				$("#edmsLine").append(insertTr);
			})
			
		})

		$('#delBtn').click(function() {
			if ($("input:checkbox[name='Del_Chk_list']:checked").length === 0) {
				alert("삭제 할 결재선을 선택하세요!");
			return;
			}

			$("input:checkbox[name='Del_Chk_list']:checked").each(function(k,kVal) {
				console.log("kVal ::", kVal.parentElement.parentElement);
				let a = kVal.parentElement.parentElement;
				$(a).remove();
			});
		});
	
		$("#cate").change(function() {
			var cate = $(this).val();
			var title = $(this).children("option:selected").text();
			
			//alert($(this).val());
			//alert($(this).children("option:selected").text());
			
			var insertct = '<input type="text" name="content" placeholder="날짜">';
			
			
			switch(cate) {
			case "1" : 
				//	$("#title").empty();
				//$("#title").prepend(title);
				$("#ct").empty();
				insertct += '<input type="text" name="content" placeholder="적요">';
				insertct += '<input type="text" name="content" placeholder="금액">';
				insertct += '<input type="text" name="content" placeholder="비고">';
				insertct += '<input type="text" name="content" hidden>';
				$("#ct").prepend(insertct);
				break;
			case "2" :
				//$("#title").empty();
				//$("#title").prepend(title);
				$("#ct").empty();
				insertct += '<input type="text" name="content" placeholder="품의내용">';
				insertct += '<input type="text" name="content" placeholder="비고">';
				insertct += '<input type="text" name="content" hidden>';
				insertct += '<input type="text" name="content" hidden>';
				$("#ct").prepend(insertct);
				break;
			case "3" :
			//	$("#title").empty();
				//$("#title").prepend(title);
				$("#ct").empty();
				insertct += '<input type="text" name="content" placeholder="보고내용">';
				insertct += '<input type="text" name="content" placeholder="비고">';
				insertct += '<input type="text" name="content" hidden>';
				insertct += '<input type="text" name="content" hidden>';
				$("#ct").prepend(insertct);
				break;
			case "4" :
				//$("#title").empty();
				//$("#title").prepend(title);
				$("#ct").empty();
				insertct += '<input type="text" name="content" placeholder="수신부서">';
				insertct += '<input type="text" name="content" placeholder="참조부서">';
				insertct += '<input type="text" name="content" placeholder="처리기한">';
				insertct += '<input type="text" name="content" placeholder="비고">';
				$("#ct").prepend(insertct);
				break;
			case "5" :
				//$("#title").empty();
				//$("#title").prepend(title);
				$("#ct").empty();
				insertct += '<input type="text" name="content" placeholder="구분(사직/휴직/복직)">';
				insertct += '<input type="text" name="content" placeholder="사유">';
				insertct += '<input type="text" name="content" placeholder="비고">';
				insertct += '<input type="text" name="content" hidden>';
				$("#ct").prepend(insertct);
				break;
			}
		});

		$('#searchBtn').click(function() {
			//alert('검색버튼클릭');
			
			// 기존 검색 결과 삭제
			$("#edmsinsert").empty();

			var cate = $("select[name=indexcate]").val();
			console.log(cate)
			var searchword = $('input[name=index]').val();
			console.log(searchword)
			
			var name = '';
			var code = '';
			var deptkr = '';
			var poskr = '';
			var insert = '';
			$.ajax({
				url:"../UserSearchServlet",
				dataType:"json",
				type:"post",
				data:{'cate':$("select[name=indexcate]").val(),'searchword':$("input[name=index]").val()}, 
				success:function(result){
					$("#edmsinsert").empty();
				//	 var resultst = JSON.stringify(result)
					for (var i = 0; i<result.length; i++){
						name = result[i].name
						code = result[i].code
						deptkr = result[i].deptkr
						poskr = result[i].poskr
						
						insert += "<tr>";
						insert += "<td>"+name+"</td>";
						insert += "<td>"+code+"</td>";
						insert += "<td>"+deptkr+"</td>";
						insert += "<td>"+poskr+"</td>";
						insert += "<td><input type='checkbox' name='Chk_list'></td></tr>";
					//	alert(insert)
					}
					$("#edmsinsert").prepend(insert);
				},
				error: function(err){
					alert('ajax 실패');
					alert(err);
				}
			})
		})
	}
</script>
	

</head>
<body>
	<form action="EdmsProcess.jsp" name="edmsapproval" enctype="multipart/form-data" method="post" onsubmit="return validateForm(this);" >
			<h4>전자결재상신</h4>
		<table border="1">
			<tr>
				<td colspan="2">
				<select size="1" id="cate" name="cate">
						<option value="0">문서유형선택</option>
						<option value="1">지출결의서</option>
						<option value="2">품의서</option>
						<option value="3">보고서</option>
						<option value="4">협조전</option>
						<option value="5">사직/휴직/복직원</option>
				</select>
				<input type="hidden" value="" name="cate2">
				</td>
			</tr>
			<tr>
				<td colspan="2" id="title">
				<input type="text" name="title" placeholder="제목을 입력해주세요">
				</td>
			</tr>
			<tr>
				<td colspan="2"  id="ct">전자결재 내용</td>
			</tr>
			<tr>
				<td>첨부파일</td>
				<td><input type="file" name="ofile"></td>
			</tr>
			<tr>
				<td>
				<input type="text" name="index" placeholder="검색어를 입력해주세요"> 
				<select name="indexcate">
						<option value="name">이름</option>
						<option value="dept">부서</option>
						<option value="pos">직위</option>
				</select> 
				<button type="button" id="searchBtn">검색</button>
				</td>
				<td>결재라인</td>
			</tr>
			<tr>
				<td>
					<table>
						<tr>
							<th>이름</th>
							<th>사번</th>
							<th>부서</th>
							<th>직위</th>
							<th>비고</th>
						</tr>
						<tbody id="edmsinsert">
						<% 
						// DAO를 생성하고, DAO에서 findList 메소드를 실행해서 list 객체에 담은 다음. 
						// 표시해주는 부분에서 표시해주면 됨.
						EdmsDAO edao = EdmsDAO.getInstance();
						ArrayList<EdmsInfoVO> list = edao.findList();
						
						for (int i = 0; i<list.size(); i++){
						%>
							<tr>
							<td><%= list.get(i).getName() %></td> <!-- 이름 -->
							<td><%= list.get(i).getCode() %></td> <!-- 부서 -->
							<td><%= list.get(i).getDeptkr() %></td> <!-- 부서 -->
							<td><%= list.get(i).getPoskr() %></td> <!-- 직위 -->
							<td><input type="checkbox" name="Chk_list"></td>
							</tr>
							<%
							}
							%>
						</tbody>
					</table>
				</td>
				<td>
					<table>
						<tr>
							<th>이름</th>
							<th>사번</th>
							<th>부서</th>
							<th>직위</th>
							<th>비고</th>
						</tr>
						<tbody id="edmsLine">
						</tbody>
					</table>
				</td>
			</tr>
			<tr>
				<td>
					<button type="button" id="insert">추가</button>
				</td>
				<td>
					<button type="button" id="delBtn">삭제</button>
				</td>
			</tr>
		</table>
		<input type="submit" value="상신"> <input type="reset" value="취소">
	</form>
</body>
</html>