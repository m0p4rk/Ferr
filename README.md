# Ferr(페르르) - Festival Warr / 페스티벌 와르르

## Table of Contents / 목차
1. [Project Introduction / 프로젝트 소개](#project-introduction--프로젝트-소개)
2. [Key Features / 주요 기능](#key-features--주요-기능)
3. [Tech Stack / 기술 스택](#tech-stack--기술-스택)
4. [Project Structure / 프로젝트 구조](#project-structure--프로젝트-구조)
5. [Database Structure / 데이터베이스 구조](#database-structure--데이터베이스-구조)
6. [API Integration / API 통합](#api-integration--api-통합)
7. [Installation and Execution / 설치 및 실행 방법](#installation-and-execution--설치-및-실행-방법)
8. [Team Members and Roles / 팀 멤버 및 역할](#team-members-and-roles--팀-멤버-및-역할)
9. [Development Schedule / 개발 일정](#development-schedule--개발-일정)

## Project Introduction / 프로젝트 소개

**English**

Ferr is a web service that provides festival information and schedule management. The name "Ferr" implies "Festivals pouring down (와르르)" in Korean. It offers various festival information to users and provides features for efficiently managing personal and group schedules. Through real-time weather information, location-based services, and community features, it helps users enjoy festivals more pleasantly.

**한국어**

Ferr(페르르)는 '페스티벌이 와르르' 라는 의미를 담고 있는 축제 정보 제공 및 일정 관리 웹 서비스입니다. 사용자들에게 다양한 축제 정보를 제공하고, 개인 및 그룹 일정을 효율적으로 관리할 수 있는 기능을 제공합니다. 또한 실시간 날씨 정보, 위치 기반 서비스, 그리고 커뮤니티 기능을 통해 사용자들이 축제를 더욱 즐겁게 즐길 수 있도록 돕습니다.

## Key Features / 주요 기능

**English**

1. Home Screen
    - Sorting festivals by ranking
    - Search function (simple search by region + period, integrated search by keyword)
    - Recommending festivals based on user preferences
    - Recommending nearby festivals based on location (Korea only)

2. User Management
    - Regular login
    - Kakao social login
    - My page (preferred region setting)

3. Schedule Management
    - My Schedule page (view registered and past schedules)
    - Schedule Detail page
        - Event venue weather information (weather description in script format)
        - Promise date and notification settings
        - Interaction between participants
        - Map summary and Kakao Map integration

4. Community Features
    - Writing and viewing reviews
    - Chat function (between schedule participants and general users)

5. Notification Feature
    - Notification icon at the bottom right
    - Real-time notifications and interactions

**한국어**

1. 홈 화면
    - 순위별 축제 정렬
    - 검색 기능 (지역 + 기간으로 간편 검색, 검색어로 통합 검색)
    - 사용자 설정 기반 추천 축제 정렬
    - 위치 기반 주변 축제 추천 (한국 한정)

2. 사용자 관리
    - 일반 로그인
    - 카카오 소셜 로그인
    - 마이페이지 (선호 지역 설정)

3. 일정 관리
    - 내 일정 페이지 (등록된 일정 및 지난 일정 조회)
    - 일정 상세 페이지
        - 행사장 날씨 정보 (스크립트 형식의 날씨 설명)
        - 약속 날짜 및 알림 설정
        - 참여자 간 상호작용
        - 지도 요약 및 카카오 지도 연동

4. 커뮤니티 기능
    - 리뷰 작성 및 조회
    - 채팅 기능 (일정 참여자 간, 일반 사용자 간)

5. 알림 기능
    - 우측 하단 알림 아이콘
    - 실시간 알림 및 상호작용

## Tech Stack / 기술 스택

**English**

- Backend: Java, Spring Framework
- Frontend: JSP, JavaScript, HTML5, CSS3
- Database: MySQL
- Build Tool: Maven
- APIs: TourAPI, KakaoMap API, Kakao mobility API, OpenWeatherMap API

**한국어**

- 백엔드: Java, Spring Framework
- 프론트엔드: JSP, JavaScript, HTML5, CSS3
- 데이터베이스: MySQL
- 빌드 도구: Maven
- API: TourAPI, KakaoMap API, Kakao mobility API, OpenWeatherMap API

## Project Structure / 프로젝트 구조

```
project-root/
│
├── src/
│   ├── main/
│   │   ├── java/com/warr/ferr/
│   │   │   ├── api/
│   │   │   ├── config/
│   │   │   ├── controller/
│   │   │   ├── dto/
│   │   │   ├── exception/
│   │   │   ├── mapper/
│   │   │   ├── model/
│   │   │   ├── service/
│   │   │   └── util/
│   │   │
│   │   ├── resources/
│   │   │   ├── mybatis/
│   │   │   └── static/
│   │   │       ├── css/
│   │   │       ├── js/
│   │   │       └── img/
│   │   │
│   │   └── webapp/
│   │       └── WEB-INF/
│   │           └── views/
│   │
│   └── test/
│
├── pom.xml
│
└── README.md
```

## Database Structure / 데이터베이스 구조

**English**

Main tables:
- users: User information
- user_events: User-specific event information
- user_preferences: User preference settings
- chatrooms: Chatroom information
- chatroom_members: Chatroom member information
- messages: Chat messages
- schedule_reviews: Schedule reviews
- review_images: Review images
- schedule_notifications: Schedule notifications

**한국어**

주요 테이블:
- users: 사용자 정보
- user_events: 사용자별 이벤트 정보
- user_preferences: 사용자 선호 설정
- chatrooms: 채팅방 정보
- chatroom_members: 채팅방 멤버 정보
- messages: 채팅 메시지
- schedule_reviews: 일정 리뷰
- review_images: 리뷰 이미지
- schedule_notifications: 일정 알림

## API Integration / API 통합

**English**

1. TourAPI: Retrieving and searching festival information
2. KakaoMap API: Displaying festival locations on map
3. Kakao mobility API: Route guidance (currently deactivated)
4. OpenWeatherMap API: Providing weather information for festival areas

**한국어**

1. TourAPI: 축제 정보 조회 및 검색
2. KakaoMap API: 축제 위치 지도 표시
3. Kakao mobility API: 경로 안내 (현재 기능 비활성화)
4. OpenWeatherMap API: 축제 지역 날씨 정보 제공

## Installation and Execution / 설치 및 실행 방법

**English**

1. Clone the repository
   ```
   git clone [repository URL]
   cd [project directory]
   ```

2. Database setup
    - Run MySQL server
    - Create database and tables using `database/schema.sql` file

3. Build and run the project
   ```
   mvn clean install
   mvn spring-boot:run
   ```

4. Access in web browser
   ```
   http://localhost:8080
   ```

**한국어**

1. 저장소 클론
   ```
   git clone [저장소 URL]
   cd [프로젝트 디렉토리]
   ```

2. 데이터베이스 설정
    - MySQL 서버 실행
    - `database/schema.sql` 파일을 이용해 데이터베이스 및 테이블 생성

3. 프로젝트 빌드 및 실행
   ```
   mvn clean install
   mvn spring-boot:run
   ```

4. 웹 브라우저에서 접속
   ```
   http://localhost:8080
   ```

## Team Members and Roles / 팀 멤버 및 역할

**English & 한국어**

- Park Moses / 박모세: Project management, Testing / 프로젝트 관리, 테스트
- Jo Hyunchul / 조현철: Web page testing, Messaging feature implementation / 웹 페이지 테스트, 메시징 기능 구현
- Shin Yehyun / 신예현: Festival information retrieval and search feature implementation / 축제 정보 조회 및 검색 기능 구현
- Kim Suhan / 김수한: Schedule management and route guidance feature implementation / 일정 관리 및 경로 안내 기능 구현
- Han Jina / 한진아: User management and personal settings feature implementation / 회원 관리 및 개인 설정 기능 구현
- Hwang Chanuk / 황찬욱: Schedule management and weather information provision feature implementation / 일정 관리 및 날씨 정보 제공 기능 구현

## Development Schedule / 개발 일정

**English & 한국어**

- 2024.02.22 ~ 2024.02.28: Project planning and design / 프로젝트 기획 및 설계
- 2024.03.01 ~ 2024.03.08: Development environment setup and basic layout work / 개발 환경 구축 및 기본 레이아웃 작업
- 2024.03.09 ~ 2024.03.31: Main feature implementation / 주요 기능 구현
- 2024.04.01 ~ 2024.04.02: Final inspection and deployment / 최종 검수 및 배포
- 2024.04.03: Project presentation / 프로젝트 발표

