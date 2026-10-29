import { LightningElement, wire } from 'lwc';
import listFlavors from '@salesforce/apex/FlavorService.flavors';


export default class IceandCream extends LightningElement {
    @wire(listFlavors) flavors;

    
    
}

