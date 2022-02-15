/*
  Insert Dummy Data into "APP" table
*/

INSERT INTO "APP" ("name","version") VALUES ('Facebook','1.0');
INSERT INTO "APP" ("name","version") VALUES ('WhatsApp','1.6');
INSERT INTO "APP" ("name","version") VALUES ('ScamBotApp','1.2');
INSERT INTO "APP" ("name","version") VALUES ('GoogleAdsTracker','0.1');
/*
  Insert Dummy Data into "USER" table
*/
INSERT INTO "USER" (username,saltyhash,"role",firstname,lastname) VALUES ('testuser1','thisisnotactuallyasaltedhash','administrator','Tom','Hardy');
INSERT INTO "USER" (username,saltyhash,"role",firstname,lastname) VALUES ('testuser2','thisisnotactuallyasaltedhash','administrator','Bob','Ross');
INSERT INTO "USER" (username,saltyhash,"role",firstname,lastname) VALUES ('testuser3','thisisnotactuallyasaltedhash','engineer','Tom','Holland');
INSERT INTO "USER" (username,saltyhash,"role",firstname,lastname) VALUES ('testuser4','thisisnotactuallyasaltedhash','analyst','Zendya','I have no idea what her last name is');
/*
  Insert Dummy Data into "BUSINESS_UNIT" table
*/

INSERT INTO "BUSINESS_UNIT" ("name",administrator) VALUES ('Life Sciences', (SELECT "USER".userid from "USER" WHERE "USER".username = 'testuser1'));
INSERT INTO "BUSINESS_UNIT" ("name",administrator) VALUES ('Physics', (SELECT "USER".userid from "USER" WHERE "USER".username = 'testuser2'));
INSERT INTO "BUSINESS_UNIT" ("name",administrator) VALUES ('Library', (SELECT "USER".userid FROM "USER" WHERE "USER".username = 'testuser2'));

/*
  Insert Dummy Data into "COMPUTER" table
*/

INSERT INTO "COMPUTER" ("name",operatingsystem,os_version, unitid) VALUES ('My_Computer', 'Arch Linux', '5.10', (SELECT "BUSINESS_UNIT".unitid from "BUSINESS_UNIT" WHERE "BUSINESS_UNIT".name = 'Life Sciences'));
INSERT INTO "COMPUTER" ("name",operatingsystem,os_version, unitid) VALUES ('LS_Server_01', 'CentOS', '8.0', (SELECT "BUSINESS_UNIT".unitid from "BUSINESS_UNIT" WHERE "BUSINESS_UNIT".name = 'Life Sciences'));
INSERT INTO "COMPUTER" ("name",operatingsystem,os_version, unitid) VALUES ('LS_Server_02', 'MS BOB', '1.0', (SELECT "BUSINESS_UNIT".unitid from "BUSINESS_UNIT" WHERE "BUSINESS_UNIT".name = 'Life Sciences'));
INSERT INTO "COMPUTER" ("name",operatingsystem,os_version, unitid) VALUES ('Lib_Server_01', 'Arch Linux', '5.05', (SELECT "BUSINESS_UNIT".unitid from "BUSINESS_UNIT" WHERE "BUSINESS_UNIT".name = 'Library'));
INSERT INTO "COMPUTER" ("name",operatingsystem,os_version, unitid) VALUES ('Lib_Desk_01', 'Windows 10', '19043', (SELECT "BUSINESS_UNIT".unitid from "BUSINESS_UNIT" WHERE "BUSINESS_UNIT".name = 'Library'));
INSERT INTO "COMPUTER" ("name",operatingsystem,os_version, unitid) VALUES ('Lib_Desk_02', 'Windows 10', '19043', (SELECT "BUSINESS_UNIT".unitid from "BUSINESS_UNIT" WHERE "BUSINESS_UNIT".name = 'Library'));

/*
  Insert Dummy Data into "VULNERABILITY" table
*/

INSERT INTO "VULNERABILITY" (severity, cve) VALUES (7.4, 'CVE-1993-2021');
INSERT INTO "VULNERABILITY" (severity, cve) VALUES (3.6, 'CVE-2034-188983928');
INSERT INTO "VULNERABILITY" (severity, cve) VALUES (4.2, 'CVE-2020-7892');

/*
  Insert Dummy Data into "APP_VULNERABILITY" table
*/

