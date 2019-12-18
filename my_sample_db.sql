
drop table items cascade constraints;

create table items (
   item char(9),
   unitWeight number(4),
   primary key(item) 
); 
--prodItem
insert into items values ( 'table' , 50);
insert into items values ( 'desk' , 60);
--matItem
insert into items values ( 'leg' , 5);
insert into items values ( 'table_top' , 20);
insert into items values ( 'desk_top' , 30);

--my item
insert into items values ( 'laptop' , 1);


drop table busEntities cascade constraints;
create table busEntities (
   entity char(25),
   shipLoc char(9),
   address varchar(20),
   phone number(10),
   web varchar(20),
   contact char(10),
   primary key(entity)
); 

--customer
insert into BUSENTITIES values ( 'customer1' , 'NYC', 'add1', 5654823651, 'web1','con1');
insert into BUSENTITIES values ( 'customer2' , 'NYC', 'add2', 5654823652, 'web2','con2');
--manufacturer
insert into BUSENTITIES values ( 'manufacturer1' , 'Boston', 'add3',6234211231, 'web3','con3');
insert into BUSENTITIES values ( 'manufacturer2' , 'DC', 'add4', 6234211232,'web4','con4');
--supplier
insert into BUSENTITIES values ( 'supplier1' , 'Boston', 'add5', 8734211231,'web5','con5');
insert into BUSENTITIES values ( 'supplier2' , 'DC', 'add6', 8734211232,'web6','con6');
insert into BUSENTITIES values ( 'supplier3' , 'NYC', 'add7', 8734982743,'web7','con7');
insert into BUSENTITIES values ( 'supplier4' , 'Boston', 'add8', 3824938748,'web8','con8');
--shipper
insert into BUSENTITIES values ( 'Fedex' , 'Chicago', 'add9', 1382938432,'web9','con9');
insert into BUSENTITIES values ( 'UPS' , 'Boston', 'add10', 8373921234,'web10','con10');


drop table billOfMaterials cascade constraints;
create table billOfMaterials(
prodItem char(9), 
matItem char (9), 
QtyMatPerItem number(3),
primary key(prodItem, matItem),
foreign key(prodItem) references items(item),
foreign key(matItem) references items(item)
);
insert into BILLOFMATERIALS values('table' , 'leg', 4);
insert into BILLOFMATERIALS values('table' , 'table_top', 1);

insert into BILLOFMATERIALS values('desk' , 'leg', 3);
insert into BILLOFMATERIALS values('desk' , 'desk_top', 1);



drop table supplierDiscounts cascade constraints;
create table supplierDiscounts
(supplier char(25), 
amt1 number(5), 
disc1 decimal(7,2), 
amt2 number(5), 
disc2 decimal(7,2),
primary key(supplier));


insert into supplierDiscounts values('supplier1' , 300, 0.03, 800, 0.10);
insert into supplierDiscounts values('supplier2' , 500, 0.07, 1000, 0.15);
insert into supplierDiscounts values('supplier3' , 500, 0.10, 1500, 0.20);
insert into supplierDiscounts values('supplier4' , 1000, 0.15, 2000, 0.25);

drop table supplyUnitPricing;
create table supplyUnitPricing(supplier char(9), 
item char(9), 
ppu number(4),
primary key(supplier,item),
foreign key(item) references items(item));


insert into supplyUnitPricing values( 'supplier1','table' , 25);
insert into supplyUnitPricing values( 'supplier1','desk' , 40);
insert into supplyUnitPricing values( 'supplier1','leg' , 2);
insert into supplyUnitPricing values( 'supplier1','table_top' , 7);
insert into supplyUnitPricing values( 'supplier1','desk_top' , 11);

insert into supplyUnitPricing values( 'supplier2','table' , 23);
insert into supplyUnitPricing values( 'supplier2','desk' , 38);
insert into supplyUnitPricing values( 'supplier2','leg' , 2);
insert into supplyUnitPricing values( 'supplier2','table_top' , 6);
insert into supplyUnitPricing values( 'supplier2','desk_top' , 10);

insert into supplyUnitPricing values( 'supplier3','table' , 30);
insert into supplyUnitPricing values( 'supplier3','desk' , 39);
insert into supplyUnitPricing values( 'supplier3','leg' , 2);
insert into supplyUnitPricing values( 'supplier3','table_top' , 8);
insert into supplyUnitPricing values( 'supplier3','desk_top' , 10);

