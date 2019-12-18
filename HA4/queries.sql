/*part2 views implement*/
-- Query 1  correct
drop view shippedVsCustDemand;
create view shippedVSCustDemand as
	select C.customer as customer, C.item as item, NVL(sum(S.qty), 0) as suppliedQty, C.qty as demandQty
	from   customerDemand C, shipOrders S
    where   C.customer = S.recipient (+) and C.item = S.item (+)
    group by    C.customer, C.item, C.qty
    order by    C.customer, C.item;

-- Query 2  correct
drop view totalManufItems;
create view totalManufItems as
	select M.item as item, sum(M.qty) as totalManufQty
	from   manufOrders M
    group by M.item
    order by M.item;

-- Query 3
drop view matsUsedVsShipped;
create view matsUsedVsShipped as
	select R.manuf as manuf , R.matItem as matItem, R.requiredQty as requiredQty, NVL(sum(S.qty), 0) as shippedQty
	from (
		select M.manuf, B.matItem, sum(M.qty * B.qtyMatPerItem) as requiredQty
		from manufOrders M, billOfMaterials B
		where M.item = B.prodItem
		group by M.manuf, B.matItem) R, shipOrders S
	where R.manuf = S.recipient (+) and R.matItem = S.item (+)
	group by R.manuf, R.matItem, R.requiredQty
	order by manuf, matItem;

-- Query 4  correct
drop view producedVsShipped;
create view producedVsShipped as
	select	M.item as item, M.manuf as manuf, NVL(sum(S.qty), 0) as shippedOutQty, NVL(sum(M.qty), 0) as orderedQty
	from   manufOrders M, shipOrders S
    where   M.item = S.item (+) and M.manuf = S.sender (+)
    group by    M.item, M.manuf
    order by    M.item, M.manuf;


-- Query 5  correct
drop view suppliedVsShipped;
create view suppliedVsShipped as
	select	S.item as item, S.supplier as supplier, S.qty as suppliedQty, NVL(sum(S1.qty), 0) as shippedQty
	from   supplyOrders S, shipOrders S1
    where   S.item = S1.item (+) and S.supplier = S1.sender (+)
    group by    S.item, S.supplier, S.qty
    order by    S.item, S.supplier;

-- Query 6
drop view perSupplierCost;
create view perSupplierCost as
	select	R.supplier as supplier,
		case when R.CBD <= R.amt1 then R.CBD
		     when R.CBD > R.amt1 and R.CBD <= R.amt2 then (R.CBD - R.amt1) * (1 - R.disc1) + R.amt1
		     when R.CBD > R.amt2 then (R.CBD - R.amt2) * (1 - R.disc2) + (R.amt2 - R.amt1) * (1 - R.disc1) + R.amt1
	    end as cost
	from  	(select	SO.supplier, sum(SUP.ppu * SO.qty) CBD, S.amt1, S.disc1, S.amt2, S.disc2
		 	from	supplierDiscounts S, supplyOrders SO, supplyUnitPricing SUP
		 	where	SO.supplier = SUP.supplier and
				SO.item = SUP.item and
				S.supplier = SO.supplier
		 group by	SO.supplier, S.amt1, S.disc1, S.amt2, S.disc2) R
	group by R.supplier, R.CBD, R.amt1, R.disc1, R.amt2, R.disc2
	order by supplier;

-- Query 7
drop view perManufCost;
create view perManufCost as
	select	R.manuf as  manuf,
		case when R.CBD <= R.amt1 then R.CBD
		     when R.CBD > R.amt1 then (R.CBD - R.amt1) * (1 - R.disc1) + R.amt1
		end as cost
	from 	(select	MO.manuf, sum(MUP.prodCostPerUnit * MO.qty + MUP.setUpCost) CBD, M.amt1, M.disc1
			from	manufDiscounts M, manufOrders MO, manufUnitPricing MUP
			where	MO.manuf = MUP.manuf and
				MO.item = MUP.prodItem and
				M.manuf = MO.manuf
			group by MO.manuf, M.amt1, M.disc1) R
	group by	R.manuf, R.CBD, R.amt1, R.disc1
	order by	manuf;


-- Query 8
drop view perShipperCost;
create view perShipperCost as
	select	R3.shipper as shipper, sum(R3.Cost) as cost
	from (select	R2.shipper, R2.fromLoc, R2.toLoc,
		case when R2.CAD > R2.minPackagePrice then R2.CAD
	 	     else R2.minPackagePrice end as Cost
	from (select	R.shipper, R.fromLoc, R.toLoc,	R.minPackagePrice,
			case
				 when R.CBD <= R.amt1 then R.CBD
	     	     when R.CBD > R.amt1 and R.CBD <= amt2 then (R.CBD - R.amt1) * (1 - R.disc1) + R.amt1
	     	     when R.CBD > R.amt2 then (R.CBD - R.amt2) * (1 - R.disc2) + (R.amt2 - R.amt1) * (1 - R.disc1) + R.amt1
			end as CAD
		from (select	SO.shipper, S.fromLoc, S.toLoc, sum(S.pricePerLb * SO.qty * I.unitWeight) CBD, S.minPackagePrice, S.amt1, S.disc1, S.amt2, S.disc2
			from	shippingPricing S, shipOrders SO, busEntities B1, busEntities B2, items I
			where	SO.shipper = S.shipper and
				SO.sender = B1.entity and
				S.fromLoc = B1.shipLoc and
				SO.recipient = B2.entity and
				S.toLoc = B2.shipLoc and
				SO.item = I.item
			group by	SO.shipper, S.fromLoc, S.toLoc, S.minPackagePrice, S.amt1, S.disc1, S.amt2, S.disc2) R
		group by R.shipper, R.CBD, R.fromLoc, R.toLoc, R.minPackagePrice, R.amt1, R.disc1, R.amt2, R.disc2) R2) R3
	group by R3.shipper
	order by shipper;

-- Query 9
drop view totalCostBreakDown;
create view totalCostBreakDown as
	select supplyCost, manufCost, shippingCost,  (supplyCost + manufCost + shippingCost) as totalCost
	from (select	sum(S.cost) supplyCost
	      from	perSupplierCost S) Supplier,
	     (select 	sum(M.Cost) manufCost
	      from	perManufCost M) Manuf,
	     (select 	sum(PSC.Cost) shippingCost
	      from 	perShipperCost PSC) Shipper;

-- Query 10	correct
drop view customersWithUnsatisfiedDemand;
create view customersWithUnsatisfiedDemand as
	select	distinct customer as customer
	from shippedVsCustDemand
	where suppliedQty < demandQty
	order by customer;

-- Query 11	correct
drop view suppliersWithUnsentOrders;
create view suppliersWithUnsentOrders as
	select	distinct supplier as supplier
	from	suppliedVsShipped
	where	suppliedQty > shippedQty
	order by	supplier;

-- Query 12	correct
drop view manufsWoutEnoughMats;
create view manufsWoutEnoughMats as
	select	distinct manuf as manuf
	from	matsUsedVsShipped
	where 	requiredQty > shippedQty
	order by	manuf;

-- Query 13 correct
drop view manufsWithUnsentOrders;
create view manufsWithUnsentOrders as
	select	distinct manuf as manuf
	from	producedVsShipped
	where	shippedOutQty < orderedQty
	order by manuf;