-- GoogleAdsTracker has multiple vulnerabilities
INSERT INTO "APP_VULNERABILITIES" (appid, vulnid) VALUES ((SELECT "APP".appid FROM "APP" WHERE "APP".name = 'Facebook'), (SELECT "VULNERABILITY".vulnid FROM "VULNERABILITY" WHERE "VULNERABILITY".cve = 'CVE-1993-2021'));
INSERT INTO "APP_VULNERABILITIES" (appid, vulnid) VALUES ((SELECT "APP".appid FROM "APP" WHERE "APP".name = 'ScamBotApp'), (SELECT "VULNERABILITY".vulnid FROM "VULNERABILITY" WHERE "VULNERABILITY".cve = 'CVE-2034-188983928'));
INSERT INTO "APP_VULNERABILITIES" (appid, vulnid) VALUES ((SELECT "APP".appid FROM "APP" WHERE "APP".name = 'GoogleAdsTracker'), (SELECT "VULNERABILITY".vulnid FROM "VULNERABILITY" WHERE "VULNERABILITY".cve = 'CVE-2034-188983928'));
INSERT INTO "APP_VULNERABILITIES" (appid, vulnid) VALUES ((SELECT "APP".appid FROM "APP" WHERE "APP".name = 'GoogleAdsTracker'), (SELECT "VULNERABILITY".vulnid FROM "VULNERABILITY" WHERE "VULNERABILITY".cve = 'CVE-2020-7892'));

/*
  Insert Dummy Data into "COMPUTER_VULNERABILITIES" table
*/

INSERT INTO "COMPUTER_VULNERABILITIES" (vulnid, computerid) VALUES ((SELECT "VULNERABILITY".vulnid FROM "VULNERABILITY" WHERE "VULNERABILITY".cve = 'CVE-1993-2021'), (SELECT "COMPUTER".computerid FROM "COMPUTER" WHERE "COMPUTER".name = 'My_Computer'));
INSERT INTO "COMPUTER_VULNERABILITIES" (vulnid, computerid) VALUES ((SELECT "VULNERABILITY".vulnid FROM "VULNERABILITY" WHERE "VULNERABILITY".cve = 'CVE-1993-2021'), (SELECT "COMPUTER".computerid FROM "COMPUTER" WHERE "COMPUTER".name = 'Lib_Desk_01'));
INSERT INTO "COMPUTER_VULNERABILITIES" (vulnid, computerid) VALUES ((SELECT "VULNERABILITY".vulnid FROM "VULNERABILITY" WHERE "VULNERABILITY".cve = 'CVE-2034-188983928'), (SELECT "COMPUTER".computerid FROM "COMPUTER" WHERE "COMPUTER".name = 'Lib_Desk_01'));
INSERT INTO "COMPUTER_VULNERABILITIES" (vulnid, computerid) VALUES ((SELECT "VULNERABILITY".vulnid FROM "VULNERABILITY" WHERE "VULNERABILITY".cve = 'CVE-2034-188983928'), (SELECT "COMPUTER".computerid FROM "COMPUTER" WHERE "COMPUTER".name = 'Lib_Desk_02'));
INSERT INTO "COMPUTER_VULNERABILITIES" (vulnid, computerid) VALUES ((SELECT "VULNERABILITY".vulnid FROM "VULNERABILITY" WHERE "VULNERABILITY".cve = 'CVE-2020-7892'), (SELECT "COMPUTER".computerid FROM "COMPUTER" WHERE "COMPUTER".name = 'Lib_Server_01'));
INSERT INTO "COMPUTER_VULNERABILITIES" (vulnid, computerid) VALUES ((SELECT "VULNERABILITY".vulnid FROM "VULNERABILITY" WHERE "VULNERABILITY".cve = 'CVE-2034-188983928'), (SELECT "COMPUTER".computerid FROM "COMPUTER" WHERE "COMPUTER".name = 'Lib_Server_01'));

/*
  Insert Dummy Data into "RUNS" table
*/

INSERT INTO "RUNS" (computerid, appid) VALUES ((SELECT "COMPUTER".computerid FROM "COMPUTER" WHERE "COMPUTER".name = 'My_Computer'), (SELECT "APP".appid FROM "APP" WHERE "APP".name = 'Facebook'));
INSERT INTO "RUNS" (computerid, appid) VALUES ((SELECT "COMPUTER".computerid FROM "COMPUTER" WHERE "COMPUTER".name = 'Lib_Server_01'), (SELECT "APP".appid FROM "APP" WHERE "APP".name = 'GoogleAdsTracker'));
INSERT INTO "RUNS" (computerid, appid) VALUES ((SELECT "COMPUTER".computerid FROM "COMPUTER" WHERE "COMPUTER".name = 'Lib_Desk_01'), (SELECT "APP".appid FROM "APP" WHERE "APP".name = 'ScamBotApp'));
INSERT INTO "RUNS" (computerid, appid) VALUES ((SELECT "COMPUTER".computerid FROM "COMPUTER" WHERE "COMPUTER".name = 'Lib_Desk_01'), (SELECT "APP".appid FROM "APP" WHERE "APP".name = 'Facebook'));
INSERT INTO "RUNS" (computerid, appid) VALUES ((SELECT "COMPUTER".computerid FROM "COMPUTER" WHERE "COMPUTER".name = 'Lib_Desk_02'), (SELECT "APP".appid FROM "APP" WHERE "APP".name = 'ScamBotApp'));


