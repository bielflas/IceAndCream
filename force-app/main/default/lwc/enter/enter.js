import { LightningElement, wire, api } from "lwc";
import { NavigationMixin } from "lightning/navigation";
import listFlavors from '@salesforce/apex/FlavorService.flavors';
import getClient from '@salesforce/apex/ClientService.getClient';
import getOrder from '@salesforce/apex/OrderService.getOrder';


export default class InputNameBase extends NavigationMixin(LightningElement) {

  picklistFlavors = [];
  selectedFlavor;

  @api tabName;
  @api label;
  @wire(listFlavors) flavors({error, data}){
      if(data){
        console.log(data);

        this.picklistFlavors = data.map(item => ({
          label: item.Name,
          value: item.Id
        }))
        if (this.picklistFlavors.length > 0) {
          this.selectedFlavor = this.picklistFlavors[0];
        }

        console.log('picklistFlavors: ', this.picklistFlavors);

      } else if (error){
        console.log(error);
      }
  };
  

    firstname;
    lastname;
    clientid;
    phone;
    a = true;
    b = false;
    c = false;
    testClient;
    createOrder;
    opp;
  

  input1(event) {
    this.firstname = event.target.value;
  }

  input2(event){
     this.lastname = event.target.value;
  }

  input3(event){
     this.phone = event.target.value;
  }

  input4(event){
     this.clientId = event.target.value;
  } 

  

  async botao1(){
    try{
      this.clientId = await getClient({
        'firstNameIn': this.firstname, 
        'lastNameIn': this.lastname, 
        'phoneIn': this.phone
      });
      console.log('Id do cliente encontrado ou criado', this.testClient);
      this.a = false;
      this.b = true;
      console.log(this.firstname + ' ' + this.lastname); 
    }
    catch(Error){
      console.log(Error);
      console.log(json.Stringfy(Error)); 
    }
  }

  handleSelectFlavor(event){
    this.selectedFlavor = event.detail.value;
    console.log(this.selectedFlavor)
  }



    async botao2(event){
      

      try{
        this.createOrder = await getOrder({
          icecreamId: this.selectedFlavor,
          clientId: this.clientId
        })

        console.log(this.createOrder);

        
        this.b = false;
        this.c = true; 

        console.log(this.selectedFlavor + ' ' + this.firstname);

        this[NavigationMixin.Navigate]({
            type: "standard__recordPage",
            attributes: {
              recordId: this.createOrder.Id,
              actionName: 'view' 
            },
          }
        );
      }

      catch(Error){
        console.log(Error);
        console.log(JSON.stringfy(Error)); 
      }
    }
  
}