package com.ratego.www;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

/*******************************************************************************
 * [ExchangeRateDTO]
 * 설명 : 환율 API(한국수출입은행 등)의 JSON 응답을 담는 객체
 * 주의 : 필드 변수명은 API의 JSON Key값과 정확히 일치해야 매핑됨
 * (예: cur_unit, deal_bas_r 등 스네이크 표기법 유지 필수)
 *******************************************************************************/
@JsonIgnoreProperties(ignoreUnknown = true) // JSON에 있는데 여기 없는 필드는 쿨하게 무시
public class ExchangeRateDTO {

    /* =================================================================
     * 1. API 응답 데이터 필드 (JSON Key와 1:1 매핑)
     * ================================================================= */
    private String cur_unit;    // 통화코드 (예: USD, JPY(100))
    private String cur_nm;      // 국가/통화명 (예: 미국 달러)
    
    private String ttb;         // 송금 받을때 (전신환매입율)
    private String tts;         // 송금 보낼때 (전신환매도율)
    private String deal_bas_r;  // 매매 기준율 (가장 많이 쓰는 기준 환율)


    /*******************************************************************************
     * 2. [ACCESSOR METHODS] Getter & Setter
     * - Lombok 미사용 : 외부 라이브러리 의존성 없이 순수 자바 코드로 구현
     *******************************************************************************/

    // 통화코드 (Currency Unit)
    public String getCur_unit() {
        return cur_unit;
    }
    public void setCur_unit(String cur_unit) {
        this.cur_unit = cur_unit;
    }
    
    // 국가명 (Currency Name)
    public String getCur_nm() {
        return cur_nm;
    }
    public void setCur_nm(String cur_nm) {
        this.cur_nm = cur_nm;
    }
    
    // 송금 받을 때 (Telegraphic Transfer Buying rate)
    public String getTtb() {
        return ttb;
    }
    public void setTtb(String ttb) {
        this.ttb = ttb;
    }
    
    // 송금 보낼 때 (Telegraphic Transfer Selling rate)
    public String getTts() {
        return tts;
    }
    public void setTts(String tts) {
        this.tts = tts;
    }
    
    // 매매 기준율 (Deal Basic Rate)
    public String getDeal_bas_r() {
        return deal_bas_r;
    }
    public void setDeal_bas_r(String deal_bas_r) {
        this.deal_bas_r = deal_bas_r;
    }
}