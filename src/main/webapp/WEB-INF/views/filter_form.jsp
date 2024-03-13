<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<form action="/search" method="get">
	<div class="row mb-3">
		<div class="col-md-3">
			<select id="regionFilter" name="region" class="form-control">
				<option value="">지역(전체)</option>
				<option value="1">서울</option>
				<option value="6">부산</option>
				<option value="4">대구</option>
				<option value="2">인천</option>
				<option value="5">광주</option>
				<option value="3">대전</option>
				<option value="7">울산</option>
				<option value="8">세종</option>
				<option value="31">경기</option>
				<option value="32">강원</option>
				<option value="33">충북</option>
				<option value="34">충남</option>
				<option value="35">경북</option>
				<option value="36">경남</option>
				<option value="37">전북</option>
				<option value="38">전남</option>
				<option value="39">제주</option>
			</select>
		</div>
		<div class="col-md-3">
			<input type="date" class="form-control" id="startDateFilter"
				name="startDate" placeholder="시작일">
		</div>
		<div class="col-md-3">
			<input type="date" class="form-control" id="endDateFilter"
				name="endDate" placeholder="종료일">
		</div>
		<div class="col-md-2">
			<input type="text" class="form-control" placeholder="검색"
				id="searchFilter" name="search">
		</div>
		<div class="col-md-1">
			<button type="submit" class="btn btn-primary" id="searchButton">검색</button>
		</div>
	</div>
</form>