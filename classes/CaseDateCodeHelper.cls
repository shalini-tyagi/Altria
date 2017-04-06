public class CaseDateCodeHelper {

   
    String ln_lastdigit_year;
    String lv_cur_year;
    String lv_year='/200';
    String lv_year_new='/200';
    String second_number;
    String first_number;
    Integer ln_days=0;
    String lv_date;
    Integer lv_jday;
    Integer lv_jyear;
    String  lv_jdate;
    
    Set<String> charSet=new Set<String>();
    Set<String> charSet1=new Set<String>();    
    
    
    public class CaseDateCode{
        public String pdate; 
        public String pshift; 
        public String plocation; 
        public String ptime; 
        public String pvalid; 
        public String msg;  
    }
    
    public CaseDateCodeHelper.CaseDateCode GetCaseDateCodeFields(String dateCode, String dateCodeIdentifier, String opCompany){        
       
        CaseDateCodeHelper.CaseDateCode CasedateCode = new CaseDateCodeHelper.CaseDateCode(); 
        
        
        lv_cur_year  =  String.ValueOf(System.Today().year());
        ln_lastdigit_year  =  String.valueOf(lv_cur_year.substring(3,4));        
        
            try{        
                if(dateCodeIdentifier == 'J'){ 
            
                    CasedateCode.msg = '';
                    CasedateCode.pvalid = 'N';
                
                    if(dateCode.length()!= 7 && dateCode.length()!= 5 ){
                        
                        CasedateCode.msg  = 'JFAIL'; 
                    }
                
                    if(dateCode.length() == 7){
                        
                        if((dateCode.substring( 0, 3)).isNumeric() == False || (dateCode.substring( 3, 7)).isNumeric() == False){
                            
                            CasedateCode.msg ='JFAIL';    
                        }else{
                            
                            lv_jday = Integer.valueOf(dateCode.substring( 0, 3));
                            lv_jyear = Integer.valueOf(dateCode.substring( 3, 7));
                        }
                        
                        if( (lv_jday >= 1 && lv_jday <= 366) && lv_jyear <= Integer.valueOf(lv_cur_year) && CasedateCode.msg != 'JFAIL'){
                            
                            Date lvdate=Date.parse(String.valueOf(lv_jday)).addDays(-1);    
                            lv_jdate=String.valueOf(lvdate).subString(0,5)+'/'+string.valueOf(lv_jyear);
            
                            
                            if(lv_jdate != null){
                                
                                ln_days = date.parse(lv_jdate).daysBetween(System.today());
                                
                                if(ln_days > 0) {
                                    CasedateCode.msg  = 'SUCCESS';
                                    CasedateCode.pvalid = 'Y';
                                    CasedateCode.pdate = lv_jdate;
                                }else{
                                    CasedateCode.msg  = 'JFAIL'; 
                                }
                            }else{
                                CasedateCode.msg  = 'JFAIL';
                            }
                        }else{
                            CasedateCode.msg = 'JFAIL';
                        }
                    }
                    
                    if(dateCode.length() == 5){
                        
                        if(((dateCode.substring( 0, 3)).isNumeric() == False) || (dateCode.substring( 3, 4) != 'X' && dateCode.substring( 3, 4) !='Y' && dateCode.substring( 3, 4) !='Z')
                           || (dateCode.substring( 4, 5) !='1' && dateCode.substring( 4, 5) !='2' && dateCode.substring( 4, 5) !='3' && dateCode.substring( 5, 1) !='4' && dateCode.substring( 4, 5) !='M'))
                        {
                            CasedateCode.msg ='JFAIL'; 
                        }
                        else{
                            lv_jday = Integer.valueOf(dateCode.substring( 0, 3));
                            
                        }
                        
                        
                        IF ( (lv_jday >= 1 && lv_jday <= 366) && (CasedateCode.msg==null && CasedateCode.msg!='JFAIL')){
                            
                            CasedateCode.msg  = 'SUCCESS'; 
                            CasedateCode.pvalid ='Y';
                            CasedateCode.pdate = String.valueOf(lv_jday);
                            CasedateCode.pshift = dateCode.substring( 3, 4);
                            
                            if(dateCode.substring(4, 5) == '1'){
                                CasedateCode.plocation = 'Caseloader1';
                            }
                            else if(dateCode.substring(4, 5) =='2'){
                                CasedateCode.plocation = 'Caseloader2';
                            }
                            else if(dateCode.substring(4, 5) =='3'){
                                CasedateCode.plocation = 'Caseloader3';
                            }
                            else if(dateCode.substring(4, 5) =='4'){
                                CasedateCode.plocation = 'Caseloader4';
                            }
                            else if(dateCode.substring(4, 5) =='M'){
                                CasedateCode.plocation = 'Manual Caseloading';
                            }
                            
                        }
                        ELSE
                        { 
                            CasedateCode.msg  = 'JFAIL'; 
                        }
                        
                    }
       
                    if(CasedateCode.msg  == 'JFAIL' ){
                        CasedateCode.msg = 'Invalid date code. Please enter a valid value';
                    }
                }
       
                IF(dateCodeIdentifier == 'S'){ 
                     
                        CasedateCode.msg = '';
                        CasedateCode.pvalid = 'N';
                        if((dateCode.substring( 1, 6).toUpperCase()).isNumeric() == False){
                            CasedateCode.msg  = 'Invalid sticker info. Please enter a valid value';
                        }
                        
                        charSet.clear();
                        charSet.add('A');charSet.add('B');charSet.add('C');
                        if( dateCode.length() != 6 ||(!charSet.contains(dateCode.toUpperCase().subString(0,1)))|| CasedateCode.msg != '') 
                        { 
                            CasedateCode.msg  = 'Invalid sticker info. Please enter a valid value'; 
                        }
                        else
                        { 
                            CasedateCode.pshift  = dateCode.substring( 0, 1).toUpperCase();
                            //--SELECT @CasedateCode.pshift  = SUBSTRING(UPPER(@dateCode), 5, 1)
            
                            CasedateCode.msg  = 'SUCCESS'; 
                            CasedateCode.pvalid = 'Y';
                         }
           
                 }
       
                IF(dateCodeIdentifier == 'P'){ 
                    
                         CasedateCode.msg = '';
                         CasedateCode.pvalid = 'N';     
        
                
                    if(( opCompany.toUpperCase() == 'PMUSA' || opCompany.toUpperCase() == 'UP' ) ){ 
                    
                         CasedateCode.msg = '';
                         CasedateCode.pvalid = 'N';
                         
                         IF((dateCode.substring( 5, 6)).isNumeric() == False || (dateCode.substring( 1, 4)).isNumeric() == False )
                         {
                            CasedateCode.msg  = 'Invalid promo date code. Please enter a valid value'; 
                         }
                        
                        if(CasedateCode.msg == '' && !(Integer.valueOf(dateCode.substring( 1, 4)) >= 1 && Integer.valueOf(dateCode.substring( 1, 4)) <= 366) )
                        {
                                CasedateCode.msg  = 'Invalid promo date code. Please enter a valid value'; 
                        }
                        
                        charSet.clear();
                        charSet1.clear();
                        charSet.add('P');charSet.add('W');
                        charSet1.add('X');charSet1.add('Y');charSet1.add('Z');
                        IF (CasedateCode.msg != '' || !(charSet.contains(dateCode.substring( 0, 1).toUpperCase())) || !(charSet1.contains(dateCode.substring( 4, 5).toUpperCase())) || !(dateCode.length() == 6 && dateCode.length() == 10 ) )
                        { 
                            CasedateCode.msg  = 'Invalid promo date code. Please enter a valid value'; 
                        }
                        ELSE
                        {
                         
                            IF (dateCode.length() == 6) 
                            { 
                                second_number  = dateCode.substring( 5, 6);
                                first_number  = dateCode.substring( 1, 4);
                                CasedateCode.msg  = 'SUCCESS'; 
                                CasedateCode.pvalid = 'Y';
                                CasedateCode.plocation  = dateCode.substring( 0, 1).toUpperCase();
                                CasedateCode.pshift  = dateCode.substring( 4, 5).toUpperCase();
                                
                                IF(Integer.valueOf(second_number) == Integer.valueOf(ln_lastdigit_year))
                                { 
                                    lv_year  = '01/01' + lv_year_new.substring( 0, 4) + second_number.substring( 0, 1);
                                }
                                ELSE
                                {   
                                   if(Integer.valueOf(lv_cur_year) >= Integer.valueOf(201 + second_number.substring( 0, 1)))
                                    { 
                                        lv_year  = '01/01' + lv_year_new.substring( 0, 4) + second_number.substring( 0, 1);
                                    }
                                    ELSE
                                    {
                                        lv_year  = '01/01' + lv_year.substring( 0, 4) + second_number.substring( 0, 1);
                                    }
           
                                }
                                
                                lv_date  =  String.valueOf(Integer.valueOf(lv_year) + (Integer.valueOf(first_number) - 1));
                                
                                ln_days  =  date.parse(lv_date).daysBetween(System.today());
                                    
                                
                                IF(ln_days <= 0 )
                                { 
                                        CasedateCode.msg  = 'Invalid promo date code. Please enter a valid value';
                                }
                                ELSE
                                {
                                    CasedateCode.msg  = 'SUCCESS'; 
                                    CasedateCode.pvalid = 'Y';
                                    CasedateCode.pdate  = lv_date;
                                }
                            }
                            else
                            {       
                                CasedateCode.msg = '';
                                CasedateCode.pvalid = 'N';
                                
                                if((dateCode.substring( 5, 6)).isNumeric() == False || (dateCode.substring( 6, 10)).isNumeric() == False){
                                
                                        CasedateCode.msg  = 'Invalid promo date code. Please enter a valid value'; 
                                }
                                
                                if((CasedateCode.msg == '' && !(Integer.valueOf(dateCode.substring( 6, 8)) >= 0 && Integer.valueOf(dateCode.substring( 6, 8)) <= 23)) 
                                || (Integer.valueOf(dateCode.substring( 8, 10)) >= 0 && Integer.valueOf(dateCode.substring( 8, 10)) <= 59 )){
                                
                                    CasedateCode.msg  = 'Invalid promo date code. Please enter a valid value'; 
                                }
                                
                                if (CasedateCode.msg != ''){
                                
                                    CasedateCode.msg  = 'Invalid promo date code. Please enter a valid value'; 
                                    
                                }else{ 
                                
                                    second_number  = dateCode.substring( 5, 6);
                                    first_number  = dateCode.substring( 1, 4);
                                    CasedateCode.msg  = 'SUCCESS'; 
                                    CasedateCode.pvalid = 'Y';
                                    CasedateCode.plocation  = dateCode.substring( 0, 1).toUpperCase();
                                    CasedateCode.pshift  = dateCode.substring( 4, 5).toUpperCase();
                                    CasedateCode.ptime  = dateCode.substring( 6, 10);
                                    
                                    if(Integer.valueOf(second_number) == Integer.valueOf(ln_lastdigit_year)){
                                    
                                        lv_year  = '01/01' + lv_year_new.substring( 0, 4) + second_number.substring( 0, 1);
                                    }else{
                                     
                                        if(Integer.valueOf(lv_cur_year) >= Integer.valueOf(201 + second_number.substring( 0, 1))){
                                        
                                            lv_year  = '01/01' + lv_year_new.substring( 0, 4) + second_number.substring( 0, 1);
                                        }else{
                                         
                                            lv_year  = '01/01' + lv_year.substring( 0, 4) + second_number.substring( 0, 1);
                                        }           
                                    }
                                    
                                    lv_date  =  String.valueOf(Integer.valueOf(lv_year) + (Integer.valueOf(first_number) - 1));
                                    
                                    ln_days  =  date.parse(lv_date).daysBetween(System.today());
                                    
                                    if (ln_days <= 0){
                                        CasedateCode.msg  = 'Invalid promo date code. Please enter a valid value'; 
                                    }else{
                                        CasedateCode.msg  = 'SUCCESS'; 
                                        CasedateCode.pvalid = 'Y';
                                        CasedateCode.pdate  = lv_date;
                                    }
                             }
                        }
                        
                    
                    if(opCompany.toUpperCase() == 'JM' || opCompany.toUpperCase() == 'JMC' ) { 
                    
                        CasedateCode.msg = '';
                        CasedateCode.pvalid = 'N';
                        if ((dateCode.substring( 0, 3)).isNumeric() == False || (dateCode.substring( 5, 4)).isNumeric() == False ){ 
                            CasedateCode.msg  = 'Invalid promo date code. Please enter a valid value'; 
                        }
                                
                        if (CasedateCode.msg == '' 
                            && !(Integer.valueOf(dateCode.substring( 0, 3)) >= 1 && Integer.valueOf(dateCode.substring( 0, 3)) <= 366) 
                            || Integer.valueOf(dateCode.substring( 4, 8)) > Integer.valueOf(lv_cur_year)
                            || dateCode.length() != 8
                            || dateCode.indexOf('/') != 3){
                            
                            CasedateCode.msg  = 'Invalid promo date code. Please enter a valid value'; 
                        }
                        
                        if ( CasedateCode.msg != ''){
                            CasedateCode.msg  = 'Invalid promo date code. Please enter a valid value'; 
                        }else{ 
                           
                            lv_jday = Integer.valueOf(dateCode.substring( 0, 3));
                            lv_jyear = Integer.valueOf(dateCode.substring( 4, 8));
                                
                            Date lvdate=Date.parse(String.valueOf(lv_jday)).addDays(-1);    
                            lv_jdate=String.valueOf(lvdate).subString(0,5)+'/'+string.valueOf(lv_jyear);
        
                            if(lv_jdate != null){ 
                                CasedateCode.msg  = 'SUCCESS'; 
                                CasedateCode.pvalid = 'Y';
                                CasedateCode.pdate = lv_jdate;
                            }else{ 
                                CasedateCode.msg  = 'Invalid date code. Please enter a valid value'; 
                            }
                         }
                      }
                   }     
                }            
            }
        }catch(Exception e){
           
        } 
        return CasedateCode;
    }

}