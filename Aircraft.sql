DROP TABLE IF EXISTS payment;
DROP TABLE IF EXISTS bill;
DROP TABLE IF EXISTS purchase;
DROP TABLE IF EXISTS expenditure;
DROP TABLE IF EXISTS charter_route;
DROP TABLE IF EXISTS route_distance;
DROP TABLE IF EXISTS expense;
DROP TABLE IF EXISTS crew;
DROP TABLE IF EXISTS charter;
DROP TABLE IF EXISTS earned_credentials;
DROP TABLE IF EXISTS employee_contact;
DROP TABLE IF EXISTS account;
DROP TABLE IF EXISTS service_package;
DROP TABLE IF EXISTS service;
DROP TABLE IF EXISTS customer;
DROP TABLE IF EXISTS credentials;
DROP TABLE IF EXISTS aircraft;
DROP TABLE IF EXISTS model;
DROP TABLE IF EXISTS employee;


CREATE TABLE employee (
	empNum INT, 
	name VARCHAR(20) NOT NULL,
	PRIMARY KEY (empNum)
)ENGINE InnoDB;

CREATE TABLE model(
	modelNum VARCHAR(15),
	hrlyWaitingCharge DECIMAL(6, 2),
	chargePerMile DECIMAL(6, 2),
	PRIMARY KEY (modelNum)
)ENGINE InnoDB;

CREATE TABLE aircraft(
	modelNum VARCHAR(15),
	aircraftNum VARCHAR(10),
	autoPilotAvailability BOOLEAN,
	yearsInservice INT(3),
	dateOfFirstLaunch DATE,
	PRIMARY KEY (aircraftNum, modelNum),
	INDEX (modelNum),
	FOREIGN KEY (modelNum) REFERENCES model (modelNum)
)ENGINE InnoDB;

CREATE TABLE credentials(
	credentialNum INT,
	credentialDescription VARCHAR(30),
	PRIMARY KEY (credentialNum)
)ENGINE InnoDB;

CREATE TABLE customer(
	id INT,
	name VARCHAR(20) NOT NULL,
	nbr INT,
	street VARCHAR(25),
	city VARCHAR(30),
	province VARCHAR(30),
	postalCode VARCHAR(7),
	methodOfPay CHAR(20),
	creditLimit INT,
	PRIMARY KEY (id)
)ENGINE InnoDB;

CREATE TABLE service(
	serviceNbr INT,
	description VARCHAR(50),
	unitCost DECIMAL(6,2),
	serviceProvider VARCHAR(30),
	providerLocation VARCHAR(25),
	PRIMARY KEY (serviceNbr)
)ENGINE InnoDB;

CREATE TABLE service_package(
	serviceNbr INT,
	packageNbr INT,
	PRIMARY KEY (serviceNbr, packageNbr),
	INDEX (serviceNbr),
	FOREIGN KEY (serviceNbr) REFERENCES service (serviceNbr),
	INDEX (packageNbr),
	FOREIGN KEY (packageNbr) REFERENCES service (serviceNbr)
)ENGINE InnoDB;

CREATE TABLE account(
	accountNum INT,
	customer_id INT,
	balance DECIMAL(13,2),
	startDate DATE,
	PRIMARY KEY (accountNum),
	INDEX (customer_id),
	FOREIGN KEY (customer_id) REFERENCES customer (id)
)ENGINE InnoDB;

CREATE TABLE employee_contact(
	empNum INT,
	location VARCHAR(25),
	phoneNumber VARCHAR(15),
	PRIMARY KEY (empNum),
	INDEX (empNum),
	FOREIGN KEY (empNum) REFERENCES employee (empNum)
)ENGINE InnoDB;

CREATE TABLE earned_credentials(
	empNum INT,
	credentialNum INT,
	certificationDate DATE,
	dateOfExpiry DATE,
	PRIMARY KEY (empNum, credentialNum),
	INDEX (empNum),
	FOREIGN KEY (empNum) REFERENCES employee (empNum),
	INDEX (credentialNum),
	FOREIGN KEY (credentialNum) REFERENCES credentials (credentialNum)
)ENGINE InnoDB;

CREATE TABLE charter(
	charter_id VARCHAR(20),
	customer_id INT,
	empNum INT,
	aircraftNum VARCHAR(10),
	fuelUsage VARCHAR(15),
	costOfFuel DECIMAL(10,2),
	PRIMARY KEY (charter_id, empNum, aircraftNum),
	INDEX (customer_id),
	FOREIGN KEY (customer_id) REFERENCES customer (id),
	INDEX (empNum),
	FOREIGN KEY (empNum) REFERENCES employee (empNum),
	INDEX (aircraftNum),
	FOREIGN KEY (aircraftNum) REFERENCES aircraft (aircraftNum)
)ENGINE InnoDB;

