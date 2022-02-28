DROP FUNCTION IF EXISTS select_all_computer_app_vulns;
DROP FUNCTION IF EXISTS select_all_bu_vulns_count;

/* ----- Function to select all app vulnerabilities associated with specified computers ----- */
CREATE FUNCTION select_all_computer_app_vulns(
	computers text
)
RETURNS TABLE (
	"Computer Name" varchar(32),
	"App Name" varchar(255),
	"App Version" varchar(32),
	"cve" varchar(32),
	"severity" float
)
LANGUAGE plpgsql
AS $$
DECLARE comp_names varchar[];
BEGIN
-- $1 here means the first variable, which is also the only variable in this case (computers)
comp_names = string_to_array($1,',');
RETURN QUERY SELECT all_computer_apps_vulns."Computer Name", all_computer_apps_vulns."App Name", all_computer_apps_vulns."App Version", all_computer_apps_vulns."cve", all_computer_apps_vulns."severity" FROM all_computer_apps_vulns WHERE all_computer_apps_vulns."Computer Name" LIKE ANY (comp_names);
END;$$;

-- How to run the above function:
-- SELECT * FROM "select_all_computer_app_vulns"('Lib_Server_01,Lib_Desk_01,%');


/* ----- Function to count all vulnerabilities in each business unit ----- */
CREATE FUNCTION select_all_bu_vulns_count(
	BUs text
)
RETURNS TABLE (
	"Business Unit" varchar(255),
	"Number of Serious Vulnerabilities" bigint
)
LANGUAGE plpgsql
AS $$
DECLARE bu_names varchar[];
BEGIN
bu_names = string_to_array($1,',');
RETURN QUERY SELECT all_bu_vulnerabilities_count."Business Unit", all_bu_vulnerabilities_count."Number of Serious Vulnerabilities" FROM all_bu_vulnerabilities_count WHERE all_bu_vulnerabilities_count."Business Unit" LIKE ANY (bu_names);
END;$$;

-- How to run the above function:
-- SELECT * FROM select_all_bu_vulns_count('%');
