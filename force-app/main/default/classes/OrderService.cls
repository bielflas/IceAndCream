public with sharing class OrderService {
    public class OrderException extends Exception {}
        @AuraEnabled(cacheable=false) 
    public static Opportunity getOrder(Id icecreamId, Id clientId){ 
        PricebookEntry preco = [SELECT UnitPrice, ID FROM PricebookEntry WHERE Product2.Family = 'icecreamFlavors' AND Product2Id = :icecreamId LIMIT 1] ?? null; //* retorna o preço escolhido
        Product2 flavor = [SELECT Name FROM Product2 WHERE Family = 'icecreamFlavors' AND Id = :icecreamId LIMIT 1] ?? null; //* retorna o sabor escolhido
       
        if(flavor == null || preco == null){
            throw new AuraHandledException('Deu errado');   
        }

        if (clientId.getSObjectType() == Lead.SObjectType){ //* verifica se o cliente ja tem uma conta, ou se é Lead
            Database.LeadConvert leadConvert = new Database.LeadConvert(); //* um objeto pra ser chamado depois que contem
            leadConvert.setLeadId(clientId); //* o Id do cliente que não tem conta ainda
            
            LeadStatus converterStatus = [SELECT MasterLabel //* pegue o status
                                          FROM LeadStatus //* entre os status dos leads
                                          WHERE IsConverted = true LIMIT 1]; //* que o status seja = convertido
            //* converterStatus retorna sempre o status 'converted' mesmo quando tem ele tem diferentes nomes
            leadConvert.setConvertedStatus(converterStatus.MasterLabel); //* retomada do objeto que contem o ID do cliente recebendo 'convertido'
            leadConvert.setDoNotCreateOpportunity(true); //* naao criar oportunidade automaticamente!
            
            Database.LeadConvertResult leadConvertResult = Database.convertLead(leadConvert); //* converte o leadConvert de verdade
            clientId = leadConvertResult.getAccountId(); //* transforma o clientId no Id da nova conta que foi criada
        }

        Pricebook2 pricebook = [SELECT Id FROM Pricebook2 WHERE IsStandard = true LIMIT 1];

            Opportunity op = new Opportunity();
                op.Name = 'Pedido ' + flavor.Name;
                op.AccountId = clientId;
                op.Flavor__c = flavor.Name;
                op.StageName = 'Prospecting';
                op.CloseDate = Date.today();
                op.Pricebook2Id = pricebook.Id;
                insert op;

             OpportunityLineItem item = new OpportunityLineItem(
                OpportunityId    = op.Id,
                PricebookEntryId = preco.Id,
                UnitPrice        = preco.UnitPrice,
                Quantity         = 1)
            ;

             insert item;

                system.debug(op);   
                return op;
            }

       
        
        }
