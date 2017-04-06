//Acxiom Request and Response classes

Public class AcxiomClasses{

    public class TokenInfo{
        public string access_token;
        public string token_type;
        public string expires_in; 
    }
    
    public class FullSearchLookupRequest{
        public string OwnerCd;
        public string ListCd;
        public string Title;
        public string FirstName;
        public string MiddleName;
        public string LastName;
        public string Suffix;
        public AddressRequest Address;
        public string DateOfBirth;  //MM/DD/YYYY,
        public string Gender;
        
        public  FullSearchLookupRequest(){
            Address = new AddressRequest();
        } 
    
    }
    
    public class AddressRequest{
        public string AddressLine1;
        public string AddressLine2;
        public string City;
        public string State;
        public string Zip;
        public string ZipPlus4;    
    }
    


    public class ConsumerFinalResponse{
        public string RequestId;
        public string CCN;
        public string WinningCCN;
        public string intTransactionId;        
        public string strOpCo;
        public string dtDOB;
        public string strAVCode;
        public string strAVOwner;
        public string Title;
        public string Fname;
        public string Lname;
        public string Addr1;
        public string City;
        public string State;
        public string Zip;
        public string Zip4; 
        public string strLexisNexisId;
        public string strConsumerAuthCd;
        public string StatusCode;
        public string StatusMessage;
        public string ConsumerMessage;   
    }
    
    
    public class ConsumerFullSearchResponse{
        public string RequestId;
        public string CCN;
        public string WinningCCN;
        public FullSearchInner FullSearch;
        public List<statusClass> StatusData;
        
        public ConsumerFullSearchResponse(){
            FullSearch = new FullSearchInner();
            StatusData = new List<statusClass>();
        }
    }
    
    public class statusClass{
        public string StatusCode;
        public string StatusMessage;
        public string ConsumerMessage;
    }
    
    
    public class FullSearchInner{
        public QualificationData objQualificationData;
        public ChannelData objChannelData;
        public AuthenticationData objAuthenticationData;
        public string intTransactionId;
        
        public FullSearchInner(){
            objQualificationData = new QualificationData();
            objChannelData = new ChannelData();
            objAuthenticationData = new AuthenticationData();
        }
    }
    
    public class QualificationData{
        public List<QualificationInner> aObjOpCoQualification;
        
        public QualificationData(){
            aObjOpCoQualification = new List<QualificationInner>();
        }
    }

    public class QualificationInner{
        public string strOpCo;
        public string dtDOB;
        public string strAVCode;
        public string strAVOwner;
    }
    
    public class ChannelData{
        public List<Channel> aObjChannel;
        
        public ChannelData(){
            aObjChannel = new List<Channel>();
        }
    }
    
    public class Channel{
        public List<ChannelLevel> aObjChannelLevel;
        
        public Channel(){
            aObjChannelLevel =  new List<ChannelLevel>();
        } 
    }
    
    public class ChannelLevel{
        public List<AddressType> aObjAddressType;
        public ChannelLevel(){
            aObjAddressType = new List<AddressType>();
        }
    }
    
    
    public class AddressType{
        public List<contact> aObjContactInfo;
        
        public AddressType(){
            aObjContactInfo = new List<contact>();
        }
    }    
     
    public class contact{
        public  string strName;
        public  string strValue;
    }
    
    public class AuthenticationData{
        public string strLexisNexisId;
        public string strConsumerAuthCd;
    }
    
    public class CCNLookupRequest{
        public string CCN;
    }
    
    public class CCNLookupFinalResponse{
        public string RequestId;
        public string CCN;
        public string WinningCCN;
        public string intTransactionId;        
        public string strOpCo;
        public string dtDOB;
        public string strAVCode;
        public string strAVOwner;
        public string Title;
        public string Fname;
        public string Lname;
        public string Addr1;
        public string City;
        public string State;
        public string Zip;
        public string Zip4; 
        public string strLexisNexisId;
        public string strConsumerAuthCd;
        public string StatusCode;
        public string StatusMessage;
        public string ConsumerMessage;
        public boolean showLocalData;   
    }
    
    public class CCNLookupResponse{
        public string RequestId;
        public string CCN;
        public string WinningCCN;
        public CCNLookupInner CcnLookup;
        public List<statusClass> StatusData;
        
        public CCNLookupResponse(){
            CcnLookup = new CCNLookupInner();
            StatusData = new List<statusClass>();
        }
     }
    
     public class CCNLookupInner{
        public QualificationData objQualificationData;
        public ChannelData objChannelData;
        public AuthenticationData objAuthenticationData;
        public string intTransactionId;
        
        public CCNLookupInner(){
            objQualificationData = new QualificationData();
            objChannelData = new ChannelData();
            objAuthenticationData = new AuthenticationData();
        }
    }
}