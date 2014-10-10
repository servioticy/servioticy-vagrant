/*******************************************************************************
 * Copyright 2014 Barcelona Supercomputing Center (BSC)
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 ******************************************************************************/

The servIoTicy Virtual Appliance is distributed for the purpose of testing the platform without the complexity of performing a distributed deployment of all its components.  The service can be initiated and stopped with the scripts provided:
o	startAll.sh - starts all services
o	stopAll.sh - stops all services

Notice that the process can take a while, particularly in virtual environments with limited resources. At least 3GB of RAM are recommended for the guest.

The Virtual Appliance is distributed with the following characteristics:

Virtual Machine Characteristics
o	User: servioticy
o	Password: servioticy
o	OS: Ubuntu 12.04.4 LTS
o	Network configuration:  2 DHCP interfaces (eth0 NAT for external routing, eth1 internal bridge for communication with the host)
o	Root access: use “sudo su” and provide the pasword of the servioticy user

Pre-created API user:
•	username: servioticy
o	API token: M2JhMmRkMDEtZTAwZi00ODM5LThmYTktOGU4NjNjYmJmMjc5N2UzNzYwNWItNTc2ZS00MGVlLTgyNTMtNTgzMmJhZjA0ZmIy


Software Components:
o	Couchbase 2.2 Enterprise
o	STORM 0.9.1-incubating (running in jar mode, not distributed)
o	Kestrel 2.9.2-2.4.1
o	Jetty 8.1.11.v20130520
o	ElasticSearch 1.0.1
o	Java(TM) SE Runtime Environment (build 1.7.0_51-b13) - Oracle
o	User management DB: Flask and SQLite
o	Apache Apollo 1.7
o	NodeJS v0.6.12

Client Libraries:
Some libraries have been developed by CREATE-NET and U-HOPPER to easily access the platform. They are available for smartphones and for the Arduino at this moment. Smartphone libraries can be found at https://github.com/compose-eu/MobileSDK. The COMPOSE Library for the Arduino is being released at https://github.com/compose-eu/COMPOSE_client_libraries


