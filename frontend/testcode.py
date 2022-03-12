#!/usr/bin/env python

#############################
# Define Imported Libraries #
#############################

import requests
import argparse
from cmd2 import Cmd, with_argparser, Cmd2ArgumentParser
import cmd2
from aws_requests_auth.aws_auth import AWSRequestsAuth
import pandas as pd


###########################
# Define Global Variables #
###########################

loggedIn = False
auth = 0
role = "analyst"


###############################
# Define Parsers for Commands #
###############################

list_parser = Cmd2ArgumentParser()
list_subparsers = list_parser.add_subparsers(title='subcommands', help='subcommand help')

parser_computer = list_subparsers.add_parser('computers', help='computer help')
parser_computer.add_argument('-b', type=int, help="Business Unit ID number")
parser_computer.add_argument('-s','--severity', type=float, help="Vulnerability Severity score (1-10)")


parser_bu = list_subparsers.add_parser('business_units', help='business_unit help')
parser_bu.add_argument('-b', type=str, default='%', help='Business Unit name')


######################################
# Define Class for interactive shell #
######################################

class cvetracker(Cmd):
    def __init__(self):
        super().__init__()
        del Cmd.do_shell
        del Cmd.do_alias
        del Cmd.do_macro
        del Cmd.do_run_pyscript
        del Cmd.do_set
        del Cmd.do_shortcuts
        del Cmd.do_edit
        del Cmd.do_run_script
        del Cmd.do_history

        self.prompt = 'Tracker> '
        """ A CVE tracking software. """

    def do_role(self, args):
        """Print the role of the user"""
        #amiLogged()
        if loggedIn == False:
            self.poutput("Sorry, can't access the database. You are not logged in.")
        else:
            self.poutput("Welcome to the database!")
            self.poutput('You are a Security Analyst')
            self.poutput("What would you like to do?")

    def do_login(self, args):
        """Login to AWS account"""
        print("Attempting to log you in")
        key = input("Please enter your key: ")
        secret = input("Please enter your secret key: ")
        awsLogin(key, secret)

    def do_logout(self, args):
        """Logout of AWS account"""
        global loggedIn
        global auth
        global role
        print("Logging you out now.")
        loggedIn = False
        auth = 0
        role = ""
        print("Successfully logged you out!")


    @cmd2.with_argparser(list_parser)
    def do_list(self, args):
        """Test Help Menu"""
        func = getattr(args, 'func', None)
        if func is not None:
            func(self, args)
        else:
            self.do_help('list')

    def list_computer(self, args):
        if(loggedIn):
            if role == 'sysadmin1':
                data = {'id': args.b}
                response = requests.get('https://imbp521xa8.execute-api.us-west-2.amazonaws.com/sysadmin1_all_computers_in_one_bu', auth=auth, json=data)
                tabledata = response.json()
                l1,l2 = len(tabledata), len(tabledata[0])
                df = pd.DataFrame(tabledata, index=['']*l1, columns=['']*l2)
                df.set_axis(['COMPUTER NAME','COMPUTER ID'],axis=1,inplace=True)
                self.poutput('Here are the computers you requested:')
                self.poutput(df.head())
                self.poutput('\n')
            elif role == 'sysadmin2':
                data = {'id': args.b}
                response = requests.get('https://fcfwijojda.execute-api.us-west-2.amazonaws.com/sysadmin2_all_computers_in_one_bu', auth=auth, json=data)
                self.poutput('Here is your data')
                tabledata = response.json()
                l1,l2 = len(tabledata), len(tabledata[0])
                df = pd.DataFrame(tabledata, index=['']*l1, columns=['']*l2)
                df.set_axis(['COMPUTER NAME','COMPUTER ID'],axis=1,inplace=True)
                self.poutput('Here are the computers you requested:')
                self.poutput(df.head())
                self.poutput('\n')
            elif role == 'analyst':
                data = {'values': args.severity}
                response = requests.get('https://cs4pjw5qb9.execute-api.us-west-2.amazonaws.com/analyst_list_all_info_by_severity', auth=auth, json=data)
                self.poutput('Here is your data')
                tabledata = response.json()
                l1,l2 = len(tabledata), len(tabledata[0])
                df = pd.DataFrame(tabledata, index=['']*l1, columns=['']*l2)
                df.set_axis(['CVE', 'SEVERITY', 'COMPUTER NAME', 'OS', 'OS_VERSION','BUSINESS UNIT'],axis=1,inplace=True)
                self.poutput('Here are the computers you requested:')
                self.poutput(df.head())
                self.poutput('\n')


        else:
            self.poutput("You must log in to view this data.")

    parser_computer.set_defaults(func=list_computer)

    def list_bus(self, args):
        if(loggedIn):
            if role == 'sysadmin1':
                response = requests.get("https://imbp521xa8.execute-api.us-west-2.amazonaws.com/sysadmin1_all_bus_user_manages", auth=auth)
                self.poutput("Here are the Business Units you manage:")
                tabledata = response.json()
                l1,l2 = len(tabledata), len(tabledata[0])
                df = pd.DataFrame(tabledata, index=['']*l1, columns=['']*l2)
                df.set_axis(['BUSINESS UNIT', 'UNIT ID'],axis=1,inplace=True)
                self.poutput(df.head())
                self.poutput('\n')
            elif role == 'sysadmin2':
                response = requests.get("https://fcfwijojda.execute-api.us-west-2.amazonaws.com/sysadmin2_all_bus_user_manages", auth=auth)
                self.poutput("Here are the Business Units you manage:")
                tabledata = response.json()
                l1,l2 = len(tabledata), len(tabledata[0])
                df = pd.DataFrame(tabledata, index=['']*l1, columns=['']*l2)
                df.set_axis(['BUSINESS UNIT', 'UNIT ID'],axis=1,inplace=True)
                self.poutput(df.head())
                self.poutput('\n')
            elif role == 'analyst':
                data = {'values': [str(args.b)]}
                response = requests.get("https://cs4pjw5qb9.execute-api.us-west-2.amazonaws.com/analyst_list_all_info_by_bu", auth=auth, json=data)
                self.poutput("Here are the vulnerable computers in the business unit")
                tabledata = response.json()
                l1,l2 = len(tabledata), len(tabledata[0])
                df = pd.DataFrame(tabledata, index=['']*l1, columns=['']*l2)
                df.set_axis(['CVE', 'SEVERITY', 'COMPUTER NAME', 'OS', 'OS_VERSION', 'BUSINESS UNIT'],axis=1,inplace=True)
                self.poutput(df.head())
                self.poutput('\n')
            elif role == 'engineer':
                data = {'values': [str(args.b)]}
                response = requests.get("https://7va75w0cr7.execute-api.us-west-2.amazonaws.com/engineer_access_bus", auth=auth, json=data)
                self.poutput("Here are the Business Units you asked for:")
                tabledata = response.json()
                l1,l2 = len(tabledata), len(tabledata[0])
                df = pd.DataFrame(tabledata, index=['']*l1, columns=['']*l2)
                df.set_axis(['BUSINESS UNIT', 'BUSINESS UNIT ID', 'ADMIN ID', 'BELONGs TO'],axis=1,inplace=True)
                self.poutput(df.head())
                self.poutput('\n')
        else:
            self.poutput("You must log in to view this data.")
    parser_bu.set_defaults(func=list_bus)




