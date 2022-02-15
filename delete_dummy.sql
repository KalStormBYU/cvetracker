/*
  Delete Dummy Data from "APP_VULNERABILITIES" table
*/

DELETE FROM "APP_VULNERABILITIES" where "APP_VULNERABILITIES".appid = (SELECT "APP".appid FROM "APP" WHERE "APP".name = 'Facebook');
DELETE FROM "APP_VULNERABILITIES" where "APP_VULNERABILITIES".appid = (SELECT "APP".appid FROM "APP" WHERE "APP".name = 'ScamBotApp');
DELETE FROM "APP_VULNERABILITIES" where "APP_VULNERABILITIES".appid = (SELECT "APP".appid FROM "APP" WHERE "APP".name = 'GoogleAdsTracker');

/*
  Delete Dummy Data from "RUNS" table
*/

DELETE FROM "RUNS" where "RUNS".computerid = (SELECT "COMPUTER".computerid FROM "COMPUTER" WHERE "COMPUTER".name = 'My Computer');
DELETE FROM "RUNS" where "RUNS".computerid = (SELECT "COMPUTER".computerid FROM "COMPUTER" WHERE "COMPUTER".name = 'Lib_Server_01');
DELETE FROM "RUNS" where "RUNS".computerid = (SELECT "COMPUTER".computerid FROM "COMPUTER" WHERE "COMPUTER".name = 'Lib_Desk_01');
DELETE FROM "RUNS" where "RUNS".computerid = (SELECT "COMPUTER".computerid FROM "COMPUTER" WHERE "COMPUTER".name = 'Lib_Desk_02');

/*
  Delete Dummy Data from "COMPUTER_VULNERABILITIES" table
*/

DELETE FROM "COMPUTER_VULNERABILITIES" where "COMPUTER_VULNERABILITIES".computerid = (SELECT "COMPUTER".computerid FROM "COMPUTER" WHERE "COMPUTER".name = 'My Computer');
DELETE FROM "COMPUTER_VULNERABILITIES" where "COMPUTER_VULNERABILITIES".computerid = (SELECT "COMPUTER".computerid FROM "COMPUTER" WHERE "COMPUTER".name = 'Lib_Desk_01');
DELETE FROM "COMPUTER_VULNERABILITIES" where "COMPUTER_VULNERABILITIES".computerid = (SELECT "COMPUTER".computerid FROM "COMPUTER" WHERE "COMPUTER".name = 'Lib_Desk_02');
DELETE FROM "COMPUTER_VULNERABILITIES" where "COMPUTER_VULNERABILITIES".computerid = (SELECT "COMPUTER".computerid FROM "COMPUTER" WHERE "COMPUTER".name = 'Lib_Server_01');

/*
  Delete Dummy Data from "APP" table
*/

DELETE FROM "APP" where "name"='Facebook' and "version" = '1.0';
DELETE FROM "APP" where "name"='WhatsApp' and "version" = '1.6';
DELETE FROM "APP" where "name"='ScamBotApp' and "version" = '1.2';
DELETE FROM "APP" where "name"='GoogleAdsTracker' and "version" = '0.1';

/*
 Delete Dummy Data from "BUSINESS_UNIT" table
*/

DELETE FROM "BUSINESS_UNIT" where "name" = 'Life Sciences';
DELETE FROM "BUSINESS_UNIT" where "name" = 'Physics';
DELETE FROM "BUSINESS_UNIT" where "name" = 'Library';

/*
 Delete Dummy Data from "COMPUTER" table
*/

DELETE FROM "COMPUTER" where "name" = 'My Computer';
DELETE FROM "COMPUTER" where "name" = 'LS_Server_01';
DELETE FROM "COMPUTER" where "name" = 'LS_Server_02';
DELETE FROM "COMPUTER" where "name" = 'Lib_Server_01';
DELETE FROM "COMPUTER" where "name" = 'Lib_Desk_01';
DELETE FROM "COMPUTER" where "name" = 'Lib_Desk_02';

/*
 Delete Dummy Data from "USER" table
*/

DELETE FROM "USER" where username = 'testuser1';
DELETE FROM "USER" where username = 'testuser2';
DELETE FROM "USER" where username = 'testuser3';
DELETE FROM "USER" where username = 'testuser4';

/*
  Delete Dumy Data from "VULNERABILITY" table
*/

DELETE FROM "VULNERABILITY" where cve = 'CVE-1993-2021';
DELETE FROM "VULNERABILITY" where cve = 'CVE-2034-188983928';
DELETE FROM "VULNERABILITY" where cve = 'CVE-2020-7892';
