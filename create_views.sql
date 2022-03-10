/* ----- Vulnerability Count For All Business Units ----- */
DROP VIEW IF EXISTS all_bu_vulnerabilities_count;
DROP VIEW IF EXISTS all_bu_vulnerabilities_over_5;
DROP VIEW IF EXISTS all_computer_vulnerabilities;
DROP VIEW IF EXISTS all_bu_computers;

--Used to take all computer ids and pair them with each of their respective vulnerabilities
CREATE VIEW all_computer_vulnerabilities AS
SELECT computerid, "VULNERABILITY".vulnid, severity, cve FROM "VULNERABILITY" INNER JOIN "COMPUTER_VULNERABILITIES" ON "VULNERABILITY".vulnid = "COMPUTER_VULNERABILITIES".vulnid;

--Used to get all computers belonging to each business unit
CREATE VIEW all_bu_computers AS
SELECT "COMPUTER".unitid, "BUSINESS_UNIT".name, administrator, computerid FROM "BUSINESS_UNIT" INNER JOIN "COMPUTER" ON "BUSINESS_UNIT".unitid = "COMPUTER".unitid;

--Used to get a count of how many vulnerabilities in each business unit are greater than 5
CREATE VIEW all_bu_vulnerabilities_over_5 AS
SELECT unitid, COUNT(vulnid) 
FROM all_bu_computers 
INNER JOIN all_computer_vulnerabilities ON all_bu_computers.computerid = all_computer_vulnerabilities.computerid 
WHERE severity > 5 
GROUP BY unitid;

--Used to show all business units, even those which have no vulnerabilities. This is the final view for this part.
CREATE VIEW all_bu_vulnerabilities_count AS
SELECT name AS "Business Unit", COALESCE(count, 0) AS "Number of Serious Vulnerabilities" 
FROM all_bu_vulnerabilities_over_5 
RIGHT JOIN "BUSINESS_UNIT" ON "BUSINESS_UNIT".unitid = all_bu_vulnerabilities_over_5.unitid;

/* ----- Vulnerabilities in a single Business Unit ----- */
DROP VIEW IF EXISTS full_bu_vulns;
DROP VIEW IF EXISTS bu_vulnerabilities;
DROP VIEW IF EXISTS bu_computer_vulns;

--Used to add the vulnerability id to the COMPUTER table 
CREATE VIEW bu_computer_vulns AS
SELECT name, operatingsystem, "COMPUTER".computerid, os_version, unitid, vulnid FROM "COMPUTER" INNER JOIN "COMPUTER_VULNERABILITIES" ON "COMPUTER".computerid = "COMPUTER_VULNERABILITIES".computerid;

--Used to return the information we care about: the cve, severity, computer name, and os info for each business unit
CREATE VIEW bu_vulnerabilities AS
SELECT cve, severity, name AS computername, operatingsystem AS os, os_version, unitid FROM bu_computer_vulns
INNER JOIN "VULNERABILITY" ON bu_computer_vulns.vulnid = "VULNERABILITY".vulnid
ORDER BY severity DESC, computername;

--Used to add the actual business unit name to the above view
CREATE VIEW full_bu_vulns AS
SELECT cve, severity, computername, os, os_version, name AS "Business Unit", bu_vulnerabilities.unitid FROM bu_vulnerabilities
INNER JOIN "BUSINESS_UNIT" ON bu_vulnerabilities.unitid = "BUSINESS_UNIT".unitid;


/* ----- Lists all apps and vulnerabilities for all computers ----- */
DROP VIEW IF EXISTS all_computer_apps_vulns;
DROP VIEW IF EXISTS all_computer_vulnids;
DROP VIEW IF EXISTS all_computer_apps;
DROP VIEW IF EXISTS all_computer_app_ids;

--Used to add the appid to a computer
CREATE VIEW all_computer_app_ids AS 
SELECT name "Computer Name","COMPUTER".computerid,OS_version,appid from "COMPUTER" 
JOIN "RUNS" on "COMPUTER".computerid = "RUNS".computerid
ORDER BY "Computer Name";

--Used to list the Apps on all computers
CREATE VIEW all_computer_apps AS 
SELECT all_computer_app_ids."Computer Name", all_computer_app_ids."computerid", "APP".name "App Name", version "App Version", "APP".appid FROM all_computer_app_ids 
JOIN "APP" ON all_computer_app_ids.appid = "APP".appid 
ORDER BY "Computer Name";

--Used to add the vulnid to all computers
CREATE VIEW all_computer_vulnids AS
SELECT "Computer Name", "App Name", "App Version", vulnid FROM all_computer_apps
JOIN "APP_VULNERABILITIES" ON all_computer_apps.appid = "APP_VULNERABILITIES".appid
ORDER BY "Computer Name";

--Used to list all Apps and Vulnerabilities on all computers
CREATE VIEW all_computer_apps_vulns AS 
SELECT "Computer Name", "App Name", "App Version",cve,severity FROM all_computer_vulnids 
JOIN "VULNERABILITY" on "VULNERABILITY".vulnid = all_computer_vulnids.vulnid 
ORDER BY severity DESC, "Computer Name";