insert into supplyUnitPricing values( 'supplier4','table' , 21);
insert into supplyUnitPricing values( 'supplier4','desk' , 45);
insert into supplyUnitPricing values( 'supplier4','leg' , 3);
insert into supplyUnitPricing values( 'supplier4','table_top' , 4);
insert into supplyUnitPricing values( 'supplier4','desk_top' , 15);

drop table manufDiscounts cascade constraints;
create table manufDiscounts(
manuf char(25), 
amt1 number(4), 
disc1 number(4),
primary key(manuf));

insert into manufDiscounts values('manufacturer1' , 500, 0.05);
insert into manufDiscounts values('manufacturer2' , 1000, 0.10);


drop table manufUnitPricing;
create table manufUnitPricing
(manuf char(25), 
prodItem char(9), 
setUpCost number(5), 
prodCostPerUnit number(5),
primary key(manuf,prodItem),
foreign key(prodItem) references items(item)
);

insert into MANUFUNITPRICING values( 'manufacturer1','table' , 10,20);
insert into MANUFUNITPRICING values( 'manufacturer1','desk' , 8,32);

insert into MANUFUNITPRICING values( 'manufacturer2','table' , 15,19);
insert into MANUFUNITPRICING values( 'manufacturer2','desk' , 12,30);


 drop table shippingPricing;
 create table shippingPricing(
 shipper char(9), 
 fromLoc  char(9), 
 toLoc char(9), 
 minPackagePrice number(5), 
 pricePerLb number(9), 
 amt1 number(9), 
 disc1 number(9), 
 amt2 number (9), 
 disc2 number(9),
 primary key (shipper, fromLoc, toLoc));
 
 insert into SHIPPINGPRICING values ( 'Fedex' , 'NYC', 'NYC',20, 1, 100,0.05,500,0.15);
 insert into SHIPPINGPRICING values ( 'Fedex' , 'NYC', 'Boston',100, 2, 50,0.02,100,0.1);
 insert into SHIPPINGPRICING values ( 'Fedex' , 'NYC', 'DC', 80, 2,100,0.10,500,0.20);
 insert into SHIPPINGPRICING values ( 'Fedex' , 'Boston', 'NYC', 90, 1.5, 60,0.05,150,0.10);
 insert into SHIPPINGPRICING values ( 'Fedex' , 'Boston', 'Boston',20, 1,50,0.05,140,0.15);
 insert into SHIPPINGPRICING values ( 'Fedex' , 'Boston', 'DC',60, 1.2, 200,0.15,400,0.20);
 insert into SHIPPINGPRICING values ( 'Fedex' , 'DC', 'NYC',70, 1.2, 200,0.15,400,0.20);
 insert into SHIPPINGPRICING values ( 'Fedex' , 'DC', 'Boston',110, 2,120,0.10,240,0.18);
 insert into SHIPPINGPRICING values ( 'Fedex' , 'DC', 'DC',10, 0.8,200,0.10,400,0.20);

 insert into SHIPPINGPRICING values ( 'UPS' , 'NYC', 'NYC',20, 1, 100,0.1,500,0.2);
 insert into SHIPPINGPRICING values ( 'UPS' , 'NYC', 'Boston',100, 2, 50,0.02,100,0.15);
 insert into SHIPPINGPRICING values ( 'UPS' , 'NYC', 'DC', 80, 2,100,0.05,500,0.25);
 insert into SHIPPINGPRICING values ( 'UPS' , 'Boston', 'NYC', 90, 1.5, 60,0.02,150,0.15);
 insert into SHIPPINGPRICING values ( 'UPS' , 'Boston', 'Boston',20, 1,50,0.02,140,0.20);
 insert into SHIPPINGPRICING values ( 'UPS' , 'Boston', 'DC',60, 1.2, 200,0.10,400,0.25);
 insert into SHIPPINGPRICING values ( 'UPS' , 'DC', 'NYC',70, 1.2, 200,0.10,400,0.25);
 insert into SHIPPINGPRICING values ( 'UPS' , 'DC', 'Boston',110, 2,120,0.05,250,0.25);
 insert into SHIPPINGPRICING values ( 'UPS' , 'DC', 'DC',10, 0.8,200,0.05,400,0.25);
 
 drop table customerDemand;
 create table customerDemand(
 customer char(9), 
 item char(9), 
 qty number(5),
 primary key(customer, item),
 foreign key(item) references items(item));
 
 insert into CUSTOMERDEMAND values ( 'customer1' , 'table', 50);
 insert into CUSTOMERDEMAND values ( 'customer1' , 'desk', 100);

 insert into CUSTOMERDEMAND values ( 'customer2' , 'table', 20);
 insert into CUSTOMERDEMAND values ( 'customer2' , 'desk', 30);
       

   
 
 
 drop table supplyOrders;
 create table supplyOrders(
 item char(9), 
 supplier char(25), 
 qty number(5),
 primary key(item, supplier),
 foreign key(item) references items(item),
 foreign key(supplier) references BUSENTITIES(entity)
 );
 
 insert into supplyOrders values('table' , 'supplier1', 10);

 insert into supplyOrders values('desk' , 'supplier1', 50);
 insert into supplyOrders values('desk' , 'supplier2', 20);

 insert into supplyOrders values('leg' , 'supplier1', 100);
 insert into supplyOrders values('leg' , 'supplier2', 100);
 insert into supplyOrders values('leg' , 'supplier3', 280);

 insert into supplyOrders values('table_top' , 'supplier1', 20);
 insert into supplyOrders values('table_top' , 'supplier4', 40);

 insert into supplyOrders values('desk_top' , 'supplier2', 50);
 insert into supplyOrders values('desk_top' , 'supplier4', 30);
 


