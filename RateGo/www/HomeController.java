package com.ratego.www;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.security.SecureRandom;
import java.security.cert.X509Certificate;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Locale;

import javax.net.ssl.HostnameVerifier;
import javax.net.ssl.HttpsURLConnection;
import javax.net.ssl.SSLContext;
import javax.net.ssl.SSLSession;
import javax.net.ssl.TrustManager;
import javax.net.ssl.X509TrustManager;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

/*******************************************************************************
 * [HomeController]
 * 설명 : 메인 화면('/') 접속 시 환율 정보를 가져오는 컨트롤러
 * 핵심 기능 : 한국수출입은행 Open API 연동 및 JSON 파싱
 * 특이사항 : 공공기관 서버의 보안 문제(SNI/SSL)를 우회하는 코드가 포함됨
 * 프로젝트 : RateGo Project
 *******************************************************************************/
@Controller
public class HomeController {
	
	private static final Logger logger = LoggerFactory.getLogger(HomeController.class);
	
	// API 인증키 (한국수출입은행 발급)
	private static final String AUTH_KEY = "GzIRr4qdFUaPuwDT3SmlpZD6tjRLnaD1"; 

	/*******************************************************************************
     * 1. [MAIN REQUEST] 메인 페이지 진입
     * - URL : / (GET)
     * - Logic : API 호출 -> JSON 파싱 -> 모델 적재 -> View 이동
     *******************************************************************************/
	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String home(Locale locale, Model model) {
		
		// ---------------------------------------------------------------------
		// Step 1. [환경 설정] 공공기관 서버 튕김 방지 (SSL/TLS 이슈 해결)
		// ---------------------------------------------------------------------
		System.setProperty("jsse.enableSNIExtension", "false"); // SNI 비활성화
		System.setProperty("https.protocols", "TLSv1.2");       // 프로토콜 강제 지정
		
		// 인증서 검증 무시 메서드 호출 (이게 없으면 SSLHandshakeException 발생 가능)
		disableSslVerification();

		// ---------------------------------------------------------------------
		// Step 2. https://context.reverso.net/translation/korean-english/%EC%83%9D%EC%84%B1 오늘 날짜 기준으로 API 요청 주소 만들기
		// ---------------------------------------------------------------------
		Date date = new Date();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
		String today = sdf.format(date);
		
		// data=AP01 : 환율 데이터 요청 코드
		String apiURL = "https://www.koreaexim.go.kr/site/program/financial/exchangeJSON?authkey=" 
						+ AUTH_KEY + "&searchdate=" + today + "&data=AP01";
		
		List<ExchangeRateDTO> rateList = new ArrayList<ExchangeRateDTO>();

		try {
			// ---------------------------------------------------------------------
			// Step 3. [API 통신] HttpURLConnection을 이용한 GET 요청
			// ---------------------------------------------------------------------
			URL url = new URL(apiURL);
			HttpURLConnection conn = (HttpURLConnection) url.openConnection();
			conn.setRequestMethod("GET");
			
			// User-Agent 위장 (사람인 척 브라우저 정보 전송)
			conn.setRequestProperty("User-Agent", "Mozilla/5.0");
			conn.setConnectTimeout(10000); // 10초 타임아웃
			conn.setReadTimeout(10000);
			
			int responseCode = conn.getResponseCode();
			
			if(responseCode == 200) {
				// ---------------------------------------------------------------------
				// Step 4. [데이터 수신] 스트림을 통해 응답 문자열 읽기
				// ---------------------------------------------------------------------
				BufferedReader rd = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
				StringBuilder sb = new StringBuilder();
				String line;
				while ((line = rd.readLine()) != null) {
					sb.append(line);
				}
				rd.close();
				conn.disconnect();
				
				String jsonResult = sb.toString();
				
				// ---------------------------------------------------------------------
				// Step 5. [JSON 파싱] Jackson 라이브러리로 문자열 -> 객체 리스트 변환
				// ---------------------------------------------------------------------
				if(jsonResult != null && !jsonResult.equals("[]")) {
					ObjectMapper mapper = new ObjectMapper();
					// JSON Array String -> List<ExchangeRateDTO> 변환
					rateList = mapper.readValue(jsonResult, new TypeReference<List<ExchangeRateDTO>>(){});
					logger.info("API 연동 성공: 데이터 " + rateList.size() + "개 수신");
				} else {
					logger.info("API 연결은 됐으나 데이터가 비어있음 (영업시간 아님/주말)");
				}
			} else {
				logger.error("API 응답 코드 에러: " + responseCode);
			}
			
		} catch (Exception e) {
			logger.error("API 접속 중 에러 발생: " + e.getMessage());
			e.printStackTrace();
		}

		// ---------------------------------------------------------------------
		// Step 6. [비상 대책] 데이터 수신 실패 시 더미 데이터 투입
		// ---------------------------------------------------------------------
		if(rateList.isEmpty()) {
			rateList = getDummyData();
			logger.info("비상용 데이터(Dummy) 출력");
		}

		model.addAttribute("rateList", rateList);
		return "home";
	}


