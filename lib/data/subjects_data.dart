import 'package:flutter/material.dart';
import '../models/subject.dart';

final List<Subject> subjectsData = [
  Subject(
    id: 'os',
    name: '운영체제',
    description: '프로세스, 메모리, 파일시스템',
    icon: Icons.computer,
    progress: 0.6,
    sections: [
      StudySection(
        id: 'os1',
        title: '프로세스와 스레드',
        content: '''프로세스(Process)는 실행 중인 프로그램을 의미합니다.

🔹 프로세스의 주요 특징:
• 독립적인 메모리 공간을 가짐
• PCB(Process Control Block)로 관리
• 프로세스 간 통신은 IPC 사용
• 각각 고유한 PID(Process ID)를 가짐

🔹 프로세스 상태:
• 생성(New): 프로세스가 생성된 상태
• 준비(Ready): CPU 할당을 기다리는 상태
• 실행(Running): CPU를 할당받아 실행 중인 상태
• 대기(Waiting): I/O 완료 등을 기다리는 상태
• 종료(Terminated): 실행이 완료된 상태

스레드(Thread)는 프로세스 내의 실행 단위입니다.

🔹 스레드의 주요 특징:
• 같은 프로세스 내에서 메모리 공간 공유
• 컨텍스트 스위칭 비용이 적음
• 동기화 문제 발생 가능
• Light Weight Process라고도 불림''',
        quiz: Quiz(
          question: '프로세스와 스레드의 주요 차이점은?',
          options: [
            '메모리 공간 공유 여부',
            '실행 속도의 차이',
            '운영체제 지원 여부',
            '프로그래밍 언어 의존성'
          ],
          correctAnswer: 0,
          explanation: '프로세스는 독립적인 메모리 공간을 가지지만, 스레드는 같은 프로세스 내에서 메모리를 공유합니다.',
        ),
      ),
      StudySection(
        id: 'os2',
        title: '메모리 관리',
        content: '''메모리 관리는 운영체제의 핵심 기능 중 하나입니다.

🔹 메모리 관리 기법:
• 고정 분할(Fixed Partitioning)
• 가변 분할(Variable Partitioning)
• 페이징(Paging): 고정 크기 블록 단위로 관리
• 세그멘테이션: 가변 크기 논리적 단위로 관리

🔹 가상 메모리(Virtual Memory):
• 물리 메모리보다 큰 프로그램 실행 가능
• 논리 주소와 물리 주소의 분리
• 페이지 폴트(Page Fault) 처리
• 스와핑(Swapping)을 통한 메모리 효율성 향상

🔹 페이지 교체 알고리즘:
• FIFO (First In First Out)
• LRU (Least Recently Used)
• LFU (Least Frequently Used)
• Optimal Algorithm
• Clock Algorithm (Second Chance)

🔹 메모리 단편화:
• 내부 단편화: 할당된 메모리 내부의 낭비
• 외부 단편화: 할당되지 않은 메모리의 분산''',
        quiz: Quiz(
          question: 'LRU 페이지 교체 알고리즘의 특징은?',
          options: [
            '가장 먼저 들어온 페이지를 교체',
            '가장 오랫동안 사용되지 않은 페이지를 교체',
            '사용 빈도가 가장 낮은 페이지를 교체',
            '무작위로 페이지를 교체'
          ],
          correctAnswer: 1,
          explanation: 'LRU는 Least Recently Used의 약자로, 가장 오랫동안 사용되지 않은 페이지를 우선적으로 교체합니다.',
        ),
      ),
      StudySection(
        id: 'os3',
        title: '동기화',
        content: '''동기화는 여러 프로세스나 스레드가 공유 자원에 안전하게 접근하도록 하는 기법입니다.

🔹 동기화 관련 문제:
• 경쟁 상태(Race Condition): 여러 스레드가 동시에 자원에 접근
• 교착 상태(Deadlock): 서로가 가진 자원을 무한정 기다림
• 기아 상태(Starvation): 특정 프로세스가 계속 자원을 얻지 못함

🔹 동기화 기법:
• 뮤텍스(Mutex): 상호 배제를 위한 락
• 세마포어(Semaphore): 카운터를 이용한 동기화
• 모니터(Monitor): 고수준 동기화 구조
• 컨디션 변수(Condition Variable)

🔹 교착상태 해결 방법:
• 예방(Prevention): 데드락 조건 중 하나를 차단
• 회피(Avoidance): 은행가 알고리즘 사용
• 탐지 및 회복(Detection & Recovery): 발생 후 해결
• 무시(Ignore): 타조 정책''',
        quiz: Quiz(
          question: '뮤텍스와 세마포어의 주요 차이점은?',
          options: [
            '뮤텍스는 이진, 세마포어는 카운터',
            '뮤텍스가 더 빠름',
            '세마포어가 더 안전함',
            '사용하는 언어가 다름'
          ],
          correctAnswer: 0,
          explanation: '뮤텍스는 이진(0 또는 1) 값만 가지며, 세마포어는 카운터 값을 가져 여러 자원을 관리할 수 있습니다.',
        ),
      ),
      StudySection(
        id: 'os4',
        title: '파일 시스템',
        content: '''파일 시스템은 데이터를 파일 형태로 저장하고 관리하는 시스템입니다.

🔹 파일 시스템 구조:
• 디렉토리 구조: 계층적 파일 조직
• 파일 할당 테이블(FAT)
• 아이노드(Inode) 시스템
• 저널링 파일 시스템

🔹 파일 할당 방법:
• 연속 할당(Contiguous Allocation)
• 연결 할당(Linked Allocation)
• 인덱스 할당(Indexed Allocation)

🔹 디스크 스케줄링:
• FCFS (First Come First Served)
• SSTF (Shortest Seek Time First)
• SCAN (엘리베이터 알고리즘)
• C-SCAN (Circular SCAN)

🔹 파일 접근 방법:
• 순차 접근(Sequential Access)
• 직접 접근(Direct Access)
• 인덱스 순차 접근(Index Sequential Access)''',
        quiz: Quiz(
          question: 'SCAN 디스크 스케줄링 알고리즘의 특징은?',
          options: [
            '요청 순서대로 처리',
            '가장 가까운 요청을 먼저 처리',
            '한 방향으로 이동하며 모든 요청 처리',
            '무작위로 요청 처리'
          ],
          correctAnswer: 2,
          explanation: 'SCAN 알고리즘은 엘리베이터 알고리즘이라고도 하며, 한 방향으로 이동하며 경로상의 모든 요청을 처리합니다.',
        ),
      ),
      StudySection(
        id: 'os5',
        title: 'CPU 스케줄링',
        content: '''CPU 스케줄링은 여러 프로세스 중 어떤 프로세스에게 CPU를 할당할지 결정하는 정책입니다.

🔹 스케줄링 알고리즘:
• FCFS (First Come First Served)
• SJF (Shortest Job First)
• SRTF (Shortest Remaining Time First)
• RR (Round Robin)
• Priority Scheduling
• MLQ (Multi-Level Queue)
• MLFQ (Multi-Level Feedback Queue)

🔹 스케줄링 기준:
• CPU 사용률(Utilization): 최대화
• 처리량(Throughput): 최대화
• 반환 시간(Turnaround Time): 최소화
• 대기 시간(Waiting Time): 최소화
• 응답 시간(Response Time): 최소화

🔹 선점형 vs 비선점형:
• 선점형: 실행 중인 프로세스를 중단시킬 수 있음
• 비선점형: 프로세스가 자발적으로 CPU를 반납할 때까지 기다림''',
        quiz: Quiz(
          question: 'Round Robin 스케줄링에서 Time Quantum이 너무 크면?',
          options: [
            'FCFS와 유사해짐',
            'SJF와 유사해짐',
            'Priority 스케줄링과 유사해짐',
            '교착상태 발생'
          ],
          correctAnswer: 0,
          explanation: 'Time Quantum이 너무 크면 프로세스가 완료될 때까지 CPU를 사용하게 되어 FCFS와 유사해집니다.',
        ),
      ),
    ],
  ),
  Subject(
    id: 'network',
    name: '네트워크',
    description: 'TCP/IP, HTTP, 보안',
    icon: Icons.network_wifi,
    progress: 0.4,
    sections: [
      StudySection(
        id: 'net1',
        title: 'OSI 7계층',
        content: '''OSI 7계층 모델은 네트워크 통신의 표준 모델입니다.

🔹 각 계층의 역할:
1️⃣ 물리 계층(Physical Layer):
• 비트 스트림 전송
• 전기적, 기계적 신호 변환
• 케이블, 허브, 리피터 등

2️⃣ 데이터링크 계층(Data Link Layer):
• 프레임 단위 전송
• 오류 검출 및 수정
• MAC 주소 사용
• 이더넷, WiFi 등

3️⃣ 네트워크 계층(Network Layer):
• 패킷 라우팅
• IP 주소 관리
• 경로 선택
• 라우터 동작

4️⃣ 전송 계층(Transport Layer):
• 포트 번호 관리
• TCP/UDP 프로토콜
• 신뢰성 있는 데이터 전송
• 흐름 제어, 오류 복구

5️⃣ 세션 계층(Session Layer):
• 세션 관리 및 제어
• 동기화 지점 설정
• 대화 제어

6️⃣ 표현 계층(Presentation Layer):
• 데이터 암호화/복호화
• 데이터 압축
• 문자 인코딩

7️⃣ 응용 계층(Application Layer):
• 사용자 인터페이스 제공
• HTTP, HTTPS, FTP, SMTP 등''',
        quiz: Quiz(
          question: 'TCP가 동작하는 계층은?',
          options: [
            '네트워크 계층',
            '전송 계층',
            '세션 계층',
            '응용 계층'
          ],
          correctAnswer: 1,
          explanation: 'TCP는 전송 계층(Transport Layer)에서 동작하며, 신뢰성 있는 데이터 전송을 담당합니다.',
        ),
      ),
      StudySection(
        id: 'net2',
        title: 'TCP/IP 프로토콜',
        content: '''TCP/IP는 인터넷의 핵심 프로토콜 스택입니다.

🔹 TCP (Transmission Control Protocol):
• 연결 지향형 프로토콜
• 신뢰성 있는 데이터 전송 보장
• 흐름 제어 및 혼잡 제어
• 3-way handshake로 연결 설정
• 4-way handshake로 연결 해제

🔹 TCP의 특징:
• 순서 보장: 패킷 재정렬
• 중복 제거: 중복 패킷 제거
• 오류 복구: 손실된 패킷 재전송
• 흐름 제어: 수신자 버퍼 크기 고려

🔹 UDP (User Datagram Protocol):
• 비연결형 프로토콜
• 빠른 데이터 전송
• 최소한의 오버헤드
• 실시간 스트리밍에 적합

🔹 IP (Internet Protocol):
• 패킷 라우팅 및 주소 지정
• IPv4: 32비트 주소
• IPv6: 128비트 주소
• 베스트 에포트 서비스

🔹 3-way Handshake:
1. 클라이언트 → 서버: SYN
2. 서버 → 클라이언트: SYN + ACK
3. 클라이언트 → 서버: ACK''',
        quiz: Quiz(
          question: 'TCP와 UDP의 주요 차이점은?',
          options: [
            '연결 지향성 여부',
            '포트 번호 사용 여부',
            'IP 주소 사용 여부',
            '데이터 크기 제한'
          ],
          correctAnswer: 0,
          explanation: 'TCP는 연결 지향형으로 신뢰성을 보장하지만, UDP는 비연결형으로 빠른 전송에 중점을 둡니다.',
        ),
      ),
      StudySection(
        id: 'net3',
        title: 'HTTP/HTTPS',
        content: '''HTTP는 웹에서 사용하는 응용 계층 프로토콜입니다.

🔹 HTTP (HyperText Transfer Protocol):
• 클라이언트-서버 모델
• 무상태(Stateless) 프로토콜
• 요청-응답 기반
• 포트 80번 사용

🔹 HTTP 메소드:
• GET: 리소스 조회
• POST: 데이터 생성
• PUT: 리소스 전체 수정
• PATCH: 리소스 부분 수정
• DELETE: 리소스 삭제
• HEAD: 메타데이터만 조회
• OPTIONS: 서버 지원 메소드 확인

🔹 HTTP 상태 코드:
• 1xx: 정보 응답
• 2xx: 성공 응답 (200 OK, 201 Created)
• 3xx: 리다이렉션 (301 Moved, 304 Not Modified)
• 4xx: 클라이언트 오류 (400 Bad Request, 404 Not Found)
• 5xx: 서버 오류 (500 Internal Error, 503 Service Unavailable)

🔹 HTTPS (HTTP Secure):
• HTTP + SSL/TLS 암호화
• 포트 443번 사용
• 데이터 암호화 및 무결성 보장
• 서버 인증서를 통한 신원 확인

🔹 HTTP/2의 개선사항:
• 바이너리 프로토콜
• 멀티플렉싱 지원
• 헤더 압축
• 서버 푸시 기능''',
        quiz: Quiz(
          question: 'HTTP와 HTTPS의 주요 차이점은?',
          options: [
            '사용 포트 번호만 다름',
            'HTTPS는 암호화를 제공함',
            'HTTPS는 더 빠름',
            '프로토콜 구조가 완전히 다름'
          ],
          correctAnswer: 1,
          explanation: 'HTTPS는 HTTP에 SSL/TLS 암호화를 추가하여 보안성을 강화한 프로토콜입니다.',
        ),
      ),
      StudySection(
        id: 'net4',
        title: 'DNS와 라우팅',
        content: '''DNS와 라우팅은 네트워크에서 핵심적인 역할을 합니다.

🔹 DNS (Domain Name System):
• 도메인 이름을 IP 주소로 변환
• 계층적 분산 데이터베이스
• 캐싱을 통한 성능 향상
• 여러 레코드 타입 지원

🔹 DNS 레코드 타입:
• A: 도메인 → IPv4 주소
• AAAA: 도메인 → IPv6 주소
• CNAME: 도메인 → 다른 도메인
• MX: 메일 서버 주소
• TXT: 텍스트 정보
• NS: 네임 서버 정보

🔹 DNS 조회 과정:
1. 클라이언트가 로컬 DNS에 질의
2. 로컬 DNS가 루트 서버에 질의
3. 루트 서버가 TLD 서버 정보 반환
4. TLD 서버가 권한 있는 서버 정보 반환
5. 권한 있는 서버가 IP 주소 반환

🔹 라우팅 (Routing):
• 패킷의 최적 경로 선택
• 라우팅 테이블 관리
• 정적 라우팅 vs 동적 라우팅

🔹 라우팅 프로토콜:
• RIP (Routing Information Protocol)
• OSPF (Open Shortest Path First)
• BGP (Border Gateway Protocol)

🔹 라우팅 알고리즘:
• 거리 벡터 알고리즘
• 링크 상태 알고리즘
• 최단 경로 우선 알고리즘''',
        quiz: Quiz(
          question: 'DNS의 주요 기능은?',
          options: [
            'IP 주소를 도메인으로 변환',
            '도메인을 IP 주소로 변환',
            '네트워크 보안 제공',
            '데이터 압축'
          ],
          correctAnswer: 1,
          explanation: 'DNS는 사람이 읽기 쉬운 도메인 이름을 컴퓨터가 이해할 수 있는 IP 주소로 변환하는 시스템입니다.',
        ),
      ),
      StudySection(
        id: 'net5',
        title: '네트워크 보안',
        content: '''네트워크 보안은 정보 자산을 보호하는 핵심 요소입니다.

🔹 보안의 3요소 (CIA Triad):
• 기밀성(Confidentiality): 인가된 사용자만 접근
• 무결성(Integrity): 데이터 변조 방지
• 가용성(Availability): 서비스 지속성 보장

🔹 암호화 기술:
• 대칭키 암호화: 같은 키로 암호화/복호화
• 비대칭키 암호화: 공개키/개인키 쌍 사용
• 해시 함수: 고정 길이 해시값 생성
• 디지털 서명: 무결성 및 인증 보장

🔹 네트워크 보안 위협:
• DDoS 공격: 서비스 거부 공격
• 피싱(Phishing): 개인정보 탈취
• 맨인더미들(Man-in-the-Middle): 통신 가로채기
• SQL 인젝션: 데이터베이스 공격
• 크로스 사이트 스크립팅(XSS)

🔹 보안 프로토콜:
• SSL/TLS: 전송 계층 보안
• IPSec: 네트워크 계층 보안
• VPN: 가상 사설망
• WPA/WPA2: 무선 보안

🔹 방화벽 (Firewall):
• 네트워크 트래픽 필터링
• 패킷 필터링 방화벽
• 상태 추적 방화벽
• 응용 프로그램 게이트웨이

🔹 침입 탐지 시스템 (IDS):
• 네트워크 침입 실시간 탐지
• 시그니처 기반 탐지
• 이상 행위 기반 탐지
• 호스트 기반 vs 네트워크 기반''',
        quiz: Quiz(
          question: '대칭키 암호화와 비대칭키 암호화의 주요 차이점은?',
          options: [
            '암호화 속도만 다름',
            '사용하는 키의 개수가 다름',
            '보안 수준이 다름',
            '알고리즘 복잡도가 다름'
          ],
          correctAnswer: 1,
          explanation: '대칭키는 하나의 키로 암호화/복호화하지만, 비대칭키는 공개키와 개인키 두 개의 키를 사용합니다.',
        ),
      ),
    ],
  ),
  Subject(
    id: 'database',
    name: '데이터베이스',
    description: 'RDBMS, SQL, 트랜잭션',
    icon: Icons.storage,
    progress: 0.8,
    sections: [
      StudySection(
        id: 'db1',
        title: 'ACID 속성',
        content: '''ACID는 데이터베이스 트랜잭션의 네 가지 중요한 속성입니다.

🔹 ACID 속성:
• Atomicity (원자성): 트랜잭션은 모두 성공하거나 모두 실패
• Consistency (일관성): 트랜잭션 후에도 데이터 무결성 유지
• Isolation (격리성): 동시 실행되는 트랜잭션들이 서로 영향 없음
• Durability (지속성): 커밋된 트랜잭션은 영구적으로 저장

🔹 원자성 (Atomicity):
• All or Nothing 원칙
• 트랜잭션 중 일부만 실행되면 모든 변경 사항 롤백
• 예: 계좌 이체 시 출금과 입금이 모두 성공하거나 모두 실패

🔹 일관성 (Consistency):
• 데이터 무결성 제약조건 유지
• 트랜잭션 전후로 데이터베이스 상태가 일관됨
• 예: 기본키, 외래키, 체크 제약조건 위반 방지

🔹 격리성 (Isolation):
• 동시 실행되는 트랜잭션의 상호 간섭 방지
• 트랜잭션 격리 수준 제공
• Read Uncommitted, Read Committed, Repeatable Read, Serializable

🔹 지속성 (Durability):
• 커밋된 트랜잭션의 영구 보존
• 시스템 장애 발생해도 데이터 보장
• 로그 파일과 백업을 통한 복구 지원''',
        quiz: Quiz(
          question: 'ACID 중 동시에 실행되는 트랜잭션의 간섭을 방지하는 속성은?',
          options: [
            'Atomicity',
            'Consistency',
            'Isolation',
            'Durability'
          ],
          correctAnswer: 2,
          explanation: 'Isolation(격리성)은 동시에 실행되는 트랜잭션들이 서로 영향을 주지 않도록 격리시키는 속성입니다.',
        ),
      ),
      StudySection(
        id: 'db2',
        title: 'SQL과 쿼리 최적화',
        content: '''SQL(Structured Query Language)은 관계형 데이터베이스 관리 언어입니다.

🔹 SQL 문법 분류:
• DDL (Data Definition Language): CREATE, ALTER, DROP
• DML (Data Manipulation Language): INSERT, UPDATE, DELETE
• DQL (Data Query Language): SELECT
• DCL (Data Control Language): GRANT, REVOKE
• TCL (Transaction Control Language): COMMIT, ROLLBACK

🔹 조인(JOIN) 종류:
• INNER JOIN: 양쪽 테이블에 모두 존재하는 데이터
• LEFT JOIN: 왼쪽 테이블의 모든 데이터 + 오른쪽 매칭 데이터
• RIGHT JOIN: 오른쪽 테이블의 모든 데이터 + 왼쪽 매칭 데이터
• FULL OUTER JOIN: 양쪽 테이블의 모든 데이터
• CROSS JOIN: 카르테시안 곱

🔹 쿼리 최적화 기법:
• 인덱스 활용: WHERE, ORDER BY 절에 인덱스 사용
• SELECT 절 최적화: 필요한 컬럼만 조회
• 조건절 최적화: 선택도가 높은 조건을 앞쪽에 배치
• 서브쿼리 최적화: EXISTS vs IN 적절한 사용

🔹 실행 계획 (Execution Plan):
• 쿼리 실행 순서와 방법 확인
• 비용(Cost) 기반 최적화
• 인덱스 스캔 vs 풀 테이블 스캔
• 조인 알고리즘 선택

🔹 인덱스 (Index):
• B-Tree 인덱스: 범위 검색에 효율적
• 해시 인덱스: 동등 비교에 효율적
• 비트맵 인덱스: 카디널리티가 낮은 컬럼에 적합
• 복합 인덱스: 여러 컬럼 조합''',
        quiz: Quiz(
          question: 'LEFT JOIN과 INNER JOIN의 차이점은?',
          options: [
            'LEFT JOIN은 왼쪽 테이블의 모든 행을 포함',
            'INNER JOIN이 더 빠름',
            '기능상 동일함',
            'LEFT JOIN은 중복을 허용하지 않음'
          ],
          correctAnswer: 0,
          explanation: 'LEFT JOIN은 왼쪽 테이블의 모든 행을 포함하며, 오른쪽 테이블에서 매칭되는 데이터가 없으면 NULL로 표시됩니다.',
        ),
      ),
      StudySection(
        id: 'db3',
        title: '정규화와 반정규화',
        content: '''데이터베이스 정규화는 데이터 중복을 최소화하고 무결성을 보장하는 과정입니다.

🔹 정규화 목적:
• 데이터 중복 제거
• 삽입/갱신/삭제 이상 방지
• 데이터 무결성 유지
• 저장 공간 효율성

🔹 정규형 (Normal Form):
1️⃣ 제1정규형 (1NF):
• 모든 속성이 원자값(atomic)을 가짐
• 다중값 속성 제거
• 반복 그룹 제거

2️⃣ 제2정규형 (2NF):
• 1NF를 만족
• 완전 함수 종속성 만족
• 부분 함수 종속성 제거

3️⃣ 제3정규형 (3NF):
• 2NF를 만족
• 이행적 함수 종속성 제거
• 비키 속성간 함수 종속성 제거

🔹 BCNF (Boyce-Codd Normal Form):
• 3NF의 강화 버전
• 모든 결정자가 후보키
• 키가 아닌 속성이 키의 일부를 결정하는 경우 제거

🔹 반정규화 (Denormalization):
• 성능 향상을 위한 정규화 역과정
• 읽기 성능 개선
• 조인 연산 최소화
• 데이터 중복 허용

🔹 반정규화 기법:
• 테이블 통합: 자주 조인되는 테이블 병합
• 테이블 분할: 수직 분할, 수평 분할
• 중복 컬럼 추가: 계산 결과 저장
• 유도 컬럼 추가: 집계 데이터 저장''',
        quiz: Quiz(
          question: '제3정규형(3NF)의 조건은?',
          options: [
            '모든 속성이 원자값을 가짐',
            '완전 함수 종속성을 만족',
            '이행적 함수 종속성을 제거',
            '모든 결정자가 후보키'
          ],
          correctAnswer: 2,
          explanation: '제3정규형은 2NF를 만족하면서 이행적 함수 종속성(A→B, B→C이면 A→C)을 제거한 형태입니다.',
        ),
      ),
      StudySection(
        id: 'db4',
        title: '트랜잭션과 동시성 제어',
        content: '''트랜잭션은 데이터베이스의 상태를 변화시키는 논리적 기능 단위입니다.

🔹 트랜잭션 상태:
• 활성(Active): 트랜잭션이 실행 중인 상태
• 부분완료(Partially Committed): 마지막 연산이 실행된 직후 상태
• 완료(Committed): 트랜잭션이 성공적으로 완료된 상태
• 실패(Failed): 정상적으로 실행될 수 없는 상태
• 철회(Aborted): 실행이 중단되고 롤백된 상태

🔹 동시성 문제:
• 갱신 분실(Lost Update): 동시 갱신으로 인한 데이터 손실
• 모순성(Inconsistency): 일부만 반영된 불일치 상태
• 연쇄 복귀(Cascading Rollback): 연쇄적 롤백 발생
• 비완료 의존성(Uncommitted Dependency): 미완료 데이터 접근

🔹 격리 수준 (Isolation Level):
1️⃣ Read Uncommitted:
• 커밋되지 않은 데이터 읽기 허용
• Dirty Read 발생 가능

2️⃣ Read Committed:
• 커밋된 데이터만 읽기 허용
• Non-repeatable Read 발생 가능

3️⃣ Repeatable Read:
• 같은 트랜잭션 내에서 일관된 읽기
• Phantom Read 발생 가능

4️⃣ Serializable:
• 완전한 격리, 직렬 실행과 동일
• 모든 이상 현상 방지

🔹 잠금 (Locking):
• 공유 잠금(Shared Lock): 읽기 허용, 쓰기 차단
• 배타 잠금(Exclusive Lock): 읽기/쓰기 모두 차단
• 의도 잠금(Intent Lock): 하위 레벨 잠금 의도 표시
• 데드락(Deadlock): 상호 대기로 인한 교착상태

🔹 회복 기법:
• 즉시 갱신(Immediate Update): 즉시 디스크에 반영
• 지연 갱신(Deferred Update): 커밋 시점에 반영
• 그림자 페이지(Shadow Paging): 복사본 생성 후 갱신
• 검사점(Checkpoint): 주기적 일관성 보장''',
        quiz: Quiz(
          question: 'Repeatable Read 격리 수준에서 발생할 수 있는 현상은?',
          options: [
            'Dirty Read',
            'Non-repeatable Read',
            'Phantom Read',
            '모든 현상이 방지됨'
          ],
          correctAnswer: 2,
          explanation: 'Repeatable Read에서는 Phantom Read(새로운 행의 삽입으로 인한 결과 집합 변화)가 발생할 수 있습니다.',
        ),
      ),
      StudySection(
        id: 'db5',
        title: 'NoSQL과 빅데이터',
        content: '''NoSQL은 전통적인 관계형 데이터베이스의 한계를 극복하기 위해 등장했습니다.

🔹 NoSQL의 특징:
• 스키마 없는 데이터 모델
• 수평적 확장성(Scale-out)
• 높은 가용성과 성능
• 최종 일관성(Eventual Consistency)

🔹 NoSQL 유형:
1️⃣ 문서형 데이터베이스:
• MongoDB, CouchDB
• JSON, XML 문서 저장
• 중첩된 구조 표현 가능

2️⃣ 키-값 데이터베이스:
• Redis, DynamoDB
• 단순한 키-값 쌍
• 캐시 용도로 많이 사용

3️⃣ 컬럼형 데이터베이스:
• Cassandra, HBase
• 컬럼 패밀리 구조
• 대용량 데이터 처리에 적합

4️⃣ 그래프 데이터베이스:
• Neo4j, Amazon Neptune
• 노드와 엣지로 관계 표현
• 소셜 네트워크, 추천 시스템

🔹 CAP 정리:
• Consistency: 일관성
• Availability: 가용성
• Partition tolerance: 분할 허용성
• 세 가지 중 최대 두 가지만 보장 가능

🔹 빅데이터의 3V:
• Volume: 데이터 크기
• Velocity: 데이터 생성 속도
• Variety: 데이터 다양성

🔹 빅데이터 처리 기술:
• Hadoop: 분산 저장 및 처리 플랫폼
• MapReduce: 분산 병렬 처리 모델
• Spark: 인메모리 처리 엔진
• Kafka: 실시간 스트림 처리
• ElasticSearch: 검색 및 분석 엔진

🔹 데이터 웨어하우스:
• OLTP vs OLAP 차이
• ETL (Extract, Transform, Load) 프로세스
• 스타 스키마, 스노우플레이크 스키마
• 데이터 마트와 데이터 레이크''',
        quiz: Quiz(
          question: 'CAP 정리에서 설명하는 내용은?',
          options: [
            '세 가지 속성을 모두 보장할 수 있음',
            '세 가지 속성 중 최대 두 가지만 보장 가능',
            '일관성이 가장 중요함',
            '분할 허용성은 선택사항임'
          ],
          correctAnswer: 1,
          explanation: 'CAP 정리는 분산 시스템에서 일관성, 가용성, 분할 허용성 중 최대 두 가지만 동시에 보장할 수 있다는 이론입니다.',
        ),
      ),
    ],
  ),
  Subject(
    id: 'algorithm',
    name: '알고리즘',
    description: '정렬, 탐색, 동적계획법',
    icon: Icons.functions,
    progress: 0.3,
    sections: [
      StudySection(
        id: 'algo1',
        title: '정렬 알고리즘',
        content: '''다양한 정렬 알고리즘과 시간복잡도를 비교해보겠습니다.

🔹 O(n²) 시간복잡도 정렬:
1️⃣ 버블 정렬 (Bubble Sort):
• 인접한 두 원소를 비교하여 교환
• 구현이 간단하지만 비효율적
• 안정 정렬 알고리즘

2️⃣ 삽입 정렬 (Insertion Sort):
• 정렬된 부분에 새 원소를 적절한 위치에 삽입
• 작은 데이터나 이미 정렬된 데이터에 효율적
• 온라인 알고리즘 (데이터가 들어오는 대로 정렬)

3️⃣ 선택 정렬 (Selection Sort):
• 최솟값을 찾아 맨 앞과 교환
• 교환 횟수가 적음
• 불안정 정렬 알고리즘

🔹 O(n log n) 시간복잡도 정렬:
1️⃣ 병합 정렬 (Merge Sort):
• 분할 정복 기법 사용
• 안정적이고 예측 가능한 성능
• 추가 메모리 O(n) 필요

2️⃣ 퀵 정렬 (Quick Sort):
• 평균 O(n log n), 최악 O(n²)
• 실제로 가장 빠른 정렬 알고리즘
• 피벗 선택이 성능에 큰 영향

3️⃣ 힙 정렬 (Heap Sort):
• 힙 자료구조 활용
• 최악의 경우에도 O(n log n) 보장
• 추가 메모리 O(1)

🔹 특수한 정렬 알고리즘:
• 계수 정렬 (Counting Sort): O(n+k), 정수 범위가 작을 때
• 기수 정렬 (Radix Sort): O(d×(n+k)), 자릿수 기반
• 버킷 정렬 (Bucket Sort): O(n), 데이터가 균등분포일 때''',
        quiz: Quiz(
          question: '최악의 경우에도 O(n log n)을 보장하는 정렬 알고리즘은?',
          options: [
            '퀵 정렬',
            '병합 정렬',
            '버블 정렬',
            '삽입 정렬'
          ],
          correctAnswer: 1,
          explanation: '병합 정렬은 모든 경우에 O(n log n)의 시간복잡도를 보장하는 안정적인 정렬 알고리즘입니다.',
        ),
      ),
      StudySection(
        id: 'algo2',
        title: '탐색 알고리즘',
        content: '''효율적인 데이터 탐색을 위한 다양한 알고리즘들입니다.

🔹 선형 탐색 (Linear Search):
• 처음부터 끝까지 순차적으로 탐색
• 시간복잡도: O(n)
• 정렬되지 않은 데이터에도 사용 가능
• 구현이 간단함

🔹 이진 탐색 (Binary Search):
• 정렬된 배열에서 중간값과 비교하여 탐색 범위를 절반으로 축소
• 시간복잡도: O(log n)
• 반드시 정렬된 데이터 필요
• 분할 정복 기법의 대표 예시

🔹 해시 탐색 (Hash Search):
• 해시 함수를 이용하여 키를 인덱스로 변환
• 평균 시간복잡도: O(1)
• 해시 충돌 처리 필요
• 체이닝, 개방 주소법 등의 해결 방법

🔹 트리 기반 탐색:
1️⃣ 이진 탐색 트리 (BST):
• 평균 O(log n), 최악 O(n)
• 중위 순회 시 정렬된 순서로 방문

2️⃣ AVL 트리:
• 높이 균형 이진 탐색 트리
• 모든 연산이 O(log n) 보장

3️⃣ 레드-블랙 트리:
• 색깔을 이용한 균형 유지
• 삽입/삭제 시 재조정 비용 적음

🔹 그래프 탐색:
• BFS (너비 우선 탐색): 큐 사용, 최단 경로 탐색
• DFS (깊이 우선 탐색): 스택 사용, 경로 존재 여부 확인
• A* 알고리즘: 휴리스틱을 이용한 최적 경로 탐색''',
        quiz: Quiz(
          question: '이진 탐색의 전제 조건은?',
          options: [
            '데이터가 정렬되어 있어야 함',
            '데이터 크기가 2의 제곱수여야 함',
            '중복 데이터가 없어야 함',
            '배열로 구현되어야 함'
          ],
          correctAnswer: 0,
          explanation: '이진 탐색은 정렬된 배열에서만 동작하며, 중간값과의 비교를 통해 탐색 범위를 절반씩 줄여나갑니다.',
        ),
      ),
      StudySection(
        id: 'algo3',
        title: '동적계획법',
        content: '''동적계획법(Dynamic Programming)은 복잡한 문제를 간단한 하위 문제로 나누어 해결하는 기법입니다.

🔹 동적계획법의 특징:
• 최적 부분 구조(Optimal Substructure): 문제의 최적해가 부분 문제들의 최적해로 구성
• 중복 부분 문제(Overlapping Subproblems): 같은 부분 문제가 여러 번 계산됨
• 메모이제이션(Memoization): 계산 결과를 저장하여 재사용

🔹 구현 방법:
1️⃣ Top-Down (재귀 + 메모이제이션):
• 큰 문제부터 시작하여 작은 문제로 분할
• 재귀 호출과 메모 테이블 사용
• 직관적이지만 스택 오버플로우 위험

2️⃣ Bottom-Up (반복문):
• 작은 문제부터 해결하여 큰 문제로 확장
• 반복문과 DP 테이블 사용
• 메모리 효율적

🔹 대표적인 DP 문제:
1️⃣ 피보나치 수열:
• F(n) = F(n-1) + F(n-2)
• 중복 계산을 메모이제이션으로 최적화

2️⃣ 배낭 문제(Knapsack):
• 제한된 용량에서 최대 가치 선택
• 0-1 배낭, 무한 배낭 등 변형 존재

3️⃣ 최장 공통 부분 수열(LCS):
• 두 문자열의 최장 공통 부분 수열 찾기
• 편집 거리, 유사도 측정 등에 응용

4️⃣ 최단 경로 문제:
• 플로이드-워셜 알고리즘
• 모든 정점 간의 최단 경로 계산

🔹 DP 문제 해결 단계:
1. 문제를 부분 문제로 분할
2. 부분 문제 간의 관계식(점화식) 도출
3. 기저 조건(Base Case) 정의
4. 구현 방식 선택 (Top-Down vs Bottom-Up)
5. 시간/공간 복잡도 최적화''',
        quiz: Quiz(
          question: '동적계획법이 적용 가능한 문제의 조건은?',
          options: [
            '최적 부분 구조만 만족하면 됨',
            '중복 부분 문제만 있으면 됨',
            '최적 부분 구조와 중복 부분 문제가 모두 존재',
            '재귀적으로 해결 가능한 모든 문제'
          ],
          correctAnswer: 2,
          explanation: '동적계획법은 최적 부분 구조와 중복 부분 문제가 모두 존재할 때 효과적으로 적용할 수 있습니다.',
        ),
      ),
      StudySection(
        id: 'algo4',
        title: '그래프 알고리즘',
        content: '''그래프는 정점과 간선으로 이루어진 자료구조로, 다양한 실생활 문제를 모델링할 수 있습니다.

🔹 그래프 표현 방법:
1️⃣ 인접 행렬 (Adjacency Matrix):
• 2차원 배열로 표현
• 공간복잡도: O(V²)
• 간선 존재 여부 확인: O(1)

2️⃣ 인접 리스트 (Adjacency List):
• 각 정점마다 연결된 정점들의 리스트
• 공간복잡도: O(V+E)
• 특정 간선 찾기: O(degree(v))

🔹 그래프 순회:
1️⃣ BFS (너비 우선 탐색):
• 큐를 사용하여 레벨 순서로 탐색
• 최단 경로 찾기에 활용
• 시간복잡도: O(V+E)

2️⃣ DFS (깊이 우선 탐색):
• 스택(또는 재귀)을 사용하여 깊이 우선 탐색
• 연결성, 사이클 검출에 활용
• 시간복잡도: O(V+E)

🔹 최단 경로 알고리즘:
1️⃣ 다익스트라 알고리즘:
• 음이 아닌 가중치 그래프에서 단일 출발점 최단 경로
• 시간복잡도: O((V+E)logV) (우선순위 큐 사용)
• 그리디 알고리즘

2️⃣ 벨만-포드 알고리즘:
• 음의 가중치 허용, 음의 사이클 검출 가능
• 시간복잡도: O(VE)
• 동적계획법

3️⃣ 플로이드-워셜 알고리즘:
• 모든 정점 간 최단 경로
• 시간복잡도: O(V³)
• 3중 반복문으로 구현

🔹 최소 신장 트리:
1️⃣ 크루스칼 알고리즘:
• 간선을 가중치 순으로 정렬
• Union-Find 자료구조 사용
• 시간복잡도: O(ElogE)

2️⃣ 프림 알고리즘:
• 정점 중심으로 트리 확장
• 우선순위 큐 사용
• 시간복잡도: O(ElogV)

🔹 위상 정렬:
• 방향 비순환 그래프(DAG)에서 순서 결정
• DFS 또는 Kahn 알고리즘 사용
• 작업 스케줄링, 선수과목 등에 활용''',
        quiz: Quiz(
          question: '다익스트라 알고리즘의 제약 조건은?',
          options: [
            '무방향 그래프여야 함',
            '음의 가중치가 없어야 함',
            '사이클이 없어야 함',
            '완전 그래프여야 함'
          ],
          correctAnswer: 1,
          explanation: '다익스트라 알고리즘은 음의 가중치가 있는 간선이 존재하면 올바른 결과를 보장할 수 없습니다.',
        ),
      ),
      StudySection(
        id: 'algo5',
        title: '시간복잡도와 공간복잡도',
        content: '''알고리즘의 효율성을 분석하기 위한 핵심 개념입니다.

🔹 시간복잡도 (Time Complexity):
• 입력 크기에 따른 실행 시간의 증가율
• 빅오 표기법(Big-O Notation) 사용
• 최악의 경우(Worst Case)를 기준으로 분석

🔹 빅오 표기법 순서:
O(1) < O(log n) < O(n) < O(n log n) < O(n²) < O(n³) < O(2ⁿ) < O(n!)

🔹 각 시간복잡도의 특징:
• O(1): 상수 시간, 입력 크기와 무관
• O(log n): 로그 시간, 이진 탐색
• O(n): 선형 시간, 배열 순회
• O(n log n): 효율적인 정렬 알고리즘
• O(n²): 이중 반복문, 버블/선택 정렬
• O(2ⁿ): 지수 시간, 부분집합 생성

🔹 공간복잡도 (Space Complexity):
• 알고리즘 실행에 필요한 메모리 공간
• 입력 크기에 따른 추가 메모리 사용량
• In-place vs Out-of-place 알고리즘

🔹 시간복잡도 분석 기법:
1️⃣ 반복문 분석:
• 단일 반복문: O(n)
• 중첩 반복문: O(n²), O(n³), ...
• 분할 정복: O(n log n)

2️⃣ 재귀 분석:
• 마스터 정리 사용
• 재귀 트리 그리기
• 점화식 세우기

🔹 최적화 기법:
1️⃣ 메모이제이션:
• 중복 계산 제거
• 공간을 사용하여 시간 단축

2️⃣ 분할 정복:
• 문제를 작은 단위로 분할
• 병합 정렬, 퀵 정렬 등

3️⃣ 그리디:
• 매 순간 최적의 선택
• 다익스트라, 크루스칼 등

4️⃣ 동적계획법:
• 중복 부분 문제 해결
• 피보나치, 배낭 문제 등

🔹 실제 성능 고려사항:
• 상수 계수의 영향
• 캐시 효율성
• 메모리 지역성
• 입력 데이터의 특성''',
        quiz: Quiz(
          question: '중첩된 반복문에서 외부 반복문이 n번, 내부 반복문이 i번(i는 0부터 n-1) 실행될 때의 시간복잡도는?',
          options: [
            'O(n)',
            'O(n log n)',
            'O(n²)',
            'O(2ⁿ)'
          ],
          correctAnswer: 2,
          explanation: '외부 루프가 n번, 내부 루프가 평균 n/2번 실행되므로 전체적으로 O(n²)의 시간복잡도를 가집니다.',
        ),
      ),
    ],
  ),
];