#############################
# Define AWS Login function #
#############################

def awsLogin(key, secret):
    global loggedIn
    global auth
    global role
    """
    login_list = ['url_1', 'url_2', 'url_3', 'url_4']
    headers = {'testing': '123abc'}
    resulting_url = ''
    for i in login_list:
        response = requests.get(i, auth=auth, headers=headers)
        if response.status_code == requests.codes.ok:
            loggedIn = True
            print("You are now logged in!")
            resulting_url = i
            break
    if resulting_url == login_list[0]:
        role = "sysadmin1"
    elif resulting_url == login_list[1]:
        role = "sysadmin2"
    elif resulting_url == login_list[2]:
        role = "analyst"
    elif resulting_url == login_list[3]:
        role = "engineer"
        """
    auth = AWSRequestsAuth(aws_access_key=key,
            aws_secret_access_key=secret,
            aws_host='to36jhw9b1.execute-api.us-west-2.amazonaws.com',
            aws_region='us-west-2',
            aws_service='execute-api')
    data = {'values': ['%']}
    headers = {'testing': '123abc'}
    #response = requests.get('https://to36jhw9b1.execute-api.us-west-2.amazonaws.com/default/all_computers_apps_vulns', auth=auth, headers=headers, json=data)
    response = requests.get('https://to36jhw9b1.execute-api.us-west-2.amazonaws.com/default/login', auth=auth, headers=headers)
    if response.status_code == requests.codes.ok:
        loggedIn = True
        print("You are now logged in!")
    else:
        print("Unfortunately we could not log you in")


###################
# Use to Run Code #
###################

if __name__ == '__main__':
    import sys
    c = cvetracker()
    sys.exit(c.cmdloop())
