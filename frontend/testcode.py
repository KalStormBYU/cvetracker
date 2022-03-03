#!/usr/bin/env python

#import requests, 
import argparse
import cmd2

loggedIn = False

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
        amiLogged()
        if loggedIn == False:
            self.poutput("Sorry, can't access the database")
        else:
            self.poutput("Welcome to the database!")
            self.poutput("What would you like to do?")

def amiLogged():
    global loggedIn
    resp = input("Am I logged in? y/n\n")
    if resp == 'n':
        loggedIn = True
    elif resp == 'y':
        loggedIn = False


if __name__ == '__main__':
    import sys
    c = cvetracker()
    sys.exit(c.cmdloop())