CREATE TABLE crew(
	charter_id VARCHAR(20),
	empNum INT,
	credentialNum INT,
	role VARCHAR(10),
	hrlyCharge DECIMAL(6,2),
	startDate DATE,
	endDate DATE,
	PRIMARY KEY (charter_id, empNum, credentialNum),
	INDEX (charter_id),
	FOREIGN KEY (charter_id) REFERENCES charter (charter_id),
	INDEX (empNum),
	FOREIGN KEY (empNum) REFERENCES employee (empNum),
	INDEX (credentialNum),
	FOREIGN KEY (credentialNum) REFERENCES credentials (credentialNum)
)ENGINE InnoDB;

CREATE TABLE expense(
	expenseNum INT,
	unitCost DECIMAL(7,2),
	description VARCHAR(40),
	typeOfExpense VARCHAR(20),
	PRIMARY KEY (expenseNum)
)ENGINE InnoDB;

CREATE TABLE route_distance(
	intermediateOrigin VARCHAR(20),
	intermediateDestination VARCHAR(20),
	distance DECIMAL(8,2),
	PRIMARY KEY (intermediateOrigin, intermediateDestination)
)ENGINE InnoDB;

CREATE TABLE charter_route(
	charter_id VARCHAR(20),
	intermediateOrigin VARCHAR(20),
	intermediateDestination VARCHAR(20),
	waitingTime TIME,
	PRIMARY KEY (charter_id),
	INDEX (charter_id),
	FOREIGN KEY (charter_id) REFERENCES charter (charter_id),
	INDEX (intermediateDestination),
	INDEX (intermediateOrigin),
	FOREIGN KEY (intermediateOrigin) REFERENCES route_distance (intermediateOrigin)
)ENGINE InnoDB;

CREATE TABLE expenditure(
	empNum INT,
	charter_id VARCHAR(20),
	expenseNum INT,
	quantity INT,
	dateOfExpense DATE,
	PRIMARY KEY (empNum, charter_id, expenseNum),
	INDEX (empNum),
	FOREIGN KEY (empNum) REFERENCES employee (empNum),
	INDEX (charter_id),
	FOREIGN KEY (charter_id) REFERENCES charter (charter_id),
	INDEX (expenseNum),
	FOREIGN KEY (expenseNum) REFERENCES expense (expenseNum)
)ENGINE InnoDB;

CREATE TABLE purchase(
	purchaseNum INT,
	serviceNbr INT,
	customer_id INT,
	date DATE,
	quantity INT,
	totalCost DECIMAL(10, 2),
	PRIMARY KEY (purchaseNum, serviceNbr, customer_id),
	INDEX (serviceNbr),
	FOREIGN KEY (serviceNbr) REFERENCES service (serviceNbr),
	INDEX (customer_id),
	FOREIGN KEY (customer_id) REFERENCES customer (id)
)ENGINE InnoDB;

CREATE TABLE bill(
	invoiceNum INT,
	purchaseNum INT,
	charter_id VARCHAR(20),
	invoiceDate DATE,
	invoiceAmount DECIMAL(10, 2),
	PRIMARY KEY (invoiceNum, purchaseNum, charter_id),
	INDEX (purchaseNum),
	FOREIGN KEY (purchaseNum) REFERENCES purchase (purchaseNum),
	INDEX (charter_id),
	FOREIGN KEY (charter_id) REFERENCES charter (charter_id)
)ENGINE InnoDB;

CREATE TABLE payment(
	invoiceNum INT,
	accountNum INT,
	customer_id INT,
	dateOfPayment DATE,
	amount DECIMAL(10, 2),
	PRIMARY KEY (invoiceNum, accountNum, customer_id),
	INDEX (invoiceNum),
	FOREIGN KEY (invoiceNum) REFERENCES bill (invoiceNum),
	INDEX (accountNum),
	FOREIGN KEY (accountNum) REFERENCES account (accountNum),
	INDEX (customer_id),
	FOREIGN KEY (customer_id) REFERENCES customer (id)
)ENGINE InnoDB;

INSERT INTO employee(empNum, name) VALUES (644801, 'Håvard');
INSERT INTO employee(empNum, name) VALUES (644802, 'Nikola');
INSERT INTO employee(empNum, name) VALUES (644803, 'Oleksandr');

INSERT INTO model VALUES ('SS505', 550.5, 1000.00); 
INSERT INTO model VALUES ('SP614', 750, 5000);
INSERT INTO model VALUES ('FD450', 1200, 9500);

