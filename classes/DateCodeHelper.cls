public class DateCodeHelper
{
    public class DateCode
    {
        public string ProductionDate;
        public string DateCodeLocation;
        public string DateCodeShift;
        public string DateCodeUnit;
        public string DateCodeColdStorage;
        public string DateCodeRptBay;
        public string DateCodeRptFactory;
        public string DateCodeMilitaryTime;
        public string UstDateCode;
    }
    public string first_char;
    public string second_char;
    public string third_char;
    public string first_number;
    public string second_number;
    public string third_number;
    public string fourth_number;
    public string lv_year = '/200';
    public string lv_year1 = '/20';
    public string lv_year2;
    public string lv_day;
    public string lv_month;
    public Integer ln_cnt = 0;
    public string production_date = '';
    public string lv_location = '';
    public string lv_shift = '';
    public string lv_unit = '';
    public string lv_error_msg = '';
    public string lv_temp_year = null;
    public string lv_date_code_cold_storage = '';
    public string lv_date_code_rpt_bay = '';
    public string lv_date_code_rpt_factory = '';
    public string lv_military_time = '';
    public string lv_ust_date_code = '';
    public Integer ln_days = 0;
    public string ln_leap = '0';
    public string lv_leap_year = '20';
    public Integer ln_lastdigit_year;
    public string lv_year_new = '/201';
    public string lv_cur_year = '';
    public Integer Retcode = 0;
    public string RetDesc = 'SUCCESS';
    public string DebugMsg;
    public Integer CHECK = 0;
    public string Check2 = '';
    public string year_leep = '';
    public string lv_year_new1 = '20';
    public Integer ln_lasttwodigit_year;
    public string traceCode;
    public string ProductLineCode;
    public string ustDateType;
    public string ustDateCode;
    public string oprCompany;
    public string PrintVariable;
    Set<string> charSet = new  Set<string>();
    Set<Integer> intSet = new  Set<Integer>();
    public DateCodeHelper.DateCode DateCodeObj;
    public DateCodeHelper()
    {
        DateCodeObj = new  DateCodeHelper.DateCode();
    }
    public DateCodeHelper.DateCode DateCodeFields(string ProductLineCodeObj, string traceCodeObj, string oprCompanyObj, string TraceCodeLocation, string ustDateTypeObj, string ustDateCodeObj)
    {
        ProductLineCode = ProductLineCodeObj.toUpperCase();
        traceCode = traceCodeObj.toUpperCase();
        oprCompany = oprCompanyObj.toUpperCase();
        ustDateType = ustDateTypeObj;
        ustDateCode = ustDateCodeObj;
        
        try
        {
            if(traceCode != null)
            {
                if(ProductLineCode == 'AS' && traceCode.length() != 9 && traceCode.length() != 11)
                {
                    production_date = 'FAIL';
                }
                else if((ProductLineCode == 'SP' || ProductLineCode == 'DS' || ProductLineCode == 'PC' || ProductLineCode == 'TP' || ProductLineCode == 'UU') && traceCode.length() != 9)
                {
                    production_date = 'FAIL';
                }
                else if(ProductLineCode == 'GP' && traceCode.length() != 5 && traceCode.length() != 7 && traceCode.length() != 11)
                {
                    production_date = 'FAIL';
                }
                else if(ProductLineCode == 'PT' && traceCode.length() != 5 && traceCode.length() != 4 && traceCode.length() != 2 && traceCode.length() != 7)
                {
                    production_date = 'FAIL';
                }
                else if((ProductLineCode == 'MD' || ProductLineCode == 'GFU' || ProductLineCode == 'SB') && traceCode.length() != 9)
                {
                    production_date = 'FAIL';
                }
                else if(ProductLineCode == 'CD' && traceCode.length() != 4)
                {
                    production_date = 'FAIL';
                }
                else if(ProductLineCode == 'SN' && traceCode.length() != 5)
                {
                    production_date = 'FAIL';
                }
                else if(ProductLineCode == 'WB' && traceCode.length() != 6)
                {
                    production_date = 'FAIL';
                }
                else if(ProductLineCode == 'EC' && traceCode.length() != 8 && traceCode.length() != 7)
                {
                    production_date = 'FAIL';
                }
                if(ProductLineCode == 'EV' && (traceCode.indexOf('o') > 0 || traceCode.indexOf('') > 0 || traceCode.length() > 3))
                {
                    production_date = 'FAIL';
                }
                else if(ProductLineCode == 'EV' && (traceCode.indexOf('o') == 0 || traceCode.indexOf('') == 0 || traceCode.length() == 3))
                {
                    production_date = '';
                }
                lv_cur_year = string.ValueOf(System.Today().year());
                ln_lastdigit_year = Integer.valueOf(lv_cur_year.substring(3, 4));
                if(oprCompany == '' && oprCompany == null)
                {
                    oprCompany = 'ZZ';
                }
                else
                {
                    oprCompany = oprCompany.trim().toUpperCase();
                }
                
                if(oprCompany.toUpperCase() != 'USST')
                {
                    //--For Cigarettes            
                    if(ProductLineCode == 'AS')
                    {
                        system.debug('test ' + ProductLineCode);
                        first_char = traceCode.substring(0, 1);
                        first_number = traceCode.substring(1, 4);
                        second_char = traceCode.substring(4, 5);
                        second_number = traceCode.substring(5, 6);
                        third_char = traceCode.substring(6, 9);
                        if(traceCode.length() > 9)
                        {
                            fourth_number = traceCode.substring(9, 11);
                        }
                        if(first_number.isNumeric() || second_number.isNumeric() || (fourth_number != null && (fourth_number.trim().length() > 0 && (!fourth_number.isNumeric() || Integer.ValueOf(fourth_number) < 0 || Integer.ValueOf(fourth_number) > 23))))
                        {
                            List<CigaretteModule__c> cig = new  List<CigaretteModule__c>([SELECT
                                id
                            FROM
                                CigaretteModule__c
                            WHERE
                                Cigarette_Code__c = : third_char.toUpperCase() AND ProductLineCode__c = : ProductLineCode AND Active__c = true]);
                            if((first_char == 'V' || first_char == 'N' || first_char == 'C' || first_char == 'R' || first_char == 'W' || first_char == 'P') && (second_char == 'A' || second_char == 'B' || second_char == 'C' || second_char == 'D' || second_char == 'E' || second_char == 'F' || second_char == 'G' || second_char == 'H' || second_char == 'I' || second_char == 'J' || second_char == 'K' || second_char == 'L' || second_char == 'M' || second_char == 'N' || second_char == 'O' || second_char == 'P' || second_char == 'Q' || second_char == 'R' || second_char == 'S' || second_char == 'T' || second_char == 'U' || second_char == 'V' || second_char == 'W' || second_char == 'X' || second_char == 'Y' || second_char == 'Z') && (Integer.ValueOf(first_number) >= 1 && Integer.ValueOf(first_number) <= 366) && (Integer.ValueOf(second_number) >= 0 && Integer.ValueOf(second_number) <= 9))
                            {
                                system.debug('-----------testdate---');
                                if(Integer.ValueOf(second_number) == Integer.ValueOf(ln_lastdigit_year))
                                {
                                    lv_year = '01/01' + lv_year_new.subString(0, 4) + second_number.subString(0, 1);
                                }
                                else
                                {
                                    if(Integer.ValueOf(lv_cur_year) >= Integer.ValueOf('201' + second_number.subString(0, 1)))
                                    {
                                        lv_year = '01/01' + lv_year_new.subString(0, 4) + second_number.subString(0, 1);
                                    }
                                    else
                                    {
                                        lv_year = '01/01' + lv_year.subString(0, 4) + second_number.subString(0, 1);
                                    }
                                }
                                production_date = date.parse(lv_year).addDays(Integer.ValueOf(first_number) - 1).format();
                                System.debug('-----production_date-------' + production_date);
                                ln_days = date.parse(production_date).daysBetween(System.today());
                                if(ln_days <= 0)
                                {
                                    production_date = 'FAIL';
                                }
                                if(first_Char == 'V')
                                {
                                    lv_location = 'Virginia';
                                }
                                else if(first_Char == 'N')
                                {
                                    lv_location = 'North Carolina';
                                }
                                else if(first_Char == 'C')
                                {
                                    lv_location = 'Cold Storage';
                                }
                                else if(first_Char == 'R')
                                {
                                    lv_location = 'Cold Storage';
                                }
                                else if(first_Char == 'P')
                                {
                                    lv_location = 'PreCon Dry Dated';
                                }
                                else if(first_Char == 'W')
                                {
                                    lv_location = 'PreCon Cold Dated';
                                }
                                else
                                {
                                }
                                lv_shift = second_char;
                                lv_unit = third_char;
                                if(first_char == 'C' || first_char == 'R' || first_char == 'W')
                                {
                                    lv_date_code_cold_storage = 'Y';
                                }
                                else
                                {
                                    lv_date_code_cold_storage = 'N';
                                }
                                if(first_char == 'V' || first_char == 'R')
                                {
                                    lv_date_code_rpt_bay = traceCode.toUpperCase().substring(6, 7);
                                }
                                else if(first_char == 'C' || first_char == 'N')
                                {
                                    lv_date_code_rpt_bay = traceCode.toUpperCase().substring(7, 8);
                                }
                                if(first_char == 'V' || first_char == 'R')
                                {
                                    lv_date_code_rpt_factory = 'MC';
                                }
                                else if(first_char == 'C' || first_char == 'N')
                                {
                                    lv_date_code_rpt_factory = 'CA';
                                }
                                lv_military_time = fourth_number;
                            }
                            else
                            {
                                production_date = 'FAIL';
                            }
                        }
                        else
                        {
                            production_date = 'FAIL';
                        }
                    }
                    //---- For MST
           /*         else if(ProductLineCode == 'SP')
                    {
                        first_char = traceCode.substring(0, 1);
                        first_number = traceCode.substring(1, 4);
                        second_char = traceCode.substring(4, 5);
                        second_number = traceCode.substring(5, 6);
                        third_char = traceCode.substring(6, 9);
                        System.debug('-------first_char-------' + first_char);
                        System.debug('-------first_number-------' + first_number);
                        System.debug('-------second_char-------' + second_char);
                        System.debug('-------second_number-------' + second_number);
                        System.debug('-------third_char-------' + third_char);
                        if(first_number.isNumeric() && second_number.isNumeric())
                        {
                            if((first_char == 'V') && (second_char == 'X' || second_char == 'Y' || second_char == 'Z') && (Integer.valueof(first_number) >= 1 && Integer.valueof(first_number) <= 366) && (Integer.valueof(second_number) >= 0 && Integer.valueof(second_number) <= 9) && (third_char == 'LPF'))
                            {
                                Datetime dt = system.now();
                                Integer tmpyer = dt.year() - Integer.valueof('201') + Integer.valueof(second_number);
                                if(tmpyer == -1)
                                {
                                    lv_temp_year = Integer.valueof('0') + second_number;
                                }
                                else
                                {
                                    lv_temp_year = Integer.valueof('1') + second_number;
                                }
                                lv_year = '01/01' + lv_year1 + lv_temp_year;
                                production_date = string.valueOf(date.parse(lv_year).addDays(Integer.ValueOf(first_number) - 1));
                                system.debug('---------production_date-------' + production_date);
                                ln_days = date.parse(production_date).daysBetween(System.today());
                                if(ln_days <= 0)
                                {
                                    production_date = 'FAIL';
                                }
                                if(first_Char == 'V')
                                {
                                    lv_location = 'Virginia';
                                }
                                else if(first_Char == 'N')
                                {
                                    lv_location = 'North Carolina';
                                }
                                else if(first_Char == 'C')
                                {
                                    lv_location = 'Cold Storage';
                                }
                                else if(first_Char == 'R')
                                {
                                    lv_location = 'Cold Storage';
                                }
                                lv_shift = second_char;
                                lv_unit = third_char;
                            }
                            else
                            {
                                production_date = 'FAIL';
                            }
                        }
                        else
                        {
                            production_date = 'FAIL';
                        }
                    }  */
                    
                    else if(productLineCode == 'SP'){
                        first_char  =  traceCode.subString( 0, 3);
                        first_number  =  traceCode.subString( 3, 4);
                        second_number  =  traceCode.subString( 4, 8);
                        third_number  =  traceCode.subString( 8, 9);
                        
                        
                        if(!first_char.isAlpha() || !first_number.isNumeric() || !second_number.isNumeric()){
                            production_date= 'FAIL';                          
                        }                       
                        charSet.clear();
                        charSet.add('N');charSet.add('S');charSet.add('H');charSet.add('V');charSet.add('I');charSet.add('L');charSet.add('E');
                        charSet.add('Q');charSet.add('C');charSet.add('D');
                        if(!charSet.Contains(first_char.subString( 0, 1)) || !charSet.Contains(first_char.subString( 1, 2)) || !charSet.Contains(first_char.subString( 2, 3))){ 
                            
                            charSet.clear();
                            charset.add('N');charset.add('S');charset.add('H');charset.add('V');charset.add('I');charset.add('L');charset.add('E');charset.add('Q');charset.add('C');charset.add('D');
                            if(charSet.contains(first_char.substring(0, 1))){
                                
                                lv_location = 'Nashville';
                                lv_date_code_rpt_factory = 'NS';
                            }
                            
                            charSet.clear();
                            charSet.add('F');charSet.add('R');charSet.add('P');charSet.add('K');charSet.add('G');charSet.add('Y');charSet.add('M');charSet.add('B');charSet.add('O');charSet.add('W');
                                if(charSet.contains(first_char.substring(0, 1))){
                                    
                                    lv_location = 'Franklin Park';
                                    lv_date_code_rpt_factory = 'FP';
                                }
                            
                            charSet.clear();
                            charSet.add('F');charSet.add('R');charSet.add('P');charSet.add('K');charSet.add('G');charSet.add('Y');charSet.add('M');
                            charSet.add('B');charSet.add('O');charSet.add('W');
                            
                            if(!charSet.Contains(first_char.subString( 0, 1)) || !charSet.Contains(first_char.subString( 1, 2)) || !charSet.Contains(first_char.subString( 2, 3))){ 
                                production_date= 'FAIL';
                            }else{
                                
                                lv_month = first_char.replace('F','0').replace('R','1').replace('P','2').replace('K','3').replace('G','4').replace('Y','5').replace('M','6').replace('B','7').replace('O','8').replace('W','9');
                            }
                            
                        }else{                          
                            lv_month = first_char.replace('N','0').replace('S','1').replace('H','2').replace('V','3').replace('I','4').replace('L','5').replace('E','6').replace('Q','7').replace('C','8').replace('D','9');
                        }
                        
                        if(!lv_month.isNumeric()){
                            production_date= 'FAIL';
                        }
                        
                        
                        if(Integer.valueOf(lv_month)>= 1 && Integer.valueOf(lv_month) <=366 ){
                            lv_temp_year = '';
                            if(Integer.valueOf(first_number) >= 0 && Integer.valueOf( first_number) <= 9){
                                
                                if((System.today().year() - Integer.valueOf( '201' + String.valueOf(first_number))) <0){                        
                                    lv_temp_year  = String.valueOf(lv_year.subString(3, 4)) + String.valueOf(first_number);
                                }else{
                                    lv_temp_year  = String.valueOf(lv_cur_year.subString(2, 3)) + String.ValueOf(first_number);
                                }
                                
                                lv_year  = '01/01' + lv_year1 + lv_temp_year;
                                
                                
                                production_date  =  date.parse(lv_year).addDays(Integer.valueOf(lv_month) - 1).format();
                                System.debug('----production_date--------'+production_date);
                                ln_days  =  date.parse(production_date).daysBetween(System.today()); 
                                System.debug('----ln_days--------'+ln_days);
                                if(ln_days <= 0){
                                    production_date= 'FAIL';
                                }
                            }else{ 
                                production_date= 'FAIL';
                            }                                               
                        }                       
                    }
                    
                    // -------------- For Snus.
                    else  if(ProductLineCode == 'TP')
                    {
                        first_char = traceCode.substring(0, 1).toUppercase();
                        first_number = traceCode.substring(1, 4);
                        second_char = traceCode.substring(6, 7).toUppercase();
                        second_number = traceCode.substring(4, 6);
                        third_char = traceCode.substring(7, 9).toUppercase();

                        if(first_char == 'W')
                        {
                            first_char = traceCode.substring(0, 1).toUppercase();
                            first_number = traceCode.substring(1, 4);
                            second_char = traceCode.substring(4, 5).toUppercase();
                            second_number = traceCode.substring(5, 7);
                            third_char = traceCode.substring(6, 9);
                            if((first_number.isNumeric() && Integer.valueOf(first_number) == 1) && (second_number.isNumeric() && Integer.valueOf(second_number) == 1))
                            {
                                List<CigaretteModule__c> cig = new  List<CigaretteModule__c>([SELECT
                                    id
                                FROM
                                    CigaretteModule__c
                                WHERE
                                    Cigarette_Code__c = : third_char.toUpperCase() AND ProductLineCode__c = : ProductLineCode AND Active__c = true]);
                                if((first_char == 'W') && (second_char == 'X' || second_char == 'Y' || second_char == 'Z') && (integer.valueOf(first_number) > 1 && integer.valueOf(first_number) < 366) && (integer.valueOf(second_number) > 0 && integer.valueOf(second_number) < 9) && ln_cnt > 0)
                                {
                                    if(integer.valueOf(second_number) == integer.valueOf(ln_lastdigit_year))
                                    {
                                        string lv_year = '01/01' + lv_year_new.substring(0, 4) + second_number.substring(0, 1);
                                    }
                                    else
                                    {
                                        if(integer.valueOf(lv_cur_year) >= integer.valueOf('201' +second_number.substring(0, 1)))
                                        {
                                            lv_year = '01/01' + lv_year_new.substring(0, 4) + second_number.substring(0, 1);
                                        }
                                        else
                                        {
                                            lv_year = '01/01' + lv_year.substring(0, 4) + second_number.substring(0, 1);
                                        }
                                    }
                                    production_date = date.parse(lv_year).addDays(Integer.ValueOf(first_number) - 1).format();
                                    system.debug('------------production_date1--------' + production_date);
                                    ln_days = date.parse(production_date).daysBetween(System.today());
                                    if(ln_days <= 0)
                                    {
                                        methodOne();
                                    }
                                    if(first_Char == 'W')
                                    {
                                        lv_location = 'York Mfg.Center';
                                    }
                                    else
                                    {
                                        lv_location = first_Char;
                                    }
                                    lv_date_code_rpt_factory = 'YK';
                                    lv_shift = second_char;
                                    lv_unit = ' "0" ' + third_char.SUBSTRING(2, third_char.length());
                                }
                                else
                                {
                                    string Check2 = 'Subloop';
                                    methodOne();
                                }
                            }
                            else
                            {
                                string Check2 = 'Subloop';
                                methodOne();
                            }
                        }
                        else if(first_char == 'N' || first_char == 'F')
                        {
                            first_char = traceCode.substring(0, 1);
                            first_number = traceCode.substring(1, 4);
                            second_char = traceCode.substring(4, 5);
                            second_number = traceCode.substring(5, 6);
                            third_char = traceCode.substring(6, 9);
                            third_number = traceCode.substring(7, 9);
                            if(first_number.isNumeric() && second_number.isNumeric() && third_number.isNumeric())
                            {
                                if((first_char == 'N' || first_char == 'F') && (second_char == 'X' || second_char == 'Y' || second_char == 'Z') && (integer.valueOf(first_number) > 1 && integer.valueOf(first_number) < 366) && (integer.valueOf(second_number) > 0 && integer.valueOf(second_number) < 9) && (integer.valueOf(third_number) > 1 && integer.valueOf(third_number) < 53))
                                {
                                    if(integer.valueOf(second_number) == integer.valueOf(ln_lastdigit_year))
                                    {
                                        lv_year = '01/01' + lv_year_new.SUBSTRING(0, 4) + second_number.SUBSTRING(0, 1);
                                    }
                                    else
                                    {
                                        if(integer.valueOf(lv_cur_year) >= integer.valueOf('201' + second_number.SUBSTRING(0, 1)))
                                        {
                                            lv_year = '01/01' + lv_year_new.SUBSTRING(0, 4) + second_number.SUBSTRING(0, 1);
                                        }
                                        else
                                        {
                                            lv_year = '01/01' + lv_year.SUBSTRING(0, 4) + second_number.SUBSTRING(0, 1);
                                        }
                                    }
                                    production_date = date.parse(lv_year).addDays(Integer.ValueOf(first_number) - 1).format();
                                    system.debug('------------production_date1--------' + production_date);
                                    ln_days = date.parse(production_date).daysBetween(System.today());
                                    if(ln_days <= 0)
                                    {
                                        Check2 = 'Subloop';
                                        methodOne();
                                    }
                                    if(first_char == 'N')
                                    {
                                        lv_location = 'NASHVILLE';
                                        lv_date_code_rpt_factory = 'NS';
                                    }
                                    else if(first_Char == 'F')
                                    {
                                        lv_location = 'Franklin Park';
                                        lv_date_code_rpt_factory = 'FP';
                                    }
                                }
                                else
                                {
                                    Check2 = 'Subloop';
                                    methodOne();
                                }
                            }
                        }
                        else if(first_char == 'L')
                        {
                            first_char = traceCode.substring(0, 1).toUppercase();
                            first_number = traceCode.substring(1, 4);
                            second_char = traceCode.substring(4, 5).toUppercase();
                            second_number = traceCode.substring(5, 6);
                            third_char = traceCode.substring(6, 9);
                            if((first_char == 'L') && (second_char == 'X' || second_char == 'Y' || second_char == 'Z') && (Integer.valueOf(first_number) > 1 && Integer.valueOf(first_number) < 366) && (Integer.valueOf(second_number) > 0 && Integer.valueOf(second_number) < 9) && third_char == '000')
                            {
                                if(integer.valueOf(second_number) == integer.valueOf(ln_lastdigit_year))
                                {
                                    lv_year = '01/01' + lv_year_new.Substring(0, 4) + second_number.Substring(0, 1);
                                }
                                else
                                {
                                    if(Integer.valueOf(lv_cur_year) >= (Integer.valueOf('201' + second_number.substring(1, 1))))
                                    {
                                        lv_year = '01/01' + lv_year_new.Substring(0, 4) + second_number.Substring(0, 1);
                                    }
                                    else
                                    {
                                        lv_year = '01/01' + lv_year.Substring(0, 4) + second_number.Substring(0, 1);
                                    }
                                }
                                production_date = date.parse(lv_year).addDays(Integer.ValueOf(first_number) - 1).format();
                                ln_days = date.parse(production_date).daysBetween(System.today());
                                if(ln_days <= 0)
                                {
                                    Check2 = 'Subloop';
                                    methodOne();
                                }
                                lv_location = 'LPF';
                                lv_date_code_rpt_factory = 'LPF';
                                lv_shift = second_char;
                            }
                            else
                            {
                                Check2 = 'Subloop';
                                methodOne();
                            }
                        }
                        else
                        {
                            if(first_number.isNumeric() && second_number.isNumeric() && third_number.isNumeric())
                            {
                                if(((first_char == 'Y' || first_char == 'J') && (Integer.valueOf(first_char) >= 1) && (Integer.valueOf(first_char) <= 366)) && (Integer.valueOf(second_number) >= 1 && (Integer.valueOf(second_number) <= 99)) && (second_char == 'X' || second_number == 'Y' || second_number == 'Z') && (Integer.valueOf(third_number) >= 0 && Integer.valueOf(third_number) <= 99))
                                {
                                    if(third_number.length() >= 2)
                                    {
                                        lv_year1 = '01/01' + lv_year1 + third_number.subString(0, 2);
                                    }
                                    else
                                    {
                                        string xx = '00';
                                        lv_year1 = '01/01' + lv_year1 + xx.subString(0, 1 - third_number.length()) + third_number;
                                    }
                                    production_date = string.ValueOf(Date.parse(lv_year1).adddays(Integer.ValueOf(first_number) - 1));
                                    ln_days = date.parse(production_date).daysBetween(System.today());
                                    if(ln_days <= 0)
                                    {
                                        Check2 = 'Subloop';
                                        methodOne();
                                    }
                                    if(first_char == 'F')
                                    {
                                        lv_location = 'Franklin Park';
                                    }
                                    else
                                    {
                                        lv_location = first_char;
                                    }
                                    if(first_char == 'F')
                                    {
                                        lv_date_code_rpt_factory = 'FP';
                                    }
                                    else
                                    {
                                        lv_date_code_rpt_factory = '';
                                    }
                                    lv_shift = second_char;
                                    lv_unit = second_number;
                                }
                                else
                                {
                                    Check2 = 'Subloop';
                                    methodOne();
                                }
                            }
                            else
                            {
                                Check2 = 'Subloop';
                                methodOne();
                            }
                        }
                    }                   
                    else if(ProductLineCode == 'GP')
                    {
                      
                        if(traceCode.length() == 7){
                            
                            first_char    =  traceCode.toUpperCase().subString( 5, 7);
                            second_char   =  traceCode.toUpperCase().subString( 2, 3);
                            third_char    =  traceCode.subString(3, 4);
                            first_number  =  traceCode.subString( 0, 2);
                            second_number =  traceCode.subString( 4, 5);
                                        
                            if((first_number.substring(1,2)).isNumeric() && second_number.isNumeric()){
                                    
                                if(((first_number.substring(1,2)).isNumeric()==false) || (second_number.isNumeric()==false )) {
                                    
                                    production_date = 'FAIL';
                                }
                                
                                charSet.clear();
                                charSet.add('X'); charSet.add('P');
                                
                                if(charSet.contains(first_number.substring(0,1))){
                                    check = 1;
                                    
                                }
                                
                                if(first_number.substring(0,1).isNumeric() == false && check != 1){
                                    production_date = 'FAIL';
                                    
                                }
                                
                                if((first_number.substring(1,2)).isNumeric() == false){
                                    production_date = 'FAIL'; 
                                    
                                }
                                
                                if((first_number.substring(0,1)).isNumeric() && check!= 1){
                                    if(Integer.valueOf(first_number) < 1 || Integer.valueOf(first_number) > 15){
                                        production_date = 'FAIL';
                                       
                                    }                                       
                                }
                                
                                if(check!= 1 && Integer.valueOf(second_number) < 1 || Integer.valueOf(second_number) > 3){
                                    production_date = 'FAIL';
                                    
                                }
                                    
                                    
                                charSet.clear();
                                charSet.add('B');charSet.add('L');charSet.add('A');charSet.add('C');charSet.add('K');
                                charSet.add('S');charSet.add('M');charSet.add('I');charSet.add('T');charSet.add('H');
                                if(!charSet.contains(first_char.substring(0,1))){
                                    production_date='FAIL';
                                    
                                }
                                
                                charSet.clear();
                                charSet.add('B');charSet.add('L');charSet.add('A');charSet.add('C');charSet.add('K');
                                charSet.add('S');charSet.add('M');charSet.add('I');charSet.add('T');charSet.add('H');
                                if(!charSet.contains(first_char.substring(1,2))){
                                    production_date='FAIL';
                                    
                                }
                                charSet.clear();
                                charSet.add('B');charSet.add('L');charSet.add('A');charSet.add('C');charSet.add('K');
                                charSet.add('S');charSet.add('M');charSet.add('I');charSet.add('T');charSet.add('H');charSet.add('E');charSet.add('R');
                                if(!charSet.contains(second_char)){
                                    production_date='FAIL';
                                    
                                }
                                    
                                charSet.clear();
                                charSet.add('B');charSet.add('L');charSet.add('A');charSet.add('C');charSet.add('K');
                                charSet.add('S');charSet.add('M');charSet.add('I');charSet.add('T');charSet.add('H');
                                if(!charSet.contains(third_char)){
                                    production_date='FAIL';
                                    
                                }
                                    
                                                        
                                lv_day  = first_Char.replace('B', '1').replace('L', '2').replace('A', '3').replace('C', '4').replace('K', '5').replace('S', '6').replace( 'M', '7').replace( 'I', '8').replace( 'T', '9').replace( 'H', '0');
                                    
                                lv_month  =  second_Char.replace('B','01').replace('L', '02').replace('A', '03').replace('C', '04').replace('K', '05').replace('S', '06').replace('M', '07').replace('I', '08').replace('T', '09').replace('H', '10').replace('E', '11').replace('R', '12');

                                lv_year2  =  third_Char.replace('B', '01').replace('L', '02').replace('A', '03').replace('C', '04').replace('K', '05').replace('S', '06').replace('M', '07').replace('I', '08').replace('T', '09').replace('H', '00');
                                 
                                
                                if(lv_day.isNumeric()){                                         
                                    if(Integer.valueOf(lv_day) > 31){
                                        production_date = 'FAIL';
                                    }
                                }
                                    
                                if(Integer.valueOf(lv_month) > 12){
                                    production_date = 'FAIL';
                                }
                                    
                                                        
                                intSet.clear();
                                intSet.add(4);intSet.add(6);intSet.add(9);intSet.add(11);
                                if(intSet.contains(Integer.valueOf(lv_month)) && Integer.valueOf(lv_day)>=31){
                                    production_date='FAIL';
                                }
                                    
                                if(Integer.ValueOf(lv_cur_year) >= Integer.ValueOf('201' + lv_year2.subString(1, 2))) {
                                    
                                    lv_year2  = lv_cur_year.substring(2,3) + lv_year2.substring(1,2);
                                    
                                    if(Integer.valueOf(lv_cur_year) == Integer.ValueOf('201' + lv_year2.subString(1, 2))){
                                        
                                        production_date  =  String.valueOf(lv_month) + '/' + String.valueOf(lv_day) + String.valueOf(lv_year1) + String.valueOf(lv_year2);
                                        
                                        
                                        if(Date.valueOf(production_date) >=  Date.today()){
                                            
                                            lv_year2 = lv_year.substring(2,3) + lv_year2.substring(1,2);
                                        }
                                    }                                           
                                }
                                else{
                                     lv_year2  = lv_year.substring(2,3) + lv_year2.substring(1,2);
                                }
                                
                                year_leep=lv_year1.substring(1,3)+string.valueOf(lv_year2);
                                
                                If (Date.parse('02/28/'+String.valueOf(year_leep)).addDays(1).Month() == 2){
                                    
                                    If ( Integer.valueOf( lv_month) == 2  && Integer.valueOf( lv_day)>= 30){
                                        
                                        production_date= 'FAIL';
                                    }
                                }  
                                else {
                                    If ( Integer.valueOf( lv_month) == 2 && Integer.valueOf( lv_day)>=29){
                                        
                                        production_date= 'FAIL';
                                    }
                                }
                                        
                                if(production_date  != 'FAIL' ){
                                    production_date  =  String.valueOf(lv_month)+ '/' + String.valueOf(lv_day) + String.valueOf(lv_year1) + String.valueOf(lv_year2);
                                     
                                }
                                
                                if(production_date  != 'FAIL' ){
                                    ln_days  =  date.parse(production_date).daysBetween(System.today());
                                }
                                if(ln_days <= 0){
                                    production_date  = 'FAIL'; 
                                }
                                
                                lv_unit  = first_number; 
                                if(first_number.substring(0,1) == 'X'){
                                    lv_location  = 'LASA'; 
                                }
                                
                                if(first_number.substring(0,1) != 'X'){
                                    lv_location  = 'Limerick'; 
                                }
                                
                                if(Integer.valueOf(second_number) == 1){
                                    lv_shift  = 'Shift1';
                                }
                                else if(Integer.valueOf(second_number) == 2){
                                    lv_shift  = 'Shift2';
                                }
                                
                                else if(Integer.valueOf(second_number) == 3){
                                    lv_shift  = 'Shift3';
                                }
                            }
                            else{
                                production_date  = 'FAIL'; 
                            }                   
                        }           
                        else if(traceCode.length() ==5){
                            
                            second_char    =  traceCode.substring(0,1);
                            third_char     =  traceCode.substring(1,2);
                            second_number  =  traceCode.substring(2,3);
                            first_char     =  traceCode.substring(3,5);
                            
                            if(second_number.isNumeric() == true){
                                
                                if(Integer.valueOf(second_number) < 1 || Integer.valueOf(second_number) > 3) 
                                {
                                    production_date  = 'FAIL';
                                } 
                            
                            
                                charSet.clear();
                                charSet.add('B');charSet.add('L');charSet.add('A');charSet.add('C');charSet.add('K');
                                charSet.add('S');charSet.add('M');charSet.add('I');charSet.add('T');charSet.add('H');
                                if(!charSet.contains(first_char.substring(0,1))){
                                    production_date='FAIL';
                                }
                                
                                charSet.clear();
                                charSet.add('B');charSet.add('L');charSet.add('A');charSet.add('C');charSet.add('K');
                                charSet.add('S');charSet.add('M');charSet.add('I');charSet.add('T');charSet.add('H');
                                if(!charSet.contains(first_char.substring(1,2))){
                                    production_date='FAIL';
                                }
                                charSet.clear();
                                charSet.add('B');charSet.add('L');charSet.add('A');charSet.add('C');charSet.add('K');
                                charSet.add('S');charSet.add('M');charSet.add('I');charSet.add('T');charSet.add('H');charSet.add('E');charSet.add('R');
                                if(!charSet.contains(second_char)){
                                    production_date='FAIL';
                                }
                                
                                charSet.clear();
                                charSet.add('B');charSet.add('L');charSet.add('A');charSet.add('C');charSet.add('K');
                                charSet.add('S');charSet.add('M');charSet.add('I');charSet.add('T');charSet.add('H');
                                if(!charSet.contains(third_char)){
                                    production_date='FAIL';
                                }
               
                            
                                lv_day  = first_Char.replace('B', '1').replace('L', '2').replace('A', '3').replace('C', '4').replace('K', '5').replace('S', '6').replace( 'M', '7').replace( 'I', '8').replace( 'T', '9').replace( 'H', '0');
                                
                                lv_month  =  second_Char.replace('B','01').replace('L', '02').replace('A', '03').replace('C', '04').replace('K', '05').replace('S', '06').replace('M', '07').replace('I', '08').replace('T', '09').replace('H', '10').replace('E', '11').replace('R', '12');

                                lv_year2  =  third_Char.replace('B', '01').replace('L', '02').replace('A', '03').replace('C', '04').replace('K', '05').replace('S', '06').replace('M', '07').replace('I', '08').replace('T', '09').replace('H', '00');      
                                    
                                if(Integer.valueOf(lv_day) > 31){ 
                                    production_date  = 'FAIL';
                                }
                                
                                if(Integer.valueOf(lv_month)> 12){
                                    production_date  = 'FAIL';
                                }
                                
                                if(Integer.valueOf(lv_cur_year) >= Integer.ValueOf('201' + lv_year2.subString(1, 2))){
                                   
                                    lv_year2  = lv_cur_year.substring(2,3) + lv_year2.substring(1,2);
                                    
                                }
                                else
                                { 
                                    lv_year2  = lv_year.substring(2,3) + lv_year2.substring(1,2);
                                    
                                }
                
                    
                                year_leep = lv_year1.subString(1,3)+String.valueOf(lv_year2);   
                                
                                if(date.parse(('02/28/'+String.valueOf(year_leep))).addDays(1).month() == 2){
                                   
                                    If (( Integer.valueOf( lv_month)== 2 ) && (Integer.valueOf( lv_day)>= 30)){
                                      
                                        production_date= 'fail';
                                    }
                                }  
                                else 
                                    If ( ( Integer.valueOf( lv_month)== 2 ) && (Integer.valueOf( lv_day)>=29)){
                                        production_date= 'fail';
                                        
                                    }    
                                
                                If (( Integer.valueOf( lv_month) == 4 || Integer.valueOf( lv_month) == 6 || Integer.valueOf( lv_month) == 9 || Integer.valueOf( lv_month) == 11) 
                                    && (Integer.valueOf( lv_day)>=31)){
                                        production_date= 'fail';  
                                
                                    }    
                                
                                System.debug(' test' +lv_month +' ,'+ lv_day +' ,'+ lv_year1+' ,'+lv_year2);
                                if( production_date  != 'fail' ){
                                    production_date  =  String.valueOf(lv_month) + '/' + String.valueOf(lv_day) + String.valueOf(lv_year1) + String.valueOf(lv_year2);
                                    System.debug('----production_date-------'+production_date +lv_month +' ,'+ lv_day +' ,'+ lv_year1+' ,'+lv_year2);
                                    ln_days  =  date.parse(production_date).daysBetween(System.today());
                                }
                                System.debug('ttest production_date   '+production_date  );
                                
                                
                                if(ln_days <= 0){ 
                                    production_date  = 'FAIL';
                                }
                            
                                lv_unit  = '';
                                lv_location  = 'Limerick';
                                
                                if(Integer.valueOf(second_number) == 1)
                                    lv_shift  =  'Shift1';
                                else if(Integer.valueOf(second_number) == 2)
                                    lv_shift  =  'Shift2';
                                else if(Integer.valueOf(second_number) == 3)
                                    lv_shift  =  'Shift3';
                            }
                            else{
                                production_date  = 'FAIL'; 
                            }                            
                        }
                        else if (traceCode.length() == 8){ 
                            
                            first_char  =  traceCode.substring(0,1);
                            first_number  =  traceCode.substring(1,4);
                            second_char  =  traceCode.substring(4,5);
                            second_number  =  traceCode.substring(5,6);
                            third_number  =  traceCode.substring(6,8);
                            
                            System.debug('-------first_char-------'+first_char);
                            System.debug('--------first_number------'+first_number);
                            System.debug('--------second_char------'+second_char);
                            System.debug('---------second_number-----'+second_number);
                            System.debug('---------third_number-----'+third_number);
                        
                            if(first_number.ISNUMERIC()  || second_number.isNumeric() || third_number.isNumeric()){ 
                                production_date  = 'FAIL';
                            }                            
                            
                            if((first_char == 'A' || first_char == 'B' || first_char == 'C' || first_char == 'D' || first_char == 'E' || 
                                first_char == 'F' || first_char == 'G'|| first_char == 'H' || first_char == 'I' || first_char == 'J' || 
                                first_char == 'K' || first_char == 'L' || first_char == 'M' || first_char == 'N'|| first_char == 'T' || 
                                first_char == 'X' || first_char == 'Z' ) && (second_char == 'X' || second_char == 'Y' || second_char == 'Z' ) &&
                               ( Integer.valueOf(first_number) >= 1 && Integer.valueOf(first_number) <= 366 ) && ( Integer.valueOf(second_number) >= 0 && Integer.valueOf(second_number) <= 9 ))
                            {                                 
                                if((Integer.valueOf(second_number) == Integer.valueOf(ln_lastdigit_year))){
                                   lv_year  = '01/01' + lv_year_new.substring(0,4) + second_number.substring(0,1);
                                }
                                else{                                       
                                   if(Integer.valueOf(lv_cur_year)>=Integer.valueOf('201' +second_number.substring(0,1))){
                                       lv_year  = '01/01' + lv_year.substring(0,4) + second_number.substring(0,1);
                                   }                                       
                                   else {
                                       lv_year  = '01/01' + lv_year.substring(0,4) + second_number.substring(0,1);
                                   }                                       
                                }
                    
                                if(second_number.length()>= 2){
                                    lv_leap_year  = lv_leap_year + second_number.substring(1,2);
                                }
                                
                                else{
                                    String xx = '00';
                                    lv_leap_year  = lv_leap_year + xx.subString(0,1-second_number.length()) + second_number;
                                }
                     
                     
                                /************Issue************/
                                //ln_leap  =  DATEPART(DD, DATEADD(D, -DAY(DATEADD(M, 1, CONVERT(DATETIME, '01-FEB-' + CAST(CONVERT(VARCHAR(23), @lv_leap_year) AS VARCHAR)))), DATEADD(M, 1, CONVERT(DATETIME, '01-FEB-' + CAST(CONVERT(VARCHAR(23), @lv_leap_year) AS VARCHAR)))))
                                        
                            
                                if(Integer.valueOf(ln_leap)== 28){
                                    if(Integer.valueOf(first_number) > 365){ 
                                        production_date  = 'FAIL';
                                    }
                                    else{   
                                        production_date  =  date.parse(lv_year).addDays(Integer.valueOf( first_number) - 1).format();
                                        system.debug('---production_date-------'+production_date);
                                      
                                    }   
                                }   
                                else{   
                                    production_date  =  date.parse(lv_year).addDays(Integer.valueOf( first_number) - 1).format();
                                    system.debug('---production_date-------'+production_date);
                                 } 
                                
                                ln_days  =  date.parse(production_date).daysBetween(System.today());


                                if(ln_days <= 0 ){
                                    production_date  = 'FAIL';
                                    system.debug('---production_date-------'+production_date);
                                }
                                else{ 
                                    production_date  = production_date; /******Issue******/
                                }
                                
                                if(   first_char == 'T' || first_char == 'N' || first_char == 'A' 
                                   || first_char == 'B' || first_char == 'C' || first_char == 'D' 
                                   || first_char == 'E' || first_char == 'F' || first_char == 'G' 
                                   || first_char == 'H' || first_char == 'I' || first_char == 'K' 
                                   || first_char == 'M'){
                                       
                                    lv_location  = 'Limerick';
                                }
                                
                                else if(first_char == 'X' || first_char == 'Z'){
                                    lv_location  = 'LASA';
                                }
                                 
                                lv_shift  = second_char; 
                                lv_unit  = third_number; 
                                
                                //--when (@first_char  = 'J'  OR    @first_char  = 'S' ) then 'Y'
                                if(first_char == 'J' || first_char  == 'Z' ){
                                    lv_date_code_cold_storage  = 'Y';
                                }
                                else{
                                lv_date_code_cold_storage  = 'N';
                                }
                            }                
                            else{
                                production_date  = 'FAIL';
                            }
                        }                              
                        else if(traceCode.length() == 11){
                    
                            
                            first_char  =  traceCode.substring(0,1).toUpperCase();
                            first_number  =  traceCode.substring(1,4);
                            second_char  =  traceCode.substring(4,5).toUpperCase();
                            second_number  =  traceCode.substring(5,6);
                            third_char  =  traceCode.substring(6,9);
                            fourth_number = traceCode.substring(9,11);

                            if(first_number.isNumeric() == TRUE && second_number.isNumeric() == TRUE  && (fourth_number.length() == 0 || fourth_number.length() > 0 && 
                                    fourth_number.isNumeric() == TRUE && (Integer.valueOf(fourth_number) >= 0 && Integer.valueOf(fourth_number) <=23 )))
                            { 
                                    System.debug('----------');
                                List<CigaretteModule__c> cig = new  List<CigaretteModule__c>([Select id from CigaretteModule__c 
                                                                                               where Cigarette_Code__c =: third_char.toUpperCase() 
                                                                                               and ProductLineCode__c =: ProductLineCode
                                                                                               and Active__c = true ]); 
                                 
                                IF( ( first_char == 'W' || first_char == 'P') && ( Integer.valueOf(first_number) >= 1 && Integer.valueOf(first_number) <= 366 ) && 
                                        ( Integer.valueOf(second_number) >= 0 && Integer.valueOf(second_number) <= 9 ) &&((third_char.substring(0,1).isNumeric() == FALSE && 
                                                                                                                           third_char.substring(1,3).isNumeric() == TRUE)))
                                {
                                 
                                    if(Integer.valueOf(second_number) == Integer.valueOf(ln_lastdigit_year)){
                                        lv_year  = '01/01' + lv_year_new.substring(0,4) + second_number.substring(0,1);
                                    }      
                                     
                                     else{
                                         
                                         if(Integer.valueOf(lv_cur_year) >= Integer.valueOf('201' + second_number.substring(0,1))){
                                             lv_year  = '01/01' + lv_year_new.substring(0,4) + second_number.substring(0,1);
                                         }
                                         
                                         else{
                                             
                                             lv_year  = '01/01' + lv_year.substring(0,4) + second_number.substring(0,1);
                                         }
                                     }
                   
                                    production_date  =  date.parse(lv_year).addDays(Integer.valueOf( first_number) - 1).format();
                                    ln_days  =  date.parse(production_date).daysBetween(System.today());
                                    System.debug('---------production_date-----'+production_date);
                                    
                                    if(ln_days <= 0 ){
                                            production_date  = 'FAIL'; 
                                    }
                                    
                                    if(first_char == 'P' || first_char == 'W'){
                                        lv_location  = 'PRECON'; 
                                    }
                                    else{
                                        lv_location  = '';  
                                    }
                                            
                                    lv_shift  = second_char; 
                                    lv_unit  = third_char; 
                                    
                                    if(first_char == 'W'){
                                        lv_date_code_cold_storage  = 'Y'; 
                                    }
                                    else{
                                        lv_date_code_cold_storage  = 'N';   
                                    }
                                 
                                    lv_date_code_rpt_bay  =  '';
                                    lv_date_code_rpt_factory  = ''; 
                                    lv_military_time = fourth_number;
                                }
                                else{
                                    production_date  = 'FAIL'; 
                                }
                            }
                            else{
                                production_date  = 'FAIL'; 
                            } 
                        }                            
                    }    
                    //-- For Pipe Tobacco 
                    else if(ProductLineCode == 'PT')
                    {
                        if(traceCode.length() == 4)
                        {
                            first_char = traceCode.toUpperCase().subString(2, 4);
                            second_char = traceCode.toUpperCase().subString(0, 1);
                            third_char = traceCode.toUpperCase().subString(1, 2);
                            system.debug('first_char--> ' + first_char);
                            system.debug('second_char--> ' + second_char);
                            system.debug('third_char--> ' + third_char);
                            charSet.clear();
                            charSet.add('B');
                            charSet.add('L');
                            charSet.add('A');
                            charSet.add('C');
                            charSet.add('K');
                            charSet.add('S');
                            charSet.add('M');
                            charSet.add('I');
                            charSet.add('T');
                            charSet.add('H');
                            if(!charSet.contains(first_char.substring(0, 1)))
                            {
                                production_date = 'FAIL';
                            }
                            charSet.clear();
                            charSet.add('B');
                            charSet.add('L');
                            charSet.add('A');
                            charSet.add('C');
                            charSet.add('K');
                            charSet.add('S');
                            charSet.add('M');
                            charSet.add('I');
                            charSet.add('T');
                            charSet.add('H');
                            if(!charSet.contains(first_char.substring(1, 2)))
                            {
                                production_date = 'FAIL';
                            }
                            charSet.clear();
                            charSet.add('B');
                            charSet.add('L');
                            charSet.add('A');
                            charSet.add('C');
                            charSet.add('K');
                            charSet.add('S');
                            charSet.add('M');
                            charSet.add('I');
                            charSet.add('T');
                            charSet.add('H');
                            charSet.add('E');
                            charSet.add('R');
                            if(!charSet.contains(second_char))
                            {
                                production_date = 'FAIL';
                            }
                            charSet.clear();
                            charSet.add('B');
                            charSet.add('L');
                            charSet.add('A');
                            charSet.add('C');
                            charSet.add('K');
                            charSet.add('S');
                            charSet.add('M');
                            charSet.add('I');
                            charSet.add('T');
                            charSet.add('H');
                            if(!charSet.contains(third_char))
                            {
                                production_date = 'FAIL';
                            }
                            lv_day = first_Char.replace('B', '1').replace('L', '2').replace('A', '3').replace('C', '4').replace('K', '5').replace('S', '6').replace('M', '7').replace('I', '8').replace('T', '9').replace('H', '0');
                            lv_month = second_Char.replace('B', '01').replace('L', '02').replace('A', '03').replace('C', '04').replace('K', '05').replace('S', '06').replace('M', '07').replace('I', '08').replace('T', '09').replace('H', '10').replace('E', '11').replace('R', '12');
                            lv_year2 = third_Char.replace('B', '01').replace('L', '02').replace('A', '03').replace('C', '04').replace('K', '05').replace('S', '06').replace('M', '07').replace('I', '08').replace('T', '09').replace('H', '00');
                            system.debug('------lv_day--------' + lv_day);
                            system.debug('------lv_month--------' + lv_month);
                            system.debug('--------lv_year2------' + lv_year2);
                            if(Integer.valueOf(lv_day) > 31)
                            {
                                production_date = 'FAIL';
                            }
                            if(Integer.valueOf(lv_month) > 12)
                            {
                                production_date = 'FAIL';
                            }
                            if(Integer.valueOf(lv_cur_year) >= Integer.valueOf('201' + lv_year2.subString(1, 2)))
                            {
                                lv_year2 = lv_cur_year.subString(2, 3) + lv_year2.subString(1, 2);
                                System.debug('-------lv_year2---------' + lv_year2);
                                if(Integer.valueOf(lv_cur_year) == Integer.valueOf('201' + lv_year2.subString(1, 2)))
                                {
                                    production_date = string.valueOf(lv_month) + '/' + string.valueOf(lv_day) + string.valueOf(lv_year1) + string.valueOf(lv_year2);
                                    //IsValidDate                         
                                    System.debug('-------production_date---------' + production_date);
                                    try
                                    {
                                        date dt = date.parse(production_date);
                                        if(date.parse(production_date) >= System.today())
                                        {
                                            lv_year2 = lv_year.subString(2, 3) + lv_year2.subString(1, 2);
                                        }
                                        System.debug('--------lv_year2--------' + lv_year2);
                                    }
                                    catch(Exception ex)
                                    {
                                    }
                                }
                            }
                            else
                            {
                                lv_year2 = lv_year.subString(2, 3) + lv_year2.subString(1, 2);
                                System.debug('-------lv_year2---------' + lv_year2);
                            }
                            year_leep = lv_year1.subString(1, 3) + string.valueOf(lv_year2);
                            System.debug('---------year_leep-------' + year_leep);
                            if(Date.parse('02/28/' + string.valueOf(year_leep)).addDays(1).Month() == 2)
                            {
                                if(Integer.valueOf(lv_month) == 2 && Integer.valueOf(lv_day) >= 30)
                                {
                                    production_date = 'fail';
                                }
                            }
                            else if(Integer.valueOf(lv_month) == 2 && Integer.valueOf(lv_day) >= 29)
                            {
                                production_date = 'fail';
                            }
                            if(production_date != 'fail')
                            {
                                production_date = string.valueOf(lv_month) + '/' + string.valueOf(lv_day) + string.valueOf(lv_year1) + string.valueOf(lv_year2);
                                System.debug('---------production_date-------' + production_date);
                            }
                            ln_days = date.parse(production_date).daysBetween(system.today());
                            System.debug('-------ln_days---------' + ln_days);
                            if(ln_days <= 0)
                            {
                                production_date = 'FAIL';
                            }
                            lv_unit = '';
                            lv_location = 'Limerick';
                            lv_date_code_rpt_factory = 'Limerick';
                            system.debug('------lv_location-----' + lv_location);
                            system.debug('-----lv_date_code_rpt_factory------' + lv_date_code_rpt_factory);
                        }
                        else if(traceCode.length() == 2)
                        {
                            first_char = traceCode.toUpperCase().substring(1, 2);
                            first_char = traceCode.toUpperCase().substring(0, 1);
                            charSet.clear();
                            charSet.add('B');
                            charSet.add('L');
                            charSet.add('A');
                            charSet.add('C');
                            charSet.add('K');
                            charSet.add('S');
                            charSet.add('M');
                            charSet.add('I');
                            charSet.add('T');
                            charSet.add('H');
                            charSet.add('E');
                            charSet.add('R');
                            if(!charSet.contains(second_char))
                            {
                                production_date = 'FAIL';
                            }
                            charSet.clear();
                            charSet.add('B');
                            charSet.add('L');
                            charSet.add('A');
                            charSet.add('C');
                            charSet.add('K');
                            charSet.add('S');
                            charSet.add('M');
                            charSet.add('I');
                            charSet.add('T');
                            charSet.add('H');
                            if(!charSet.contains(first_char))
                            {
                                production_date = 'FAIL';
                            }
                            lv_day = '1';
                            lv_month = second_Char.replace('B', '01').replace('L', '02').replace('A', '03').replace('C', '04').replace('K', '05').replace('S', '06').replace('M', '07').replace('I', '08').replace('T', '09').replace('H', '10').replace('E', '11').replace('R', '12');
                            lv_year2 = third_Char.replace('B', '01').replace('L', '02').replace('A', '03').replace('C', '04').replace('K', '05').replace('S', '06').replace('M', '07').replace('I', '08').replace('T', '09').replace('H', '00');
                            if(Integer.valueOf(lv_day) > 31)
                            {
                                production_date = 'FAIL';
                            }
                            if(Integer.valueOf(lv_month) > 12)
                            {
                                production_date = 'FAIL';
                            }
                            //-- Start Change  02/05/2010
                            if(Integer.valueOf(lv_cur_year) >= Integer.valueOf('201' + lv_year2.substring(1, 2)))
                            {
                                lv_year2 = lv_cur_year.substring(2, 3) + lv_year2.substring(1, 2);
                            }
                            //--  ADDING    FOR LEAP YEAR
                            year_leep = lv_year1.substring(1, 3) + string.valueOf(lv_year2);
                            if(Date.parse(string.ValueOf(year_leep) + '0228').addDays(1).Month() == 2)
                            {
                                if(Integer.valueOf(lv_month) == 2 && Integer.valueOf(lv_day) >= 30)
                                {
                                    production_date = 'FAIL';
                                }
                            }
                            else if(Integer.valueOf(lv_month) == 2 && Integer.valueOf(lv_day) >= 29)
                            {
                                production_date = 'FAIL';
                            }
                            intSet.clear();
                            intSet.add(4);
                            intSet.add(6);
                            intSet.add(9);
                            intSet.add(11);
                            if(intSet.contains(Integer.valueOf(lv_month)) && Integer.valueOf(lv_day) >= 31)
                            {
                                production_date = 'FAIL';
                            }
                            if(production_date != 'FAIL')
                            {
                                production_date = string.valueOf(lv_month) + '/' + string.valueOf(lv_day) + string.valueOf(lv_year1) + string.valueOf(lv_year2);
                            }
                            ln_days = Date.parse(production_date).daysBetween(System.today());
                            if(ln_days <= 0)
                            {
                                production_date = 'FAIL';
                            }
                            lv_unit = '';
                            lv_location = 'Limerick';
                            lv_date_code_rpt_factory = 'Limerick';
                        }
                        else if(traceCode.length() == 7)
                        {
                            if(traceCode.substring(0, 1) == 'J')
                            {
                                lv_date_code_cold_storage = 'Y';
                            }
                            else
                            {
                                lv_date_code_cold_storage = 'N';
                            }
                            lv_shift = traceCode.substring(4, 5);
                            if(traceCode.substring(6, 7) == 'M' && TraceCodeLocation == 'CAS')
                            {
                                lv_unit = 'M';
                            }
                            else
                            {
                                lv_unit = traceCode.substring(6, 7);
                            }
                            first_char = traceCode.subString(1, 3);
                            second_char = traceCode.subString(3, 4);
                            third_Char = traceCode.subString(5, 6);
                            charSet.clear();
                            charSet.add('B');
                            charSet.add('L');
                            charSet.add('A');
                            charSet.add('C');
                            charSet.add('K');
                            charSet.add('S');
                            charSet.add('M');
                            charSet.add('I');
                            charSet.add('T');
                            charSet.add('H');
                            if(!charSet.contains(first_char.substring(0, 1)))
                            {
                                production_date = 'FAIL';
                            }
                            charSet.clear();
                            charSet.add('B');
                            charSet.add('L');
                            charSet.add('A');
                            charSet.add('C');
                            charSet.add('K');
                            charSet.add('S');
                            charSet.add('M');
                            charSet.add('I');
                            charSet.add('T');
                            charSet.add('H');
                            if(!charSet.contains(first_char.substring(1, 2)))
                            {
                                production_date = 'FAIL';
                            }
                            charSet.clear();
                            charSet.add('B');
                            charSet.add('L');
                            charSet.add('A');
                            charSet.add('C');
                            charSet.add('K');
                            charSet.add('S');
                            charSet.add('M');
                            charSet.add('I');
                            charSet.add('T');
                            charSet.add('H');
                            charSet.add('E');
                            charSet.add('R');
                            if(!charSet.contains(second_char))
                            {
                                production_date = 'FAIL';
                            }
                            charSet.clear();
                            charSet.add('B');
                            charSet.add('L');
                            charSet.add('A');
                            charSet.add('C');
                            charSet.add('K');
                            charSet.add('S');
                            charSet.add('M');
                            charSet.add('I');
                            charSet.add('T');
                            charSet.add('H');
                            if(!charSet.contains(third_char))
                            {
                                production_date = 'FAIL';
                            }
                            lv_day = first_Char.replace('B', '1').replace('L', '2').replace('A', '3').replace('C', '4').replace('K', '5').replace('S', '6').replace('M', '7').replace('I', '8').replace('T', '9').replace('H', '0');
                            lv_month = second_Char.replace('B', '01').replace('L', '02').replace('A', '03').replace('C', '04').replace('K', '05').replace('S', '06').replace('M', '07').replace('I', '08').replace('T', '09').replace('H', '10').replace('E', '11').replace('R', '12');
                            lv_year2 = third_Char.replace('B', '01').replace('L', '02').replace('A', '03').replace('C', '04').replace('K', '05').replace('S', '06').replace('M', '07').replace('I', '08').replace('T', '09').replace('H', '00');
                            if(Integer.valueOf(lv_day) > 31)
                            {
                                production_date = 'FAIL';
                            }
                            if(Integer.valueOf(lv_month) > 12)
                            {
                                production_date = 'FAIL';
                            }
                            if(Integer.valueOf(lv_cur_year) >= (Integer.valueOf('201' + lv_year2.substring(1, 2))))
                            {
                                lv_year2 = lv_cur_year.substring(2, 3) + lv_year2.substring(1, 2);
                            }
                            else
                            {
                                lv_year2 = lv_year.substring(2, 3) + lv_year2.substring(1, 2);
                            }
                            //--  ADDING    FOR LEAP YEAR   
                            year_leep = lv_year1.subString(1, 3) + string.valueOf(lv_year2);
                            if(Date.parse(('02/28/' + string.valueOf(year_leep))).addDays(1).month() == 2)
                            {
                                if((Integer.valueOf(lv_month) == 2) && (Integer.valueOf(lv_day) >= 30))
                                {
                                    production_date = 'fail';
                                }
                            }
                            else if((Integer.valueOf(lv_month) == 2) && (Integer.valueOf(lv_day) >= 29))
                            {
                                production_date = 'fail';
                            }
                            if((Integer.valueOf(lv_month) == 4 || Integer.valueOf(lv_month) == 6 || Integer.valueOf(lv_month) == 9 || Integer.valueOf(lv_month) == 11) && (Integer.valueOf(lv_day) >= 31))
                            {
                                production_date = 'fail';
                            }
                            //-- FOR LEEP YEAR AND CHECKING FOR DAYS i.e., 30 OR 31     
                            if(production_date != 'fail')
                            {
                                production_date = string.valueOf(lv_month) + '/' + string.valueOf(lv_day) + string.valueOf(lv_year1) + string.valueOf(lv_year2);
                                ln_days = date.parse(production_date).daysBetween(System.today());
                                System.debug('------production_date------'+production_date);
                            }
                            if(ln_days <= 0)
                            {
                                production_date = 'FAIL';
                            }
                            lv_location = 'Limerick';
                            lv_date_code_rpt_factory = 'Limerick';
                        }
                        else
                        {
                           
                            first_char = traceCode.subString(2, 4);
                            second_char = traceCode.subString(0, 1);
                            third_char = traceCode.subString(1, 2);
                            first_number = traceCode.subString(4, 5);
                            

                            if(first_number.isNumeric())
                            {
                                if(Integer.valueOf(first_number) < 1 || Integer.valueOf(first_number) > 4)
                                {
                                    production_date = 'FAIL';
                                }
                                charSet.clear();
                                charSet.add('B');
                                charSet.add('L');
                                charSet.add('A');
                                if(!charSet.contains(first_char.substring(0, 1)))
                                {
                                    production_date = 'FAIL';
                                   
                                }
                                charSet.clear();
                                charSet.add('B');
                                charSet.add('L');
                                charSet.add('A');
                                charSet.add('C');
                                charSet.add('K');
                                charSet.add('S');
                                charSet.add('M');
                                charSet.add('I');
                                charSet.add('T');
                                charSet.add('H');
                                if(!charSet.contains(first_char.substring(1, 2)))
                                {
                                    production_date = 'FAIL';
                                }
                                charSet.clear();
                                charSet.add('B');
                                charSet.add('L');
                                charSet.add('A');
                                charSet.add('C');
                                charSet.add('K');
                                charSet.add('S');
                                charSet.add('M');
                                charSet.add('I');
                                charSet.add('T');
                                charSet.add('H');
                                charSet.add('E');
                                charSet.add('R');
                                if(!charSet.contains(second_char))
                                {
                                    production_date = 'FAIL';
                                }
                                charSet.clear();
                                charSet.add('B');
                                charSet.add('L');
                                charSet.add('A');
                                charSet.add('C');
                                charSet.add('K');
                                charSet.add('S');
                                charSet.add('M');
                                charSet.add('I');
                                charSet.add('T');
                                charSet.add('H');
                                if(!charSet.contains(third_char))
                                {
                                    production_date = 'FAIL';
                                }
                                
                                lv_day = first_Char.replace('B', '1').replace('L', '2').replace('A', '3').replace('C', '4').replace('K', '5').replace('S', '6').replace('M', '7').replace('I', '8').replace('T', '9').replace('H', '0');
                                lv_month = second_Char.replace('B', '01').replace('L', '02').replace('A', '03').replace('C', '04').replace('K', '05').replace('S', '06').replace('M', '07').replace('I', '08').replace('T', '09').replace('H', '10').replace('E', '11').replace('R', '12');
                                lv_year2 = third_Char.replace('B', '01').replace('L', '02').replace('A', '03').replace('C', '04').replace('K', '05').replace('S', '06').replace('M', '07').replace('I', '08').replace('T', '09').replace('H', '00');

                                if(Integer.valueOf(lv_day) > 31)
                                {
                                    production_date = 'FAIL';
                                }
                                if(Integer.valueOf(lv_month) > 12)
                                {
                                    production_date = 'FAIL';
                                }
                                System.debug('test lv_year2  '+lv_year2 +lv_cur_year + ' ,'+ Integer.valueOf(lv_year2.substring(1, 2)));
                                if(Integer.valueOf(lv_cur_year) >= Integer.valueOf('201' + lv_year2.substring(1, 2)))
                                {
                                    lv_year2 = lv_cur_year.substring(2, 3) + lv_year2.substring(1, 2);
                                    System.debug('test data 1'+lv_cur_year.substring(2, 3) + lv_year2.substring(1, 2));
                                }
                                else
                                {
                                    lv_year2 = lv_year.substring(2, 3) + lv_year2.substring(1, 2);
                                     System.debug('test data 2'+ lv_year.substring(2, 3) + lv_year2.substring(1, 2));
                                }
                                //--  ADDING    FOR LEAP YEAR   
                                year_leep = lv_year1.substring(1, 3) + string.valueOf(lv_year2);
                                If (Date.parse(('02/28/'+String.valueOf(year_leep))).addDays(1).month() ==2) 
                                {
                                    If ( ( Integer.valueOf( lv_month)== 2 ) && (Integer.valueOf( lv_day)>= 30))
                                    { 
                                        production_date='FAIL';
                                    }  
                                } 
                                else if(Integer.valueOf(lv_month) == 2 && Integer.valueOf(lv_day) >= 29)
                                {
                                    production_date = 'FAIL';
                                }
                                System.debug('test production_date  '+production_date );
                                intSet.clear();
                                intSet.add(4);
                                intSet.add(6);
                                intSet.add(9);
                                intSet.add(11);
                                if(intSet.contains(Integer.valueOf(lv_month)) && Integer.valueOf(lv_day) >= 31)
                                {
                                    production_date = 'FAIL';
                                }
                                if(production_date != 'FAIL')
                                {
                                    production_date = string.valueOf(lv_month) + '/' + string.valueOf(lv_day) + string.valueOf(lv_year1) + string.valueOf(lv_year2);
                                    
                                }
                                System.debug('test production_date  '+production_date );
                                ln_days = Date.parse(production_date).daysBetween(System.today());
                                if(ln_days <= 0)
                                {
                                    production_date = 'FAIL';
                                }
                                lv_unit = first_number;
                                lv_location = 'Limerick';
                                lv_date_code_rpt_factory = 'Limerick';
                            }
                        }
                    }
                    // for E-Cigaretes
                    else if(ProductLineCode == 'EC')
                    {
                        if(traceCode.length() == 8)
                        {
                            ln_lasttwodigit_year = Integer.valueOf(string.ValueOf(System.today().year()).substring(2, 4));
                            first_char = traceCode.subString(0, 1);
                            first_number = traceCode.subString(1, 3);
                            second_char = traceCode.subString(5, 6);
                            second_number = traceCode.subString(3, 5);
                            third_number = traceCode.subString(6, 8);
                            system.debug('-----ln_lasttwodigit_year-----' + ln_lasttwodigit_year);
                            system.debug('-----first_char-----' + first_char);
                            system.debug('-----first_number-----' + first_number);
                            system.debug('------second_char----' + second_char);
                            system.debug('------second_number----' + second_number);
                            system.debug('------third_number----' + third_number);
                            if(!first_number.isNumeric() || !second_number.isNumeric())
                            {
                                production_date = 'FAIL';
                                system.debug('------production_date----' + production_date);
                            }
                            if((first_char == 'A' || first_char == 'X' || first_char == 'B' || first_char == 'C' || first_char == 'D' || first_char == 'S') && (second_char == 'A' || second_char == 'B' || second_char == 'C') && (Integer.valueOf(first_number) >= 0 && Integer.valueOf(first_number) <= 99) && (Integer.valueOf(second_number) >= 0 && Integer.valueOf(second_number) <= 99))
                            {
                                if(Integer.valueOf(second_number) <= Integer.valueOf(ln_lasttwodigit_year))
                                {
                                    lv_year = lv_year_new1.substring(0, 2) + second_number.substring(0, 2);
                                    system.debug('------lv_year----' + lv_year);
                                }
                                else
                                {
                                    lv_year = '19' + second_number.subString(0, 2);
                                    system.debug('------lv_year----' + lv_year);
                                }
                                production_date = mondayDate(lv_year, first_number);
                                system.debug('------production_date----' + production_date);
                                ln_days = date.parse(production_date).daysBetween(System.today());
                                system.debug('------ln_days----' + ln_days);
                                if(ln_days <= 0)
                                {
                                    production_date = 'FAIL';
                                }
                                else
                                {
                                    production_date = production_date;
                                    system.debug('------production_date----' + production_date);
                                    lv_unit = third_number;
                                    if(first_char == 'A')
                                    {
                                        lv_location = 'New2';
                                    }
                                    else if(first_char == 'B')
                                    {
                                        lv_location = 'New3';
                                    }
                                    else if(first_char == 'C')
                                    {
                                        lv_location = 'New4';
                                    }
                                    else if(first_char == 'D')
                                    {
                                        lv_location = 'New5';
                                    }
                                    else if(first_char == 'X')
                                    {
                                        lv_location = 'Existing 4';
                                    }
                                    if(first_char == 'A')
                                    {
                                        lv_date_code_rpt_factory = 'New2';
                                    }
                                    else if(first_char == 'B')
                                    {
                                        lv_date_code_rpt_factory = 'New3';
                                    }
                                    else if(first_char == 'C')
                                    {
                                        lv_date_code_rpt_factory = 'New4';
                                    }
                                    else if(first_char == 'D')
                                    {
                                        lv_date_code_rpt_factory = 'New5';
                                    }
                                    else if(first_char == 'X')
                                    {
                                        lv_date_code_rpt_factory = 'Existing 4';
                                    }
                                    lv_shift = second_char;
                                }
                            }
                            else
                            {
                                production_date = 'FAIL';
                            }
                        }
                        if(traceCode.length() == 7)
                        {
                            ln_lasttwodigit_year = Integer.valueOf(string.ValueOf(System.today().year()).substring(2, 4));
                            first_char = traceCode.substring(0, 1);
                            second_char = traceCode.substring(1, 2);
                            first_number = traceCode.substring(2, 4);
                            second_number = traceCode.substring(4, 6);
                            third_number = traceCode.substring(6, 7);
                            system.debug('-----ln_lasttwodigit_year-----' + ln_lasttwodigit_year);
                            system.debug('-----first_char-----' + first_char);
                            system.debug('-----first_number-----' + first_number);
                            system.debug('------second_char----' + second_char);
                            system.debug('------second_number----' + second_number);
                            system.debug('------third_number----' + third_number);
                            if(first_number.isNumeric() == false || second_number.isNumeric() == false)
                            {
                                //--third_number.isNumeric()==False)
                                production_date = 'FAIL';
                            }
                            if((first_char == 'B' || first_char == 'C') && (second_char == 'A' || second_char == 'B' || second_char == 'C' || second_char == 'D' || second_char == 'X' || second_char == 'S') && (Integer.valueOf(first_number) >= 0 && Integer.valueOf(first_number) <= 52) && (Integer.valueOf(second_number) >= 0 && Integer.valueOf(second_number) <= 99) && (third_number == 'A' || third_number == 'B' || third_number == 'C' || third_number == '0' || third_number == '1' || third_number == '2' || third_number == '3' || third_number == '4' || third_number == '5' || third_number == '6' || third_number == '7' || third_number == '8' || third_number == '9'))
                            {
                                if(Integer.valueOf(second_number) <= Integer.valueof(ln_lasttwodigit_year))
                                {
                                    //--SELECT @lv_year  = '01/01' + SUBSTRING(@lv_year_new1, 1, 3)+ SUBSTRING(@second_number, 1, 2)
                                    lv_year = lv_year_new1.substring(0, 2) + second_number.substring(0, 2);
                                    system.debug('------lv_year-----' + lv_year);
                                }
                                else
                                {
                                    lv_year = '19' + second_number.substring(0, 2);
                                    system.debug('------lv_year-----' + lv_year);
                                }
                                production_date = mondayDate(lv_year, first_number);
                                system.debug('------production_date-----' + production_date);
                                ln_days = date.parse(production_date).daysBetween(System.today());
                                system.debug('------ln_days-----' + ln_days);
                                if(ln_days <= 0)
                                {
                                    production_date = 'FAIL';
                                }
                                else
                                {
                                    //SELECT @production_date  = @production_date
                                    if(second_char == 'A')
                                    {
                                        lv_location = 'New2';
                                        lv_date_code_rpt_factory = 'New2';
                                    }
                                    else if(second_char == 'B')
                                    {
                                        lv_location = 'New3';
                                        lv_date_code_rpt_factory = 'New3';
                                    }
                                    else if(second_char == 'C')
                                    {
                                        lv_location = 'New4';
                                        lv_date_code_rpt_factory = 'New4';
                                    }
                                    else if(second_char == 'D')
                                    {
                                        lv_location = 'New5';
                                        lv_date_code_rpt_factory = 'New5';
                                    }
                                    else if(second_char == 'S')
                                    {
                                        lv_date_code_rpt_factory = 'Smoore Songgang 3';
                                    }
                                    else if(second_char == 'X')
                                    {
                                        lv_location = 'Existing 4';
                                        lv_date_code_rpt_factory = 'Existing 4';
                                    }
                                    lv_unit = first_char;
                                    lv_shift = third_number;
                                    system.debug('--------lv_unit------' + lv_unit);
                                    system.debug('--------lv_shift------' + lv_shift);
                                }
                            }
                            else
                            {
                                production_date = 'FAIL';
                            }
                        }
                    }
                    //  For Dry Snuff                     
                    else if(ProductLineCode == 'DS')
                    {
                        first_char = traceCode.substring(0, 3);
                        first_number = traceCode.substring(3, 5);
                        second_char = traceCode.substring(5, 7);
                        second_number = traceCode.substring(7, 9);
                        system.debug('-----first_char-----' + first_char);
                        system.debug('-----first_number-----' + first_number);
                        system.debug('------second_char----' + second_char);
                        system.debug('------second_number----' + second_number);
                        if(second_number.isNumeric() && first_char.isNumeric())
                        {
                            if((Integer.valueOf(first_char) >= 1 && Integer.valueOf(first_char) <= 366) && (Integer.valueOf(second_number) >= 0 && Integer.valueOf(second_number) <= 99))
                            {
                                lv_leap_year = '20';
                                if(second_number.length() >= 2)
                                {
                                    lv_year1 = '01/01' + lv_year1 + second_number.subString(0, 2);
                                    system.debug('------lv_year1-----' + lv_year1);
                                    lv_leap_year = lv_leap_year + second_number.subString(0, 2);
                                    system.debug('------lv_leap_year-----' + lv_leap_year);
                                }
                                else
                                {
                                    lv_year1 = '01/01' + lv_year1 + '0' + second_number;
                                    lv_leap_year = lv_leap_year + '0' + second_number;
                                    system.debug('------lv_leap_year-----' + lv_leap_year);
                                    system.debug('------lv_year1-----' + lv_year1);
                                }
                                Date dt = Date.parse('02/01/' + string.valueOf(lv_leap_year)).addMonths(1);
                                ln_leap = string.ValueOf(dt.addDays(-dt.day()).day());
                                system.debug('-----ln_leap-------' + ln_leap);
                                if(Integer.valueOf(ln_leap) == 29)
                                {
                                    production_date = date.parse(lv_year1).addDays(Integer.valueOf(first_char) - 1).format();
                                    system.debug('-----production_date-------' + production_date);
                                }
                                else
                                {
                                    if(Integer.valueOf(first_char) > 60)
                                    {
                                        production_date = date.parse(lv_year1).addDays(Integer.valueOf(first_char) - 2).format();
                                        system.debug('-----production_date-------' + production_date);
                                    }
                                    else
                                    {
                                        production_date = date.parse(lv_year1).addDays(Integer.valueOf(first_char) - 1).format();
                                        system.debug('-----production_date-------' + production_date);
                                    }
                                }
                                //SELECT @lv_leap_year  = @lv_leap_year + CASE WHEN LEN(@second_number) >= 2 THEN SUBSTRING(@second_number,1,2) ELSE //SUBSTRING(REPLICATE('0',2),1,2-LEN(@second_number)) + @second_number END
                                ln_days = date.parse(production_date).daysBetween(System.today());
                                system.debug('-----ln_days-------' + ln_days);
                                if(ln_days <= 0)
                                {
                                    production_date = 'FAIL';
                                    system.debug('-----production_date-------' + production_date);
                                }
                                if((INTEGER.VALUEOF(first_number) > 0 && integer.valueOf(first_number) < 23) && (integer.valueOf(second_char) > 0 && integer.valueOf(second_char) < 59))
                                {
                                    lv_military_time = first_number + second_char;
                                    system.debug('-----lv_military_time-------' + lv_military_time);
                                }
                                else
                                {
                                    lv_military_time = '';
                                    system.debug('-----lv_military_time-------' + lv_military_time);
                                }
                                lv_location = 'Nashville';
                                lv_date_code_rpt_factory = 'NS';
                                system.debug('-----lv_location-------' + lv_location);
                                system.debug('-----lv_date_code_rpt_factory-------' + lv_date_code_rpt_factory);
                            }
                            else
                            {
                                production_date = 'FAIL';
                            }
                            if((integer.valueOf(first_number) > 0 && integer.valueOf(first_number) < 23) && (integer.valueOf(second_char) > 0 && integer.valueOf(second_char) < 59))
                            {
                                lv_military_time = first_number + second_char;
                                system.debug('-----lv_military_time-------' + lv_military_time);
                            }
                            else
                            {
                                //-- Code added by Mythreyee as part of CRC JMC and USSTC Trace Code logic change on 1/20/2014
                                lv_military_time = '';
                            }
                        }
                        else
                        {
                            production_date = 'FAIL';
                        }
                    }                    
                    //Pouch start from here.  || ProductLineCode == 'SP'                
                    else if(ProductLineCode == 'PC' || ProductLineCode == 'UU')
                    {
                        lv_month = '0';
                        first_char = traceCode.substring(0, 3);
                        first_number = traceCode.substring(3, 4);
                        second_char = traceCode.substring(4, 6);
                        second_number = traceCode.substring(6, 8);
                        third_char = traceCode.substring(8, 9);
                       
                       System.debug('-------first_char-------' + first_char);
                        System.debug('-------first_number-------' + first_number);
                        System.debug('-------second_char-------' + second_char);
                        System.debug('-------second_number-------' + second_number);
                        System.debug('-------third_char-------' + third_char);
                        if(first_number.isNumeric())
                        {
                            if((Integer.valueOf(second_char) >= 0 && Integer.valueOf(second_char) <= 23) && (Integer.valueOf(second_number) >= 0 && Integer.valueOf(second_number) <= 59))
                            {
                                lv_military_time = second_char + second_number;
                            }
                            else
                            {
                                lv_military_time = '';
                            }
                            charSet.clear();
                            charSet.add('N');
                            charSet.add('S');
                            charSet.add('H');
                            charSet.add('V');
                            charSet.add('I');
                            charSet.add('L');
                            charSet.add('E');
                            charSet.add('A');
                            charSet.add('B');
                            charSet.add('P');
                            charSet.add('Y');
                            charSet.add('O');
                            charSet.add('F');
                            charSet.add('G');
                            charSet.add('Z');
                            charSet.add('M');
                            charSet.add('R');
                            charSet.add('K');
                            charSet.add('W');
                            charSet.add('1');
                            charSet.add('X');
                            charSet.add('2');
                            charSet.add('3');
                            charSet.add('J');
                            if(!charSet.Contains(third_char.subString(0, 1)))
                            {
                                production_date = 'fail';
                            }
                            charSet.clear();
                            charset.add('N');
                            charset.add('S');
                            charset.add('H');
                            charset.add('V');
                            charset.add('I');
                            charset.add('L');
                            charset.add('E');
                            charset.add('2');
                            charset.add('3');
                            if(charSet.contains(third_char.substring(0, 1)))
                            {
                                system.debug('-----test-------');
                                charSet.clear();
                                charset.add('N');
                                charset.add('S');
                                charset.add('H');
                                charset.add('V');
                                charset.add('I');
                                charset.add('L');
                                charset.add('E');
                                charset.add('Q');
                                charset.add('C');
                                charset.add('D');
                                if(!charSet.contains(first_char.substring(0, 1)))
                                {
                                    production_date = 'FAIL';
                                }
                                charSet.clear();
                                charset.add('N');
                                charset.add('S');
                                charset.add('H');
                                charset.add('V');
                                charset.add('I');
                                charset.add('L');
                                charset.add('E');
                                charset.add('Q');
                                charset.add('C');
                                charset.add('D');
                                if(!charSet.contains(first_char.substring(1, 2)))
                                {
                                    production_date = 'FAIL';
                                }
                                charSet.clear();
                                charset.add('N');
                                charset.add('S');
                                charset.add('H');
                                charset.add('V');
                                charset.add('I');
                                charset.add('L');
                                charset.add('E');
                                charset.add('Q');
                                charset.add('C');
                                charset.add('D');
                                if(!charSet.contains(first_char.substring(2, 3)))
                                {
                                    production_date = 'FAIL';
                                }
                                
                                charSet.clear();
                                charset.add('N');
                                charset.add('S');
                                charset.add('H');
                                charset.add('V');
                                charset.add('I');
                                charset.add('L');
                                charset.add('E');
                                charset.add('Q');
                                charset.add('C');
                                charset.add('D');
                                system.debug('-------testt---'+first_char.substring(0, 1));
                                if(charSet.contains(first_char.substring(0, 1)))
                                {
                                    
                                    lv_location = 'Nashville';
                                    lv_date_code_rpt_factory = 'NS';
                                    system.debug('---------lv_location------'+lv_location);
                                }
                                
                                if(production_date != 'FAIL')
                                {
                                    first_char = first_char.replace('N', '0');
                                    first_char = first_char.replace('S', '1');
                                    first_char = first_char.replace('H', '2');
                                    first_char = first_char.replace('V', '3');
                                    first_char = first_char.replace('I', '4');
                                    first_char = first_char.replace('L', '5');
                                    first_char = first_char.replace('E', '6');
                                    first_char = first_char.replace('Q', '7');
                                    first_char = first_char.replace('C', '8');
                                    first_char = first_char.replace('D', '9');
                                    lv_month = first_char;
                                    system.debug('-------lv_month---------' + lv_month);
                                }
                            }
                            charSet.clear();
                            charSet.add('A');
                            charSet.add('B');
                            charSet.add('P');
                            charSet.add('Y');
                            charSet.add('O');
                            charSet.add('F');
                            charSet.add('G');
                            charSet.add('Z');
                            charSet.add('M');
                            charSet.add('R');
                            charSet.add('K');
                            charSet.add('W');
                            charSet.add('1');
                            charSet.add('X');
                            charSet.add('J');
                            if(charSet.contains(third_char.substring(0, 1)))
                            {
                                system.debug('-----third_charnew--' + third_char);
                                charSet.clear();
                                charSet.add('F');
                                charSet.add('R');
                                charSet.add('P');
                                charSet.add('K');
                                charSet.add('G');
                                charSet.add('Y');
                                charSet.add('M');
                                charSet.add('B');
                                charSet.add('O');
                                charSet.add('W');
                                if(!charSet.contains(first_char.substring(0, 1)))
                                {
                                    production_date = 'FAIL';
                                    system.debug('-----production_date1--' + production_date);
                                }
                                charSet.clear();
                                charSet.add('F');
                                charSet.add('R');
                                charSet.add('P');
                                charSet.add('K');
                                charSet.add('G');
                                charSet.add('Y');
                                charSet.add('M');
                                charSet.add('B');
                                charSet.add('O');
                                charSet.add('W');
                                if(!charSet.contains(first_char.substring(1, 2)))
                                {
                                    production_date = 'FAIL';
                                    system.debug('-----production_date2--' + production_date);
                                }
                                charSet.clear();
                                charSet.add('F');
                                charSet.add('R');
                                charSet.add('P');
                                charSet.add('K');
                                charSet.add('G');
                                charSet.add('Y');
                                charSet.add('M');
                                charSet.add('B');
                                charSet.add('O');
                                charSet.add('W');
                                if(!charSet.contains(first_char.substring(2, 3)))
                                {
                                    production_date = 'FAIL';
                                    system.debug('-----production_date3--' + production_date);
                                }
                                system.debug('-------------' + production_date);
                                if(production_date != 'FAIL')
                                {
                                    first_char = first_char.replace('F', '0');
                                    first_char = first_char.replace('R', '1');
                                    first_char = first_char.replace('P', '2');
                                    first_char = first_char.replace('K', '3');
                                    first_char = first_char.replace('G', '4');
                                    first_char = first_char.replace('Y', '5');
                                    first_char = first_char.replace('M', '6');
                                    first_char = first_char.replace('B', '7');
                                    first_char = first_char.replace('O', '8');
                                    first_char = first_char.replace('W', '9');
                                    lv_month = first_char;
                                    System.debug('-----lv_month-------' + lv_month);
                                }
                                charSet.clear();
                                charSet.add('F');
                                charSet.add('R');
                                charSet.add('P');
                                charSet.add('K');
                                charSet.add('G');
                                charSet.add('Y');
                                charSet.add('M');
                                charSet.add('B');
                                charSet.add('O');
                                charSet.add('W');
                                if(charSet.contains(first_char.substring(0, 1)))
                                {
                                    lv_location = 'Franklin Park';
                                    lv_date_code_rpt_factory = 'FP';
                                    System.debug('-----lv_location-------' + lv_location);
                                    System.debug('-----lv_date_code_rpt_factory-------' + lv_date_code_rpt_factory);
                                }
                            }
                            if(Integer.valueof(lv_month) <= 0 || Integer.valueof(lv_month) > 366)
                            {
                                production_date = 'FAIL';
                            }
                            lv_temp_year = '';
                            if((Integer.valueOf(first_number) >= 0 && Integer.valueOf(first_number) <= 9) && (Integer.valueOf(lv_month) <= 366 && Integer.valueOf(lv_month) > 0))
                            {
                                System.debug('------lvtempyear------');
                                if((System.today().year() - Integer.valueOf('201' + string.valueOf(first_number))) < 0)
                                {
                                    lv_temp_year = string.valueOf(lv_year.subString(3, 4)) + string.valueOf(first_number);
                                    system.debug('------lv_temp_year------' + lv_temp_year);
                                }
                                else
                                {
                                    lv_temp_year = string.valueOf(lv_cur_year.subString(2, 3)) + string.ValueOf(first_number);
                                    system.debug('------lv_temp_year------' + lv_temp_year);
                                }
                                lv_year = '01/01' + lv_year1 + lv_temp_year;
                                production_date = date.parse(lv_year).addDays(Integer.valueOf(lv_month) - 1).format();
                                system.debug('------production_date-------' + production_date);
                                ln_days = date.parse(production_date).daysBetween(System.today());
                                if(ln_days <= 0)
                                {
                                    production_date = 'FAIL';
                                }
                                if((integer.valueof(second_char) >= 0 && integer.valueof(second_char) <= 23) && (integer.valueof(second_number) >= 0 && integer.valueof(second_number) <= 59))
                                {
                                    lv_military_time = second_char + second_number;
                                    system.debug('------lv_military_time------' + lv_military_time);
                                }
                                else
                                {
                                    lv_military_time = '';
                                }
                            }
                            else
                            {
                                production_date = 'FAIL';
                            }
                        }
                        else
                        {
                            production_date = 'FAIL';
                        }
                    }
                }
                if((ustDateType != null && ustDateType == 'ZZZZ') && (ustDateCode != null && ustDateCode == 'ZZZZ'))
                {
                    if(ustDateType == 'MD' || ustDateType == 'GFU' || ustDateType == 'SB')
                    {
                        if(ustDateCode.length() == 9)
                        {
                            lv_ust_date_code = ustDateCode.substring(0, 3) + '' + ustDateCode.substring(3, 5) + '' + ustDateCode.substring(5, 9);
                        }
                        else
                        {
                            lv_ust_date_code = ustDateCode;
                        }
                    }
                    else if(ustDateType == 'CD')
                    {
                        if(ustDateCode.length() == 4)
                        {
                            lv_ust_date_code = ustDateCode.substring(0, 2) + '/' + ustDateCode.substring(2, 4);
                        }
                        else
                        {
                            lv_ust_date_code = ustDateCode;
                        }
                    }
                    else if(ustDateType == 'SN')
                    {
                        if(ustDateCode.length() == 5)
                        {
                            lv_ust_date_code = ustDateCode.substring(0, 2) + '' + ustDateCode.substring(2, 4) + '/' + ustDateCode.substring(4, 5);
                        }
                        else
                        {
                            lv_ust_date_code = ustDateCode;
                        }
                    }
                    else if(ustDateType == 'WB')
                    {
                        if(ustDateCode.length() == 5)
                        {
                            lv_ust_date_code = ustDateCode.substring(0, 2) + '' + ustDateCode.substring(2, 4) + '' + ustDateCode.substring(4, 6);
                        }
                        else
                        {
                            lv_ust_date_code = ustDateCode;
                        }
                    }
                }
            }
        }
        catch(Exception e)
        {
            System.debug('Warning:' + e +e.getLineNumber());
        }
        if(ProductLineCode == 'PT')
        {
            lv_location = 'Limerick';
            lv_date_code_rpt_factory = 'Limerick';
        }
        if(production_date == 'FAIL' || traceCode == null || traceCode.length() == 0)
        {
            traceCode = traceCode.trim();
            string codep = traceCode.substring(0, 1).toUpperCase();
            if((ProductLineCode == 'GP') && (traceCode != null && traceCode.length() != 5 && traceCode.length() != 11) && (codep.toUpperCase() == 'X'))
            {
                lv_location = 'LASA';
            }
            else
            {
                if(ProductLineCode == 'GP' && traceCode != null && traceCode.length() != 9 && traceCode.length() != 11 && traceCode.length() != 5 && (codep.toUpperCase() != 'X'))
                {
                    lv_location = 'Limerick';
                    lv_date_code_rpt_factory = 'Limerick';
                }
            }
            if(ProductLineCode == 'GP' && traceCode.length() == 5)
            {
                lv_location = 'Limerick';
                lv_date_code_rpt_factory = 'Limerick';
            }
            if(ProductLineCode == 'GP' && traceCode.length() == 8 && codep == 'J')
            {
                lv_location = 'Limerick';
                lv_date_code_cold_storage = 'Y';
            }
            if(ProductLineCode == 'GP' && traceCode.length() == 8 && codep == 'S')
            {
                lv_location = 'LASA';
                lv_date_code_cold_storage = 'Y';
            }
            if(ProductLineCode == 'GP' && (traceCode == null || traceCode.length() == 0))
            {
                lv_location = 'Unknown';
            }
            if(ProductLineCode == 'GP' && traceCode.length() == 11 && codep == 'W')
            {
                lv_location = 'PRECON';
                lv_date_code_cold_storage = 'Y';
            }
            if(ProductLineCode == 'GP' && traceCode.length() == 11 && codep == 'P')
            {
                lv_location = 'PRECON';
                lv_date_code_cold_storage = 'N';
            }
        }
        DateCodeObj.ProductionDate = production_date;
        DateCodeObj.DateCodeLocation = lv_location;
        DateCodeObj.DateCodeShift = lv_shift;
        DateCodeObj.DateCodeUnit = lv_unit;
        DateCodeObj.DateCodeColdStorage = lv_date_code_cold_storage;
        DateCodeObj.DateCodeRptBay = lv_date_code_rpt_bay;
        DateCodeObj.DateCodeRptFactory = lv_date_code_rpt_factory;
        DateCodeObj.DateCodeMilitaryTime = lv_military_time;
        DateCodeObj.UstDateCode = lv_ust_date_code;
        return DateCodeObj;
    }
    public date nextDay(string vDate, string vDay)
    {
        Integer I = 1;
        while (I <= 7)
        {
            Datetime dt = DateTime.newInstance(date.parse(vDate).addDays(I), Time.newInstance(0, 0, 0, 0));
            string wName = dt.format('EEEE');
            if(wName.toUpperCase() == vDay.toUpperCase())
            {
                return Date.parse(vDate).addDays(I);
            }
            I += 1;
        }
        return Date.parse(vDate).addDays(I);
    }
    public string mondayDate(string year, string WeekNumber)
    {
        Date startdate;
        Date enddate;
        Integer ctr;
        Date dt = Date.parse('01/01/' + Year).addMonths(-1);
        Date lastDate = Date.parse('12/31/' + string.valueOf(dt.year()));
        DateTime dtNew = DateTime.newInstance(lastDate, Time.newInstance(0, 0, 0, 0));
        string WeekName = dtNew.format('EEE').toUpperCase();
        if(WeekName == 'MON')
        {
            startdate = lastDate;
        }
        else if(WeekName == 'TUE')
        {
            startdate = lastDate.addDays(-1);
        }
        else if(WeekName == 'WED')
        {
            startdate = lastDate.addDays(-2);
        }
        else if(WeekName == 'THU')
        {
            startdate = lastDate.addDays(-3);
        }
        else if(WeekName == 'FRI')
        {
            startdate = lastDate.addDays(-4);
        }
        else if(WeekName == 'SAT')
        {
            startdate = lastDate.addDays(-5);
        }
        else
        {
            startdate = lastDate.addDays(-6);
        }
        enddate = Date.Parse('12/31/' + string.valueOf(Integer.ValueOf(Year) + 1));
        ctr = 1;
        while (enddate >= startdate)
        {
            if(Integer.valueOf(WeekNumber) == ctr)
            {
                break;
            }
            ctr += 1;
            startdate = startdate.addDays(7);
        }
        return startdate.format();
    }
    // Method One Start From here 
    public void methodOne()
    {
        if(ProductLineCode == 'TP' && Check2 == 'Subloop')
        {
            lv_month = '0';
            first_char = traceCode.substring(0, 3).toUppercase();
            first_number = traceCode.substring(3, 4);
            second_char = traceCode.substring(4, 6).toUppercase();
            second_number = traceCode.substring(6, 8);
            third_char = traceCode.substring(8, 9);
            if((first_number.isNumeric() && Integer.valueOf(first_number) == 1) && (second_char.isNumeric() && Integer.valueOf(second_char) == 1))
            {
                if((Integer.valueOf(second_char) < 0 && Integer.valueOf(second_char) > 23) || (Integer.valueOf(second_char) < 0 && Integer.valueOf(second_char) > 59))
                {
                    production_date = 'FAIL';
                }
                lv_military_time = second_char + second_number;
                charSet.clear();
                charSet.add('N');
                charSet.add('S');
                charSet.add('H');
                charSet.add('V');
                charSet.add('I');
                charSet.add('L');
                charSet.add('E');
                charSet.add('A');
                charSet.add('B');
                charSet.add('P');
                charSet.add('Y');
                charSet.add('O');
                charSet.add('F');
                charSet.add('G');
                charSet.add('Z');
                charSet.add('M');
                charSet.add('R');
                charSet.add('K');
                charSet.add('W');
                charSet.add('1');
                charSet.add('2');
                charSet.add('3');
                if(!charSet.contains(first_char.subString(0, 1)))
                {
                    production_date = 'FAIL';
                }
                charSet.clear();
                charSet.add('N');
                charSet.add('S');
                charSet.add('H');
                charSet.add('V');
                charSet.add('I');
                charSet.add('L');
                charSet.add('E');
                charSet.add('2');
                charSet.add('3');
                if(charSet.contains(third_char.substring(0, 1)))
                {
                    charSet.clear();
                    charSet.add('N');
                    charSet.add('S');
                    charSet.add('H');
                    charSet.add('V');
                    charSet.add('I');
                    charSet.add('L');
                    charSet.add('E');
                    charSet.add('Q');
                    charSet.add('C');
                    charSet.add('D');
                    if(!charSet.contains(first_char.substring(0, 1)))
                    {
                        production_date = 'FAIL';
                    }
                    if(!charSet.contains(first_char.substring(1, 2)))
                    {
                        production_date = 'FAIL';
                    }
                    if(!charSet.contains(first_char.substring(2, 3)))
                    {
                        production_date = 'FAIL';
                    }
                    if(production_date != 'FAIL')
                    {
                        lv_month = second_Char.replace('N', '0').replace('S', '1').replace('H', '2').replace('V', '3').replace('I', '4').replace('L', '5').replace('E', '6').replace('Q', '7').replace('C', '8').replace('C', '9');
                    }
                    lv_location = 'Nashville';
                    lv_date_code_rpt_factory = 'NS';
                }
                charSet.clear();
                charSet.add('A');
                charSet.add('B');
                charSet.add('P');
                charSet.add('Y');
                charSet.add('O');
                charSet.add('F');
                charSet.add('G');
                charSet.add('Z');
                charSet.add('M');
                charSet.add('R');
                charSet.add('K');
                charSet.add('W');
                charSet.add('1');
                charSet.add('X');
                if(charSet.contains(third_char.substring(1, 1)))
                {
                    charSet.clear();
                    charSet.add('F');
                    charSet.add('R');
                    charSet.add('P');
                    charSet.add('K');
                    charSet.add('G');
                    charSet.add('Y');
                    charSet.add('M');
                    charSet.add('B');
                    charSet.add('O');
                    charSet.add('W');
                    if(!charSet.contains(first_char.substring(0, 1)))
                    {
                        production_date = 'FAIL';
                    }
                    charSet.clear();
                    charSet.add('F');
                    charSet.add('R');
                    charSet.add('P');
                    charSet.add('K');
                    charSet.add('G');
                    charSet.add('Y');
                    charSet.add('M');
                    charSet.add('B');
                    charSet.add('O');
                    charSet.add('W');
                    if(!charSet.contains(first_char.substring(1, 2)))
                    {
                        production_date = 'FAIL';
                    }
                    charSet.clear();
                    charSet.add('F');
                    charSet.add('R');
                    charSet.add('P');
                    charSet.add('K');
                    charSet.add('G');
                    charSet.add('Y');
                    charSet.add('M');
                    charSet.add('B');
                    charSet.add('O');
                    charSet.add('W');
                    if(!charSet.contains(first_char.substring(2, 3)))
                    {
                        production_date = 'FAIL';
                    }
                    if(production_date != 'FAIL')
                    {
                        lv_month = second_Char.replace('F', '0').replace('R', '1').replace('P', '2').replace('K', '3').replace('F', '4').replace('Y', '5').replace('M', '6').replace('B', '7').replace('O', '8').replace('W', '9');
                    }
                    lv_location = 'Franklin Park';
                    lv_date_code_rpt_factory = 'FP';
                }
                if(Integer.valueOf(lv_month) > 366 || Integer.valueOf(lv_month) < 366)
                {
                    production_date = 'FAIL';
                }
                lv_temp_year = '';
                if((Integer.valueOf(first_number) > 0 && Integer.valueOf(first_number) < 9) && (Integer.valueOf(lv_month) <= 366 && Integer.valueOf(lv_month) > 0))
                {
                    lv_temp_year = null;
                    if(System.today().year() - Integer.ValueOf('201' + string.ValueOf(second_number)) < 0)
                    {
                        lv_temp_year = '0' + string.valueOf(second_number);
                    }
                    else
                    {
                        lv_temp_year = '1' + string.valueOf(second_number);
                    }
                    lv_year = '01/01' + lv_year1 + lv_temp_year;
                    production_date = string.ValueOf(date.parse(lv_year).adddays(Integer.valueOf(first_number) - 1));
                    ln_days = Date.parse(production_date).daysBetween(System.today());
                    if(ln_days <= 0)
                    {
                        production_date = 'FAIL';
                    }
                    lv_military_time = second_char + second_number;
                }
                else
                {
                    production_date = 'FAIL';
                }
            }
            else
            {
                production_date = 'FAIL';
            }
        }
    }
}