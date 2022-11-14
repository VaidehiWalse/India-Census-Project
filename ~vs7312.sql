select * from project.dbo.data1;

select * from project.dbo.data2;

--number of rows into our dataset

select COUNT(*) from project.dbo.data1;
select COUNT(*) from project.dbo.data2;

--dataset for jharlhand and bihar

select * from Project..data1
Where state in ('Jharkhand','Bihar');

--total population of india

select sum (population) AS population from project..data2;

-- average growth of population 

select Avg (Growth)*100 AS Growth from project..data1;

--average growth population by state

select state,Avg(Growth)AS Avg_Growth from Project..data1
Group By State;

--average sex ratio by state

select state,Avg(Sex_Ratio) AS Avg_Sex_Ratio from Project..data1
Group By State;

--round the decimal number in the above query

select state,Round(Avg(Sex_Ratio),0)AS Avg_Sex_Ratio from Project..data1
Group By State;

--Arrange the above dataset in highest sex ratio--

Select state,Round(Avg(Sex_Ratio),0) AS Avg_Sex_Ratio From Project..data1
Group By State
Order By Avg_Sex_Ratio DESC;

--Average literacy Rate by State--

Select state,Round(Avg(Literacy),0) AS Avg_Literacy From Project..Data1
Group By State
Order By Avg_Literacy DESC;

--Get the Litercy rate by stategreater then 90--

Select state,Round(Avg(Literacy),0) As Avg_Literacy from Project..data1
Group By State
Having Round(Avg(Literacy),0)> 90
Order By Avg_Literacy DESC;

--Top 3 state with highest growth ratio--

Select top 3 state,Avg(Growth)*100 AS Avg_Growth From Project..data1
Group By State
Order By Avg_Growth DESC;

--Top 3 State with highest growth Ratio with Limit function--

Select state,Avg(Growth)*100 As Avg_Growth From Project..data1
Group By State
Order By Avg_Growth DESC
limit 3;

--Bottom 3 State Showing Lowest Sex Ratio

Select Top 3 state,Round(Avg(Sex_Ratio),0) AS Avg_Sex_Ratio From Project..data1
Group By State
Order By Avg_Sex_Ratio ASC;

--Top and Bottom 3 States in literacy State in a table--

drop table if exists #TopStates
Create Table #TopStates
(
State nvarchar(255),
topstate float
);

Insert Into #TopStates
Select State,Round(Avg(Literacy),0) As Avg_Literacy From Project..data1
Group By State
Order By Avg_Literacy desc;
 
Select top 3 * From #TopStates Order by #TopStates.topstate desc;

--for bottom 3 states --

Drop table if exists #BottomStates;
Create Table #BottomStates
(
State nvarchar(255),
BottomState Float
)
Insert Into #BottomStates
Select State,Round(Avg(Literacy),0) AS Avg_Literacy From Project..data1
Group by State
Order by Avg_Literacy Asc;

Select Top 3 * from #BottomStates Order By #BottomStates.BottomState Asc;

-- put the 2 table output into a single output --
--union operator--

select * from
(Select top 3 * From #TopStates Order by #TopStates.topstate desc) a
UNION
Select * from 
(Select Top 3 * from #BottomStates Order By #BottomStates.BottomState Asc)b
;

--States Starting with letter'a'--

Select distinct State from Project..data1 
Where State Like 'a%';

--States starting with letter 'a' and 'b'

Select Distinct State from Project..data1
Where State Like 'a%' or State Like 'b%';

--States starting with letter 'a' and and ending with 'm'

Select Distinct State From Project..data1
Where State Like 'a%' AND State Like '%m' ;

--Joining 2 tables data1 , data2  with inner join--
--Total male and female 

Select d.State,sum(d.Male) Total_Male ,sum(d.Female) Total_Female from
(Select c.District,c.State,round(c.Population/(c.Sex_Ratio+1),0)AS  Male,round((c.Population*c.Sex_Ratio)/(c.Sex_Ratio+1),0) AS Female from
(Select a.District,a.State,a.Sex_Ratio/1000 AS Sex_Ratio,b.Population From Project..data1 a
Inner join Project..data2  b
On a.District = b.District)c )d
Group by State;

--Total Literacy rate--

Select d.State,Sum(d.Total_Literate),Sum(d.Total_Illerate) from
(Select c.District,c.State,round(c.Literacy_Ratio*c.Population,0) Total_Literate,round((1-c.Literacy_Ratio)*c.Population,0) Total_Illerate from 
(Select a.District,a.State,a.Literacy/100 Literacy_Ratio,b.Population From Project..data1 a
Inner join Project..data2  b
On a.District = b.District) c )d
Group By d.State;

--Population in previous Census--

Select Sum(e.Previous_Census) AS Previous_Census_pop, Sum(e.Recent_Population) AS Recent_Population_pop from(
Select d.State, Sum(d.Previous_Census) Previous_Census,Sum(d.Recent_Population)Recent_Population From
(Select c.District,c.State,round(c.Population/(1+c.Growth_Rate),0) Previous_Census,c.Population Recent_Population From 
(Select a.District,a.State,a.Growth Growth_Rate,b.Population from Project..Data1 a Inner Join Project..data2 b 
on a.District=b.District)c)d
Group By d.State)e;


--top 3 districts from each state with highest literacy rate

Select a.* from
(Select district,state,literacy,rank() over(Partition by State order by Literacy DESC) Rank From Project..data1) a
Where a.rank in (1,2,3) 
Order by State;