	/*******************************************************************************
     * 2. [FALLBACK DATA] 비상용 더미 데이터
     * - API 서버가 터졌거나 주말이라 데이터가 없을 때 화면 깨짐 방지용
     *******************************************************************************/
	private List<ExchangeRateDTO> getDummyData() {
		List<ExchangeRateDTO> list = new ArrayList<ExchangeRateDTO>();
		
		ExchangeRateDTO usd = new ExchangeRateDTO(); 
		usd.setCur_unit("USD"); usd.setCur_nm("미국 달러"); 
		usd.setDeal_bas_r("1,395.50"); usd.setTts("1,409.00"); 
		list.add(usd);
		
		ExchangeRateDTO jpy = new ExchangeRateDTO(); 
		jpy.setCur_unit("JPY(100)"); jpy.setCur_nm("일본 엔"); 
		jpy.setDeal_bas_r("912.40"); jpy.setTts("921.50"); 
		list.add(jpy);
		
		ExchangeRateDTO eur = new ExchangeRateDTO(); 
		eur.setCur_unit("EUR"); eur.setCur_nm("유로"); 
		eur.setDeal_bas_r("1,480.10"); eur.setTts("1,495.20"); 
		list.add(eur);
		
		ExchangeRateDTO cnh = new ExchangeRateDTO(); 
		cnh.setCur_unit("CNH"); cnh.setCur_nm("위안화"); 
		cnh.setDeal_bas_r("192.30"); cnh.setTts("194.50"); 
		list.add(cnh);
		
		return list;
	}


	/*******************************************************************************
     * 3. [SECURITY BYPASS] SSL 인증서 검증 무시
     * - 주의 : 개발/테스트 목적이나 공공기관 API 호환성을 위해 사용 (보안 취약점 주의)
     *******************************************************************************/
	public static void disableSslVerification() {
		try {
			// 신뢰할 수 있는 인증서를 묻지 않고 무조건 통과시키는 TrustManager 생성
			TrustManager[] trustAllCerts = new TrustManager[] { new X509TrustManager() {
				public java.security.cert.X509Certificate[] getAcceptedIssuers() { return null; }
				public void checkClientTrusted(X509Certificate[] certs, String authType) { }
				public void checkServerTrusted(X509Certificate[] certs, String authType) { }
			} };
			
			// SSL 컨텍스트 초기화
			SSLContext sc = SSLContext.getInstance("SSL");
			sc.init(null, trustAllCerts, new SecureRandom());
			HttpsURLConnection.setDefaultSSLSocketFactory(sc.getSocketFactory());
			
			// 호스트 이름 검증 무시 (localhost 등)
			HostnameVerifier allHostsValid = new HostnameVerifier() {
				@Override
				public boolean verify(String hostname, SSLSession session) { return true; }
			};
			HttpsURLConnection.setDefaultHostnameVerifier(allHostsValid);
			
		} catch (Exception e) { e.printStackTrace(); }
	}
}