public class ClientService {
    @AuraEnabled(cacheable=false)
    public static String getClient(String firstNameIn, String lastNameIn, String phoneIn) {
        List<Account> accountList = [SELECT Id, Name, phone FROM Account WHERE Name =: firstNameIn  LIMIT 1];
        List<Lead> leadList = [SELECT Id, firstName, lastName, Company, phone FROM Lead WHERE FirstName =: firstNameIn LIMIT 1];
        
        String clientId = (
            accountList.size() == 1 ? accountList[0].Id :
            leadList.size() == 1 ? leadList[0].Id :
            null
        );

        if(accountList.size() == 0 && leadList.size() == 0) {
            Lead lead = new Lead(firstName = firstNameIn, lastName = lastNameIn, Phone = phoneIn, Company = 'Nao informado');
            insert lead;
            clientId = lead.Id;
        }

        return clientId;

        //  if (clientId.getSObjectType() == Lead.SObjectType){ //* verifica se o cliente ja tem uma conta, ou se é Lead
        //     Database.LeadConvert leadConvert = new Database.LeadConvert(); //* um objeto pra ser chamado depois que contem
        //     leadConvert.setLeadId(clientId); //* o Id do cliente que não tem conta ainda
            
        //     LeadStatus converterStatus = [SELECT MasterLabel //* pegue o status
        //                                   FROM LeadStatus //* entre os status dos leads
        //                                   WHERE IsConverted = true LIMIT 1]; //* que o status seja = convertido
        //     //* converterStatus retorna sempre o status 'converted' mesmo quando tem ele tem diferentes nomes
        //     leadConvert.setConvertedStatus(converterStatus.MasterLabel); //* retomada do objeto que contem o ID do cliente recebendo 'convertido'
        //     leadConvert.setDoNotCreateOpportunity(true); //* naao criar oportunidade automaticamente!
            
        //     Database.LeadConvertResult leadConvertResult = Database.convertLead(leadConvert); //* converte o leadConvert de verdade
        //     clientId = leadConvertResult.getAccountId(); //* transforma o clientId no Id da nova conta que foi criada
        // }

        // return clientId;
    }
}
