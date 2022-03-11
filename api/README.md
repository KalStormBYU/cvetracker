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

* `sysadmin#_all_bus_user_manages`: 
    * Request Type: GET
    * Input: None
    * Example Input: N/A
    * Action: SELECT all Business Units that Sysadmin manages.
    * Response: A table. Columns: [name, unitid]
* `sysadmin#_all_computers_in_one_bu`: 
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
* `sysadmin#_all_computer_vulns_by_bu`: 
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
* `sysadmin#_all_apps_on_computers`: 
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
