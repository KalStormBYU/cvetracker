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
role = ""
method = "https://"
url_sysadmin1 = "imbp521xa8.execute-api.us-west-2.amazonaws.com"
url_sysadmin2 = "fcfwijojda.execute-api.us-west-2.amazonaws.com"
url_analyst = "cs4pjw5qb9.execute-api.us-west-2.amazonaws.com"
url_engineer = "7va75w0cr7.execute-api.us-west-2.amazonaws.com"


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

parser_vuln = list_subparsers.add_parser('vulns', help='vulnerability help')

parser_apps = list_subparsers.add_parser('apps', help='application help')

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
            self.poutput(f'Your Role is {role.upper()}')

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
                response = requests.get(method + url_sysadmin1 + "/sysadmin1_all_bus_user_manages", auth=auth)
                self.poutput("Here are the Business Units you manage:")
                tabledata = response.json()
                l1,l2 = len(tabledata), len(tabledata[0])
                df = pd.DataFrame(tabledata, index=['']*l1, columns=['']*l2)
                self.poutput(df.head())
                self.poutput('\n')
                b_id = input("Which Business Unit would you like to view? (ID NUMBER): ")
                try:
                    data = {'id': int(b_id)}
                    response = requests.get(method + url_sysadmin1 + '/sysadmin1_all_computers_in_one_bu', auth=auth, json=data)
                    tabledata = response.json()
                    l1,l2 = len(tabledata), len(tabledata[0])
                    df = pd.DataFrame(tabledata, index=['']*l1, columns=['']*l2)
                    df.set_axis(['COMPUTER NAME','COMPUTER ID'],axis=1,inplace=True)
                    self.poutput('Here are the computers you requested:')
                    self.poutput(df.head())
                    self.poutput('\n')
                except ValueError:
                    print("Please enter a valid integer")
                except KeyError:
                    print("You do not have access to that business unit")
                except IndexError:
                    print("The business unit you requested is empty.")
            elif role == 'sysadmin2':
                response = requests.get(method + url_sysadmin2 + "/sysadmin2_all_bus_user_manages", auth=auth)
                self.poutput("Here are the Business Units you manage:")
                tabledata = response.json()
                l1,l2 = len(tabledata), len(tabledata[0])
                df = pd.DataFrame(tabledata, index=['']*l1, columns=['']*l2)
                self.poutput(df.head())
                self.poutput('\n')
                b_id = input("Which Business Unit would you like to view? (ID NUMBER): ")
                try:
                    data = {'id': int(b_id)}
                    response = requests.get(method + url_sysadmin2 + '/sysadmin2_all_computers_in_one_bu', auth=auth, json=data)
                    tabledata = response.json()
                    l1,l2 = len(tabledata), len(tabledata[0])
                    df = pd.DataFrame(tabledata, index=['']*l1, columns=['']*l2)
                    df.set_axis(['COMPUTER NAME','COMPUTER ID'],axis=1,inplace=True)
                    self.poutput('Here are the computers you requested:')
                    self.poutput(df.head())
                    self.poutput('\n')
                except ValueError:
                    print("Please enter a valid integer")
                except KeyError:
                    print("You do not have access to that business unit")
                except IndexError:
                    print("The business unit you requested is empty.")
            elif role == 'analyst':
                data = {'values': args.severity}
                response = requests.get(method + url_analyst + '/analyst_list_all_info_by_severity', auth=auth, json=data)
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
                response = requests.get(method + url_sysadmin1 + "/sysadmin1_all_bus_user_manages", auth=auth)
                self.poutput("Here are the Business Units you manage:")
                tabledata = response.json()
                l1,l2 = len(tabledata), len(tabledata[0])
                df = pd.DataFrame(tabledata, index=['']*l1, columns=['']*l2)
                df.set_axis(['BUSINESS UNIT', 'UNIT ID'],axis=1,inplace=True)
                self.poutput(df.head())
                self.poutput('\n')
            elif role == 'sysadmin2':
                response = requests.get(method + url_sysadmin2 + "/sysadmin2_all_bus_user_manages", auth=auth)
                self.poutput("Here are the Business Units you manage:")
                tabledata = response.json()
                l1,l2 = len(tabledata), len(tabledata[0])
                df = pd.DataFrame(tabledata, index=['']*l1, columns=['']*l2)
                df.set_axis(['BUSINESS UNIT', 'UNIT ID'],axis=1,inplace=True)
                self.poutput(df.head())
                self.poutput('\n')
            elif role == 'analyst':
                data = {'values': [str(args.b)]}
                response = requests.get(method + url_analyst + "/analyst_list_all_info_by_bu", auth=auth, json=data)
                self.poutput("Here are the vulnerable computers in the business unit")
                tabledata = response.json()
                l1,l2 = len(tabledata), len(tabledata[0])
                df = pd.DataFrame(tabledata, index=['']*l1, columns=['']*l2)
                df.set_axis(['CVE', 'SEVERITY', 'COMPUTER NAME', 'OS', 'OS_VERSION', 'BUSINESS UNIT'],axis=1,inplace=True)
                self.poutput(df.head())
                self.poutput('\n')
            elif role == 'engineer':
                data = {'values': [str(args.b)]}
                response = requests.get(method + url_engineer + "/engineer_access_bus", auth=auth, json=data)
                self.poutput("Here are the Business Units you asked for:")
                tabledata = response.json()
                l1,l2 = len(tabledata), len(tabledata[0])
                df = pd.DataFrame(tabledata, index=['']*l1, columns=['']*l2)
                df.set_axis(['BUSINESS UNIT', 'BUSINESS UNIT ID', 'ADMIN ID', 'BELONGS TO'],axis=1,inplace=True)
                self.poutput(df.head())
                self.poutput('\n')
        else:
            self.poutput("You must log in to view this data.")
    parser_bu.set_defaults(func=list_bus)

    def list_vulns(self, args):
        if(loggedIn):
            if role == 'sysadmin1':
                response = requests.get(method + url_sysadmin1 + "/sysadmin1_all_bus_user_manages", auth=auth)
                self.poutput("Here are the Business Units you manage:")
                tabledata = response.json()
                l1,l2 = len(tabledata), len(tabledata[0])
                df = pd.DataFrame(tabledata, index=['']*l1, columns=['']*l2)
                self.poutput(df.head())
                self.poutput('\n')
                b_id = input("Which Business Unit's Vulnerabilities would you like to view? (ID NUMBER): ")
                try:
                    data = {'id': int(b_id)}
                    response = requests.get(method + url_sysadmin1 + '/sysadmin1_all_computer_vulns_by_bu', auth=auth, json=data)
                    tabledata = response.json()
                    l1,l2 = len(tabledata), len(tabledata[0])
                    df = pd.DataFrame(tabledata, index=['']*l1, columns=['']*l2)
                    df.set_axis(['COMPUTER NAME', 'OS','OS_VERSION','CVE', 'SEVERITY'],axis=1,inplace=True)
                    self.poutput('Here are the vulnerabilities in your business unit:')
                    self.poutput(df.head())
                    self.poutput('\n')
                except ValueError:
                    print("Please enter a valid integer")
                except KeyError:
                    print("You do not have access to that business unit")
                except IndexError:
                    print("The business unit you requested is empty.")
            if role == 'sysadmin2':
                response = requests.get(method + url_sysadmin2 + "/sysadmin2_all_bus_user_manages", auth=auth)
                self.poutput("Here are the Business Units you manage:")
                tabledata = response.json()
                l1,l2 = len(tabledata), len(tabledata[0])
                df = pd.DataFrame(tabledata, index=['']*l1, columns=['']*l2)
                self.poutput(df.head())
                self.poutput('\n')
                b_id = input("Which Business Unit's Vulnerabilities would you like to view? (ID NUMBER): ")
                try:
                    data = {'id': int(b_id)}
                    response = requests.get(method + url_sysadmin2 + '/sysadmin2_all_computer_vulns_by_bu', auth=auth, json=data)
                    tabledata = response.json()
                    l1,l2 = len(tabledata), len(tabledata[0])
                    df = pd.DataFrame(tabledata, index=['']*l1, columns=['']*l2)
                    df.set_axis(['COMPUTER NAME', 'OS','OS_VERSION','CVE', 'SEVERITY'],axis=1,inplace=True)
                    self.poutput('Here are the vulnerabilities in your business unit:')
                    self.poutput(df.head())
                    self.poutput('\n')
                except ValueError:
                    print("Please enter a valid integer")
                except KeyError:
                    print("You do not have access to that business unit")
                except IndexError:
                    print("The business unit you requested is empty.")
    parser_vuln.set_defaults(func=list_vulns)

    def list_apps(self, args):
        if(loggedIn):
            if role == 'sysadmin1':
                response = requests.get(method + url_sysadmin1 + "/sysadmin1_all_bus_user_manages", auth=auth)
                self.poutput("Here are the Business Units you manage:")
                tabledata = response.json()
                l1,l2 = len(tabledata), len(tabledata[0])
                df = pd.DataFrame(tabledata, index=['']*l1, columns=['']*l2)
                self.poutput(df.head())
                self.poutput('\n')
                b_id = input("Which Business Unit's Computers would you like to view? (ID NUMBER): ")
                try:
                    data = {'id': int(b_id)}
                    response = requests.get(method + url_sysadmin1 + '/sysadmin1_all_computers_in_one_bu', auth=auth, json=data)
                    tabledata = response.json()
                    l1,l2 = len(tabledata), len(tabledata[0])
                    df = pd.DataFrame(tabledata, index=['']*l1, columns=['']*l2)
                    self.poutput('Here are the computers in your business unit:')
                    self.poutput(df.head())
                    self.poutput('\n')
                    c_id = input("Which Computer's Apps would you like to view? (ID NUMBER): ")
                    try:
                        data = {'id': int(c_id)}
                        response = requests.get(method + url_sysadmin1 + '/sysadmin1_all_apps_on_computers', auth=auth, json=data)
                        tabledata = response.json()
                        l1,l2 = len(tabledata), len(tabledata[0])
                        df = pd.DataFrame(tabledata, index=['']*l1, columns=['']*l2)
                        df.set_axis(['COMPUTER NAME', 'APPLICATION', 'APP_VERSION', 'APP ID'],axis=1,inplace=True)
                        self.poutput('Here are the computers in your business unit:')
                        self.poutput(df.head())
                        self.poutput('\n')
                    except ValueError:
                        print("Please enter a valid integer")
                    except KeyError:
                        print("You do not have access to that computer.")
                    except IndexError:
                        print("The computer you requested has no apps.")
                except ValueError:
                    print("Please enter a valid integer")
                except KeyError:
                    print("You do not have access to that business unit")
                except IndexError:
                    print("The business unit you requested is empty.")
            if role == 'sysadmin2':
                response = requests.get(method + url_sysadmin2 + "/sysadmin2_all_bus_user_manages", auth=auth)
                self.poutput("Here are the Business Units you manage:")
                tabledata = response.json()
                l1,l2 = len(tabledata), len(tabledata[0])
                df = pd.DataFrame(tabledata, index=['']*l1, columns=['']*l2)
                self.poutput(df.head())
                self.poutput('\n')
                b_id = input("Which Business Unit's Computers would you like to view? (ID NUMBER): ")
                try:
                    data = {'id': int(b_id)}
                    response = requests.get(method + url_sysadmin2 + '/sysadmin2_all_computers_in_one_bu', auth=auth, json=data)
                    tabledata = response.json()
                    l1,l2 = len(tabledata), len(tabledata[0])
                    df = pd.DataFrame(tabledata, index=['']*l1, columns=['']*l2)
                    self.poutput('Here are the computers in your business unit:')
                    self.poutput(df.head())
                    self.poutput('\n')
                    c_id = input("Which Computer's Apps would you like to view? (ID NUMBER): ")
                    try:
                        data = {'id': int(c_id)}
                        response = requests.get(method + url_sysadmin2 + '/sysadmin2_all_apps_on_computers', auth=auth, json=data)
                        tabledata = response.json()
                        l1,l2 = len(tabledata), len(tabledata[0])
                        df = pd.DataFrame(tabledata, index=['']*l1, columns=['']*l2)
                        df.set_axis(['COMPUTER NAME', 'APPLICATION', 'APP_VERSION', 'APP ID'],axis=1,inplace=True)
                        self.poutput('Here are the computers in your business unit:')
                        self.poutput(df.head())
                        self.poutput('\n')
                    except ValueError:
                        print("Please enter a valid integer")
                    except KeyError:
                        print("You do not have access to that computer.")
                    except IndexError:
                        print("The computer you requested has no apps.")
                except ValueError:
                    print("Please enter a valid integer")
                except KeyError:
                    print("You do not have access to that business unit")
                except IndexError:
                    print("The business unit you requested is empty.")
    parser_apps.set_defaults(func=list_apps)


#############################
# Define AWS Login function #
#############################

def awsLogin(key, secret):
    global loggedIn
    global auth
    global role


    login_list = [url_sysadmin1, url_sysadmin2, url_analyst, url_engineer]
    headers = {'testing': '123abc'}
    resulting_url = ''
    for i in login_list:
        auth = AWSRequestsAuth(aws_access_key=key,
                aws_secret_access_key=secret,
                #aws_host='to36jhw9b1.execute-api.us-west-2.amazonaws.com',
                aws_host=i,
                aws_region='us-west-2',
                aws_service='execute-api')
        response = requests.get(method + i + '/login', auth=auth, headers=headers)
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


###################
# Use to Run Code #
###################

if __name__ == '__main__':
    import sys
    c = cvetracker()
    sys.exit(c.cmdloop())
