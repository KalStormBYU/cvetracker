#!/usr/bin/env python

import requests
import argparse
import cmd2
from aws_requests_auth.aws_auth import AWSRequestsAuth

loggedIn = False
auth = 0

class cvetracker(cmd2.Cmd):
    def __init__(self):
        super().__init__()
        del cmd2.Cmd.do_shell
        del cmd2.Cmd.do_alias
        del cmd2.Cmd.do_macro
        del cmd2.Cmd.do_run_pyscript
        del cmd2.Cmd.do_set
        del cmd2.Cmd.do_shortcuts
        del cmd2.Cmd.do_edit
        del cmd2.Cmd.do_run_script
        del cmd2.Cmd.do_history

        self.prompt = 'Tracker> '


        """ A CVE tracking software. """
    #role_parser = cmd2.Cmd2ArgumentParser()
    #role_parser.add_argument('-r', '--role', action='store_true', help='display role of current user')

    #@cmd2.with_argparser(role_parser)
    def do_role(self, args):
        """Print the role of the user"""
        #amiLogged()
        if loggedIn == False:
            self.poutput("Sorry, can't access the database. You are not logged in.")
        else:
            self.poutput("Welcome to the database!")
            self.poutput("What would you like to do?")

    def do_login(self, args):
        """Login to AWS account"""
        print("Attempting to log you in")
        key = input("Please enter your key: ")
        secret = input("Please enter your secret key: ")
        awsLogin(key, secret)


    list_parser = cmd2.Cmd2ArgumentParser()
    list_parser.add_argument('-c', '--computers',action='store_true', help='display computers user has visibility for')

    @cmd2.with_argparser(list_parser)
    def do_list(self, args):
        print('list')

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
    response = requests.get('https://to36jhw9b1.execute-api.us-west-2.amazonaws.com/default/all_computers_apps_vulns', auth=auth, headers=headers, json=data)
    if response.status_code == requests.codes.ok:
        loggedIn = True
        print("You are now logged in!")
    else:
        print("Unfortunately we could not log you in")


if __name__ == '__main__':
    import sys
    c = cvetracker()
    sys.exit(c.cmdloop())
