#!/usr/bin/env python

import requests
import argparse
from cmd2 import Cmd, with_argparser, Cmd2ArgumentParser
import cmd2
from aws_requests_auth.aws_auth import AWSRequestsAuth

loggedIn = False
auth = 0

list_parser = Cmd2ArgumentParser()
list_subparsers = list_parser.add_subparsers(title='subcommands', help='subcommand help')

parser_computer = list_subparsers.add_parser('computers', help='computer help')
parser_bu = list_subparsers.add_parser('Business Units', help='Business Unit help')



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

    def list_computer(self, args):
        if(loggedIn):
            data = {'values': ['%']}
            headers = {'testing': '123abc'}
            response = requests.get('https://to36jhw9b1.execute-api.us-west-2.amazonaws.com/default/all_computers_apps_vulns', auth=auth, headers=headers, json=data)
            self.poutput('Here is your data')
            self.poutput(response.json())
        else:
            self.poutput("You must log in to view this data.")

    parser_computer.set_defaults(func=list_computer)

    @cmd2.with_argparser(list_parser)
    def do_list(self, args):
        """Test Help Menu"""
        func = getattr(args, 'func', None)
        if func is not None:
            func(self, args)
        else:
            self.do_help('list')

def awsLogin(key, secret):
    global loggedIn
    global auth
    auth = AWSRequestsAuth(aws_access_key=key,
            aws_secret_access_key=secret,
            aws_host='to36jhw9b1.execute-api.us-west-2.amazonaws.com',
            aws_region='us-west-2',
            aws_service='execute-api')
    headers = {'testing': '123abc'}
    data = {'values': ['%']}
    #response = requests.get('https://to36jhw9b1.execute-api.us-west-2.amazonaws.com/default/all_computers_apps_vulns', auth=auth, headers=headers, json=data)
    response = requests.get('https://to36jhw9b1.execute-api.us-west-2.amazonaws.com/default/login', auth=auth, headers=headers)
    if response.status_code == requests.codes.ok:
        loggedIn = True
        print("You are now logged in!")
    else:
        print("Unfortunately we could not log you in")


if __name__ == '__main__':
    import sys
    c = cvetracker()
    sys.exit(c.cmdloop())