drop table manufOrders;
create table manufOrders(
item char(9), 
manuf char(25), 
qty number(6),
primary key(item, manuf),
 foreign key(item) references items(item),
 foreign key(manuf) references BUSENTITIES(entity));
 
 insert into manufOrders values('table' , 'manufacturer1', 40);
 insert into manufOrders values('table' , 'manufacturer2', 20);

 insert into manufOrders values('desk' , 'manufacturer1', 30);
 insert into manufOrders values('desk' , 'manufacturer2', 50);
 
 
 drop table shipOrders;
 create table shipOrders(
 item char(9), 
 shipper char(9), 
 sender char(25), 
 recipient char(25), 
 qty number(6),
 primary key(item, shipper, sender, recipient),
 foreign key(item) REFERENCES items(item),
 foreign key(sender) REFERENCES BUSENTITIES(entity),
 foreign key(recipient) REFERENCES BUSENTITIES(entity));
 
  --for matItems(send to manufacturer)
  insert into SHIPORDERS values('leg','Fedex' , 'supplier1', 'manufacturer1',100);
  insert into SHIPORDERS values('leg','Fedex' , 'supplier3', 'manufacturer1',100);
  insert into SHIPORDERS values('leg','UPS' , 'supplier2', 'manufacturer1',50);
  insert into SHIPORDERS values('table_top','UPS' , 'supplier4', 'manufacturer1',40);
  insert into SHIPORDERS values('desk_top','Fedex' , 'supplier4', 'manufacturer1',30);

  insert into SHIPORDERS values('leg','UPS' , 'supplier2', 'manufacturer2',230);
  insert into SHIPORDERS values('table_top','Fedex' , 'supplier1', 'manufacturer2',20);
  insert into SHIPORDERS values('desk_top','UPS' , 'supplier2', 'manufacturer2',50);

  --for prodItems(send to customer)
  insert into SHIPORDERS values('table','Fedex' , 'manufacturer1', 'customer1',40);
  insert into SHIPORDERS values('table','Fedex' , 'supplier1', 'customer1',10);
  insert into SHIPORDERS values('desk','UPS' , 'manufacturer2', 'customer1',50);
  insert into SHIPORDERS values('desk','UPS' , 'supplier1', 'customer1',50);

  insert into SHIPORDERS values('table','Fedex' , 'manufacturer2', 'customer2',20);
  insert into SHIPORDERS values('desk','Fedex' , 'supplier2', 'customer2',20);
  insert into SHIPORDERS values('desk','Fedex' , 'manufacturer1', 'customer2',30);

