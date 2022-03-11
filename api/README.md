# API Documentation

## Table of Contents
* [General](#general)
* [Sysadmin APIs](#sysadmin-apis)
* [Analyst APIs](#analyst-apis)
* [Engineer APIs](#engineer-apis)

## General
This project works primarily with AWS. It uses RDS to run a PostgreSQL database, which is then accessed by Lambda functions. The Lambda functions are in turn called through HTTP APIs via the AWS API Gateway, and authentication is all handled by AWS IAM. The diagram looks something like this:

![Picture](./IT%26C%20350%20Diagram.svg)

This README file will explain what each of the different API endpoints do, as well as how to send data to them.

## Sysadmin APIs

Note that since there are 2 sysadmins, replace # in sysadmin# with either 1 or 2 (sysadmin1/sysadmin2). The results from each API call will only return results that the System Adminstrator manages.

* **sysadmin#_all_bus_user_manages**: 
    * Request Type: GET
    * Input: None
    * Example Input: N/A
    * Action: SELECT all Business Units that Sysadmin manages.
    * Response: A table. Columns: [name, unitid]
* **sysadmin#_all_computers_in_one_bu**: 
    * Request Type: GET
    * Input: id (int): corresponds to a Business Unit ID
    * Example Input:  
    ```
    {
     "id": 1   
    }
    ```
    * Action: SELECT all computers from one Business Unit owned by that Sysadmin.
    * Response: A table. Columns: [name, computerid]
* **sysadmin#_all_computer_vulns_by_bu**: 
    * Request Type: GET
    * Input: id (int): corresponds to a Business Unit ID
    * Example Input:  
    ```
    {
     "id": 1   
    }
    ```
    * Action: SELECT all computers and their vulnerabilities from one Business Unit owned by that Sysadmin. Will not display computers with no vulnerabilities.
    * Response: A table. Columns: [computername, os, os_version, cve, severity]
* **sysadmin#_all_apps_on_computers**: 
    * Request Type: GET
    * Input: id (int): corresponds to a Computer ID
    * Example Input:  
    ```
    {
     "id": 1   
    }
    ```
    * Action: SELECT all apps from one computer owned by that Sysadmin.
    * Response: A table. Columns: [Computer Name, App Name, App Version, appid]

## Analyst APIs

Analysts act similar to Sysadmins, but with no restriction on owning Business Units or computers and with more visibility into vulnerabilities. They also tend to filter off of names rather than IDs.

* **analyst_list_all_info_by_bu**:
    * Request Type: GET
    * Input: values (string, wildcard: %): corresponds to a Business Unit name.
    * Example Input:  
    ```
    {
     "values": "Life Science%"   
    }
    ```
    * Action: SELECT all computers with vulnerabilities from one Business Unit, along with the vulnerabilities. Computers without vulnerabilities do not show up.
    * Response: A table. Columns: [cve, severity, computername, os, os_version, Business Unit]
* **analyst_list_all_info_by_severity**:
    * Request Type: GET
    * Input: values (int): corresponds to the lowest severity to be listed (all results will be >= the values severity level)
    * Example Input:  
    ```
    {
     "values": 7.4   
    }
    ```
    * Action: SELECT all computers with vulnerabilities with severities at or higher than the value, along with those vulnerabilities. Computers without vulnerabilities do not show up. (Identical to above API, but filters on severity)
    * Response: A table. Columns: [cve, severity, computername, os, os_version, Business Unit]
* **analyst_list_all_info_by_cve**:
    * Request Type: GET
    * Input: values (string, wildcard: %): corresponds to a cve name. Case insensitive.
    * Example Input:  
    ```
    {
     "values": "CVE-1993-%"   
    }
    ```
    * Action: SELECT all computers with vulnerabilities matching a CVE name, along with the vulnerabilities. Computers without vulnerabilities do not show up.
    * Response: A table. Columns: [cve, severity, computername, os, os_version, Business Unit]
* **analyst_vuln_count_per_bu**:
    * Request Type: GET
    * Input: None
    * Example Input: N/A
    * Action: SELECT all Business Units, and list the number of computers with vulnerabilities having a severity level over 5 in each business unit.
    * Response: A table. Columns: [Business Unit, number of serious vulnerabilities]

## Engineer APIs

Engineer APIs are much more complex, because Engineers can modify existing data. Because of this, there are 4 endpoints which have 4 methods each. Each method will be treated like a different endpoint, but notice that the endpoint names are often the same. To access them, use the exact same URL, but with a different method.

* **engineer_list_all_info_by_bu**:
    * Request Type: GET
    * Input: values (string, wildcard: %): corresponds to a computer name. This API is an unfortunate misnomer, but it is very difficult to change now without risking breaking something.
    * Example Input:  
    ```
    {
     "values": "Lib_%"   
    }
    ```
    * Action: SELECT all computers matching the value string with vulnerabilities, along with the vulnerabilities. Computers without vulnerabilities do not show up.
    * Response: A table. Columns: [Computer Name, App Name, App Version, CVE Name, Severity]
* **engineer_access_computers_post**:
    * Request Type: POST
    * Input:
        * name (string): corresponds to the new computer name.
        * operatingsystem (string): corresponds to the new computer os.
        * os_version (string): corresponds to the new computer os version.
        * unitid (int): corresponds to the new computer's Business Unit.
    * Example Input:  
    ```
    {
        "name": "DeleteMe",
        "operatingsystem": "Windows XP",
        "os_version": "1010",
        "unitid": 3
    }
    ```
    * Action: INSERT a new computer with the above values.
    * Response: None. (Technically a message saying the query succeeded)
* **engineer_access_computers_get**:
    * Request Type: GET
    * Input: values (string, wildcard: %): corresponds to a computer name.
    * Example Input:  
    ```
    {
     "values": "Lib_%"   
    }
    ```
    * Action: SELECT all computers matching the value string.
    * Response: A table. Columns: [Computer Name, OS, Computer ID, OS Version, Business Unit ID]
* **engineer_access_computers_put**:
    * Request Type: PUT
    * Input:
        * name (string): corresponds to the updated computer name.
        * operatingsystem (string): corresponds to the updated computer os.
        * os_version (string): corresponds to the updated computer os version.
        * unitid (int): corresponds to the updated computer's Business Unit.
        * id (int): corresponds to the computer id matching the computer to update.
    * Example Input:  
    ```
    {
        "name": "Updated_DeleteMe",
        "operatingsystem": "Linux",
        "os_version": "5.16.3",
        "unitid": 3,
        "id": 7
    }
    ```
    * Action: UPDATE a computer with the above values.
    * Response: None. (Technically a message saying the query succeeded)
* **engineer_access_computers_delete**:
    * Request Type: DELETE
    * Input:
        * id (int): corresponds to the id of the computer to delete.
    * Example Input:  
    ```
    {
        "id": 7
    }
    ```
    * Action: DELETE the computer with the above id.
    * Response: None. (Technically a message saying the query succeeded)
* **engineer_access_bus_post**:
    * Request Type: POST
    * Input:
        * name (string): corresponds to the new Business Unit name.
        * administrator (int): corresponds to the new Business Unit's admin. Note that a new admin must be added before a new Business Unit with that admin.
    * Example Input:  
    ```
    {
        "name": "JSB",
        "administrator": 2
    }
    ```
    * Action: INSERT a new Business Unit with the above values.
    * Response: None. (Technically a message saying the query succeeded)
* **engineer_access_bus_get**:
    * Request Type: GET
    * Input: values (string, wildcard: %): corresponds to a Business Unit name.
    * Example Input:  
    ```
    {
     "values": "%"   
    }
    ```
    * Action: SELECT all Business Units matching the value string.
    * Response: A table. Columns: [Business Unit Name, Business Unit ID, Administrator ID, Belongs To ID]
* **engineer_access_bus_put**:
    * Request Type: PUT
    * Input:
        * name (string): corresponds to the updated Business Unit name.
        * administrator (int): corresponds to the updated Business Unit's admin. Note that a new admin must be added before an updated Business Unit can be assigned to that admin.
        * id (int): corresponds to the Business Unit ID of the Business Unit to update.
    * Example Input:  
    ```
    {
        "name": "Updated_JSB",
        "administrator": 2,
        "id": 4
    }
    ```
    * Action: UPDATE a Business Unit with the above values.
    * Response: None. (Technically a message saying the query succeeded)
* **engineer_access_bus_delete**:
    * Request Type: DELETE
    * Input:
        * id (int): corresponds to the id of the Business Unit to delete.
    * Example Input:  
    ```
    {
        "id": 7
    }
    ```
    * Action: DELETE the Business Unit with the above id.
    * Response: None. (Technically a message saying the query succeeded)
* **engineer_access_users_post**:
    * Request Type: POST
    * Input:
        * username (string): corresponds to the new user's username.
        * role (string): corresponds to the new user's role.
        * firstname (string): corresponds to the new user's first name.
        * lastname (string): corresponds to the new user's last name.
    * Example Input:  
    ```
    {
        "username": "DeleteMe",
        "role": "engineer",
        "firstname": "Delete",
        "lastname": "Me"
    }
    ```
    * Action: INSERT a new user with the above values.
    * Response: None. (Technically a message saying the query succeeded)
* **engineer_access_users_get**:
    * Request Type: GET
    * Input: values (string, wildcard: %): corresponds to a user name.
    * Example Input:  
    ```
    {
     "values": "%"   
    }
    ```
    * Action: SELECT all users matching the value string.
    * Response: A table. Columns: [Username, Role, First Name, Last Name, User ID]
* **engineer_access_users_put**:   
    * Request Type: PUT
    * Input:
        * username (string): corresponds to the updated user's username.
        * role (string): corresponds to the updated user's role.
        * firstname (string): corresponds to the updated user's first name.
        * lastname (string): corresponds to the updated user's last name.
        * 
    * Example Input:  
    ```
    {
        "username": "Updated_DeleteMe",
        "role": "analyst",
        "firstname": "Delete",
        "lastname": "Me",
        "id": 5
    }
    ```
    * Action: UPDATE a user with the above values.
    * Response: None. (Technically a message saying the query succeeded)
* **engineer_access_users_delete**:
    * Request Type: DELETE
    * Input:
        * id (int): corresponds to the id of the user to delete.
    * Example Input:  
    ```
    {
        "id": 7
    }
    ```
    * Action: DELETE the user with the above id.
    * Response: None. (Technically a message saying the query succeeded)
* **engineer_access_cves_post**:
    * Request Type: POST
    * Input:
        * cve (string): corresponds to the new CVE name.
        * severity (float/double): corresponds to the new CVE vulnerability.
    * Example Input:  
    ```
    {
        "cve": "CVE-2001-3445",
        "severity": 3.2
    }
    ```
    * Action: INSERT a new vulnerability with the above values.
    * Response: None. (Technically a message saying the query succeeded)
* **engineer_access_cves_get**:
    * Request Type: GET
    * Input: values (string, wildcard: %): corresponds to a CVE name.
    * Example Input:  
    ```
    {
     "values": "%"   
    }
    ```
    * Action: SELECT all CVEs/vulnerabilities matching the value string.
    * Response: A table. Columns: [CVE Name, Severity, Vulnerability ID]
* **engineer_access_cves_put**:
    * Request Type: PUT
    * Input:
        * cve (string): corresponds to the updated CVE name.
        * severity (float/double): corresponds to the updated CVE vulnerability.
    * Example Input:  
    ```
    {
        "cve": "Updated-CVE-2001-3445",
        "severity": 6.4,
        "id": 4
    }
    ```
    * Action: UPDATE a vulnerability with the above values.
    * Response: None. (Technically a message saying the query succeeded)
* **engineer_access_cves_delete**:
    * Request Type: DELETE
    * Input:
        * id (int): corresponds to the id of the vulnerability/CVE to delete.
    * Example Input:  
    ```
    {
        "id": 7
    }
    ```
    * Action: DELETE the vulnerability/CVE with the above id.
    * Response: None. (Technically a message saying the query succeeded)
