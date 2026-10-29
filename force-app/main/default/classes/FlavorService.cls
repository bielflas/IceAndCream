public class FlavorService{
    @AuraEnabled(cacheable=true)
    public static List<Product2> flavors() {
        List<Product2> listFlavors = [SELECT Name, Id FROM Product2 WHERE Family = 'icecreamFlavors' AND IsActive = true];
        return listFlavors;
    }
}