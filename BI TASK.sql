
-- On-Boarding Task

--Number 1a

SELECT 
p.name AS PropertyName,
p.Id AS PropertyId,
op.ownerid AS OwnerId
from Property p
INNER JOIN Ownerproperty op ON p.id = op.propertyid
Where OwnerId =1426


--Number 1b

SELECT 
p.name AS PropertyName,
pf.CurrentHomeValue AS CurrentValue
from OwnerProperty op
INNER JOIN Property p ON  op.PropertyId = p.Id
INNER JOIN PropertyFinance pf ON  op.PropertyId = pf.PropertyId
Where op.OwnerId =1426 


--Number 1c i

select 
p.[Name] AS PropertyName,
tp.PaymentAmount AS PaymentAmount,
tp.PaymentFrequencyId AS PaymentFrequencyId,
pf.[Name] AS PaymentFrequency,
tp.StartDate AS TenantStartdate,
tp.EndDate AS TenantEnddate,
CASE WHEN tp.PaymentFrequencyId=1
	     THEN SUM(tp.PaymentAmount * (DATEDIFF(WEEK, tp.startdate, tp.enddate)))
	 WHEN tp.paymentfrequencyId=2
	     THEN SUM(tp.PaymentAmount/2 * (DATEDIFF(WEEK, tp.StartDate,tp.EndDate)))
     WHEN tp.paymentfrequencyId=3
	 AND
	 DAY(tp.StartDate) > DAY(tp.EndDate) THEN SUM(tp.PaymentAmount* (DATEDIFF(MONTH, tp.startdate, tp.EndDate)))
	 ELSE SUM(tp.PaymentAmount * (DATEDIFF(MONTH, tp.StartDate,tp.EndDate)+1))
	 END AS TotalPayment
FROM Property p
INNER JOIN OwnerProperty op ON p.Id = op.PropertyId
INNER JOIN TenantProperty tp ON op.PropertyId = tp.PropertyId
INNER JOIN TenantPaymentFrequencies pf ON tp.PaymentFrequencyId =pf.Id
Where op.OwnerId =1426
GROUP BY p.[Name],
		 tp.PaymentAmount,
		 tp.PaymentFrequencyId,
		 pf.[Name],
		 tp.StartDate,
		 tp.EndDate

-- Number 1c ii
select 
p.[Name] AS PropertyName,
tp.PaymentAmount AS PaymentAmount,
tp.PaymentFrequencyId AS PaymentFrequencyId,
tpf.[Name] AS PaymentFrequency,
tp.StartDate AS TenantStartdate,
tp.EndDate AS TenantEnddate,
pf.yield AS Yield,
CASE WHEN tp.PaymentFrequencyId=1
	     THEN SUM(tp.PaymentAmount * (DATEDIFF(WEEK, tp.startdate, tp.enddate)))
	 WHEN tp.paymentfrequencyId=2
	     THEN SUM(tp.PaymentAmount/2 * (DATEDIFF(WEEK, tp.StartDate,tp.EndDate)))
     WHEN tp.paymentfrequencyId=3
	 AND
	 DAY(tp.StartDate) > DAY(tp.EndDate) THEN SUM(tp.PaymentAmount* (DATEDIFF(MONTH, tp.startdate, tp.EndDate)))
	 ELSE SUM(tp.PaymentAmount * (DATEDIFF(MONTH, tp.StartDate,tp.EndDate)+1))
	 END AS TotalPayment
FROM Property p
INNER JOIN OwnerProperty op ON p.Id = op.PropertyId
INNER JOIN TenantProperty tp ON op.PropertyId = tp.PropertyId
INNER JOIN TenantPaymentFrequencies tpf ON tp.PaymentFrequencyId =tpf.Id
INNER JOIN  PropertyFinance pf ON tp.PropertyId =pf.PropertyId
Where op.OwnerId =1426
GROUP BY p.[Name],
		 tp.PaymentAmount,
		 tp.PaymentFrequencyId,
		 tpf.[Name],
		 tp.StartDate,
		 tp.EndDate,
		 pf.Yield


--Number 1d
 
 SELECT
 p.[Name] AS PropertyName,
 js.[Name] AS JobStatus,
 jr.Title AS Title
FROM OwnerProperty op
inner join Property p ON op.PropertyId= p.id 
inner join job j on p.id = j.PropertyId
INNER JOIN TenantJobRequest jr ON j.JobRequestId = jr.Id
INNER JOIN TenantJobStatus js ON jr.JobStatusId = js.Id
where op.OwnerId =1426 AND js.Name = 'open'



--Number 1e
 
 SELECT
 pp.[Name] AS PropertyName,
 p.FirstName,
 p.LastName,
 tp.PaymentAmount AS Amount,
 tpf.[Name] AS PaymentFrequency
 FROM Person p
 inner join Tenant t on p.PhysicalAddressId =t.ResidentialAddress
 inner join TenantProperty tp on t.Id = tp.TenantId
 inner join Property pp ON tp.PropertyId = pp.Id
 inner join OwnerProperty op ON pp.id = op.PropertyId
 inner join TenantPaymentFrequencies tpf on tp.PaymentFrequencyId =tpf.Id
 where OwnerId= 1426 and tp.IsActive =1

 --QUESTION 2
select
pe.description AS Expense,
concat(pp.FirstName, ' ', pp.LastName) AS CurrentOwner,
case 
     when p.bedroom =2 and p.bathroom = 2 then '2 Bedrooms, 2 Bathrooms'
	 end as PropertyDetails,
concat(ad.number, ' ', ad.street) AS PropertyAddress,
pe.Amount,
CONVERT(VARCHAR, pe.Date, 106) AS Date
from property p 
inner join propertyexpense pe on p.id = pe.propertyid
inner join address ad on p.addressid= ad.addressid
inner join PropertyRentalPayment rp on p.id = rp.PropertyId
inner join OwnerProperty op on p.id =op .PropertyId
inner join person pp on op.OwnerId =pp.id
where p.name= 'property a'