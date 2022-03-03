#!/usr/bin/env python

#import requests, 
import argparse
import cmd2

"""
parser = argparse.ArgumentParser()
parser.add_argument("-r", "--role", help="display role of current user", action='store_true')
args = parser.parse_args()
if args.role:
    print("Role now displays properly")
"""

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
        if loggedIn == False:
            self.poutput("Sorry, can't access the database")
        else:
            self.poutput("Welcome to the database!")
            self.poutput("What would you like to do?")




if __name__ == '__main__':
    import sys
    c = cvetracker()
    sys.exit(c.cmdloop())