final List<InterviewQuestion> technicalQuestions = [
  // 운영체제 관련
  InterviewQuestion(
    id: 'tech1',
    question: '프로세스와 스레드의 차이점을 설명하고, 각각의 장단점을 말해주세요.',
    type: '기술면접',
    difficulty: '중급',
  ),
  InterviewQuestion(
    id: 'tech2',
    question: '데드락(Deadlock)이 발생하는 조건 4가지와 해결 방법을 설명해주세요.',
    type: '기술면접',
    difficulty: '고급',
  ),
  InterviewQuestion(
    id: 'tech3',
    question: '가상 메모리의 개념과 페이징 기법에 대해 설명해주세요.',
    type: '기술면접',
    difficulty: '중급',
  ),
  InterviewQuestion(
    id: 'tech4',
    question: 'CPU 스케줄링 알고리즘 중 Round Robin과 SJF의 차이점을 설명해주세요.',
    type: '기술면접',
    difficulty: '중급',
  ),

  // 네트워크 관련
  InterviewQuestion(
    id: 'tech5',
    question: 'OSI 7계층 모델에 대해 설명하고, 각 계층의 역할을 말해주세요.',
    type: '기술면접',
    difficulty: '중급',
  ),
  InterviewQuestion(
    id: 'tech6',
    question: 'HTTP와 HTTPS의 차이점과 SSL/TLS의 동작 원리를 설명해주세요.',
    type: '기술면접',
    difficulty: '중급',
  ),
  InterviewQuestion(
    id: 'tech7',
    question: 'TCP와 UDP의 차이점과 각각의 사용 사례를 말해주세요.',
    type: '기술면접',
    difficulty: '초급',
  ),
  InterviewQuestion(
    id: 'tech8',
    question: '3-way handshake와 4-way handshake 과정을 설명해주세요.',
    type: '기술면접',
    difficulty: '중급',
  ),
  InterviewQuestion(
    id: 'tech9',
    question: 'DNS의 동작 원리와 레코드 타입에 대해 설명해주세요.',
    type: '기술면접',
    difficulty: '중급',
  ),

  // 데이터베이스 관련
  InterviewQuestion(
    id: 'tech10',
    question: 'ACID 속성에 대해 설명하고, 각각의 의미를 말해주세요.',
    type: '기술면접',
    difficulty: '중급',
  ),
  InterviewQuestion(
    id: 'tech11',
    question: '데이터베이스 정규화에 대해 설명하고, 1NF부터 3NF까지의 특징을 말해주세요.',
    type: '기술면접',
    difficulty: '고급',
  ),
  InterviewQuestion(
    id: 'tech12',
    question: '트랜잭션 격리 수준 4가지와 각각에서 발생할 수 있는 문제점을 설명해주세요.',
    type: '기술면접',
    difficulty: '고급',
  ),
  InterviewQuestion(
    id: 'tech13',
    question: 'JOIN의 종류와 차이점을 설명해주세요.',
    type: '기술면접',
    difficulty: '중급',
  ),
  InterviewQuestion(
    id: 'tech14',
    question: 'NoSQL과 RDBMS의 차이점과 각각의 적합한 사용 사례를 말해주세요.',
    type: '기술면접',
    difficulty: '중급',
  ),

  // 알고리즘 관련
  InterviewQuestion(
    id: 'tech15',
    question: '시간복잡도와 공간복잡도의 개념을 설명하고, Big-O 표기법에 대해 말해주세요.',
    type: '기술면접',
    difficulty: '초급',
  ),
  InterviewQuestion(
    id: 'tech16',
    question: '정렬 알고리즘 중 퀵 정렬과 병합 정렬의 차이점과 각각의 시간복잡도를 설명해주세요.',
    type: '기술면접',
    difficulty: '중급',
  ),
  InterviewQuestion(
    id: 'tech17',
    question: '스택과 큐의 차이점과 각각의 활용 사례를 설명해주세요.',
    type: '기술면접',
    difficulty: '초급',
  ),
  InterviewQuestion(
    id: 'tech18',
    question: '동적계획법(DP)의 개념과 적용 조건, 대표적인 예시를 설명해주세요.',
    type: '기술면접',
    difficulty: '고급',
  ),
  InterviewQuestion(
    id: 'tech19',
    question: '이진 탐색의 동작 원리와 시간복잡도, 전제 조건을 설명해주세요.',
    type: '기술면접',
    difficulty: '초급',
  ),
  InterviewQuestion(
    id: 'tech20',
    question: 'BFS와 DFS의 차이점과 각각의 사용 사례를 설명해주세요.',
    type: '기술면접',
    difficulty: '중급',
  ),

  // 웹/소프트웨어 공학 관련
  InterviewQuestion(
    id: 'tech21',
    question: 'RESTful API 설계 원칙과 HTTP 메소드의 특징을 설명해주세요.',
    type: '기술면접',
    difficulty: '중급',
  ),
  InterviewQuestion(
    id: 'tech22',
    question: 'MVC 패턴에 대해 설명하고, 각 구성요소의 역할을 말해주세요.',
    type: '기술면접',
    difficulty: '초급',
  ),
  InterviewQuestion(
    id: 'tech23',
    question: '객체지향 프로그래밍의 4대 특징을 설명해주세요.',
    type: '기술면접',
    difficulty: '초급',
  ),
  InterviewQuestion(
    id: 'tech24',
    question: 'Git의 브랜치 전략과 merge와 rebase의 차이점을 설명해주세요.',
    type: '기술면접',
    difficulty: '중급',
  ),
  InterviewQuestion(
    id: 'tech25',
    question: '테스트 주도 개발(TDD)과 단위 테스트의 중요성을 설명해주세요.',
    type: '기술면접',
    difficulty: '중급',
  ),
];