INSERT INTO aircraft VALUES ('SS505', 'B740', false, 20, '1998/05/20');
INSERT INTO aircraft VALUES ('SP614', 'S230', true, 10, '2008/02/16');
INSERT INTO aircraft VALUES ('FD450', 'Z540', true, 5, '2013/01/02');

INSERT INTO credentials VALUES (6000574, 'FAA Airline Transport Pilot');
INSERT INTO credentials VALUES (7885204, 'FCC Radiotelephone Operator');
INSERT INTO credentials VALUES (2555121, 'EWO Aviation');

INSERT INTO customer VALUES (102650, 'Ladislav', 444, 'Poplar Chase Lane', 'Rexburg', 'Idaho', 83440, 'Direct Billing', 20000000);
INSERT INTO customer VALUES (506252, 'Robin', 56, 'Brackley Rd', 'Tiddington', 'Westbury', 'OX9 8GS', 'American Express', 500000000);
INSERT INTO customer VALUES (111111, 'Duncan', 60, 'Quay Street', 'Nash', 'Bulimba', 'MK1 4JQ', 'Direct Billing', 6500000);

INSERT INTO service VALUES (226532, 'On Board Champagne', 250.75 , 'WestLand', 'Australia');
INSERT INTO service VALUES (566252, 'Luxury Experience', 6000, 'Brooklyn Luxury Ltd', 'United Kingdom');
INSERT INTO service VALUES (264578, 'Satellite Phone and TV', 75.50, 'CK Satellite', 'Canada');

INSERT INTO service_package VALUES (226532, 226532);
INSERT INTO service_package VALUES (566252, 566252);
INSERT INTO service_package VALUES (264578, 264578);

INSERT INTO account VALUES (00748152, 102650, 45672218.74, '1995/06/17');
INSERT INTO account VALUES (00257413, 506252, 14625237.46, '2001/12/12');
INSERT INTO account VALUES (00653274, 111111, 574685200.12, '1984/03/01');

INSERT INTO employee_contact VALUES (644801, 'Sweden', '870604-1459');
INSERT INTO employee_contact VALUES (644802, 'Poland', '39061423811');
INSERT INTO employee_contact VALUES (644803, 'Czech Republic' , '516332525');

INSERT INTO earned_credentials VALUES (644801, 6000574, '2014/03/24', '2019/03/24');
INSERT INTO earned_credentials VALUES (644802, 7885204, '2010/05/21', '2020/05/21');
INSERT INTO earned_credentials VALUES (644803, 7885204, '2008/12/24', '2018/12/24');

INSERT INTO charter VALUES ('SF-9411', 102650, 644802, 'Z540', '614 mpg', 230.5);
INSERT INTO charter VALUES ('SS-2345', 111111, 644803, 'S230', '540 mpg', 180);

INSERT INTO crew VALUES ('SF-9411', 644802, 6000574, 'Onboard', 110.55, '2018/04/27', '2018/12/21');
INSERT INTO crew VALUES ('SS-2345', 644803, 2555121, 'Pilot', 220, '2012/12/03', '2019/11/24');

INSERT INTO expense VALUES (400512, 50, 'Bottle Champagne', 'Leisure');
INSERT INTO expense VALUES (400563, 23.75, 'Seven Star Cig', 'Leisure');
INSERT INTO expense VALUES (400745, 65.50, 'TV Remote Set', 'Technical');

INSERT INTO route_distance VALUES ('Ohio', 'Paris', 6447.03);
INSERT INTO route_distance VALUES ('Huston', 'Stockholm', 8387.90);
INSERT INTO route_distance VALUES ('Malmo', 'Ottawa', 5930);

INSERT INTO charter_route VALUES ('SF-9411', 'Ohio', 'Paris', '02:10:00');
INSERT INTO charter_route VALUES ('SS-2345', 'Huston', 'Stockholm', '05:05:00');


INSERT INTO expenditure VALUES (644803, 'SS-2345', 400563, 1, '2018/10/12');
INSERT INTO expenditure VALUES (644802, 'SS-2345', 400745, 1, '2018/11/15');

INSERT INTO purchase VALUES (455673, 226532, 111111, '2017/12/10', 5, 1407.60);
INSERT INTO purchase VALUES (455679, 566252, 102650, '2014/01/24', 1, 6274.38);

INSERT INTO bill VALUES (1000385, 455679, 'SS-2345', '2014/02/16', 6274.38);
INSERT INTO bill VALUES (1000385, 455679, 'SF-9411', '2006/05/27', 81.24);

INSERT INTO payment VALUES (1000385, 00653274, 111111, '2018/02/03', 1407.60);
INSERT INTO payment VALUES (1000385, 00748152, 102650, '2014/02/17', 6500);