final List<InterviewQuestion> personalityQuestions = [
  // 자기소개 및 동기
  InterviewQuestion(
    id: 'pers1',
    question: '간단한 자기소개를 해주세요.',
    type: '인성면접',
    difficulty: '초급',
  ),
  InterviewQuestion(
    id: 'pers2',
    question: '개발자가 되고 싶은 이유는 무엇인가요?',
    type: '인성면접',
    difficulty: '초급',
  ),
  InterviewQuestion(
    id: 'pers3',
    question: '우리 회사에 지원한 이유를 말씀해 주세요.',
    type: '인성면접',
    difficulty: '중급',
  ),

  // 장단점 및 성격
  InterviewQuestion(
    id: 'pers4',
    question: '본인의 장점과 단점을 말씀해 주세요.',
    type: '인성면접',
    difficulty: '초급',
  ),
  InterviewQuestion(
    id: 'pers5',
    question: '주변 사람들이 당신을 어떤 사람이라고 평가하나요?',
    type: '인성면접',
    difficulty: '중급',
  ),
  InterviewQuestion(
    id: 'pers6',
    question: '스트레스를 받을 때 어떻게 해결하시나요?',
    type: '인성면접',
    difficulty: '중급',
  ),

  // 팀워크 및 소통
  InterviewQuestion(
    id: 'pers7',
    question: '팀 프로젝트에서 갈등이 발생했을 때 어떻게 해결하셨나요?',
    type: '인성면접',
    difficulty: '중급',
  ),
  InterviewQuestion(
    id: 'pers8',
    question: '의견이 다른 동료와 어떻게 협업하시겠습니까?',
    type: '인성면접',
    difficulty: '중급',
  ),
  InterviewQuestion(
    id: 'pers9',
    question: '리더십을 발휘했던 경험이 있다면 말씀해 주세요.',
    type: '인성면접',
    difficulty: '고급',
  ),

  // 문제 해결 및 학습
  InterviewQuestion(
    id: 'pers10',
    question: '가장 어려웠던 문제를 어떻게 해결하셨나요?',
    type: '인성면접',
    difficulty: '고급',
  ),
  InterviewQuestion(
    id: 'pers11',
    question: '새로운 기술을 학습할 때 어떤 방법을 사용하시나요?',
    type: '인성면접',
    difficulty: '중급',
  ),
  InterviewQuestion(
    id: 'pers12',
    question: '실패했던 경험과 그로부터 배운 점을 말씀해 주세요.',
    type: '인성면접',
    difficulty: '고급',
  ),

  // 미래 계획 및 목표
  InterviewQuestion(
    id: 'pers13',
    question: '5년 후 본인의 모습은 어떨 것 같나요?',
    type: '인성면접',
    difficulty: '중급',
  ),
  InterviewQuestion(
    id: 'pers14',
    question: '개발자로서 어떤 분야에서 전문성을 키우고 싶으신가요?',
    type: '인성면접',
    difficulty: '중급',
  ),
  InterviewQuestion(
    id: 'pers15',
    question: '본인만의 차별화된 강점은 무엇인가요?',
    type: '인성면접',
    difficulty: '고급',
  ),

  // 가치관 및 태도
  InterviewQuestion(
    id: 'pers16',
    question: '일과 삶의 균형을 어떻게 유지하시나요?',
    type: '인성면접',
    difficulty: '중급',
  ),
  InterviewQuestion(
    id: 'pers17',
    question: '개발자로서 가장 중요하게 생각하는 가치는 무엇인가요?',
    type: '인성면접',
    difficulty: '중급',
  ),
  InterviewQuestion(
    id: 'pers18',
    question: '마감 기한이 촉박한 프로젝트를 어떻게 관리하시겠습니까?',
    type: '인성면접',
    difficulty: '고급',
  ),

  // 경험 및 성과
  InterviewQuestion(
    id: 'pers19',
    question: '가장 기억에 남는 프로젝트와 그 이유를 말씀해 주세요.',
    type: '인성면접',
    difficulty: '중급',
  ),
  InterviewQuestion(
    id: 'pers20',
    question: '코드 리뷰를 받을 때 기분이 어떠신가요?',
    type: '인성면접',
    difficulty: '중급',
  ),
  InterviewQuestion(
    id: 'pers21',
    question: '개발 과정에서 가장 보람을 느끼는 순간은 언제인가요?',
    type: '인성면접',
    difficulty: '중급',
  ),

  // 회사 및 업무 관련
  InterviewQuestion(
    id: 'pers22',
    question: '야근이나 주말 근무에 대해 어떻게 생각하시나요?',
    type: '인성면접',
    difficulty: '고급',
  ),
  InterviewQuestion(
    id: 'pers23',
    question: '신기술 도입 시 팀의 반대가 있다면 어떻게 설득하시겠습니까?',
    type: '인성면접',
    difficulty: '고급',
  ),
  InterviewQuestion(
    id: 'pers24',
    question: '회사에서 기대하는 역할과 본인의 목표가 다르다면 어떻게 하시겠습니까?',
    type: '인성면접',
    difficulty: '고급',
  ),
  InterviewQuestion(
    id: 'pers25',
    question: '마지막으로 저희에게 궁금한 점이나 하고 싶은 말씀이 있나요?',
    type: '인성면접',
    difficulty: '초급',
  ),
];